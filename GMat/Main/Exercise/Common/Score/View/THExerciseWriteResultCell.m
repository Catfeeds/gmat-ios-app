//
//  THExerciseWriteResultCell.m
//  TingApp
//
//  Created by hublot on 16/8/26.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "THExerciseWriteResultCell.h"

@interface THExerciseWriteResultCell ()

@property (nonatomic, strong) UILabel *titleNameLabel;

@end

@implementation THExerciseWriteResultCell

- (void)didMoveToSuperview {
	self.backgroundColor = [UIColor ht_colorString:@"e6e6e6"];
	[self addSubview:self.titleNameLabel];
	[self.titleNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.mas_equalTo(self);
	}];
}

- (void)setModel:(id)model row:(NSInteger)row {
	self.titleNameLabel.text = model;
}

- (UILabel *)titleNameLabel {
	if (!_titleNameLabel) {
		_titleNameLabel = [[UILabel alloc] init];
		_titleNameLabel.textAlignment = NSTextAlignmentCenter;
		_titleNameLabel.textColor = [UIColor ht_colorStyle:HTColorStyleSecondaryTitle];
		_titleNameLabel.font = [UIFont ht_fontStyle:HTFontStyleHeadSmall];
	}
	return _titleNameLabel;
}


- (void)setFrame:(CGRect)frame {
	frame.origin.x = [UIScreen mainScreen].bounds.size.width / 4 + 10;
	frame.size.width = [UIScreen mainScreen].bounds.size.width / 2 - 20;
	frame.origin.y += 8;
	frame.size.height -= 16;
	self.layer.cornerRadius = 2;
	self.layer.masksToBounds = true;
	[super setFrame:frame];
}

@end
