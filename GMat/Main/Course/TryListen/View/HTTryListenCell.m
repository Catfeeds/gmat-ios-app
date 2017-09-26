//
//  HTTryListenCell.m
//  GMat
//
//  Created by hublot on 16/10/13.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTTryListenCell.h"
#import "HTTryListenModel.h"

@interface HTTryListenCell ()

@property (nonatomic, strong) UIButton *titleNameButton;

@property (nonatomic, strong) UILabel *courseDetailLabel;

@end

@implementation HTTryListenCell

- (void)didMoveToSuperview {
	[self addSubview:self.titleNameButton];
	[self addSubview:self.courseDetailLabel];
	[self.titleNameButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.mas_equalTo(self);
	}];
	[self.courseDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.mas_equalTo(self).offset(- HTADAPT568(10));
		make.right.mas_equalTo(self).offset(- 15);
	}];
}

- (void)setModel:(HTTryListenModel *)model row:(NSInteger)row {
	[self.titleNameButton setTitle:model.catname forState:UIControlStateNormal];
	UIImage *backgroundImage = [UIImage imageNamed:model.backgroundImageForButton];
	backgroundImage = [backgroundImage ht_croppedAtRect:CGRectInset(CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height), 5, 5)];
	[self.titleNameButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
	self.courseDetailLabel.text = [NSString stringWithFormat:@"课程时长: %@ \n授课老师: %@", model.times, model.teacher.length ? [NSString stringWithFormat:@"%@ ", model.teacher] : @"暂无信息"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [self setHighlighted:selected animated:animated];
    [super setSelected:selected animated:animated];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    self.titleNameButton.highlighted = highlighted;
}

- (UIButton *)titleNameButton {
	if (!_titleNameButton) {
		_titleNameButton = [[UIButton alloc] init];
		[_titleNameButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		_titleNameButton.titleLabel.font = [UIFont systemFontOfSize:HTADAPT568(16) weight:0.1];
		_titleNameButton.userInteractionEnabled = false;
		
	}
	return _titleNameButton;
}

- (UILabel *)courseDetailLabel {
	if (!_courseDetailLabel) {
		_courseDetailLabel = [[UILabel alloc] init];
		_courseDetailLabel.font = [UIFont ht_adaptFontOnlyCodeButFontWithInterBuilderWithHeight568FontSize:12];
		_courseDetailLabel.textColor = [UIColor whiteColor];
		_courseDetailLabel.textAlignment = NSTextAlignmentRight;
		_courseDetailLabel.numberOfLines = 0;
	}
	return _courseDetailLabel;
}

- (void)setFrame:(CGRect)frame {
	frame.origin.y += 15;
	frame.size.height -= 15;
	frame.origin.x += 15;
	frame.size.width -= 30;
	self.layer.cornerRadius = 3;
	self.layer.masksToBounds = true;
	[super setFrame:frame];
}

@end
