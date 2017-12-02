//
//  HTKnowledgeSubjectCell.m
//  GMat
//
//  Created by hublot on 16/10/12.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTKnowledgeSubjectCell.h"
#import "HTKnowledgeModel.h"

@interface HTKnowledgeSubjectCell ()

@property (nonatomic, strong) UILabel *titleNameLabel;

@end

@implementation HTKnowledgeSubjectCell

- (void)didMoveToSuperview {
	[self addSubview:self.titleNameLabel];
	[self.titleNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.mas_equalTo(UIEdgeInsetsMake(0, 15, 0, 0));
	}];
}

- (void)setModel:(KnowledgeCategorycontent *)model row:(NSInteger)row {
	self.titleNameLabel.text = model.contenttitle;
}

- (UILabel *)titleNameLabel {
	if (!_titleNameLabel) {
		_titleNameLabel = [[UILabel alloc] init];
		_titleNameLabel.textColor = [UIColor ht_colorStyle:HTColorStylePrimaryTitle];
		_titleNameLabel.font = [UIFont systemFontOfSize:14];
	}
	return _titleNameLabel;
}


@end
