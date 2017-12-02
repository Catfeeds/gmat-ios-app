//
//  HTPlayerTeacherDetailCell.m
//  GMat
//
//  Created by hublot on 2017/10/9.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTPlayerTeacherDetailCell.h"
#import "HTPlayerController.h"
#import <NSAttributedString+HTAttributedString.h>
#import <NSObject+HTTableRowHeight.h>

@interface HTPlayerTeacherDetailCell ()

@property (nonatomic, strong) UIImageView *headImageView;

@property (nonatomic, strong) UILabel *titleNameLabel;

@property (nonatomic, strong) UILabel *detailNameLabel;

@end

@implementation HTPlayerTeacherDetailCell

- (void)didMoveToSuperview {
	self.backgroundColor = [UIColor clearColor];
	[self addSubview:self.headImageView];
	[self addSubview:self.titleNameLabel];
	[self addSubview:self.detailNameLabel];
	
	[self.headImageView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(15);
		make.top.mas_equalTo(15);
		make.width.height.mas_equalTo(100);
	}];
	[self.titleNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
		make.centerY.mas_equalTo(self.headImageView);
		make.right.mas_equalTo(- 15);
		make.left.mas_equalTo(self.headImageView.mas_right).offset(15);
	}];
	[self.detailNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(15);
		make.right.mas_equalTo(- 15);
		make.top.mas_equalTo(self.headImageView.mas_bottom).offset(15);
	}];
}

- (void)setModel:(NSObject <HTPlayerCourseProtocol> *)model row:(NSInteger)row {
	[self.headImageView sd_setImageWithURL:[NSURL URLWithString:GmatResourse(model.courseTeacherImage)] placeholderImage:HTPLACEHOLDERIMAGE];
	self.titleNameLabel.attributedText = model.courseTeacherTitle;
	self.detailNameLabel.attributedText = model.courseTeacherDetail;
	
	CGFloat modelHeight = 15;
	modelHeight += 100;
	modelHeight += 15;
	modelHeight += [self.detailNameLabel.attributedText ht_attributedStringHeightWithWidth:HTSCREENWIDTH - 30 textView:nil];
	modelHeight += 15;
	
	[model ht_setRowHeightNumber:@(modelHeight) forCellClass:self.class];
}

- (UIImageView *)headImageView {
	if (!_headImageView) {
		_headImageView = [[UIImageView alloc] init];
	}
	return _headImageView;
}

- (UILabel *)titleNameLabel {
	if (!_titleNameLabel) {
		_titleNameLabel = [[UILabel alloc] init];
		_titleNameLabel.numberOfLines = 0;
	}
	return _titleNameLabel;
}

- (UILabel *)detailNameLabel {
	if (!_detailNameLabel) {
		_detailNameLabel = [[UILabel alloc] init];
		_detailNameLabel.numberOfLines = 0;
	}
	return _detailNameLabel;
}

@end
