//
//  HTImageBrowserView.m
//  HTImageBrowserView
//
//  Created by hublot on 17/1/7.
//  Copyright © 2017年 hublot. All rights reserved.
//

#import "HTImageBrowserView.h"
#import <objc/runtime.h>
@import Accelerate;
#import "YYAnimatedImageView.h"


@implementation UIView (HTImage)

- (UIImage *)snapshotImage {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snap;
}

@end




@implementation UIImage (HTBlurImage)

- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage {
    
    // Check pre-conditions.
    if (self.size.width < 1 || self.size.height < 1) {
        
        NSLog (@"*** error: invalid size: (%.2f x %.2f). Both dimensions must be >= 1: %@", self.size.width, self.size.height, self);
        return self;
    }
    
    if (!self.CGImage) {
        
        NSLog (@"*** error: image must be backed by a CGImage: %@", self);
        return self;
    }
    
    if (maskImage && !maskImage.CGImage) {
        
        NSLog (@"*** error: maskImage must be backed by a CGImage: %@", maskImage);
        return self;
    }
    
    CGRect   imageRect   = { CGPointZero, self.size };
    UIImage *effectImage = self;
    
    BOOL hasBlur             = blurRadius > __FLT_EPSILON__;
    BOOL hasSaturationChange = fabs(saturationDeltaFactor - 1.) > __FLT_EPSILON__;
    if (hasBlur || hasSaturationChange) {
        
        UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectInContext = UIGraphicsGetCurrentContext();
        CGContextScaleCTM(effectInContext, 1.0, -1.0);
        CGContextTranslateCTM(effectInContext, 0, -self.size.height);
        CGContextDrawImage(effectInContext, imageRect, self.CGImage);
        
        vImage_Buffer effectInBuffer;
        effectInBuffer.data     = CGBitmapContextGetData(effectInContext);
        effectInBuffer.width    = CGBitmapContextGetWidth(effectInContext);
        effectInBuffer.height   = CGBitmapContextGetHeight(effectInContext);
        effectInBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectInContext);
        
        UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectOutContext = UIGraphicsGetCurrentContext();
        vImage_Buffer effectOutBuffer;
        effectOutBuffer.data     = CGBitmapContextGetData(effectOutContext);
        effectOutBuffer.width    = CGBitmapContextGetWidth(effectOutContext);
        effectOutBuffer.height   = CGBitmapContextGetHeight(effectOutContext);
        effectOutBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectOutContext);
        
        if (hasBlur) {
            
            // A description of how to compute the box kernel width from the Gaussian
            // radius (aka standard deviation) appears in the SVG spec:
            // http://www.w3.org/TR/SVG/filters.html#feGaussianBlurElement
            //
            // For larger values of 's' (s >= 2.0), an approximation can be used: Three
            // successive box-blurs build a piece-wise quadratic convolution kernel, which
            // approximates the Gaussian kernel to within roughly 3%.
            //
            // let d = floor(s * 3*sqrt(2*pi)/4 + 0.5)
            //
            // ... if d is odd, use three box-blurs of size 'd', centered on the output pixel.
            //
            CGFloat inputRadius = blurRadius * [[UIScreen mainScreen] scale];
            NSUInteger radius = floor(inputRadius * 3. * sqrt(2 * M_PI) / 4 + 0.5);
            if (radius % 2 != 1) {
                
                radius += 1; // force radius to be odd so that the three box-blur methodology works.
            }
            
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, (uint32_t)radius, (uint32_t)radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, NULL, 0, 0, (uint32_t)radius, (uint32_t)radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, (uint32_t)radius, (uint32_t)radius, 0, kvImageEdgeExtend);
        }
        
        BOOL effectImageBuffersAreSwapped = NO;
        if (hasSaturationChange) {
            
            CGFloat s = saturationDeltaFactor;
            CGFloat floatingPointSaturationMatrix[] = {
                0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
                0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
                0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
                0,                    0,                    0,  1,
            };
            const int32_t divisor = 256;
            NSUInteger matrixSize = sizeof(floatingPointSaturationMatrix)/sizeof(floatingPointSaturationMatrix[0]);
            int16_t saturationMatrix[matrixSize];
            
            for (NSUInteger i = 0; i < matrixSize; ++i) {
                
                saturationMatrix[i] = (int16_t)roundf(floatingPointSaturationMatrix[i] * divisor);
            }
            
            if (hasBlur) {
                
                vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
                effectImageBuffersAreSwapped = YES;
                
            } else {
                
                vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
            }
        }
        
        if (!effectImageBuffersAreSwapped) {
            
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        }
        
        UIGraphicsEndImageContext();
        
        if (effectImageBuffersAreSwapped) {
            
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        }
        
        UIGraphicsEndImageContext();
    }
    
    // Set up output context.
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef outputContext = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(outputContext, 1.0, -1.0);
    CGContextTranslateCTM(outputContext, 0, -self.size.height);
    
    // Draw base image.
    CGContextDrawImage(outputContext, imageRect, self.CGImage);
    
    // Draw effect image.
    if (hasBlur) {
        
        CGContextSaveGState(outputContext);
        
        if (maskImage) {
            
            CGContextClipToMask(outputContext, imageRect, maskImage.CGImage);
        }
        
        CGContextDrawImage(outputContext, imageRect, effectImage.CGImage);
        CGContextRestoreGState(outputContext);
    }
    
    // Add in color tint.
    if (tintColor) {
        
        CGContextSaveGState(outputContext);
        CGContextSetFillColorWithColor(outputContext, tintColor.CGColor);
        CGContextFillRect(outputContext, imageRect);
        CGContextRestoreGState(outputContext);
    }
    
    // Output image is ready.
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return outputImage;
}


@end



@interface UIImageView ()

@property (nonatomic, strong) NSMutableDictionary *blurImageDictionary;

@end

@implementation UIImageView (HTImageView)

- (void)setOriginImage:(UIImage *)originImage maxBlurImageRadius:(NSInteger)maxBlurImageRadius blurProgress:(CGFloat)blurProgress {
    if (!(originImage && maxBlurImageRadius > 0)) {
        return;
    }
    blurProgress = MAX(0, MIN(blurProgress, 1));
    if ([self.blurImageDictionary valueForKey:[NSString stringWithFormat:@"0"]] != originImage) {
        [self.blurImageDictionary removeAllObjects];
        UIImage *maxBlurImage = [originImage applyBlurWithRadius:maxBlurImageRadius tintColor:[UIColor colorWithWhite:0.11 alpha:0.63] saturationDeltaFactor:1.8 maskImage:nil];
        [self.blurImageDictionary setValue:maxBlurImage forKey:[NSString stringWithFormat:@"%ld", maxBlurImageRadius]];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            for (NSInteger index = 0; index < maxBlurImageRadius; index ++) {
                UIImage *blurImage = index == 0 ? originImage : [originImage applyBlurWithRadius:index tintColor:[UIColor colorWithWhite:0.11  alpha:0.43 + (0.2 / maxBlurImageRadius * index)] saturationDeltaFactor:1.8 maskImage:nil];
                [self.blurImageDictionary setValue:blurImage forKey:[NSString stringWithFormat:@"%ld", index]];
            }
        });
    }
    UIImage *blurImage = [self.blurImageDictionary valueForKey:[NSString stringWithFormat:@"%ld", (NSInteger)((maxBlurImageRadius) * blurProgress)]];
    if (blurImage) {
        self.image = blurImage;
    } else if (!self.image && originImage) {
        self.image = originImage;
    }
}

- (NSMutableDictionary *)blurImageDictionary {
    NSMutableDictionary *blurImageDictionary = objc_getAssociatedObject(self, _cmd);
    if (!blurImageDictionary) {
        objc_setAssociatedObject(self, _cmd, [@{} mutableCopy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return [self blurImageDictionary];
    }
    return blurImageDictionary;
}

@end

@interface HTNumberPageControl : UIPageControl

@property (nonatomic, strong) UILabel *titleNameLabel;

@end

@implementation HTNumberPageControl

- (void)didMoveToSuperview {
	[super didMoveToSuperview];
	[self addSubview:self.titleNameLabel];
}

- (void)setCurrentPage:(NSInteger)currentPage {
	[super setCurrentPage:currentPage];
	if ([self sizeForNumberOfPages:self.numberOfPages].width > self.frame.size.width - 20) {
		// title
		self.titleNameLabel.frame = self.bounds;
		self.titleNameLabel.text = [NSString stringWithFormat:@"%ld / %ld", self.currentPage + 1, self.numberOfPages];
		[self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
			if (obj == self.titleNameLabel) {
				obj.transform = CGAffineTransformIdentity;
			} else {
				obj.transform = CGAffineTransformMakeScale(0, 0);
			}
		}];
	} else {
		// origin
		[self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
			if (obj != self.titleNameLabel) {
				obj.transform = CGAffineTransformIdentity;
			} else {
				obj.transform = CGAffineTransformMakeScale(0, 0);
			}
		}];
	}
}

- (UILabel *)titleNameLabel {
	if (!_titleNameLabel) {
		_titleNameLabel = [[UILabel alloc] init];
		_titleNameLabel.textColor = [UIColor whiteColor];
		_titleNameLabel.font = [UIFont systemFontOfSize:14];
		_titleNameLabel.textAlignment = NSTextAlignmentCenter;
	}
	return _titleNameLabel;
}

@end




@interface HTImageBrowserModel ()

@property (nonatomic, strong) NSData *modelImageData;

@end

@implementation HTImageBrowserModel

@end





#define HTImageBrowserScreenSize [UIScreen mainScreen].bounds.size

#define HTImageBrowserPadding 20

#define HTImageBrowserMaxBlurRadius 20

static HTImageBrowserView *imageBrowserView;

typedef NS_ENUM(NSInteger, HTImageBrowserState) {
	HTImageBrowserStateThubnail,
    HTImageBrowserStateDismissing,
    HTImageBrowserStatePresenting,
    HTImageBrowserStateDisplay,
};


@interface HTImageBrowserCell : UICollectionViewCell <UIScrollViewDelegate>

@property (nonatomic, strong) YYAnimatedImageView *imageView;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) CAShapeLayer *progressLayer;

@property (nonatomic, strong) HTImageBrowserModel *model;

@end





@interface HTImageBrowserView () <UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSArray <HTImageBrowserModel *> *modelArray;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, assign) NSInteger fromIndex;

@property (nonatomic, strong) UIImageView *backgroundImageView;

@property (nonatomic, strong) HTNumberPageControl *pageControl;

@property (nonatomic, strong) UIImage *hiddenFromImageViewScreenShotImage;

@property (nonatomic, assign) BOOL originStatusBarHidden;

@property (nonatomic, strong) UITapGestureRecognizer *oneTapGestureRecognizer;

@property (nonatomic, strong) UITapGestureRecognizer *twoTapGestureRecognizer;

@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesureRecognizer;

@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

@property (nonatomic, assign) HTImageBrowserState imageBrowserState;

@property (nonatomic, copy) void(^imageAndProgressBlock)(HTImageBrowserModel *model, NSInteger index, UIImageView *imageView, NSURL *browserModelImageURL, void(^)(HTImageBrowserModel *model, CGFloat progress), void(^)(HTImageBrowserModel *model, NSData *imageData, UIImage *image));

@property (nonatomic, assign) void(^longPressBlock)(NSData *imageData, HTImageBrowserModel *model, NSInteger pressIndex);

@end




@implementation HTImageBrowserCell

- (void)didMoveToSuperview {
	self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.imageView];
    self.scrollView.delegate = self;
    self.progressLayer.position = CGPointMake(HTImageBrowserScreenSize.width / 2, HTImageBrowserScreenSize.height / 2);
	[self.scrollView.panGestureRecognizer requireGestureRecognizerToFail:imageBrowserView.panGestureRecognizer];
	[self.layer addSublayer:self.progressLayer];
}

- (void)setModel:(HTImageBrowserModel *)model row:(NSInteger)row {
    if (model == self.model) {
        return;
    } else {
        self.model = model;
        self.scrollView.scrollsToTop = true;
        self.progressLayer.hidden = true;
		self.progressLayer.strokeEnd = 0;
        self.imageView.image = nil;
        [self.scrollView setZoomScale:1 animated:false];
    }
    void(^progressBlock)(HTImageBrowserModel *model, CGFloat progress) = ^(HTImageBrowserModel *model, CGFloat progress) {
		if (imageBrowserView.imageBrowserState != HTImageBrowserStateDisplay) {
			return;
		}
        if (model == self.model) {
            dispatch_async(dispatch_get_main_queue(), ^{
				self.progressLayer.hidden = false;
				self.progressLayer.strokeEnd = progress;
            });
        }
    };
    void(^setImageBlock)(HTImageBrowserModel *model, NSData *imageData, UIImage *image) = ^(HTImageBrowserModel *model, NSData *imageData, UIImage *image) {
        if (model == self.model) {
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.progressLayer.hidden = true;
                    self.imageView.image = image;
                    model.modelImageData = imageData;
                    NSString *mediaFunction = kCAMediaTimingFunctionLinear;
                    CATransition *transition = [CATransition animation];
                    transition.duration = 0.1;
                    transition.timingFunction = [CAMediaTimingFunction functionWithName:mediaFunction];
                    transition.type = kCATransitionFade;
                    [self.imageView.layer addAnimation:transition forKey:@"fade"];
                    [self resetSubViews];
                });
            }
        }
    };
	if (imageBrowserView.imageAndProgressBlock) {
		imageBrowserView.imageAndProgressBlock(self.model, row, self.imageView, self.model.browserModelImageURL, progressBlock, setImageBlock);
	}
}

- (void)resetSubViews {
    self.imageView.bounds = CGRectMake(0, 0, HTImageBrowserScreenSize.width, HTImageBrowserScreenSize.width * self.imageView.image.size.height / self.imageView.image.size.width);
    self.imageView.center = CGPointMake(HTImageBrowserScreenSize.width / 2, (MAX(HTImageBrowserScreenSize.height, self.imageView.bounds.size.height)) / 2);
    self.scrollView.showsVerticalScrollIndicator = self.imageView.bounds.size.height > HTImageBrowserScreenSize.height + 1;
    self.scrollView.contentSize = CGSizeMake(HTImageBrowserScreenSize.width, self.imageView.center.y * 2);
    [self.scrollView scrollRectToVisible:CGRectMake(0, 0, HTImageBrowserScreenSize.width, HTImageBrowserScreenSize.height) animated:false];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    UIView *subView = self.imageView;
    
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    subView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                 scrollView.contentSize.height * 0.5 + offsetY);
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[YYAnimatedImageView alloc] initWithFrame:CGRectMake(0, 0, HTImageBrowserScreenSize.width, HTImageBrowserScreenSize.height)];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = true;
    }
    return _imageView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, HTImageBrowserScreenSize.width, HTImageBrowserScreenSize.height)];
        _scrollView.scrollsToTop = false;
        _scrollView.showsHorizontalScrollIndicator = false;
        _scrollView.alwaysBounceVertical = true;
        _scrollView.alwaysBounceHorizontal = false;
        _scrollView.clipsToBounds = true;
        _scrollView.bouncesZoom = true;
        _scrollView.maximumZoomScale = 3;
        _scrollView.multipleTouchEnabled = true;
    }
    return _scrollView;
}

- (CAShapeLayer *)progressLayer {
    if (!_progressLayer) {
        _progressLayer = [CAShapeLayer layer];
        _progressLayer.bounds = CGRectMake(0, 0, 40, 40);
        _progressLayer.cornerRadius = 20;
        _progressLayer.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.500].CGColor;
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(_progressLayer.bounds, 7, 7) cornerRadius:(40 / 2 - 7)];
        _progressLayer.path = path.CGPath;
        _progressLayer.fillColor = [UIColor clearColor].CGColor;
        _progressLayer.strokeColor = [UIColor whiteColor].CGColor;
        _progressLayer.lineWidth = 2;
        _progressLayer.lineCap = kCALineCapRound;
        _progressLayer.strokeStart = 0;
        _progressLayer.strokeEnd = 0;
    }
    return _progressLayer;
}

- (void)setCenter:(CGPoint)center {
	center.x += HTImageBrowserPadding / 2;
	[super setCenter:center];
}

@end





@implementation HTImageBrowserView

+ (instancetype)presentModelArray:(NSArray <HTImageBrowserModel *> *)modelArray fromIndex:(NSInteger)fromIndex setImageAndProgressBlock:(void(^)(HTImageBrowserModel *model, NSInteger index, UIImageView *imageView, NSURL *browserModelImageURL, void(^progressBlock)(HTImageBrowserModel *model, CGFloat progress), void(^setImageBlock)(HTImageBrowserModel *model, NSData *imageData, UIImage *image)))imageAndProgressBlock longPressBlock:(void(^)(NSData *imageData, HTImageBrowserModel *model, NSInteger pressIndex))longPressBlock {
    if (fromIndex < 0 && modelArray.count <= fromIndex && !imageAndProgressBlock) {
        return nil;
    }
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imageBrowserView = [[HTImageBrowserView alloc] initWithFrame:CGRectMake(0, 0, HTImageBrowserScreenSize.width, HTImageBrowserScreenSize.height)];
        [imageBrowserView addGestureRecognizer:imageBrowserView.oneTapGestureRecognizer];
        [imageBrowserView addGestureRecognizer:imageBrowserView.twoTapGestureRecognizer];
        [imageBrowserView addGestureRecognizer:imageBrowserView.longPressGesureRecognizer];
		[imageBrowserView addGestureRecognizer:imageBrowserView.panGestureRecognizer];
    });
    if (imageBrowserView.imageBrowserState != HTImageBrowserStateThubnail) {
        return nil;
    }
    imageBrowserView.imageBrowserState = HTImageBrowserStatePresenting;
    if (imageBrowserView.modelArray == modelArray && imageAndProgressBlock == imageBrowserView.imageAndProgressBlock && imageBrowserView.longPressBlock == longPressBlock) {
        return imageBrowserView;
    } else {
        imageBrowserView.modelArray = modelArray;
        imageBrowserView.imageAndProgressBlock = imageAndProgressBlock;
		imageBrowserView.longPressBlock = longPressBlock;
    }
    imageBrowserView.fromIndex = fromIndex;
    [imageBrowserView addSubview:imageBrowserView.backgroundImageView];
    [imageBrowserView addSubview:imageBrowserView.collectionView];
	[imageBrowserView addSubview:imageBrowserView.pageControl];
    imageBrowserView.collectionView.alwaysBounceHorizontal = modelArray.count > 1;
    BOOL fromViewHidden = modelArray[fromIndex].thubnailImageView.hidden;
    modelArray[fromIndex].thubnailImageView.hidden = YES;
    imageBrowserView.hiddenFromImageViewScreenShotImage = [[UIApplication sharedApplication].keyWindow.rootViewController.view snapshotImage];
    modelArray[fromIndex].thubnailImageView.hidden = fromViewHidden;
    [imageBrowserView.backgroundImageView setOriginImage:imageBrowserView.hiddenFromImageViewScreenShotImage maxBlurImageRadius:HTImageBrowserMaxBlurRadius blurProgress:1];
    imageBrowserView.pageControl.numberOfPages = modelArray.count;
    imageBrowserView.pageControl.currentPage = fromIndex;
    imageBrowserView.originStatusBarHidden = [UIApplication sharedApplication].statusBarHidden;
    [imageBrowserView animatedRemoveFromSuperView:false];
    return imageBrowserView;
}

- (void)animatedRemoveFromSuperView:(BOOL)removeFromSuperView {
    if (!removeFromSuperView) {
        [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:imageBrowserView];
        [imageBrowserView.collectionView reloadData];
        [imageBrowserView.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:imageBrowserView.fromIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:false];
        [imageBrowserView.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:imageBrowserView.fromIndex inSection:0]]];
    }
    [[UIApplication sharedApplication] setStatusBarHidden:removeFromSuperView ? imageBrowserView.originStatusBarHidden : true withAnimation:UIStatusBarAnimationSlide];
    UIImageView *connectImageView = imageBrowserView.modelArray[imageBrowserView.fromIndex].thubnailImageView;
    if (removeFromSuperView && imageBrowserView.modelArray[imageBrowserView.pageControl.currentPage].thubnailImageView) {
        connectImageView = imageBrowserView.modelArray[imageBrowserView.pageControl.currentPage].thubnailImageView;
    }
    HTImageBrowserCell *cell = (HTImageBrowserCell *)[imageBrowserView.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:removeFromSuperView ? imageBrowserView.pageControl.currentPage : imageBrowserView.fromIndex inSection:0]];
    if (!cell.imageView.image && connectImageView.image) {
        cell.imageView.image = connectImageView.image;
    }
	[cell resetSubViews];
    CGRect originImageViewFrame = cell.imageView.frame;
    CGRect originFromViewFrame = [connectImageView convertRect:connectImageView.bounds toView:cell];
    if (CGRectEqualToRect(CGRectZero, originFromViewFrame)) {
        originFromViewFrame = CGRectMake(HTImageBrowserScreenSize.width / 2, HTImageBrowserScreenSize.height / 2, 0, 0);
    }
    if (cell.imageView.image) {
        [cell.scrollView setZoomScale:1 animated:false];
        if (!removeFromSuperView) {
            cell.imageView.frame = originFromViewFrame;
            imageBrowserView.backgroundImageView.alpha = 0;
        }
    } else {
        imageBrowserView.collectionView.hidden = true;
        if (!removeFromSuperView) {
            imageBrowserView.backgroundImageView.frame = originFromViewFrame;
        }
    }
    self.pageControl.alpha = 0;
    self.collectionView.userInteractionEnabled = false;
	cell.progressLayer.hidden = true;
	[UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
		if (cell.imageView.image) {
            cell.imageView.frame = removeFromSuperView ? originFromViewFrame : originImageViewFrame;
            imageBrowserView.backgroundImageView.alpha = removeFromSuperView ? 0 : 1;
		} else {
            imageBrowserView.backgroundImageView.frame = removeFromSuperView ? originFromViewFrame : CGRectMake(0, 0, HTImageBrowserScreenSize.width, HTImageBrowserScreenSize.height);
		}
	} completion:^(BOOL finished) {
		imageBrowserView.backgroundImageView.alpha = 1;
		self.collectionView.userInteractionEnabled = true;
		imageBrowserView.collectionView.hidden = false;
		if (removeFromSuperView) {
			[self removeFromSuperview];
			imageBrowserView.backgroundImageView.frame = CGRectMake(0, 0, HTImageBrowserScreenSize.width, HTImageBrowserScreenSize.height);
			cell.imageView.frame = originImageViewFrame;
			imageBrowserView.imageBrowserState = HTImageBrowserStateThubnail;
		} else {
			imageBrowserView.imageBrowserState = HTImageBrowserStateDisplay;
		}
	}];
}

- (void)dismiss {
    if (imageBrowserView.imageBrowserState != HTImageBrowserStateDisplay) {
        return;
    }
    imageBrowserView.imageBrowserState = HTImageBrowserStateDismissing;
    [self animatedRemoveFromSuperView:true];
}

- (void)zoomScrollView {
    if (self.imageBrowserState != HTImageBrowserStateDisplay) {
        return;
    }
    HTImageBrowserCell *cell = (HTImageBrowserCell *)[imageBrowserView.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:imageBrowserView.pageControl.currentPage inSection:0]];
    if (cell) {
        if (cell.scrollView.zoomScale > 1) {
            [cell.scrollView setZoomScale:1 animated:true];
        } else {
            CGPoint touchPoint = [self.twoTapGestureRecognizer locationInView:cell.imageView];
            CGFloat newZoomScale = cell.scrollView.maximumZoomScale;
            CGFloat xsize = HTImageBrowserScreenSize.width / newZoomScale;
            CGFloat ysize = HTImageBrowserScreenSize.height / newZoomScale;
            [cell.scrollView zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:true];
        }
    }
}

- (void)longPress {
    if (self.imageBrowserState != HTImageBrowserStateDisplay || self.longPressGesureRecognizer.state != UIGestureRecognizerStateBegan) {
        return;
    }
	if (self.modelArray.count > self.pageControl.currentPage && self.longPressBlock) {
		self.longPressBlock(self.modelArray[self.pageControl.currentPage].modelImageData, self.modelArray[self.pageControl.currentPage], self.pageControl.currentPage);
	}
}

- (void)panCollectionView:(UIPanGestureRecognizer *)panGestureRecognizer {
	CGPoint translationInView = [panGestureRecognizer translationInView:panGestureRecognizer.view];
	CGPoint locationInView = [panGestureRecognizer locationInView:self.collectionView];
	switch (panGestureRecognizer.state) {
		case UIGestureRecognizerStatePossible:
			break;
		case UIGestureRecognizerStateBegan:
			
			break;
		case UIGestureRecognizerStateChanged:
			self.collectionView.frame = CGRectMake(- HTImageBrowserPadding / 2, translationInView.y, HTImageBrowserScreenSize.width + HTImageBrowserPadding, HTImageBrowserScreenSize.height);
			CGFloat gestureToScreenDistance = translationInView.y > 0 ? HTImageBrowserScreenSize.height - locationInView.y : locationInView.y;
			CGFloat gestureToScreenComplete = abs((int)translationInView.y);
			[self.backgroundImageView setOriginImage:self.hiddenFromImageViewScreenShotImage maxBlurImageRadius:HTImageBrowserMaxBlurRadius blurProgress:MAX((CGFloat)1 / HTImageBrowserMaxBlurRadius, 1 - gestureToScreenComplete / gestureToScreenDistance)];
			break;
		case UIGestureRecognizerStateEnded:
			
		case UIGestureRecognizerStateCancelled:
			if (abs((int)imageBrowserView.collectionView.frame.origin.y) > HTImageBrowserScreenSize.height / 4) {
				imageBrowserView.imageBrowserState = HTImageBrowserStateDismissing;
				self.collectionView.userInteractionEnabled = false;
				[[UIApplication sharedApplication] setStatusBarHidden:imageBrowserView.originStatusBarHidden withAnimation:UIStatusBarAnimationNone];
				[UIView animateWithDuration:0.25 animations:^{
					imageBrowserView.collectionView.frame = CGRectMake(- HTImageBrowserPadding / 2, (imageBrowserView.collectionView.frame.origin.y > 0 ? 1 : - 1) * HTImageBrowserScreenSize.height, HTImageBrowserScreenSize.width + HTImageBrowserPadding, HTImageBrowserScreenSize.height);
					imageBrowserView.backgroundImageView.alpha = 0;
				} completion:^(BOOL finished) {
					[imageBrowserView removeFromSuperview];
					imageBrowserView.collectionView.frame = CGRectMake(- HTImageBrowserPadding / 2, 0, HTImageBrowserScreenSize.width + HTImageBrowserPadding, HTImageBrowserScreenSize.height);
					imageBrowserView.userInteractionEnabled = true;
					imageBrowserView.backgroundImageView.alpha = 1;
					imageBrowserView.imageBrowserState = HTImageBrowserStateThubnail;
				}];
			} else {
				[UIView animateWithDuration:0.25 animations:^{
					imageBrowserView.collectionView.frame = CGRectMake(- HTImageBrowserPadding / 2, 0, HTImageBrowserScreenSize.width + HTImageBrowserPadding, HTImageBrowserScreenSize.height);
				} completion:^(BOOL finished) {
					
				}];
			}
			break;
		case UIGestureRecognizerStateFailed:
			break;
	}
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
	if (gestureRecognizer == self.panGestureRecognizer) {
		if (self.imageBrowserState != HTImageBrowserStateDisplay) {
			return false;
		}
		CGPoint translationInView = [self.panGestureRecognizer translationInView:self];
		HTImageBrowserCell *cell = (HTImageBrowserCell *)[imageBrowserView.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:imageBrowserView.pageControl.currentPage inSection:0]];
		return ((NSInteger)cell.scrollView.contentOffset.y <= 0 && translationInView.y > 0) || ((NSInteger)cell.scrollView.contentOffset.y >= (NSInteger)cell.scrollView.contentSize.height - (NSInteger)cell.scrollView.bounds.size.height && translationInView.y < 0);
	}
	return true;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate) {
        [self pagerHidden:true];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self pagerHidden:true];
}

- (void)pagerHidden:(BOOL)hiddenPager {
    [UIView animateWithDuration:0.3 delay:0.8 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut animations:^{
        self.pageControl.alpha = hiddenPager ? 0 : 1;
    }completion:^(BOOL finish) {
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.modelArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HTImageBrowserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"1" forIndexPath:indexPath];
    [cell setModel:self.modelArray[indexPath.row] row:indexPath.row];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self pagerHidden:false];
    self.pageControl.currentPage = (NSInteger)round(self.collectionView.contentOffset.x / HTImageBrowserScreenSize.width);
	CGFloat bouncesContentOffset = 0;
	if (scrollView.contentOffset.x < 0) {
		bouncesContentOffset = - scrollView.contentOffset.x;
	} else if (scrollView.contentSize.width > 0 && scrollView.contentOffset.x > scrollView.contentSize.width - scrollView.bounds.size.width) {
		bouncesContentOffset = scrollView.contentOffset.x - (scrollView.contentSize.width - scrollView.bounds.size.width);
	}
	if (bouncesContentOffset > 0) {
		[self.backgroundImageView setOriginImage:self.hiddenFromImageViewScreenShotImage maxBlurImageRadius:HTImageBrowserMaxBlurRadius blurProgress:MAX((CGFloat)1 / HTImageBrowserMaxBlurRadius, 1 - bouncesContentOffset / (HTImageBrowserScreenSize.width / 2))];
	}
	[self.collectionView.visibleCells enumerateObjectsUsingBlock:^(__kindof HTImageBrowserCell * _Nonnull cell, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect cellRectForScreen = [cell convertRect:cell.bounds toView:self];
        CGRect imageRect = cell.imageView.frame;
        imageRect.origin.x = cellRectForScreen.origin.x * - 0.3;
        cell.imageView.frame = imageRect;
	}];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(HTImageBrowserScreenSize.width + HTImageBrowserPadding, HTImageBrowserScreenSize.height);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(- HTImageBrowserPadding / 2, 0, HTImageBrowserScreenSize.width + HTImageBrowserPadding, HTImageBrowserScreenSize.height) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = imageBrowserView;
        _collectionView.dataSource = imageBrowserView;
        _collectionView.scrollsToTop = false;
        _collectionView.pagingEnabled = true;
        _collectionView.showsVerticalScrollIndicator = false;
        _collectionView.showsHorizontalScrollIndicator = false;
        _collectionView.alwaysBounceHorizontal = true;
		_collectionView.alwaysBounceVertical = false;
        _collectionView.delaysContentTouches = false;
        _collectionView.canCancelContentTouches = true;
        _collectionView.allowsSelection = false;
        [_collectionView registerClass:[HTImageBrowserCell class] forCellWithReuseIdentifier:@"1"];
    }
    return _collectionView;
}

- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, HTImageBrowserScreenSize.width, HTImageBrowserScreenSize.height)];
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        _backgroundImageView.clipsToBounds = true;
    }
    return _backgroundImageView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[HTNumberPageControl alloc] initWithFrame:CGRectMake(0, 0, HTImageBrowserScreenSize.width, 20)];
        _pageControl.center = CGPointMake(HTImageBrowserScreenSize.width / 2, HTImageBrowserScreenSize.height - 30);
        _pageControl.hidesForSinglePage = true;
        _pageControl.userInteractionEnabled = false;
    }
    return _pageControl;
}

- (UITapGestureRecognizer *)oneTapGestureRecognizer {
    if (!_oneTapGestureRecognizer) {
        _oneTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    }
    return _oneTapGestureRecognizer;
}

- (UITapGestureRecognizer *)twoTapGestureRecognizer {
    if (!_twoTapGestureRecognizer) {
        _twoTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomScrollView)];
        _twoTapGestureRecognizer.numberOfTapsRequired = 2;
        [self.oneTapGestureRecognizer requireGestureRecognizerToFail:_twoTapGestureRecognizer];
    }
    return _twoTapGestureRecognizer;
}

- (UILongPressGestureRecognizer *)longPressGesureRecognizer {
    if (!_longPressGesureRecognizer) {
        _longPressGesureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress)];
        _longPressGesureRecognizer.minimumPressDuration = 0.35;
    }
    return _longPressGesureRecognizer;
}

- (UIPanGestureRecognizer *)panGestureRecognizer {
	if (!_panGestureRecognizer) {
		_panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panCollectionView:)];
		_panGestureRecognizer.delegate = self;
	}
	return _panGestureRecognizer;
}

@end
