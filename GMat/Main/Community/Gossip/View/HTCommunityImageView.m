//
//  HTCommunityImageView.m
//  GMat
//
//  Created by hublot on 2017/1/12.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTCommunityImageView.h"
#import "YYImage.h"
#import "NSAttributedString+YYText.h"
#import "UIImageView+YYWebImage.h"

typedef NS_ENUM(NSInteger, ShowImageStyle) {
	ShowImageStyleNormal,
	ShowImageStyleAnimation,
	ShowImageStyleLong
};

@interface HTCommunityImageView ()

@property (nonatomic, assign) ShowImageStyle style;

@end

@implementation HTCommunityImageView

- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		self.imageInfoLabel.frame = CGRectMake(frame.size.width - self.imageInfoLabel.ht_w, frame.size.height - self.imageInfoLabel.ht_h, self.imageInfoLabel.ht_w, self.imageInfoLabel.ht_h);
        self.clipsToBounds = true;
		[self addSubview:self.imageInfoLabel];
	}
	return self;
}

- (void)setModel:(NSString *)model {
	_model = model;
	[self updateShowImageStyle:ShowImageStyleNormal];
	[self.layer removeAnimationForKey:@"contents"];
	__weak typeof(HTCommunityImageView *) weakSelf = self;
    UIImage *placeImage = HTPLACEHOLDERIMAGE;
    [self updateContentModelWithImage:placeImage];
	[self setImageWithURL:[NSURL URLWithString:model] placeholder:placeImage options:kNilOptions completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
		if (from != YYWebImageFromMemoryCacheFast) {
			CATransition *transition = [CATransition animation];
			transition.duration = 0.15;
			transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
			transition.type = kCATransitionFade;
			[weakSelf.layer addAnimation:transition forKey:@"contents"];
		}
        [weakSelf updateContentModelWithImage:image];
		if ([image isKindOfClass:[YYImage class]] && ((YYImage *)image).animatedImageType == YYImageTypeGIF) {
			[weakSelf updateShowImageStyle:ShowImageStyleAnimation];
		} else if (image.size.width / image.size.height > 3 || image.size.width / image.size.height < 0.3) {
			[weakSelf updateShowImageStyle:ShowImageStyleLong];
		}
	}];
}

- (void)updateContentModelWithImage:(UIImage *)image {
//    CGFloat scale = (image.size.height / image.size.width) / (self.h / self.w);
//    if (scale < 0.99 || isnan(scale)) {
        self.contentMode = UIViewContentModeScaleAspectFill;
//        self.layer.contentsRect = CGRectMake(0, 0, 1, 1);
//    } else {
//        self.contentMode = UIViewContentModeScaleToFill;
//        self.layer.contentsRect = CGRectMake(0, 0, 1, (float)image.size.width / image.size.height);
//    }
}

- (void)updateShowImageStyle:(ShowImageStyle)imageStyle {
	if (self.style == imageStyle) {
		return;
	} else {
		self.style = imageStyle;
	}
	switch (imageStyle) {
		case ShowImageStyleNormal:
			self.imageInfoLabel.hidden = true;
			break;
		case ShowImageStyleAnimation:
			[self updateInfoLabelStyleWithString:@"动图"];
			break;
		case ShowImageStyleLong:
			[self updateInfoLabelStyleWithString:@"长图"];
			break;
		default:
			break;
	}
}

- (void)updateInfoLabelStyleWithString:(NSString *)infoString {
	dispatch_async(dispatch_get_global_queue(0, 0), ^{
		NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:infoString];
		attributedString.font = [UIFont systemFontOfSize:9];
		attributedString.color = [UIColor whiteColor];
		attributedString.alignment = NSTextAlignmentCenter;
		YYTextLayout *textLayout = [YYTextLayout layoutWithContainer:[YYTextContainer containerWithSize:self.imageInfoLabel.bounds.size] text:attributedString];
		self.imageInfoLabel.textLayout = textLayout;
		dispatch_async(dispatch_get_main_queue(), ^{
			self.imageInfoLabel.textLayout = textLayout;
			self.imageInfoLabel.hidden = false;
		});
	});
}

- (YYLabel *)imageInfoLabel {
	if (!_imageInfoLabel) {
		_imageInfoLabel = [[YYLabel alloc] initWithFrame:CGRectMake(0, 0, 30, 15)];
		_imageInfoLabel.backgroundColor = [UIColor orangeColor];
		_imageInfoLabel.hidden = true;
		_imageInfoLabel.displaysAsynchronously = YES;
		_imageInfoLabel.ignoreCommonProperties = YES;
		_imageInfoLabel.fadeOnHighlight = NO;
		_imageInfoLabel.fadeOnAsynchronouslyDisplay = NO;
	}
	return _imageInfoLabel;
}


@end
