//
//  HTOnlineHeaderView.m
//  GMat
//
//  Created by hublot on 16/10/14.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTOnlineHeaderView.h"
#import "HTOnlineDetailController.h"

@interface HTOnlineHeaderView ()

@property (nonatomic, strong) UIImageView *backgroundImageView;

@property (nonatomic, strong) UIView *grayContentView;

@property (nonatomic, strong) UILabel *titleNameLabel;

@property (nonatomic, strong) UIButton *priceButton;

@end

@implementation HTOnlineHeaderView

- (void)didMoveToSuperview {
	[self addSubview:self.backgroundImageView];
	[self.backgroundImageView addSubview:self.grayContentView];
	[self.grayContentView addSubview:self.titleNameLabel];
	[self.grayContentView addSubview:self.priceButton];
	[self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.mas_equalTo(self);
	}];
	[self.grayContentView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.right.bottom.mas_equalTo(self.backgroundImageView);
		make.height.mas_equalTo(40);
	}];
	[self.titleNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.bottom.mas_equalTo(self.grayContentView);
		make.left.mas_equalTo(self.grayContentView).mas_offset(5);
		make.right.lessThanOrEqualTo(self.priceButton.mas_left).mas_offset(- 10).priority(999);
	}];
	[self.priceButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.mas_equalTo(self.grayContentView).mas_offset(- 5);
		make.top.bottom.mas_equalTo(self.grayContentView);
	}];
}

- (void)setModel:(HTCourseOnlineVideoModel *)model section:(NSInteger)section {
	[self.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", @"http://www.gmatonline.cn/", model.contentthumb]] placeholderImage:HTPLACEHOLDERIMAGE];
	self.titleNameLabel.text = model.contenttitle;
	[self.priceButton setTitle:model.price forState:UIControlStateNormal];
}

- (UIImageView *)backgroundImageView {
	if (!_backgroundImageView) {
		_backgroundImageView = [[UIImageView alloc] init];
	}
	return _backgroundImageView;
}

- (UIView *)grayContentView {
	if (!_grayContentView) {
		_grayContentView = [[UIView alloc] init];
		_grayContentView.backgroundColor = [[UIColor ht_colorString:@"7e7e7e"] colorWithAlphaComponent:0.7];
	}
	return _grayContentView;
}

- (UILabel *)titleNameLabel {
	if (!_titleNameLabel) {
		_titleNameLabel = [[UILabel alloc] init];
		_titleNameLabel.textColor = [UIColor whiteColor];
		_titleNameLabel.font = [UIFont systemFontOfSize:15];
	}
	return _titleNameLabel;
}

- (UIButton *)priceButton {
	if (!_priceButton) {
		_priceButton = [[UIButton alloc] init];
		[_priceButton setImage:[UIImage imageNamed:@"Course20"] forState:UIControlStateNormal];
		_priceButton.titleLabel.font = [UIFont systemFontOfSize:12];
		[_priceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[_priceButton setContentHuggingPriority:300 forAxis:UILayoutConstraintAxisHorizontal];
		[_priceButton setContentCompressionResistancePriority:800 forAxis:UILayoutConstraintAxisHorizontal];
        _priceButton.hidden = [HTOnlineDetailController hiddenCourcePriceTag];
	}
	return _priceButton;
}

@end
