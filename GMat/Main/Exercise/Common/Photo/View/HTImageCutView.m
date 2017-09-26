//
//  HTImageCutView.m
//  GMat
//
//  Created by hublot on 2017/3/20.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTImageCutView.h"
#import "HTScanfView.h"

@interface HTImageCutView ()

@property (nonatomic, strong) HTScanfView *scanfView;

@end

@implementation HTImageCutView

- (void)didMoveToSuperview {
	self.backgroundColor = [UIColor blackColor];
	self.userInteractionEnabled = true;
	self.contentMode = UIViewContentModeScaleAspectFit;
	[self addSubview:self.scanfView];
	[self addSubview:self.sureButton];
	[self addSubview:self.exitButton];
	
	[self.sureButton mas_updateConstraints:^(MASConstraintMaker *make) {
		make.width.mas_equalTo(70);
		make.height.mas_equalTo(70);
		make.bottom.mas_equalTo(self).offset(- 30);
		make.left.mas_equalTo(100);
	}];
	[self.exitButton mas_updateConstraints:^(MASConstraintMaker *make) {
		make.width.mas_equalTo(70);
		make.height.mas_equalTo(70);
		make.bottom.mas_equalTo(self).offset(- 30);
		make.right.mas_equalTo(- 100);
	}];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	self.sureButton.layer.cornerRadius = self.sureButton.bounds.size.width / 2;
	self.exitButton.layer.cornerRadius = self.exitButton.bounds.size.width / 2;
}

- (void)setInputImage:(UIImage *)inputImage outPutImageBlock:(void(^)(UIImage *outPutImage))outPutImageBlock {
	self.image = inputImage;
	CGFloat originImageWidth = self.image.size.width;
	CGFloat originImageHeight = self.image.size.height;
	
	CGFloat imageZoomScale = MAX(originImageWidth / self.frame.size.width, originImageHeight / self.frame.size.height);
	
	CGFloat zoomImageWidth = originImageWidth / imageZoomScale;
	CGFloat zoomImageHeight = originImageHeight / imageZoomScale;
	
	CGFloat imageX = (self.bounds.size.width - zoomImageWidth) / 2;
	CGFloat imageY = (self.bounds.size.height - zoomImageHeight) / 2;
	CGFloat imageWidth = zoomImageWidth;
	CGFloat imageHeight = zoomImageHeight;
	self.scanfView.frame = CGRectMake(imageX, imageY, imageWidth, imageHeight);
	
	__weak HTImageCutView *weakSelf = self;
	[self.sureButton ht_whenTap:^(UIView *view) {
		UIImage *fixOrientationImage = [inputImage ht_fixOrientation];
		CGRect scanfRect = weakSelf.scanfView.scanfRect;
		CGFloat widthScale = inputImage.size.width / imageWidth;
		CGFloat heightScale = inputImage.size.height / imageHeight;
		scanfRect.origin.x *= widthScale;
		scanfRect.origin.y *= heightScale;
		scanfRect.size.width *= widthScale;
		scanfRect.size.height *= heightScale;
		UIImage *outputImage = [fixOrientationImage ht_croppedAtRect:scanfRect];
		if (outPutImageBlock) {
			outPutImageBlock(outputImage);
		}
	}];
	[self.exitButton ht_whenTap:^(UIView *view) {
		if (outPutImageBlock) {
			outPutImageBlock(nil);
		}
	}];
}

- (HTScanfView *)scanfView {
	if (!_scanfView) {
		_scanfView = [[HTScanfView alloc] init];
	}
	return _scanfView;
}

- (UIButton *)sureButton {
	if (!_sureButton) {
		_sureButton = [[UIButton alloc] init];
		[_sureButton setImage:[[UIImage imageNamed:@"ExerciseOk128_128"] ht_resetSize:CGSizeMake(40, 40)] forState:UIControlStateNormal];
		_sureButton.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.4];
		_sureButton.layer.masksToBounds = true;
	}
	return _sureButton;
}

- (UIButton *)exitButton {
	if (!_exitButton) {
		_exitButton = [[UIButton alloc] init];
		[_exitButton setImage:[[UIImage imageNamed:@"ExerciseClose128_128"] ht_resetSize:CGSizeMake(40, 40)] forState:UIControlStateNormal];
		_exitButton.backgroundColor = self.sureButton.backgroundColor;
		_exitButton.layer.masksToBounds = true;
	}
	return _exitButton;
}

@end
