//
//  HTMineRecordCell.m
//  GMat
//
//  Created by hublot on 2016/11/4.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTMineRecordCell.h"
#import "HTRecordExerciseModel.h"
#import <NSString+HTString.h>
#import <NSMutableAttributedString+HTMutableAttributedString.h>

@interface HTMineRecordCell ()

@property (nonatomic, strong) UILabel *titleNameLabel;

@property (nonatomic, strong) UILabel *detailNameLabel;

@property (nonatomic, strong) UILabel *exerciseTimeLabel;

@end

@implementation HTMineRecordCell

- (void)didMoveToSuperview {
	[self.contentView addSubview:self.titleNameLabel];
	[self.contentView addSubview:self.detailNameLabel];
	[self.contentView addSubview:self.exerciseTimeLabel];
	[self.titleNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(self).offset(15);
		make.right.mas_equalTo(self).offset(- 15);
		make.top.mas_equalTo(self).offset(10);
	}];
	[self.detailNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(self).offset(15);
		make.right.mas_equalTo(self).offset(- 15);
		make.top.mas_equalTo(self.titleNameLabel.mas_bottom).offset(10);
	}];
	[self.exerciseTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(self).offset(15);
		make.right.mas_equalTo(self).offset(- 15);
		make.top.mas_equalTo(self.detailNameLabel.mas_bottom).offset(10);
	}];
}

- (void)setModel:(HTRecordExerciseModel *)model row:(NSInteger)row {
	NSString *exerciseNameString = [NSString stringWithFormat:@"%@-%@", model.section, model.questionId];
	NSString *exerciseAnswerUserString = [NSString stringWithFormat:@"你的答案:%@", model.userAnswer];
	NSString *exerciseAnswerRightString = [NSString stringWithFormat:@"正确答案:%@", model.rightAnswer];
	NSString *exerciseAnswerString = [NSString stringWithFormat:@"%@ %@", exerciseAnswerUserString, exerciseAnswerRightString];
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@  %@", exerciseNameString, exerciseAnswerString] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
	[attributedString addAttributes:@{NSForegroundColorAttributeName:[UIColor ht_colorStyle:HTColorStylePrimaryTheme]} range:NSMakeRange(0, exerciseNameString.length)];
	[attributedString addAttributes:@{NSForegroundColorAttributeName:[UIColor ht_colorStyle:HTColorStyleAnswerRight]} range:NSMakeRange(attributedString.length - exerciseAnswerRightString.length, exerciseAnswerRightString.length)];
	self.titleNameLabel.attributedText = attributedString;
    
    NSMutableAttributedString *questionAttributedString = [[[model.questionTitle ht_htmlDecodeString] ht_attributedStringNeedDispatcher:nil] mutableCopy];
    [questionAttributedString ht_clearBreakLineMaxAllowContinueCount:0];
	self.detailNameLabel.text = questionAttributedString.string;
    
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	dateFormatter.dateFormat = @"yyyy.MM.dd HH:mm:ss";
	NSString *submitTimeString = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:model.submitTime.integerValue]];
	NSString *durationString;
	if (model.duration.integerValue > 60 * 60) {
		durationString = [NSString stringWithFormat:@"%ldh%ldm", model.duration.integerValue / 3600, model.duration.integerValue / 60];
	} else if (model.duration.integerValue > 60) {
		durationString = [NSString stringWithFormat:@"%ldm%lds", model.duration.integerValue / 60, model.duration.integerValue % 60];
	} else {
		durationString = [NSString stringWithFormat:@"%@s", model.duration];
	}
	self.exerciseTimeLabel.text = [NSString stringWithFormat:@"%@ 用时:%@ %@人已做", submitTimeString, durationString, model.num];
}

- (UILabel *)titleNameLabel {
	if (!_titleNameLabel) {
		_titleNameLabel = [[UILabel alloc] init];
		_titleNameLabel.textColor = [UIColor ht_colorStyle:HTColorStylePrimaryTitle];
	}
	return _titleNameLabel;
}

- (UILabel *)detailNameLabel {
	if (!_detailNameLabel) {
		_detailNameLabel = [[UILabel alloc] init];
		_detailNameLabel.textColor = [UIColor ht_colorStyle:HTColorStyleSecondaryTitle];
		_detailNameLabel.font = [UIFont systemFontOfSize:14];
	}
	return _detailNameLabel;
}

- (UILabel *)exerciseTimeLabel {
	if (!_exerciseTimeLabel) {
		_exerciseTimeLabel = [[UILabel alloc] init];
		_exerciseTimeLabel.textColor = [UIColor ht_colorStyle:HTColorStyleSpecialTitle];
		_exerciseTimeLabel.font = [UIFont systemFontOfSize:13];
		_exerciseTimeLabel.textAlignment = NSTextAlignmentRight;
	}
	return _exerciseTimeLabel;
}

@end
