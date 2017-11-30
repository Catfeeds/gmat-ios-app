//
//  HTOpenCell.m
//  GMat
//
//  Created by hublot on 16/10/14.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTOpenCell.h"
#import "HTCourseOpenModel.h"
#import <UIButton+HTButtonCategory.h>

@interface HTOpenCell ()

@property (nonatomic, strong) UIButton *courseDateButton;

@property (nonatomic, strong) UIImageView *headImageView;

@property (nonatomic, strong) UILabel *titleNameLabel;

@property (nonatomic, strong) UILabel *detailNameLabel;

//@property (nonatomic, strong) UIButton *courseSignButton;

@end

@implementation HTOpenCell

- (void)dealloc {
    
}

- (void)didMoveToSuperview {
	[self addSubview:self.courseDateButton];
	[self addSubview:self.headImageView];
	[self addSubview:self.titleNameLabel];
	[self addSubview:self.detailNameLabel];
	[self.courseDateButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(self.headImageView);
		make.top.mas_equalTo(self).mas_offset(5);
	}];
	[self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(self).mas_offset(15);
		make.top.mas_equalTo(self.courseDateButton.mas_bottom).mas_offset(5);
		make.width.height.mas_equalTo(40);
	}];
	[self.titleNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(self.headImageView.mas_right).offset(10);
		make.top.mas_equalTo(self.headImageView);
		make.right.mas_equalTo(self).offset(- 10);
	}];
	[self.detailNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(self.titleNameLabel);
		make.bottom.mas_equalTo(self.headImageView);
		make.right.mas_equalTo(self).offset(- 10);
	}];
}

- (void)setModel:(HTCourseOpenModel *)model row:(NSInteger)row {
	[self.courseDateButton setTitle:@"课程回放中" forState:UIControlStateNormal];
	[self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", @"http://open.viplgw.cn/", model.image]] placeholderImage:HTPLACEHOLDERIMAGE];
	self.titleNameLabel.text = model.name;
	self.detailNameLabel.text = [NSString stringWithFormat:@"主讲: %@ 时间: %@", model.listeningFile, @"课程回放中"];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	self.headImageView.layer.cornerRadius = 20;
	self.headImageView.layer.masksToBounds = true;
	[self.courseDateButton ht_makeEdgeWithDirection:HTButtonEdgeDirectionHorizontal imageViewToTitleLabelSpeceOffset:5];
}

- (UIButton *)courseDateButton {
	if (!_courseDateButton) {
		_courseDateButton = [[UIButton alloc] init];
		[_courseDateButton setImage:[[[UIImage imageNamed:@"CourseCalender"] ht_resetSize:CGSizeMake(13, 13)] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
		_courseDateButton.tintColor = [UIColor ht_colorStyle:HTColorStylePrimaryTheme];
		[_courseDateButton setTitleColor:[UIColor ht_colorStyle:HTColorStylePrimaryTheme] forState:UIControlStateNormal];
		_courseDateButton.titleLabel.font = [UIFont systemFontOfSize:13];
	}
	return _courseDateButton;
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
		_titleNameLabel.textColor = [UIColor ht_colorStyle:HTColorStylePrimaryTitle];
		_titleNameLabel.font = [UIFont systemFontOfSize:14];
	}
	return _titleNameLabel;
}

- (UILabel *)detailNameLabel {
	if (!_detailNameLabel) {
		_detailNameLabel = [[UILabel alloc] init];
		_detailNameLabel.textColor = [UIColor ht_colorStyle:HTColorStyleSecondaryTitle];
		_detailNameLabel.font = [UIFont systemFontOfSize:12];
	}
	return _detailNameLabel;
}

- (void)setFrame:(CGRect)frame {
	frame.origin.y += 10;
	frame.size.height -= 10;
	[super setFrame:frame];
}

@end
