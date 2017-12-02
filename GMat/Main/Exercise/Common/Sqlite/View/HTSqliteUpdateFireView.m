//
//  HTSqliteUpdateFireView.m
//  GMat
//
//  Created by hublot on 2017/8/22.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTSqliteUpdateFireView.h"

@interface HTSqliteUpdateFireView ()

@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, strong) UIImageView *contentImageView;

@property (nonatomic, strong) UIProgressView *progressView;

@property (nonatomic, strong) UILabel *titleNameLabel;

@end

@implementation HTSqliteUpdateFireView

+ (instancetype)defaultFireView {
	static HTSqliteUpdateFireView *kHTUpdateFireView;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		kHTUpdateFireView = [[HTSqliteUpdateFireView alloc] init];
	});
	return kHTUpdateFireView;
}

+ (void)showUpdateFireView {
	HTSqliteUpdateFireView *fireView = [HTSqliteUpdateFireView defaultFireView];
	[HTSqliteUpdateFireView setProgress:0];
	
	[[UIApplication sharedApplication].keyWindow addSubview:fireView.backgroundView];
	
	[fireView.backgroundView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.edges.mas_equalTo(UIEdgeInsetsZero);
	}];
	[fireView.backgroundView addSubview:fireView];
	[fireView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.edges.mas_equalTo(UIEdgeInsetsZero);
	}];
}

+ (void)setProgress:(CGFloat)progress {
	HTSqliteUpdateFireView *fireView = [HTSqliteUpdateFireView defaultFireView];
	fireView.progressView.progress = progress;
}

+ (void)removeUpdateFireView {
	
}

+ (void)removeUpdateAlerView {
	[[HTSqliteUpdateFireView defaultFireView] willMoveToSuperview:nil];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
	[super willMoveToSuperview:newSuperview];
	[self setAnimationWillShow:!newSuperview];
	[UIView animateWithDuration:0.25 animations:^{
		[self setAnimationWillShow:newSuperview];
	} completion:^(BOOL finished) {
		if (!newSuperview) {
			[self removeFromSuperview];
			[self.backgroundView removeFromSuperview];
		} else {
			
		}
	}];
}

- (void)setAnimationWillShow:(BOOL)willShow {
	if (willShow) {
		self.backgroundView.alpha = 1;
		self.transform = CGAffineTransformIdentity;
	} else {
		self.backgroundView.alpha = 0;
		self.transform = CGAffineTransformMakeScale(0.8, 0.8);
	}
}

- (void)didMoveToSuperview {
	[self addSubview:self.contentImageView];
	[self.contentImageView addSubview:self.progressView];
	[self.contentImageView addSubview:self.titleNameLabel];
	[self.contentImageView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.center.mas_equalTo(self);
		make.height.mas_equalTo(300);
	}];
	[self.progressView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(50);
		make.right.mas_equalTo(- 50);
		self.progressView.layer.cornerRadius = 5;
		make.height.mas_equalTo(10);
		make.bottom.mas_equalTo(self.titleNameLabel.mas_top).offset(- 0);
	}];
	[self.titleNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
		make.left.right.bottom.mas_equalTo(self.contentImageView);
		make.height.mas_equalTo(80);
	}];
}

- (UIView *)backgroundView {
	if (!_backgroundView) {
		_backgroundView = [[UIView alloc] init];
		_backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
	}
	return _backgroundView;
}

- (UIImageView *)contentImageView {
	if (!_contentImageView) {
		_contentImageView = [[UIImageView alloc] init];
		UIImage *image = [UIImage imageNamed:@"cn_sqlite_update_fire_background"];
		image = [image ht_resetSizeZoomNumber:300 / image.size.width];
		UIEdgeInsets insets = UIEdgeInsetsMake(150, 0, 0, 0);
		image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
		_contentImageView.image = image;
	}
	return _contentImageView;
}

- (UIProgressView *)progressView {
	if (!_progressView) {
		_progressView = [[UIProgressView alloc] init];
		_progressView.layer.masksToBounds = true;
	}
	return _progressView;
}

- (UILabel *)titleNameLabel {
	if (!_titleNameLabel) {
		_titleNameLabel = [[UILabel alloc] init];
		_titleNameLabel.font = [UIFont systemFontOfSize:16];
		_titleNameLabel.textColor = [UIColor ht_colorStyle:HTColorStylePrimaryTitle];
		_titleNameLabel.textAlignment = NSTextAlignmentCenter;
		_titleNameLabel.text = @"正在更新";
	}
	return _titleNameLabel;
}


@end
