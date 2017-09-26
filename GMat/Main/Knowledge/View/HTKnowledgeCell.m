//
//  HTKnowledgeCell.m
//  GMat
//
//  Created by hublot on 16/10/12.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTKnowledgeCell.h"
#import "HTKnowledgeModel.h"

@interface HTKnowledgeCell ()

@property (nonatomic, strong) UIButton *titleNameButton;

@end

@implementation HTKnowledgeCell

- (void)didMoveToSuperview {
	self.layer.masksToBounds = true;
	self.backgroundColor = [UIColor clearColor];
	[self addSubview:self.titleNameButton];
	[self.titleNameButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.mas_equalTo(self);
	}];
}

- (void)setModel:(HTKnowledgeModel *)model row:(NSInteger)row {
	UIImage *backgroundImage = [UIImage imageNamed:[NSString stringWithFormat:@"Knowledge%ld", 2 + row]];
	backgroundImage = [backgroundImage ht_croppedAtRect:CGRectInset(CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height), 5, 5)];
	[self.titleNameButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
	
	NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	paragraphStyle.lineSpacing = 10;
	paragraphStyle.alignment = NSTextAlignmentCenter;
	NSDictionary *normalDictionary = @{NSFontAttributeName:[UIFont systemFontOfSize:HTADAPT568(18) weight:0.1],
									   NSForegroundColorAttributeName:[UIColor whiteColor],
									   NSParagraphStyleAttributeName:paragraphStyle};
	NSDictionary *selectedDictionary = @{NSFontAttributeName:[UIFont systemFontOfSize:15],
										 NSForegroundColorAttributeName:[UIColor whiteColor],
										 NSParagraphStyleAttributeName:paragraphStyle};
	NSDictionary *highlightDictionary = @{NSFontAttributeName:[UIFont systemFontOfSize:15],
										 NSForegroundColorAttributeName:[UIColor orangeColor],
										 NSParagraphStyleAttributeName:paragraphStyle};
	NSMutableAttributedString *attributedString = [[[NSAttributedString alloc] initWithString:model.catname attributes:normalDictionary] mutableCopy];
	NSAttributedString *appendAttributedString = [[NSAttributedString alloc] initWithString:@"\n共 " attributes:selectedDictionary];
	[attributedString appendAttributedString:appendAttributedString];
	appendAttributedString = [[NSAttributedString alloc] initWithString:model.sum attributes:highlightDictionary];
	[attributedString appendAttributedString:appendAttributedString];
	appendAttributedString = [[NSAttributedString alloc] initWithString:@" 知识点, " attributes:selectedDictionary];
	[attributedString appendAttributedString:appendAttributedString];
	appendAttributedString = [[NSAttributedString alloc] initWithString:model.views attributes:highlightDictionary];
	[attributedString appendAttributedString:appendAttributedString];
	appendAttributedString = [[NSAttributedString alloc] initWithString:@" 人已学习" attributes:selectedDictionary];
	[attributedString appendAttributedString:appendAttributedString];
	[self.titleNameButton setAttributedTitle:attributedString forState:UIControlStateNormal];
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
		_titleNameButton.userInteractionEnabled = false;
		_titleNameButton.layer.masksToBounds = true;
		_titleNameButton.backgroundColor = [UIColor clearColor];
		_titleNameButton.titleLabel.numberOfLines = 0;
	}
	return _titleNameButton;
}


@end
