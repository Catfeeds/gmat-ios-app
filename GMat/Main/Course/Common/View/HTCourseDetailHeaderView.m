//
//  HTCourseDetailHeaderView.m
//  GMat
//
//  Created by hublot on 2017/5/11.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTCourseDetailHeaderView.h"
#import "HTCourseOnlineVideoModel.h"
#import <UIButton+HTButtonCategory.h>
#import "HTTryListenController.h"

@interface HTCourseDetailHeaderView ()

@property (nonatomic, strong) UIView *darkBackgroundView;

@property (nonatomic, strong) UIImageView *courseImageView;

@property (nonatomic, strong) UILabel *courseTitleLabel;

@property (nonatomic, strong) UILabel *courseDetailLabel;

@property (nonatomic, strong) UILabel *courseRateLabel;

@property (nonatomic, strong) UIButton *tryListenButton;

@property (nonatomic, strong) UIVisualEffectView *blurErrectView;

@end

@implementation HTCourseDetailHeaderView

- (void)didMoveToSuperview {
	self.userInteractionEnabled = true;
	self.contentMode = UIViewContentModeScaleAspectFill;
	self.clipsToBounds = true;
	[self addSubview:self.darkBackgroundView];
	[self addSubview:self.blurErrectView];
	[self.darkBackgroundView addSubview:self.courseImageView];
	[self.darkBackgroundView addSubview:self.courseTitleLabel];
	[self.darkBackgroundView addSubview:self.courseDetailLabel];
	[self.darkBackgroundView addSubview:self.courseRateLabel];
	[self.darkBackgroundView addSubview:self.tryListenButton];
	
	[self.blurErrectView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.edges.mas_equalTo(self);
	}];
	
	[self.darkBackgroundView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.edges.mas_equalTo(self);
	}];
	
	[self.courseImageView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(self.darkBackgroundView).mas_offset(20);
		make.centerY.mas_equalTo(self.darkBackgroundView).mas_offset(0);
		make.width.mas_equalTo(100);
		make.height.mas_equalTo(100);
	}];
	[self.courseTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(self.courseImageView.mas_right).mas_offset(15);
		make.top.mas_equalTo(self.courseImageView);
		make.right.mas_equalTo(self.darkBackgroundView).mas_offset(- 15);
	}];
	[self.courseDetailLabel mas_updateConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(self.courseTitleLabel);
		make.bottom.mas_equalTo(self.courseRateLabel.mas_top).mas_offset(- 15);
		make.right.mas_equalTo(self.darkBackgroundView).mas_offset(- 15);
	}];
	[self.courseRateLabel mas_updateConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(self.courseTitleLabel);
		make.bottom.mas_equalTo(self.courseImageView);
	}];
	[self.tryListenButton mas_updateConstraints:^(MASConstraintMaker *make) {
		make.right.mas_equalTo(self.darkBackgroundView).mas_offset(- 30);
		make.bottom.mas_equalTo(self.courseRateLabel);
		make.width.mas_equalTo(70);
		make.height.mas_equalTo(25);
	}];
}

- (void)setModel:(HTCourseOnlineVideoModel *)model row:(NSInteger)row {
	self.image = [UIImage imageNamed:@"CourseDetailBackground"];
	NSString *imageUrlString;
	if (model.contentSmartApplythumb.length) {
		imageUrlString = [NSString stringWithFormat:@"%@%@", @"http://open.viplgw.cn/", model.contentSmartApplythumb];
	} else if (model.contentthumb.length) {
		imageUrlString = GmatResourse(model.contentthumb);
	}
	[self.courseImageView sd_setImageWithURL:[NSURL URLWithString:imageUrlString] placeholderImage:HTPLACEHOLDERIMAGE];
	self.courseTitleLabel.text = model.contenttitle;
	self.courseDetailLabel.text = [NSString stringWithFormat:@"%@人已加入", model.views];
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"评分 " attributes:@{NSFontAttributeName:self.courseRateLabel.font,
																													   NSForegroundColorAttributeName:self.courseRateLabel.textColor}];
	for (NSInteger index = 0; index < 5; index ++) {
		NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
		UIImage *backLargeImage = [UIImage ht_pureColor:[UIColor clearColor]];
		backLargeImage = [backLargeImage ht_resetSize:CGSizeMake(self.courseRateLabel.font.pointSize, self.courseRateLabel.font.pointSize)];
		UIImage *starImage = [[UIImage imageNamed:@"CourseDetailStar"] ht_resetSize:CGSizeMake(self.courseRateLabel.font.pointSize - 3, self.courseRateLabel.font.pointSize - 3)];
		backLargeImage = [backLargeImage ht_appendImage:starImage atRect:CGRectMake(3 / 2.0, 3, starImage.size.width, starImage.size.height)];
		textAttachment.image = backLargeImage;
		NSMutableAttributedString *attachmentAttributedString = [[NSMutableAttributedString attributedStringWithAttachment:textAttachment] mutableCopy];
		[attributedString appendAttributedString:attachmentAttributedString];
	}
	self.courseRateLabel.attributedText = attributedString;
}

- (void)setBlurProgress:(CGFloat)blurProgress {
	_blurProgress = MAX(0, MIN(blurProgress, 1));
	self.blurErrectView.alpha = _blurProgress;
}

- (UIView *)darkBackgroundView {
	if (!_darkBackgroundView) {
		_darkBackgroundView = [[UIView alloc] init];
		_darkBackgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
	}
	return _darkBackgroundView;
}

- (UIImageView *)courseImageView {
	if (!_courseImageView) {
		_courseImageView = [[UIImageView alloc] init];
		_courseImageView.contentMode = UIViewContentModeScaleAspectFill;
		_courseImageView.clipsToBounds = true;
	}
	return _courseImageView;
}

- (UILabel *)courseTitleLabel {
	if (!_courseTitleLabel) {
		_courseTitleLabel = [[UILabel alloc] init];
		_courseTitleLabel.textColor = [UIColor whiteColor];
		_courseTitleLabel.font = [UIFont systemFontOfSize:16];
	}
	return _courseTitleLabel;
}

- (UILabel *)courseDetailLabel {
	if (!_courseDetailLabel) {
		_courseDetailLabel = [[UILabel alloc] init];
		_courseDetailLabel.textColor = [UIColor whiteColor];
		_courseDetailLabel.font = [UIFont systemFontOfSize:13];
	}
	return _courseDetailLabel;
}

- (UILabel *)courseRateLabel {
	if (!_courseRateLabel) {
		_courseRateLabel = [[UILabel alloc] init];
		_courseRateLabel.textColor = [UIColor whiteColor];
		_courseRateLabel.font = [UIFont systemFontOfSize:13];
	}
	return _courseRateLabel;
}

- (UIButton *)tryListenButton {
	if (!_tryListenButton) {
		_tryListenButton = [[UIButton alloc] init];
		[_tryListenButton setTitleColor:[UIColor ht_colorString:@"f8b62c"] forState:UIControlStateNormal];
		[_tryListenButton setTitle:@"试听" forState:UIControlStateNormal];
		_tryListenButton.titleLabel.font = [UIFont systemFontOfSize:12];
		[_tryListenButton setImage:[[UIImage imageNamed:@"CourseDetailPlay"] ht_resetSizeZoomNumber:0.5] forState:UIControlStateNormal];
		_tryListenButton.layer.cornerRadius = 7;
		_tryListenButton.layer.masksToBounds = true;
		_tryListenButton.layer.borderWidth = 1;
		_tryListenButton.layer.borderColor = [UIColor whiteColor].CGColor;
		[_tryListenButton ht_makeEdgeWithDirection:HTButtonEdgeDirectionHorizontal imageViewToTitleLabelSpeceOffset:5];
		
		__weak HTCourseDetailHeaderView *weakSelf = self;
		[_tryListenButton ht_whenTap:^(UIView *view) {
			HTTryListenController *tryListenController = [[HTTryListenController alloc] init];
			[weakSelf.ht_controller.navigationController pushViewController:tryListenController animated:true];
		}];
	}
	return _tryListenButton;
}

- (UIVisualEffectView *)blurErrectView {
	if (!_blurErrectView) {
		_blurErrectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
	}
	return _blurErrectView;
}

@end
