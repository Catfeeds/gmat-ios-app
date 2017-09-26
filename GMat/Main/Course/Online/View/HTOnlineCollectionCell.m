//
//  HTOnlineCollectionCell.m
//  GMat
//
//  Created by hublot on 16/10/14.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTOnlineCollectionCell.h"
#import "HTCourseOnlineVideoModel.h"
#import "HTOnlineDetailController.h"

@interface HTOnlineCollectionCell ()

@property (nonatomic, strong) UIImageView *backgroundImageView;

@property (nonatomic, strong) UILabel *titleNameLabel;

@property (nonatomic, strong) UIButton *coursePriceButton;

@property (nonatomic, strong) UIButton *playViedoButton;

@end

@implementation HTOnlineCollectionCell

- (void)didMoveToSuperview {
	[self addSubview:self.backgroundImageView];
	[self addSubview:self.titleNameLabel];
	[self addSubview:self.coursePriceButton];
	[self addSubview:self.playViedoButton];
	self.layer.cornerRadius = 3;
	self.layer.masksToBounds = true;
	self.backgroundColor = [UIColor whiteColor];
	[self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 50, 0));
	}];
	[self.titleNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(self.backgroundImageView.mas_bottom).offset(7);
		make.left.mas_equalTo(self.backgroundImageView).offset(10);
		make.right.mas_lessThanOrEqualTo(self.playViedoButton.mas_left).offset(- 5).priority(999);
	}];
	[self.coursePriceButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(self.titleNameLabel);
		make.top.mas_equalTo(self.titleNameLabel.mas_bottom).offset(5);
	}];
	[self.playViedoButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.mas_equalTo(self.backgroundImageView).offset(- 10);
		make.top.mas_equalTo(self.backgroundImageView.mas_bottom).offset(10);
	}];
}

- (void)setModel:(HTCourseOnlineVideoModel *)model row:(NSInteger)row {
	[self.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", @"http://www.gmatonline.cn/", model.contentthumb]] placeholderImage:HTPLACEHOLDERIMAGE];
	self.titleNameLabel.text = model.contenttitle;
	[self.coursePriceButton setTitle:model.price forState:UIControlStateNormal];
}

- (UIImageView *)backgroundImageView {
	if (!_backgroundImageView) {
		_backgroundImageView = [[UIImageView alloc] init];
	}
	return _backgroundImageView;
}

- (UILabel *)titleNameLabel {
	if (!_titleNameLabel) {
		_titleNameLabel = [[UILabel alloc] init];
		_titleNameLabel.font = [UIFont systemFontOfSize:14];
		_titleNameLabel.textColor = [UIColor ht_colorStyle:HTColorStylePrimaryTitle];
	}
	return _titleNameLabel;
}

- (UIButton *)coursePriceButton {
	if (!_coursePriceButton) {
		_coursePriceButton = [[UIButton alloc] init];
		_coursePriceButton.titleLabel.font = [UIFont systemFontOfSize:12];
		[_coursePriceButton setTitleColor:[UIColor ht_colorStyle:HTColorStylePrimaryTitle] forState:UIControlStateNormal];
		[_coursePriceButton setImage:[UIImage imageNamed:@"Course20"] forState:UIControlStateNormal];
        _coursePriceButton.hidden = [HTOnlineDetailController hiddenCourcePriceTag];
	}
	return _coursePriceButton;
}

- (UIButton *)playViedoButton {
	if (!_playViedoButton) {
		_playViedoButton = [[UIButton alloc] init];
		_playViedoButton.userInteractionEnabled = false;
		[_playViedoButton setImage:[UIImage imageNamed:@"Course22"] forState:UIControlStateNormal];
		[_playViedoButton setContentHuggingPriority:300 forAxis:UILayoutConstraintAxisHorizontal];
		[_playViedoButton setContentCompressionResistancePriority:800 forAxis:UILayoutConstraintAxisHorizontal];
	}
	return _playViedoButton;
}


@end
