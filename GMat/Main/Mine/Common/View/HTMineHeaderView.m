//
//  HTExerciseHeaderView.m
//  GMat
//
//  Created by hublot on 2016/10/18.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTMineHeaderView.h"
#import <UIButton+HTButtonCategory.h>
#import "HTLoginManager.h"
#import "THMinePreferenceController.h"
#import "HTQuestionController.h"
#import "HTScoreController.h"
#import "HTQuestionManager.h"


@interface HTMineHeaderView ()

@property (nonatomic, strong) UIImageView *headImageView;

@property (nonatomic, strong) UILabel *headLeftLabel;

@property (nonatomic, strong) UILabel *headRightLabel;

@property (nonatomic, strong) UILabel *nicknameLabel;

@property (nonatomic, strong) UILabel *nearExerciseLabel;

@property (nonatomic, strong) UIButton *continueExerciseButton;

@end

@implementation HTMineHeaderView

- (void)didMoveToSuperview {
	[self addSubview:self.headImageView];
	[self addSubview:self.headLeftLabel];
	[self addSubview:self.headRightLabel];
	[self addSubview:self.nicknameLabel];
	[self addSubview:self.nearExerciseLabel];
	[self addSubview:self.continueExerciseButton];
	[self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.mas_equalTo(self);
		make.centerY.mas_equalTo(- self.ht_h * 0.1);
		make.width.mas_equalTo(self.headImageView.mas_height);
		make.width.mas_equalTo(HTADAPT568(80));
	}];
	[self.headLeftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(self);
		make.right.mas_equalTo(self.headImageView.mas_left);
		make.centerY.mas_equalTo(self.headImageView);
	}];
	[self.headRightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.mas_equalTo(self);
		make.left.mas_equalTo(self.headImageView.mas_right);
		make.centerY.mas_equalTo(self.headImageView);
	}];
	[self.nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.right.mas_equalTo(self);
		make.top.mas_equalTo(self.headImageView.mas_bottom).offset(HTADAPT568(7));
	}];
	[self.nearExerciseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(self.nicknameLabel.mas_bottom).offset(HTADAPT568(7));
		make.left.right.mas_equalTo(self);
	}];
	[self.continueExerciseButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(self.nearExerciseLabel.mas_bottom).offset(HTADAPT568(15));
		make.centerX.mas_equalTo(self);
		make.width.mas_equalTo(HTADAPT568(60));
		make.height.mas_equalTo(HTADAPT568(22));
	}];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateModel) name:kHTLoginNotification object:nil];
    [self updateModel];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	self.headImageView.layer.cornerRadius = HTADAPT568(80) / 2;
	self.headImageView.layer.masksToBounds = true;
}

- (void)updateModel {
	HTUser *user = [HTUserManager currentUser];
	[self setLeftAttributedNumber:user.num.integerValue rightAttributedNumber:user.accuracy.integerValue];
	[self.headImageView sd_setImageWithURL:[NSURL URLWithString:GmatResourse(user.photo)] placeholderImage:HTPLACEHOLDERIMAGE];
	self.nicknameLabel.text = user.nickname.length ? user.nickname : @"没有设置昵称";
	self.nearExerciseLabel.text = user.user_tikuname.length ? [NSString stringWithFormat:@"你最近做到了 \"%@\"", user.user_tikuname] : @"";
//	[self.continueExerciseButton setTitle:user.permission >= HTUserPermissionExerciseNotFullThreeUser ? @"继续做题" : @"登录" forState:UIControlStateNormal];
	[self.continueExerciseButton setTitle:user.permission >= HTUserPermissionExerciseAbleUser ? @"继续做题" : @"登录" forState:UIControlStateNormal];
}

- (void)setLeftAttributedNumber:(NSInteger)leftNumber rightAttributedNumber:(NSInteger)rightNumber {
	NSMutableAttributedString *leftAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld\n做题数量", leftNumber] attributes:nil];
	[leftAttributedString addAttributes:@{NSFontAttributeName:[UIFont ht_fontStyle:HTFontStyleHeadLarge], NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(0, [NSString stringWithFormat:@"%ld", leftNumber].length)];
	[leftAttributedString addAttributes:@{NSFontAttributeName:[UIFont ht_fontStyle:HTFontStyleDetailLarge], NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange([NSString stringWithFormat:@"%ld", leftNumber].length, leftAttributedString.length - [NSString stringWithFormat:@"%ld", leftNumber].length)];
	self.headLeftLabel.attributedText = leftAttributedString;
	NSMutableAttributedString *rightAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld%%\n平均正确率", rightNumber] attributes:nil];
	[rightAttributedString addAttributes:@{NSFontAttributeName:[UIFont ht_fontStyle:HTFontStyleHeadLarge], NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(0, [NSString stringWithFormat:@"%ld", rightNumber].length)];
	[rightAttributedString addAttributes:@{NSFontAttributeName:[UIFont ht_fontStyle:HTFontStyleDetailLarge], NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange([NSString stringWithFormat:@"%ld", rightNumber].length, rightAttributedString.length - [NSString stringWithFormat:@"%ld", rightNumber].length)];
	self.headRightLabel.attributedText = rightAttributedString;
}

- (UIImageView *)headImageView {
	if (!_headImageView) {
		_headImageView = [[UIImageView alloc] init];
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:GmatResourse([HTUserManager currentUser].photo)] placeholderImage:HTPLACEHOLDERIMAGE];
		[_headImageView ht_whenTap:^(UIView *view) {
			THMinePreferenceController *preferenceController = [[THMinePreferenceController alloc] init];
			[self.ht_controller.navigationController pushViewController:preferenceController animated:true];
		}];
	}
	return _headImageView;
}

- (UILabel *)headLeftLabel {
	if (!_headLeftLabel) {
		_headLeftLabel = [[UILabel alloc] init];
		_headLeftLabel.numberOfLines = 0;
		_headLeftLabel.textAlignment = NSTextAlignmentCenter;
		[self setLeftAttributedNumber:0 rightAttributedNumber:0];
	}
	return _headLeftLabel;
}

- (UILabel *)headRightLabel {
	if (!_headRightLabel) {
		_headRightLabel = [[UILabel alloc] init];
		_headRightLabel.numberOfLines = 0;
		_headRightLabel.textAlignment = NSTextAlignmentCenter;
	}
	return _headRightLabel;
}

- (UILabel *)nicknameLabel {
	if (!_nicknameLabel) {
		_nicknameLabel = [[UILabel alloc] init];
		_nicknameLabel.textColor = [UIColor whiteColor];
		_nicknameLabel.font = [UIFont ht_fontStyle:HTFontStyleTitleLarge];
		_nicknameLabel.textAlignment = NSTextAlignmentCenter;
		_nicknameLabel.text = @"游客";
	}
	return _nicknameLabel;
}

- (UILabel *)nearExerciseLabel {
	if (!_nearExerciseLabel) {
		_nearExerciseLabel = [[UILabel alloc] init];
		_nearExerciseLabel.font = [UIFont ht_fontStyle:HTFontStyleDetailLarge];
		_nearExerciseLabel.textColor = [UIColor whiteColor];
		_nearExerciseLabel.textAlignment = NSTextAlignmentCenter;
		_nearExerciseLabel.text = @"";
	}
	return _nearExerciseLabel;
}

- (UIButton *)continueExerciseButton {
	if (!_continueExerciseButton) {
		_continueExerciseButton = [[UIButton alloc] init];
		[_continueExerciseButton setBackgroundImage:[UIImage ht_pureColor:[UIColor colorWithWhite:0.7 alpha:0.3]] forState:UIControlStateNormal];
		[_continueExerciseButton setBackgroundImage:[UIImage ht_pureColor:[UIColor colorWithWhite:0.4 alpha:0.3]] forState:UIControlStateHighlighted];
		[_continueExerciseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		_continueExerciseButton.titleLabel.font = [UIFont ht_fontStyle:HTFontStyleDetailLarge];
		_continueExerciseButton.layer.cornerRadius = 3;
		_continueExerciseButton.layer.masksToBounds = true;
		[_continueExerciseButton setTitle:@"登录" forState:UIControlStateNormal];
		[_continueExerciseButton ht_whenTap:^(UIView *view) {
			if ([_continueExerciseButton.currentTitle containsString:@"登录"]) {
				[HTLoginManager presentAndLoginSuccess:nil];
			} else {
				HTUser *user = [HTUserManager currentUser];
				if (user.user_tikuname.length && user.nearExerciseStid.length) {
                    HTExerciseModel *exerciseModel = [HTQuestionManager packExerciseModelWithStid:user.nearExerciseStid];
                    if (exerciseModel) {
                        HTQuestionController *questionController;
                        HTQuestionControllerBlocks *questionControllerBlocks;
                        HTScoreController *scoreController;
                        questionControllerBlocks = [[HTQuestionControllerBlocks alloc] initWithNavigationControllerToPushQuestionController:self.ht_controller.navigationController exerciseModel:exerciseModel];
                        if (exerciseModel.userlowertk.integerValue < exerciseModel.lowertknumb) {
                            questionController = [[HTQuestionController alloc] init];
                            questionController.blockPackage = questionControllerBlocks;
                            [self.ht_controller.navigationController pushViewController:questionController animated:true];
                        } else {
                            scoreController = [HTQuestionControllerBlocks scoreControllerWithExerciseModel:exerciseModel];
                            scoreController.blockPacket = questionControllerBlocks;
                            [self.ht_controller.navigationController pushViewController:scoreController animated:true];
                        }
                    } else {
                        [HTAlert title:@"获取最近做题记录失败"];
                    }
				} else {
					[HTAlert title:@"获取最近做题记录失败"];
				}
			}
		}];
	}
	return _continueExerciseButton;
}

@end
