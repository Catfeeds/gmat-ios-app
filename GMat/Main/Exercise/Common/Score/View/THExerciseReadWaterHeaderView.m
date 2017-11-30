//
//  THExerciseReadWaterHeaderView.m
//  TingApp
//
//  Created by hublot on 16/9/12.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "THExerciseReadWaterHeaderView.h"
#import "LXWaveProgressView.h"
#import "HTScoreModel.h"
#import "NSString+HTString.h"

@interface THExerciseReadWaterHeaderView ()

@property (nonatomic, strong) UILabel *leftTimeLabel;

@property (nonatomic, strong) UILabel *topScoreLabel;

@property (nonatomic, strong) LXWaveProgressView *waterView;

@property (nonatomic, strong) UILabel *rightPresentLabel;

@end

@implementation THExerciseReadWaterHeaderView

- (void)didMoveToSuperview {
	[self addSubview:self.topScoreLabel];
	[self addSubview:self.leftTimeLabel];
	[self addSubview:self.waterView];
	[self addSubview:self.rightPresentLabel];
    [self.topScoreLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self);
        make.height.mas_equalTo(110);
        make.left.top.mas_equalTo(self);
    }];
    [self.waterView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.waterView.ht_w);
        make.height.mas_equalTo(self.waterView.ht_h);
        make.top.mas_equalTo(self.topScoreLabel.mas_bottom);
        make.centerX.mas_equalTo(self);
    }];
    [self.leftTimeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.right.mas_equalTo(self.waterView.mas_left);
        make.height.mas_equalTo(self.waterView);
        make.top.mas_equalTo(self.waterView);
    }];
    [self.rightPresentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self);
        make.left.mas_equalTo(self.waterView.mas_right);
        make.height.mas_equalTo(self.waterView);
        make.top.mas_equalTo(self.waterView);
    }];
}

- (void)setModel:(HTScoreModel *)model row:(NSInteger)row {
	NSString *elapsedTime = model.totletime;
	NSInteger rightPercent = model.correct;
	NSInteger rightCount = model.Qtruenum.integerValue;
	NSInteger allCount = model.qyesnum.integerValue;
	NSMutableAttributedString *leftAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n耗时", elapsedTime] attributes:nil];
	[leftAttributedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20], NSForegroundColorAttributeName:[UIColor ht_colorStyle:HTColorStylePrimaryTitle]} range:NSMakeRange(0, elapsedTime.length)];
	[leftAttributedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13], NSForegroundColorAttributeName:[UIColor ht_colorStyle:HTColorStyleSecondaryTitle]} range:NSMakeRange(elapsedTime.length + 1, leftAttributedString.length - elapsedTime.length - 1)];
	self.leftTimeLabel.attributedText = leftAttributedString;
	NSMutableAttributedString *rightAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld%%\n正确率", rightPercent] attributes:nil];
	[rightAttributedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20], NSForegroundColorAttributeName:[UIColor ht_colorStyle:HTColorStylePrimaryTitle]} range:NSMakeRange(0, [NSString stringWithFormat:@"%ld", rightPercent].length + 1)];
	[rightAttributedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13], NSForegroundColorAttributeName:[UIColor ht_colorStyle:HTColorStyleSecondaryTitle]} range:NSMakeRange([NSString stringWithFormat:@"%ld", rightPercent].length + 2, rightAttributedString.length - [NSString stringWithFormat:@"%ld", rightPercent].length - 2)];
	self.rightPresentLabel.attributedText = rightAttributedString;
	self.waterView.progress = rightPercent / 100.0;
	self.waterView.progressLabel.text = [NSString stringWithFormat:@"%ld/%ld", rightCount, allCount];
	self.waterView.progressLabel.textColor = [UIColor ht_colorStyle:HTColorStylePrimaryTheme];
	NSMutableAttributedString *scoreAttributedString;
	model.credit.V_score = (model.credit.V_score.integerValue > 25) ? model.credit.V_score : @"<25";
	model.credit.Q_score = (model.credit.Q_score.integerValue > 30) ? model.credit.Q_score : @"<30";
	model.credit.Totalscore = (model.credit.Totalscore.integerValue > 470) ? model.credit.Totalscore : @"<470";
	switch (model.mockStartType) {
		case 1:
			scoreAttributedString = [[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"本次得分: %@ (满分: 51分)", model.credit.V_score] attributes:@{}] mutableCopy];
			[scoreAttributedString addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:[UIFont systemFontOfSize:14].pointSize]} range:NSMakeRange(0, 5)];
			[scoreAttributedString addAttributes:@{NSForegroundColorAttributeName:[UIColor ht_colorStyle:HTColorStylePrimaryTheme]} range:NSMakeRange(6, model.credit.V_score.length)];
			[scoreAttributedString addAttributes:@{NSForegroundColorAttributeName:[UIColor ht_colorStyle:HTColorStylePrimaryTheme]} range:NSMakeRange(scoreAttributedString.string.length - 4, 2)];
			break;
		case 2:
			scoreAttributedString = [[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"本次得分: %@ (满分: 51分)", model.credit.Q_score] attributes:@{}] mutableCopy];
			[scoreAttributedString addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:[UIFont systemFontOfSize:14].pointSize]} range:NSMakeRange(0, 5)];
			[scoreAttributedString addAttributes:@{NSForegroundColorAttributeName:[UIColor ht_colorStyle:HTColorStylePrimaryTheme]} range:NSMakeRange(6, model.credit.Q_score.length)];
			[scoreAttributedString addAttributes:@{NSForegroundColorAttributeName:[UIColor ht_colorStyle:HTColorStylePrimaryTheme]} range:NSMakeRange(scoreAttributedString.string.length - 4, 2)];
			break;
		case 3:
			scoreAttributedString = [[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"语文得分: %@ (满分: 51分)\n\n数学得分: %@ (满分: 51分)\n\n本次总得分: %@ (满分: 800分)", model.credit.V_score, model.credit.Q_score, model.credit.Totalscore] attributes:@{}] mutableCopy];
			NSArray *scoreAttributedArray = [scoreAttributedString.string componentsSeparatedByString:@"\n\n"];
			[scoreAttributedArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
				NSRange positionRange = [scoreAttributedString.string rangeOfString:obj];
				if (positionRange.location != NSNotFound) {
					[scoreAttributedString addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:[UIFont systemFontOfSize:14].pointSize]} range:NSMakeRange(positionRange.location, 5)];
					if (idx == 0) {
						[scoreAttributedString addAttributes:@{NSForegroundColorAttributeName:[UIColor ht_colorStyle:HTColorStylePrimaryTheme]} range:NSMakeRange(6, model.credit.V_score.length)];
						[scoreAttributedString addAttributes:@{NSForegroundColorAttributeName:[UIColor ht_colorStyle:HTColorStylePrimaryTheme]} range:NSMakeRange(positionRange.location + positionRange.length - 4, 2)];
					} else if (idx == 1) {
						[scoreAttributedString addAttributes:@{NSForegroundColorAttributeName:[UIColor ht_colorStyle:HTColorStylePrimaryTheme]} range:NSMakeRange(positionRange.location + 6, model.credit.Q_score.length)];
						[scoreAttributedString addAttributes:@{NSForegroundColorAttributeName:[UIColor ht_colorStyle:HTColorStylePrimaryTheme]} range:NSMakeRange(positionRange.location + positionRange.length - 4, 2)];
					} else if (idx == 2) {
						[scoreAttributedString addAttributes:@{NSForegroundColorAttributeName:[UIColor ht_colorStyle:HTColorStylePrimaryTheme]} range:NSMakeRange(positionRange.location + 7, model.credit.Totalscore.length)];
						[scoreAttributedString addAttributes:@{NSForegroundColorAttributeName:[UIColor ht_colorStyle:HTColorStylePrimaryTheme]} range:NSMakeRange(positionRange.location + positionRange.length - 5, 3)];
					}
				}
			}];
			break;
	}
	self.topScoreLabel.attributedText = scoreAttributedString;
}

- (UILabel *)leftTimeLabel {
	if (!_leftTimeLabel) {
		_leftTimeLabel = [[UILabel alloc] init];
		_leftTimeLabel.numberOfLines = 0;
		_leftTimeLabel.textAlignment = NSTextAlignmentCenter;
	}
	return _leftTimeLabel;
}

- (UILabel *)topScoreLabel {
	if (!_topScoreLabel) {
		_topScoreLabel = [[UILabel alloc] init];
		_topScoreLabel.textColor = [UIColor ht_colorStyle:HTColorStylePrimaryTitle];
		_topScoreLabel.font = [UIFont systemFontOfSize:14];
		_topScoreLabel.numberOfLines = 0;
		_topScoreLabel.textAlignment = NSTextAlignmentCenter;
	}
	return _topScoreLabel;
}


- (LXWaveProgressView *)waterView {
	if (!_waterView) {
		_waterView = [[LXWaveProgressView alloc] initWithFrame:CGRectMake(0, 0, 170, 170)];
		_waterView.firstWaveColor = [UIColor ht_colorString:@"b7fdbd"];
		_waterView.secondWaveColor = [UIColor ht_colorString:@"51d16a"];
	}
	return _waterView;
}

- (UILabel *)rightPresentLabel {
	if (!_rightPresentLabel) {
		_rightPresentLabel = [[UILabel alloc] init];
		_rightPresentLabel.numberOfLines = 0;
		_rightPresentLabel.textAlignment = NSTextAlignmentCenter;
	}
	return _rightPresentLabel;
}


@end
