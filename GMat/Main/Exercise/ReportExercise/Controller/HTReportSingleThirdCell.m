//
//  HTReportSingleThirdCell.m
//  GMat
//
//  Created by hublot on 16/11/30.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTReportSingleThirdCell.h"
#import <UIButton+HTButtonCategory.h>
#import "HTReportModel.h"

@interface HTReportSingleThirdCell ()

@property (nonatomic, strong) UIButton *titleNameButton;

@end

@implementation HTReportSingleThirdCell

- (void)didMoveToSuperview {
	self.backgroundColor = [UIColor clearColor];
	[self addSubview:self.titleNameButton];
	[self.titleNameButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.mas_equalTo(self);
	}];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	[self.titleNameButton ht_makeEdgeWithDirection:HTButtonEdgeDirectionHorizontal imageViewToTitleLabelSpeceOffset:20];
}

- (void)setModel:(HTReportModel *)model row:(NSInteger)row {
	[self.titleNameButton setImage:[UIImage imageNamed:@"Exercise14"] forState:UIControlStateNormal];
	CGFloat avavgeCorrect;
	switch (self.reportStyle) {
		case 0:
			avavgeCorrect = (model.sc_data.correctAll + model.rc_data.correctAll + model.cr_data.correctAll + model.quant_data.correctAll) / 4.0;
			break;
		case 1:
			avavgeCorrect = model.sc_data.correctAll;
			break;
		case 2:
			avavgeCorrect = model.rc_data.correctAll;
			break;
		case 3:
			avavgeCorrect = model.cr_data.correctAll;
			break;
		case 4:
			avavgeCorrect = model.quant_data.correctAll;
			break;
	}
	NSString *titleNameString = @"";
	if (avavgeCorrect >= 70) {
		titleNameString = [NSString stringWithFormat:@"总体掌握不错, 继续加油"];
	} else if (avavgeCorrect >= 50) {
		titleNameString = [NSString stringWithFormat:@"总体掌握一般, 还有提升空间"];
	} else {
		titleNameString = [NSString stringWithFormat:@"总体掌握较差, 继续努力"];
	}
	[self.titleNameButton setTitle:titleNameString forState:UIControlStateNormal];
}

- (UIButton *)titleNameButton {
	if (!_titleNameButton) {
		_titleNameButton = [[UIButton alloc] init];
		[_titleNameButton setTitleColor:[UIColor ht_colorStyle:HTColorStylePrimaryTitle] forState:UIControlStateNormal];
		_titleNameButton.titleLabel.font = [UIFont systemFontOfSize:13];
		_titleNameButton.titleLabel.numberOfLines = 0;
	}
	return _titleNameButton;
}


@end
