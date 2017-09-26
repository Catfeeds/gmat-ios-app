//
//  HTSqliteUpdateView.m
//  GMat
//
//  Created by hublot on 2017/8/22.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTSqliteUpdateView.h"

@interface HTSqliteUpdateView ()

@property (nonatomic, strong) UILabel *titleNameLabel;

@property (nonatomic, strong) UIButton *sureUpdateButton;

@property (nonatomic, strong) UIButton *cancelUpdateButton;

@end

@implementation HTSqliteUpdateView

+ (instancetype)defaultUpdateView {
	static HTSqliteUpdateView *kHTSqliteUpdateView;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		kHTSqliteUpdateView = [[HTSqliteUpdateView alloc] init];
	});
	return kHTSqliteUpdateView;
}

+ (void)showUpdateAlertViewInSuperView:(UIView *)superView sureButtonBlock:(void(^)(HTSqliteUpdateView *))sureButtonBlock {
	HTSqliteUpdateView *udpateView = [HTSqliteUpdateView defaultUpdateView];
	[superView addSubview:udpateView];
	
	__weak typeof(udpateView) weakUpdateView = udpateView;
	[udpateView.sureUpdateButton ht_whenTap:^(UIView *view) {
		if (sureButtonBlock) {
			sureButtonBlock(weakUpdateView);
		}
	}];
	[udpateView.cancelUpdateButton ht_whenTap:^(UIView *view) {
		[self removeUpdateAlerView];
	}];
}

+ (void)removeUpdateAlerView {
	[[HTSqliteUpdateView defaultUpdateView] willMoveToSuperview:nil];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
	[super willMoveToSuperview:newSuperview];
	[self setAnimationWillShow:!newSuperview];
	[UIView animateWithDuration:0.25 animations:^{
		[self setAnimationWillShow:newSuperview];
	} completion:^(BOOL finished) {
		if (!newSuperview) {
			[self removeFromSuperview];
		} else {
			
		}
	}];
}

- (void)setAnimationWillShow:(BOOL)willShow {
	CGFloat height = 50;
	if (willShow) {
		self.frame = CGRectMake(0, 64, HTSCREENWIDTH, height);
		self.cancelUpdateButton.hidden = self.sureUpdateButton.hidden = false;
	} else {
		self.frame = CGRectMake(0, 64, HTSCREENWIDTH, 0);
		self.cancelUpdateButton.hidden = self.sureUpdateButton.hidden = true;
	}
}

- (void)didMoveToSuperview {
	self.clipsToBounds = true;
	self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
	[self addSubview:self.titleNameLabel];
	[self addSubview:self.sureUpdateButton];
	[self addSubview:self.cancelUpdateButton];
	[self.titleNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(15);
		make.right.mas_equalTo(self.sureUpdateButton.mas_left).offset(- 15);
		make.top.bottom.mas_equalTo(self);
	}];
	
	[self.sureUpdateButton mas_updateConstraints:^(MASConstraintMaker *make) {
		make.right.mas_equalTo(self.cancelUpdateButton.mas_left).offset(- 15);
		make.centerY.mas_equalTo(self);
	}];
	[self.cancelUpdateButton mas_updateConstraints:^(MASConstraintMaker *make) {
		make.right.mas_equalTo(- 15);
		make.centerY.mas_equalTo(self);
	}];
}

- (UILabel *)titleNameLabel {
	if (!_titleNameLabel) {
		_titleNameLabel = [[UILabel alloc] init];
		_titleNameLabel.font = [UIFont systemFontOfSize:16];
		_titleNameLabel.textColor = [UIColor ht_colorString:@"00a0e8"];
		_titleNameLabel.text = @"题库有更新咯~";
	}
	return _titleNameLabel;
}


- (UIButton *)sureUpdateButton {
	if (!_sureUpdateButton) {
		_sureUpdateButton = [self.class createButtonWithTitle:@"更新" titleColor:[UIColor whiteColor] backgroundColor:[UIColor ht_colorString:@"00a0e8"]];
	}
	return _sureUpdateButton;
}

- (UIButton *)cancelUpdateButton {
	if (!_cancelUpdateButton) {
		_cancelUpdateButton = [self.class createButtonWithTitle:@"取消" titleColor:[UIColor ht_colorStyle:HTColorStylePrimaryTitle] backgroundColor:[UIColor whiteColor]];
	}
	return _cancelUpdateButton;
}

+ (UIButton *)createButtonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor backgroundColor:(UIColor *)backgroundColor {
	UIButton *button = [[UIButton alloc] init];
	UIImage *normalBackgroundImage = [UIImage ht_pureColor:backgroundColor];
	UIColor *highlightBackgroundColor = [backgroundColor colorWithAlphaComponent:0.5];
	UIImage *highlightBackgroundImage = [UIImage ht_pureColor:highlightBackgroundColor];
	button.titleLabel.font = [UIFont systemFontOfSize:14];
	[button setTitle:title forState:UIControlStateNormal];
	[button setTitleColor:titleColor forState:UIControlStateNormal];
	[button setBackgroundImage:normalBackgroundImage forState:UIControlStateNormal];
	[button setBackgroundImage:highlightBackgroundImage forState:UIControlStateHighlighted];
	button.layer.cornerRadius = 3;
	button.layer.masksToBounds = true;
	button.contentEdgeInsets = UIEdgeInsetsMake(5, 12, 5, 12);
	[button setContentHuggingPriority:999 forAxis:UILayoutConstraintAxisHorizontal];
	[button setContentCompressionResistancePriority:999 forAxis:UILayoutConstraintAxisHorizontal];
	return button;
}

@end
