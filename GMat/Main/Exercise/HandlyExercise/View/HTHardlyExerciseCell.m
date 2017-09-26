//
//  HTHardlyExerciseCell.m
//  GMat
//
//  Created by hublot on 2016/10/25.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTHardlyExerciseCell.h"

@interface HTHardlyExerciseCell ()

@property (nonatomic, strong) UILabel *titleNameLabel;

@end

@implementation HTHardlyExerciseCell

- (void)didMoveToSuperview {
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	[self addSubview:self.titleNameLabel];
	[self addSubview:self.startButton];
	[self.titleNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.right.mas_equalTo(self);
		make.centerY.mas_equalTo(- HTADAPT568(10));
	}];
	[self.startButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.mas_equalTo(HTADAPT568(50));
		make.height.mas_equalTo(HTADAPT568(20));
		make.top.mas_equalTo(self.titleNameLabel.mas_bottom).offset(HTADAPT568(5));
		make.centerX.mas_equalTo(self);
	}];
}

- (void)setModel:(NSString *)model row:(NSInteger)row {
	self.titleNameLabel.text = model;
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
		_titleNameLabel.textColor = [UIColor whiteColor];
		_titleNameLabel.textAlignment = NSTextAlignmentCenter;
		_titleNameLabel.font = [UIFont ht_fontStyle:HTFontStyleTitleLarge];
	}
	return _titleNameLabel;
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
	frame.origin.x += 20;
	frame.size.width -= 40;
	frame.origin.y += 10;
	frame.size.height -= 10;
	self.layer.cornerRadius = 3;
	self.layer.masksToBounds = true;
	[super setFrame:frame];
}

@end
