//
//  HTOctopusAlertView.m
//  GMat
//
//  Created by hublot on 16/11/29.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTOctopusAlertView.h"

@interface HTOctopusAlertView ()

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *titleNameLabel;

@property (nonatomic, strong) UILabel *messageNameLabel;

@property (nonatomic, strong) UIButton *tryAgainButton;

@property (nonatomic, copy) void(^tryAgainBlock)(void);

@end

static HTOctopusAlertView *octopusAlertView;

@implementation HTOctopusAlertView

+ (HTOctopusAlertView *)title:(NSString *)title message:(NSString *)message tryAgainTitle:(NSString *)tryAgainTitle tryAgainBlock:(void(^)(void))tryAgainBlock {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		octopusAlertView = [[HTOctopusAlertView alloc] initWithFrame:[UIScreen mainScreen].bounds];
	});
	octopusAlertView.titleNameLabel.text = title;
	octopusAlertView.messageNameLabel.text = message;
	[octopusAlertView.tryAgainButton setTitle:tryAgainTitle forState:UIControlStateNormal];
	octopusAlertView.tryAgainBlock = tryAgainBlock;
	[[UIApplication sharedApplication].keyWindow addSubview:octopusAlertView];
	return octopusAlertView;
}

+ (void)dissmissAlert {
	[octopusAlertView removeFromSuperview];
}

- (void)didMoveToSuperview {
	octopusAlertView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
	[octopusAlertView ht_whenTap:^(UIView *view) {
		[[self class] dissmissAlert];
	}];
	[octopusAlertView addSubview:octopusAlertView.contentView];
	[octopusAlertView.contentView addSubview:octopusAlertView.imageView];
	[octopusAlertView.contentView addSubview:octopusAlertView.titleNameLabel];
	[octopusAlertView.contentView addSubview:octopusAlertView.messageNameLabel];
	[octopusAlertView.contentView addSubview:octopusAlertView.tryAgainButton];
}

- (UIView *)contentView {
	if (!_contentView) {
		_contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HTSCREENWIDTH / 1.5, HTSCREENWIDTH / 1.5)];
		_contentView.center = octopusAlertView.center;
		CAShapeLayer *shapeLayer = [CAShapeLayer layer];
		shapeLayer.bounds = _contentView.bounds;
		shapeLayer.position = CGPointMake(_contentView.ht_w / 2, _contentView.ht_h / 2);
		shapeLayer.fillColor = [UIColor ht_colorString:@"e6e6e6"].CGColor;
		shapeLayer.strokeColor = [UIColor clearColor].CGColor;
		UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:_contentView.bounds cornerRadius:5];
		[bezierPath addArcWithCenter:CGPointMake(_contentView.ht_w / 2, 0) radius:_contentView.ht_w / 4 startAngle:0 endAngle:M_PI * 2 clockwise:true];
		shapeLayer.path = bezierPath.CGPath;
		[_contentView.layer addSublayer:shapeLayer];
		[_contentView ht_whenTap:^(UIView *view) {
			
		}];
	}
	return _contentView;
}

- (UIImageView *)imageView {
	if (!_imageView) {
		_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.ht_w / 2.5, self.contentView.ht_w / 2.5)];
		_imageView.contentMode = UIViewContentModeScaleAspectFill;
		_imageView.center = CGPointMake(self.contentView.ht_w / 2, self.contentView.ht_w / 8);
		_imageView.image = [UIImage imageNamed:@"MineLogin1"];
		[_imageView ht_whenTap:^(UIView *view) {
			
		}];
	}
	return _imageView;
}

- (UILabel *)titleNameLabel {
	if (!_titleNameLabel) {
		_titleNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.contentView.ht_w, HTADAPT568(35))];
		_titleNameLabel.center = CGPointMake(self.contentView.ht_w / 2, CGRectGetMaxY(self.imageView.frame) + HTADAPT568(30));
		_titleNameLabel.textColor = [UIColor orangeColor];
		_titleNameLabel.font = [UIFont ht_fontStyle:HTFontStyleTitleLarge];
		_titleNameLabel.textAlignment = NSTextAlignmentCenter;
		_titleNameLabel.numberOfLines = 0;
	}
	return _titleNameLabel;
}

- (UILabel *)messageNameLabel {
	if (!_messageNameLabel) {
		_messageNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.contentView.ht_w, 20)];
		_messageNameLabel.center = CGPointMake(self.contentView.ht_w / 2, CGRectGetMaxY(self.titleNameLabel.frame) + HTADAPT568(30));
		_messageNameLabel.textColor = [UIColor ht_colorStyle:HTColorStylePrimaryTitle];
		_messageNameLabel.font = [UIFont ht_fontStyle:HTFontStyleDetailLarge];
		_messageNameLabel.textAlignment = NSTextAlignmentCenter;
	}
	return _messageNameLabel;
}

- (UIButton *)tryAgainButton {
	if (!_tryAgainButton) {
		_tryAgainButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.contentView.ht_w - HTADAPT568(40), (self.contentView.ht_w - HTADAPT568(60)) * 0.2)];
		_tryAgainButton.layer.cornerRadius = _tryAgainButton.ht_h / 2;
		_tryAgainButton.layer.masksToBounds = true;
		_tryAgainButton.center = CGPointMake(self.contentView.ht_w / 2, (self.contentView.ht_h - CGRectGetMaxY(self.messageNameLabel.frame)) / 2 + CGRectGetMaxY(self.messageNameLabel.frame));
		[_tryAgainButton setBackgroundImage:[UIImage ht_pureColor:[UIColor ht_colorString:@"fa4a45"]] forState:UIControlStateNormal];
		[_tryAgainButton setBackgroundImage:[UIImage ht_pureColor:[UIColor ht_colorString:@"fa4a00"]] forState:UIControlStateHighlighted];
		_tryAgainButton.titleLabel.font = [UIFont ht_fontStyle:HTFontStyleTitleSmall];
		[_tryAgainButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[_tryAgainButton ht_whenTap:^(UIView *view) {
			[[octopusAlertView class] dissmissAlert];
			if (octopusAlertView.tryAgainBlock) {
				octopusAlertView.tryAgainBlock();
			}
		}];
	}
	return _tryAgainButton;
}


@end
