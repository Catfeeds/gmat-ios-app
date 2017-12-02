//
//  HTCourseOpenCell.m
//  GMat
//
//  Created by hublot on 2017/4/19.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTCourseOpenCell.h"
#import "HTCourseOpenModel.h"

@interface HTCourseOpenCell ()

@property (nonatomic, strong) UIImageView *backgroundImageView;

@property (nonatomic, strong) UIImageView *headImageButton;

@property (nonatomic, strong) UILabel *nicknameLabel;

@property (nonatomic, strong) UILabel *titleNameLabel;

@property (nonatomic, strong) UILabel *joinCountLabel;

@end

@implementation HTCourseOpenCell

- (void)didMoveToSuperview {
	[self addSubview:self.backgroundImageView];
	[self.backgroundImageView addSubview:self.headImageButton];
	[self.backgroundImageView addSubview:self.nicknameLabel];
	[self.backgroundImageView addSubview:self.titleNameLabel];
	[self.backgroundImageView addSubview:self.joinNowButton];
	[self.backgroundImageView addSubview:self.joinCountLabel];
	[self.backgroundImageView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.edges.mas_equalTo(self);
	}];
	[self.headImageButton mas_updateConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(self.backgroundImageView).offset(20);
		make.left.mas_equalTo(self.backgroundImageView).offset(10);
		make.width.height.mas_equalTo(55);
	}];
	[self.nicknameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
		make.centerX.mas_equalTo(self.headImageButton);
		make.centerY.mas_equalTo(self.joinCountLabel);
	}];
	[self.titleNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(self.headImageButton.mas_right);
		make.right.mas_equalTo(self.backgroundImageView);
		make.top.mas_equalTo(self.headImageButton).offset(3);
		make.bottom.mas_lessThanOrEqualTo(self.joinNowButton.mas_top).offset(- 5).priority(999);
	}];
	[self.joinNowButton mas_updateConstraints:^(MASConstraintMaker *make) {
		make.right.mas_equalTo(self.joinCountLabel);
		make.bottom.mas_equalTo(self.joinCountLabel.mas_top).offset(- 5);
	}];
	[self.joinCountLabel mas_updateConstraints:^(MASConstraintMaker *make) {
		make.bottom.mas_equalTo(self.backgroundImageView).offset(- 10);
		make.right.mas_equalTo(self.backgroundImageView).offset(- 10);
	}];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	self.headImageButton.layer.borderColor = [UIColor ht_colorString:@"ff9b01"].CGColor;
	self.headImageButton.layer.borderWidth = 1;
	self.headImageButton.layer.cornerRadius = self.headImageButton.bounds.size.height / 2;
	self.headImageButton.layer.masksToBounds = true;
	self.joinNowButton.layer.cornerRadius = self.joinNowButton.bounds.size.height / 2;
	self.joinNowButton.layer.masksToBounds = true;
}

- (void)applyBlurImageSuccess:(void(^)(UIImage *blurImage))success originImage:(UIImage *)originImage {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *blurImage = [originImage ht_applyBlurWithRadius:40 tintColor:[UIColor colorWithWhite:0 alpha:0.4] saturationDeltaFactor:1.8 maskImage:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                success(blurImage);
            }
        });
    });
}

- (void)setModel:(HTCourseOpenModel *)model row:(NSInteger)row {
	NSString *viewCount = [NSString stringWithFormat:@"%ld", model.joinTimes];
	self.backgroundImageView.layer.cornerRadius = 10;
	self.backgroundImageView.layer.masksToBounds = true;
	[self.headImageButton sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://open.viplgw.cn/%@", model.article]] placeholderImage:HTPLACEHOLDERIMAGE];
	[self.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://open.viplgw.cn/%@", model.image]] placeholderImage:HTPLACEHOLDERIMAGE completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
		if (!image) {
			image = HTPLACEHOLDERIMAGE;
		}
		[self applyBlurImageSuccess:^(UIImage *blurImage) {
			self.backgroundImageView.image = blurImage;
		} originImage:image];
	}];
	self.nicknameLabel.text = model.listeningFile;
	self.titleNameLabel.text = model.name;
	[self.joinNowButton setTitle:@"立即报名" forState:UIControlStateNormal];
	self.joinNowButton.selected = false;
	self.joinCountLabel.text = [NSString stringWithFormat:@"报名人数: %@ 人", viewCount];
}

- (UIImageView *)backgroundImageView {
	if (!_backgroundImageView) {
		_backgroundImageView = [[UIImageView alloc] init];
		_backgroundImageView.userInteractionEnabled = true;
	}
	return _backgroundImageView;
}

- (UIImageView *)headImageButton {
	if (!_headImageButton) {
		_headImageButton = [[UIImageView alloc] init];
	}
	return _headImageButton;
}

- (UILabel *)nicknameLabel {
	if (!_nicknameLabel) {
		_nicknameLabel = [[UILabel alloc] init];
		_nicknameLabel.textAlignment = NSTextAlignmentCenter;
		_nicknameLabel.textColor = [UIColor whiteColor];
		_nicknameLabel.font = [UIFont systemFontOfSize:13];
	}
	return _nicknameLabel;
}

- (UILabel *)titleNameLabel {
	if (!_titleNameLabel) {
		_titleNameLabel = [[UILabel alloc] init];
		_titleNameLabel.textColor = [UIColor whiteColor];
		_titleNameLabel.font = [UIFont systemFontOfSize:14];
		_titleNameLabel.numberOfLines = 0;
	}
	return _titleNameLabel;
}

- (UIButton *)joinNowButton {
	if (!_joinNowButton) {
		_joinNowButton = [[UIButton alloc] init];
		_joinNowButton.titleLabel.font = [UIFont systemFontOfSize:13];
		[_joinNowButton setTitleColor:[UIColor ht_colorString:@"ff9b01"] forState:UIControlStateNormal];
		[_joinNowButton setBackgroundImage:nil forState:UIControlStateNormal];
		
		[_joinNowButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[_joinNowButton setBackgroundImage:[[UIImage ht_pureColor:[UIColor ht_colorString:@"ff9b01"]] ht_resetSize:CGSizeMake(80, 25)] forState:UIControlStateNormal];
		
		[_joinNowButton setContentHuggingPriority:300 forAxis:UILayoutConstraintAxisVertical];
		[_joinNowButton setContentCompressionResistancePriority:800 forAxis:UILayoutConstraintAxisVertical];
	}
	return _joinNowButton;
}

- (UILabel *)joinCountLabel {
	if (!_joinCountLabel) {
		_joinCountLabel = [[UILabel alloc] init];
		_joinCountLabel.font = [UIFont systemFontOfSize:13];
		_joinCountLabel.textColor = [UIColor whiteColor];
		_joinCountLabel.textAlignment = NSTextAlignmentRight;
		
		[_joinCountLabel setContentHuggingPriority:300 forAxis:UILayoutConstraintAxisVertical];
		[_joinCountLabel setContentCompressionResistancePriority:800 forAxis:UILayoutConstraintAxisVertical];

	}
	return _joinCountLabel;
}

@end
