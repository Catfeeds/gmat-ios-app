//
//  HTMockRecordCell.m
//  GMat
//
//  Created by hublot on 2016/11/4.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTMockRecordCell.h"
#import "HTMockRecordModel.h"

@interface HTMockRecordCell ()

@property (nonatomic, strong) UILabel *titleNameLabel;

@property (nonatomic, strong) UILabel *detailNameLabel;

@property (nonatomic, strong) UIButton *exerciseAgainButton;

@end

@implementation HTMockRecordCell

- (void)didMoveToSuperview {
	[self addSubview:self.titleNameLabel];
	[self addSubview:self.detailNameLabel];
	[self addSubview:self.exerciseAgainButton];
	[self.titleNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(self).offset(15);
		make.top.mas_equalTo(self).offset(10);
		make.right.mas_lessThanOrEqualTo(self.exerciseAgainButton.mas_left).offset(- 10).priority(999);
	}];
	[self.detailNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(self).offset(15);
		make.bottom.mas_equalTo(self).offset(- 10);
		make.right.mas_lessThanOrEqualTo(self.exerciseAgainButton.mas_left).offset(- 10).priority(999);
	}];
	[self.exerciseAgainButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.mas_equalTo(90);
		make.height.mas_equalTo(30);
		make.right.mas_equalTo( - 15);
		make.centerY.mas_equalTo(self);
	}];
}

- (void)setModel:(HTMockRecordModel *)model row:(NSInteger)row {
	self.titleNameLabel.text = [NSString stringWithFormat:@"%@ - %@", model.name, model.nameid];
	self.detailNameLabel.text = [NSString stringWithFormat:@"已做: %ld / %@ 正确率:%ld%% 耗时:%@", model.releattr.correct.numAll.integerValue, model.num, (NSInteger)model.releattr.correct.correct, model.releattr.totletime];
	NSString *titleNameString = @"";
	UIColor *titleTintColor;
	if (model.markquestion.integerValue == 2) {
		titleNameString = @"查看结果";
		titleTintColor = [UIColor ht_colorString:@"4bc93a"];
	} else {
		titleNameString = @"继续模考";
		titleTintColor = [UIColor ht_colorString:@"ef921a"];
	}
	[self.exerciseAgainButton setTitle:titleNameString forState:UIControlStateNormal];
	self.exerciseAgainButton.backgroundColor = titleTintColor;
}

- (UILabel *)titleNameLabel {
	if (!_titleNameLabel) {
		_titleNameLabel = [[UILabel alloc] init];
		_titleNameLabel.textColor = [UIColor ht_colorStyle:HTColorStylePrimaryTitle];
		_titleNameLabel.font = [UIFont systemFontOfSize:14];
	}
	return _titleNameLabel;
}

- (UILabel *)detailNameLabel {
	if (!_detailNameLabel) {
		_detailNameLabel = [[UILabel alloc] init];
		_detailNameLabel.textColor = [UIColor ht_colorStyle:HTColorStyleSecondaryTitle];
		_detailNameLabel.font = [UIFont systemFontOfSize:13];
	}
	return _detailNameLabel;
}

- (UIButton *)exerciseAgainButton {
	if (!_exerciseAgainButton) {
		_exerciseAgainButton = [[UIButton alloc] init];
		_exerciseAgainButton.userInteractionEnabled = false;
		_exerciseAgainButton.backgroundColor = [UIColor ht_colorStyle:HTColorStyleAnswerRight];
		_exerciseAgainButton.titleLabel.font = [UIFont systemFontOfSize:13];
		[_exerciseAgainButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[_exerciseAgainButton setTitle:@"查看结果" forState:UIControlStateNormal];
		_exerciseAgainButton.layer.cornerRadius = 3;
		_exerciseAgainButton.layer.masksToBounds = true;
		[_exerciseAgainButton setContentHuggingPriority:300 forAxis:UILayoutConstraintAxisHorizontal];
		[_exerciseAgainButton setContentCompressionResistancePriority:800 forAxis:UILayoutConstraintAxisHorizontal];
	}
	return _exerciseAgainButton;
}

@end
