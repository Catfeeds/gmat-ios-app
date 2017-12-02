//
//  HTCourseOnlineVideoCell.m
//  GMat
//
//  Created by hublot on 17/4/19.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTCourseOnlineVideoCell.h"
#import <UIButton+HTButtonCategory.h>
#import "HTCourseOnlineVideoModel.h"

@interface HTCourseOnlineVideoCell ()

@property (nonatomic, strong) UIImageView *backgroundImageView;

@property (nonatomic, strong) UILabel *titleNameLabel;

@property (nonatomic, strong) UILabel *courseStartLabel;

@property (nonatomic, strong) UILabel *courseDurationLabel;

@property (nonatomic, strong) UIButton *lookNumberButton;

@end

@implementation HTCourseOnlineVideoCell

- (void)didMoveToSuperview {
    [self addSubview:self.backgroundImageView];
    [self addSubview:self.titleNameLabel];
    [self addSubview:self.courseStartLabel];
    [self addSubview:self.courseDurationLabel];
    [self addSubview:self.lookNumberButton];
    
    self.backgroundColor = [UIColor whiteColor];
//    self.layer.shadowOffset = CGSizeMake(0, 2);
//    self.layer.shadowRadius = 2;
//    self.layer.shadowOpacity = 0.1;
//    self.layer.shadowColor = [UIColor blackColor].CGColor;
	
    [self.backgroundImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.right.mas_equalTo(self);
        make.top.mas_equalTo(self);
        make.height.mas_equalTo(self).multipliedBy(0.55);
    }];
    [self.titleNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(5);
        make.right.mas_equalTo(self).offset(- 5);
        make.top.mas_equalTo(self.backgroundImageView.mas_bottom).offset(10);
    }];
    [self.courseStartLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(5);
        make.right.mas_equalTo(self.courseDurationLabel.mas_left).offset(- 5);
        make.top.mas_equalTo(self.courseDurationLabel);
    }];
    [self.courseDurationLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(- 5);
        make.top.mas_equalTo(self.titleNameLabel.mas_bottom).offset(5);
    }];
    [self.lookNumberButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.courseDurationLabel.mas_bottom).offset(2);
        make.left.mas_equalTo(self).offset(5);
    }];
}

- (void)setModel:(HTCourseOnlineVideoModel *)model row:(NSInteger)row {
	[self.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:GmatResourse(model.contentthumb)] placeholderImage:HTPLACEHOLDERIMAGE];
	self.titleNameLabel.text = model.contenttitle;
	self.courseStartLabel.text = [NSString stringWithFormat:@"开课时间: %@", model.time.length ? model.time : @"随时"];
	NSString *courseDuration = @"0课时";
	if (model.hour.length) {
		courseDuration = model.hour;
	} else if (model.times.length) {
		courseDuration = [NSString stringWithFormat:@"%@课时", model.times];
	}
    self.courseDurationLabel.text = [NSString stringWithFormat:@"课时: %@", courseDuration];
    [self.lookNumberButton setTitle:[NSString stringWithFormat:@"浏览数: %@", model.views] forState:UIControlStateNormal];
}

- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] init];
		_backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
		_backgroundImageView.clipsToBounds = true;
    }
    return _backgroundImageView;
}

- (UILabel *)titleNameLabel {
    if (!_titleNameLabel) {
        _titleNameLabel = [[UILabel alloc] init];
        _titleNameLabel.textColor = [UIColor ht_colorStyle:HTColorStylePrimaryTitle];
        _titleNameLabel.font = [UIFont systemFontOfSize:14];
    }
    return _titleNameLabel;
}

- (UILabel *)courseStartLabel {
    if (!_courseStartLabel) {
        _courseStartLabel = [[UILabel alloc] init];
        _courseStartLabel.textColor = [UIColor ht_colorStyle:HTColorStyleSecondaryTitle];
        _courseStartLabel.font = [UIFont systemFontOfSize:13];
    }
    return _courseStartLabel;
}

- (UILabel *)courseDurationLabel {
    if (!_courseDurationLabel) {
        _courseDurationLabel = [[UILabel alloc] init];
        _courseDurationLabel.textColor = [UIColor ht_colorStyle:HTColorStyleSecondaryTitle];
        _courseDurationLabel.font = [UIFont systemFontOfSize:13];
        _courseDurationLabel.textAlignment = NSTextAlignmentRight;
        [_courseDurationLabel setContentHuggingPriority:300 forAxis:UILayoutConstraintAxisHorizontal];
        [_courseDurationLabel setContentCompressionResistancePriority:800 forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _courseDurationLabel;
}

- (UIButton *)lookNumberButton {
    if (!_lookNumberButton) {
        _lookNumberButton = [[UIButton alloc] init];
        _lookNumberButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_lookNumberButton setTitleColor:[UIColor ht_colorStyle:HTColorStyleSecondaryTitle] forState:UIControlStateNormal];
        [_lookNumberButton setImage:[[UIImage imageNamed:@"Course42"] ht_resetSizeZoomNumber:0.5] forState:UIControlStateNormal];
        [_lookNumberButton ht_makeEdgeWithDirection:HTButtonEdgeDirectionHorizontal imageViewToTitleLabelSpeceOffset:5];
        _lookNumberButton.userInteractionEnabled = false;
    }
    return _lookNumberButton;
}

@end
