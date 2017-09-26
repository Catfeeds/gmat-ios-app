//
//  HTOpenHeaderView.m
//  GMat
//
//  Created by hublot on 16/10/14.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTOpenDetailHeaderView.h"
#import "HTCourseOpenModel.h"
#import "HTCourseOnlineVideoModel.h"

@interface HTOpenDetailHeaderView ()

@property (nonatomic, strong) UILabel *backgroundGmatLabel;

@property (nonatomic, strong) UILabel *titleNameLabel;

@property (nonatomic, strong) UILabel *detailNameLabel;

@property (nonatomic, strong) UILabel *gmatFontLabel;

@end

@implementation HTOpenDetailHeaderView

- (void)didMoveToSuperview {
	self.backgroundColor = [UIColor ht_colorStyle:HTColorStyleCompareBackground];
	[self addSubview:self.backgroundGmatLabel];
	[self addSubview:self.titleNameLabel];
	[self addSubview:self.detailNameLabel];
	[self.backgroundGmatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.mas_equalTo(self).mas_offset(- 30);
		make.top.mas_equalTo(self).mas_offset(30);
	}];
	[self.titleNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(self).mas_offset(50);
		make.left.mas_equalTo(self).mas_offset(15);
		make.right.mas_equalTo(self).mas_offset(- 15);
	}];
	[self.detailNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.mas_equalTo(self).mas_offset(- 50);
		make.left.mas_equalTo(self.titleNameLabel);
		make.right.mas_equalTo(self).mas_offset(- 15);
	}];
}

- (void)setModel:(id)model row:(NSInteger)row {
	
	if ([model isKindOfClass:[HTCourseOpenModel class]]) {
		HTCourseOpenModel *subModel = (HTCourseOpenModel *)model;
		self.titleNameLabel.text = subModel.name;
		self.detailNameLabel.text = [NSString stringWithFormat:@"主讲: %@", subModel.listeningFile];
	} else {
		HTCourseOnlineVideoModel *subModel = (HTCourseOnlineVideoModel *)model;
		self.titleNameLabel.text = subModel.contenttitle;
        self.detailNameLabel.text = [NSString stringWithFormat:@"主讲: %@", subModel.teacher.length ? subModel.teacher : @"暂无"];
	}
}

- (UILabel *)backgroundGmatLabel {
	if (!_backgroundGmatLabel) {
		_backgroundGmatLabel = [[UILabel alloc] init];
		_backgroundGmatLabel.text = @"GMAT";
		_backgroundGmatLabel.textColor = [UIColor ht_colorString:@"e3e3e3"];
		_backgroundGmatLabel.font = [UIFont systemFontOfSize:60 weight:0.5];
		_backgroundGmatLabel.textAlignment = NSTextAlignmentRight;
	}
	return _backgroundGmatLabel;
}

- (UILabel *)titleNameLabel {
	if (!_titleNameLabel) {
		_titleNameLabel = [[UILabel alloc] init];
		_titleNameLabel.font = [UIFont systemFontOfSize:20 weight:0.5];
		_titleNameLabel.textColor = [UIColor ht_colorStyle:HTColorStylePrimaryTitle];
	}
	return _titleNameLabel;
}

- (UILabel *)detailNameLabel {
	if (!_detailNameLabel) {
		_detailNameLabel = [[UILabel alloc] init];
		_detailNameLabel.font = [UIFont systemFontOfSize:14];
		_detailNameLabel.textColor = [UIColor ht_colorStyle:HTColorStyleSecondaryTitle];
	}
	return _detailNameLabel;
}

@end
