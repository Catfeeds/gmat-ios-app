//
//  THTeacherDetailHeaderCell.m
//  TingApp
//
//  Created by hublot on 16/8/24.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "THTeacherDetailHeaderCell.h"
#import "THCourseTogetherTeacherModel.h"
#import "UICollectionView+HTSeparate.h"
#import "NSString+HTString.h"
#import <NSObject+HTTableRowHeight.h>

@interface THTeacherDetailHeaderCell ()

@property (nonatomic, strong) UIImageView *backgroundImageView;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIButton *headImageButton;

@property (nonatomic, strong) UILabel *titleNameLabel;

@property (nonatomic, strong) UILabel *detailNameLabel;

@end

@implementation THTeacherDetailHeaderCell

- (void)didMoveToSuperview {
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	[self addSubview:self.backgroundImageView];
	[self addSubview:self.headImageButton];
	[self addSubview:self.titleNameLabel];
	[self addSubview:self.detailNameLabel];
	[self addSubview:self.lineView];
	[self.backgroundImageView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.edges.mas_equalTo(self);
	}];
	[self.headImageButton mas_updateConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(10);
		make.width.mas_equalTo(75);
		make.height.mas_equalTo(self.headImageButton.mas_width);
		make.top.mas_equalTo(30);
	}];
	[self.titleNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(self.headImageButton);
		make.left.mas_equalTo(self.headImageButton.mas_right).offset(10);
		make.right.mas_equalTo(- 10);
	}];
	[self.detailNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(self.titleNameLabel);
		make.right.mas_equalTo(self.titleNameLabel);
		make.top.mas_equalTo(self.lineView.mas_bottom).offset(10);
	}];
	[self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(self.titleNameLabel);
		make.right.mas_equalTo(self.titleNameLabel);
		make.height.mas_equalTo(1 / [UIScreen mainScreen].scale);
		make.top.mas_equalTo(self.titleNameLabel.mas_bottom).offset(10);
	}];
}

- (void)setModel:(THCourseTogetherTeacherModel *)model row:(NSInteger)row {
	[self.headImageButton sd_setImageWithURL:[NSURL URLWithString:GmatResourse(model.teacherIamge)] forState:UIControlStateNormal placeholderImage:HTPLACEHOLDERIMAGE];
	self.titleNameLabel.text = model.teacherName;
	self.detailNameLabel.text = model.title;
    
    CGFloat modelHeight = 120 + [self.detailNameLabel.text ht_stringHeightWithWidth:HTSCREENWIDTH - 10 - 75 - 10 - 10 font:self.detailNameLabel.font textView:nil];
    [model ht_setRowHeightNumber:@(modelHeight) forCellClass:self.class];
}

- (UIImageView *)backgroundImageView {
	if (!_backgroundImageView) {
		_backgroundImageView = [[UIImageView alloc] init];
		_backgroundImageView.image = [UIImage imageNamed:@"Course25"];
	}
	return _backgroundImageView;
}

- (UIView *)lineView {
	if (!_lineView) {
		_lineView = [[UIView alloc] init];
		_lineView.backgroundColor = [[UIColor ht_colorString:@"fafafa"] colorWithAlphaComponent:0.2];
	}
	return _lineView;
}

- (UIButton *)headImageButton {
	if (!_headImageButton) {
		_headImageButton = [[UIButton alloc] init];
		_headImageButton.layer.cornerRadius = 75 / 2;
		_headImageButton.layer.masksToBounds = true;
		_headImageButton.layer.borderColor = [UIColor ht_colorString:@"9cb1dd"].CGColor;
		_headImageButton.layer.borderWidth = 5;
	}
	return _headImageButton;
}

- (UILabel *)titleNameLabel {
	if (!_titleNameLabel) {
		_titleNameLabel = [[UILabel alloc] init];
		_titleNameLabel.font = [UIFont ht_fontStyle:HTFontStyleTitleSmall];
		_titleNameLabel.textColor = [UIColor ht_colorStyle:HTColorStyleBackground];
	}
	return _titleNameLabel;
}

- (UILabel *)detailNameLabel {
	if (!_detailNameLabel) {
		_detailNameLabel = [[UILabel alloc] init];
		_detailNameLabel.font = [UIFont ht_fontStyle:HTFontStyleDetailLarge];
		_detailNameLabel.textColor = [UIColor whiteColor];
		_detailNameLabel.numberOfLines = 0;
	}
	return _detailNameLabel;
}

@end
