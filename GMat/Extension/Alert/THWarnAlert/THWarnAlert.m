//
//  THWarnAlert.m
//  TingApp
//
//  Created by hublot on 16/8/26.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "THWarnAlert.h"
#import "HTManagerController.h"

@interface THWarnAlert ()

@property (nonatomic, strong) UIButton *titleNameButton;

@property (nonatomic, strong) UILabel *messageNameLabel;

@property (nonatomic, strong) UIButton *sureActionButton;

@end

@implementation THWarnAlert

static THWarnAlert *warnAlert;

+ (void)title:(NSString *)title message:(NSString *)message sureAction:(void(^)(void))sureAction {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		warnAlert = [[THWarnAlert alloc] initWithFrame:CGRectMake(0, 0, 300, 140)];
		warnAlert.backgroundColor = [UIColor whiteColor];
		warnAlert.layer.cornerRadius = 5;
		warnAlert.layer.masksToBounds = true;
		[warnAlert addSubview:warnAlert.titleNameButton];
		[warnAlert addSubview:warnAlert.messageNameLabel];
		
		UIButton *cancelButton = [warnAlert actionButtonWithTitleName:@"取消"];
		[cancelButton ht_whenTap:^(UIView *view) {
			[warnAlert.superview removeFromSuperview];
		}];
		cancelButton.ht_x = warnAlert.ht_w - 15 - cancelButton.ht_w;
		cancelButton.ht_y = CGRectGetMaxY(warnAlert.messageNameLabel.frame);
		[warnAlert addSubview:cancelButton];
		[warnAlert addSubview:warnAlert.sureActionButton];
		[warnAlert ht_whenTap:^(UIView *view) {
			
		}];
	});
	[warnAlert.titleNameButton setTitle:title forState:UIControlStateNormal];
	warnAlert.messageNameLabel.text = message;
	[warnAlert.sureActionButton ht_whenTap:^(UIView *view) {
		[warnAlert.superview removeFromSuperview];
		if (sureAction) {
			sureAction();
		}
	}];
	UIButton *backGroundButton = [[UIButton alloc] init];
	backGroundButton.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.4];
	[backGroundButton ht_whenTap:^(UIView *view) {
		[backGroundButton removeFromSuperview];
	}];
	[backGroundButton addSubview:warnAlert];
    [warnAlert mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(warnAlert.ht_w);
        make.height.mas_equalTo(warnAlert.ht_h);
        make.centerX.mas_equalTo(backGroundButton);
        make.centerY.mas_equalTo(backGroundButton);
    }];
	[[UIApplication sharedApplication].keyWindow addSubview:backGroundButton];
    [backGroundButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
	
}

- (UIButton *)titleNameButton {
	if (!_titleNameButton) {
		_titleNameButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.ht_w, 40)];
		[_titleNameButton setImage:[UIImage imageNamed:@"Exercise26"] forState:UIControlStateNormal];
		_titleNameButton.backgroundColor = [UIColor ht_colorString:@"f23030"];
		[_titleNameButton setTitle:@"警告" forState:UIControlStateNormal];
		[_titleNameButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		_titleNameButton.titleLabel.font = [UIFont ht_fontStyle:HTFontStyleHeadSmall];
	}
	return _titleNameButton;
}

- (UILabel *)messageNameLabel {
	if (!_messageNameLabel) {
		_messageNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.titleNameButton.ht_h, self.ht_w, 55)];
		_messageNameLabel.numberOfLines = 0;
		_messageNameLabel.textAlignment =  NSTextAlignmentCenter;
		_messageNameLabel.font = [UIFont ht_fontStyle:HTFontStyleHeadSmall];
		_messageNameLabel.textColor = [UIColor ht_colorStyle:HTColorStylePrimaryTitle];
	}
	return _messageNameLabel;
}

- (UIButton *)sureActionButton {
	if (!_sureActionButton) {
		_sureActionButton = [self actionButtonWithTitleName:@"确定"];
		_sureActionButton.ht_x = 15;
		_sureActionButton.ht_y = CGRectGetMaxY(warnAlert.messageNameLabel.frame);
	}
	return _sureActionButton;
}


- (UIButton *)actionButtonWithTitleName:(NSString *)titleName {
	UIButton *actionButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, (self.ht_w - 30 - 15) / 2, 30)];
	[actionButton setTitleColor:[UIColor ht_colorStyle:HTColorStylePrimaryTitle] forState:UIControlStateNormal];
	actionButton.layer.cornerRadius = 5;
	actionButton.layer.borderWidth = 1;
	actionButton.layer.borderColor = [UIColor ht_colorString:@"bbbbbb"].CGColor;
	[actionButton setTitle:titleName forState:UIControlStateNormal];
	actionButton.titleLabel.font = [UIFont ht_fontStyle:HTFontStyleHeadSmall];
	return actionButton;
}

@end
