//
//  HTMockExerciseCell.m
//  GMat
//
//  Created by hublot on 2016/10/26.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTMockExerciseCell.h"
#import "HTMockExerciseModel.h"

@interface HTMockExerciseCell ()

@property (nonatomic, strong) UILabel *titleNameLabel;

@property (nonatomic, strong) UILabel *detailNameLabel;

@end

@implementation HTMockExerciseCell

- (void)didMoveToSuperview {
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	[self addSubview:self.titleNameLabel];
	[self addSubview:self.detailNameLabel];
	[self addSubview:self.startButton];
	[self.titleNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.right.mas_equalTo(self);
		make.bottom.mas_equalTo(self.detailNameLabel.mas_top).offset(- HTADAPT568(5));
	}];
	[self.detailNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.right.mas_equalTo(self);
		make.center.mas_equalTo(self);
	}];
	[self.startButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.mas_equalTo(HTADAPT568(50));
		make.height.mas_equalTo(HTADAPT568(20));
		make.top.mas_equalTo(self.detailNameLabel.mas_bottom).offset(HTADAPT568(5));
		make.centerX.mas_equalTo(self);
	}];
}

- (void)setModel:(HTMockExerciseModel *)model row:(NSInteger)row {
	self.titleNameLabel.text = model.titleName;
	self.detailNameLabel.text = model.detailName;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[self setHighlighted:selected animated:animated];
	[super setSelected:selected animated:animated];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
	[super setHighlighted:highlighted animated:animated];
	self.backgroundColor = highlighted ? [UIColor colorWithWhite:0.4 alpha:0.3] : [UIColor colorWithWhite:0.6 alpha:0.3];
}

- (UILabel *)titleNameLabel {
	if (!_titleNameLabel) {
		_titleNameLabel = [[UILabel alloc] init];
		_titleNameLabel.font = [UIFont ht_fontStyle:HTFontStyleHeadLarge];
		_titleNameLabel.textColor = [UIColor whiteColor];
		_titleNameLabel.textAlignment = NSTextAlignmentCenter;
	}
	return _titleNameLabel;
}

- (UILabel *)detailNameLabel {
	if (!_detailNameLabel) {
		_detailNameLabel = [[UILabel alloc] init];
		_detailNameLabel.font = [UIFont ht_fontStyle:HTFontStyleTitleSmall];
		_detailNameLabel.textColor = [UIColor whiteColor];
		_detailNameLabel.textAlignment = NSTextAlignmentCenter;
	}
	return _detailNameLabel;
}

- (UIButton *)startButton {
	if (!_startButton) {
		_startButton = [[UIButton alloc] init];
		[_startButton setBackgroundImage:[UIImage ht_pureColor:[UIColor ht_colorStyle:HTColorStylePrimaryTheme]] forState:UIControlStateNormal];
		[_startButton setBackgroundImage:[UIImage ht_pureColor:[[UIColor ht_colorStyle:HTColorStylePrimaryTheme] colorWithAlphaComponent:0.8]] forState:UIControlStateHighlighted];
		[_startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		_startButton.titleLabel.font = [UIFont ht_fontStyle:HTFontStyleTitleSmall];
		[_startButton setTitle:@"GO" forState:UIControlStateNormal];
		_startButton.layer.cornerRadius = 3;
		_startButton.layer.masksToBounds = true;
	}
	return _startButton;
}

- (void)setFrame:(CGRect)frame {
	frame.origin.x += 30;
	frame.size.width -= 60;
	frame.origin.y += 30;
	frame.size.height -= 30;
	self.layer.cornerRadius = 3;
	self.layer.masksToBounds = true;
	[super setFrame:frame];
}

@end
