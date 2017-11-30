//
//  HTExerciseCell.m
//  GMat
//
//  Created by hublot on 2016/10/31.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTExerciseCell.h"
#import "HTExerciseModel.h"
#import "HTQuestionManager.h"

@interface HTExerciseCell ()

@property (nonatomic, strong) UILabel *titleNameLabel;

@property (nonatomic, strong) UILabel *detailNameLabel;

@property (nonatomic, strong) UIButton *firstExerciseButton;

@end

@implementation HTExerciseCell

- (void)didMoveToSuperview {
    UIView *selecteBackgroundView = [[UIView alloc] init];
    selecteBackgroundView.backgroundColor = [UIColor ht_colorString:@"f3f3f3"];
    [self.selectedBackgroundView addSubview:selecteBackgroundView];
    [selecteBackgroundView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
	[self.contentView addSubview:self.titleNameLabel];
	[self.contentView addSubview:self.detailNameLabel];
	[self.contentView addSubview:self.firstExerciseButton];
	[self.contentView addSubview:self.secondExerciseButton];
	[self.secondExerciseButton mas_updateConstraints:^(MASConstraintMaker *make) {
		make.height.mas_equalTo(self.firstExerciseButton);
		make.right.mas_equalTo(self).offset(- 15);
		make.centerY.mas_equalTo(self.firstExerciseButton);
	}];
	[self.firstExerciseButton mas_updateConstraints:^(MASConstraintMaker *make) {
		make.height.mas_equalTo(HTADAPT568(25));
		make.centerY.mas_equalTo(self);
	}];
	[self.titleNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(self).offset(15);
		make.top.mas_equalTo(self).offset(10);
		make.right.mas_lessThanOrEqualTo(self.firstExerciseButton.mas_left).offset(- 10).priority(999);
	}];
	[self.detailNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(self).offset(15);
		make.bottom.mas_equalTo(self).offset(- 10);
		make.right.mas_lessThanOrEqualTo(self.firstExerciseButton.mas_left).offset(- 10).priority(999);
	}];
}

- (void)setModel:(HTExerciseModel *)model row:(NSInteger)row {
	[self didMoveToSuperview];
	CGFloat width = HTADAPT568(85);
	[self.firstExerciseButton mas_updateConstraints:^(MASConstraintMaker *make) {
		make.width.mas_equalTo(width);
		make.right.mas_equalTo(self.secondExerciseButton.mas_left).offset(0);
	}];
	[self.secondExerciseButton mas_updateConstraints:^(MASConstraintMaker *make) {
		make.width.mas_equalTo(0);
	}];
	switch (model.modelStyle) {
		case HTExerciseModelStyleSingle:
			self.titleNameLabel.text = [NSString stringWithFormat:@"%@-%@: %@", [HTQuestionManager twoobjectTitlteWithTwoobjectId:model.twoobjectid.integerValue], [HTQuestionManager sectionTitleWithSectionId:model.sectionid.integerValue], model.stname];
			break;
		case HTExerciseModelStylePoint:
			self.titleNameLabel.text = [NSString stringWithFormat:@"%@", model.knows];
			break;
		case HTExerciseModelStyleHardly:
			self.titleNameLabel.text = [NSString stringWithFormat:@"%@", model.stname];
			break;
		case HTExerciseModelStyleMock:
			self.titleNameLabel.text = [NSString stringWithFormat:@"%@", model.name];
			break;
		case HTExerciseModelStyleSort:
			self.titleNameLabel.text = [NSString stringWithFormat:@"%@: %@", [HTQuestionManager sectionTitleWithSectionId:model.sectionid.integerValue], model.stname];
		default:
			break;
	}
	NSString *exerciseTitle;
	UIColor *backgroundColor;
	if (model.modelStyle != HTExerciseModelStyleMock) {
		if (model.userlowertk.integerValue == 0) {
			exerciseTitle = @"开始做题";
			backgroundColor = [UIColor ht_colorString:@"197fed"];
		} else if (model.userlowertk.integerValue < model.lowertknumb) {
			exerciseTitle = @"继续做题";
			backgroundColor = [UIColor ht_colorString:@"ef921a"];
			[self.firstExerciseButton mas_updateConstraints:^(MASConstraintMaker *make) {
				make.right.mas_equalTo(self.secondExerciseButton.mas_left).offset(- 15);
			}];
			[self.secondExerciseButton mas_updateConstraints:^(MASConstraintMaker *make) {
				make.width.mas_equalTo(width);
			}];
		} else {
			exerciseTitle = @"查看结果";
			backgroundColor = [UIColor ht_colorString:@"4bc93a"];
		}
	} else {
		NSInteger mockQuestion = model.markquestion.integerValue;
		if (mockQuestion <= 0) {
			exerciseTitle = @"开始模考";
			backgroundColor = [UIColor ht_colorString:@"197fed"];
		} else if (mockQuestion == 1) {
			exerciseTitle = @"继续模考";
			backgroundColor = [UIColor ht_colorString:@"ef921a"];
		} else {
			exerciseTitle = @"查看结果";
			backgroundColor = [UIColor ht_colorString:@"4bc93a"];
		}
	}
	[self.firstExerciseButton setTitle:exerciseTitle forState:UIControlStateNormal];
	[self.firstExerciseButton setBackgroundColor:backgroundColor];
	NSMutableAttributedString *attributedString = [[[NSAttributedString alloc] initWithString:@""] mutableCopy];
	NSAttributedString *leftAttributedString;
	NSAttributedString *rightAttributedString;
	NSDictionary *normalDictionary  = @{NSFontAttributeName:[UIFont ht_fontStyle:HTFontStyleDetailSmall],
										NSForegroundColorAttributeName:[UIColor ht_colorStyle:HTColorStyleSecondaryTitle]};
	NSDictionary *selectedDictionary = @{NSFontAttributeName:[UIFont ht_fontStyle:HTFontStyleDetailSmall],
										 NSForegroundColorAttributeName:[UIColor ht_colorString:@"1f885d"]};
	if (model.modelStyle == HTExerciseModelStylePoint) {
		leftAttributedString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"题目总数: %ld ", model.lowertknumb] attributes:normalDictionary];
		rightAttributedString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"做题人数: %ld", model.num] attributes:selectedDictionary];
		self.firstExerciseButton.hidden = true;
		self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	} else if (model.modelStyle != HTExerciseModelStyleMock) {
		leftAttributedString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"已做: %@/%ld题 ", model.userlowertk, model.lowertknumb] attributes:normalDictionary];
		rightAttributedString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"平均正确率: %ld%%", model.correct] attributes:selectedDictionary];
	} else {
		model.lowertknumb = model.mockStartType == 1 ? 41 : (model.mockStartType == 2 ? 37 : 78);
		leftAttributedString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"已做: %ld / %ld题 ", model.userlowertk.integerValue, model.lowertknumb] attributes:normalDictionary];
		rightAttributedString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"平均得分: %ld分", model.mockStartType == 3 ? (NSInteger)roundf((CGFloat)model.averscore / 10) * 10 : model.averscore] attributes:selectedDictionary];
	}
	[attributedString appendAttributedString:leftAttributedString];
	[attributedString appendAttributedString:rightAttributedString];
	self.detailNameLabel.attributedText = attributedString;
}

- (UILabel *)titleNameLabel {
	if (!_titleNameLabel) {
		_titleNameLabel = [[UILabel alloc] init];
		_titleNameLabel.textColor = [UIColor ht_colorStyle:HTColorStylePrimaryTitle];
		_titleNameLabel.font = [UIFont ht_fontStyle:HTFontStyleTitleSmall];
	}
	return _titleNameLabel;
}

- (UILabel *)detailNameLabel {
	if (!_detailNameLabel) {
		_detailNameLabel = [[UILabel alloc] init];
	}
	return _detailNameLabel;
}

- (UIButton *)firstExerciseButton {
	if (!_firstExerciseButton) {
		_firstExerciseButton = [[UIButton alloc] init];
		_firstExerciseButton.titleLabel.font = [UIFont ht_fontStyle:HTFontStyleTitleSmall];
		[_firstExerciseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		_firstExerciseButton.layer.cornerRadius = 3;
		_firstExerciseButton.layer.masksToBounds = true;
		[_firstExerciseButton setContentHuggingPriority:300 forAxis:UILayoutConstraintAxisHorizontal];
		[_firstExerciseButton setContentCompressionResistancePriority:800 forAxis:UILayoutConstraintAxisHorizontal];
		_firstExerciseButton.userInteractionEnabled = false;
	}
	return _firstExerciseButton;
}

- (UIButton *)secondExerciseButton {
	if (!_secondExerciseButton) {
		_secondExerciseButton = [[UIButton alloc] init];
		_secondExerciseButton.titleLabel.font = [UIFont ht_fontStyle:HTFontStyleTitleSmall];
		[_secondExerciseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		_secondExerciseButton.layer.cornerRadius = 3;
		_secondExerciseButton.layer.masksToBounds = true;
		[_secondExerciseButton setContentHuggingPriority:300 forAxis:UILayoutConstraintAxisHorizontal];
		[_secondExerciseButton setContentCompressionResistancePriority:800 forAxis:UILayoutConstraintAxisHorizontal];
		_secondExerciseButton.userInteractionEnabled = false;
		[_secondExerciseButton setTitle:@"查看结果" forState:UIControlStateNormal];
		_secondExerciseButton.backgroundColor = [UIColor ht_colorString:@"4bc93a"];
	}
	return _secondExerciseButton;
}

@end
