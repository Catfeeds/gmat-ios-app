//
//  HTCommunityCell.m
//  GMat
//
//  Created by hublot on 2016/11/22.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTCommunityCell.h"
#import "HTCommunityDetailHeaderView.h"
#import "HTCommunityReplyContentView.h"
#import <NSObject+HTTableRowHeight.h>

@interface HTCommunityCell ()

@property (nonatomic, strong) HTCommunityDetailHeaderView *headerContentView;

@property (nonatomic, strong) HTCommunityReplyContentView *replyContentView;

@property (nonatomic, strong) HTCommunityLayoutModel *model;

@end

@implementation HTCommunityCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		self.backgroundColor = [UIColor clearColor];
        [self.headerContentView.whiteContentView addSubview:self.replyContentView];
        [self.contentView addSubview:self.headerContentView];
	}
	return self;
}

- (void)setModel:(HTCommunityLayoutModel *)model row:(NSInteger)row {
    _model = model;
    [self.headerContentView setModel:model row:row];
	self.replyContentView.model = model;
    self.replyContentView.ht_y = self.headerContentView.whiteContentView.ht_h;
    self.headerContentView.whiteContentView.ht_h += self.replyContentView.ht_h;
    self.headerContentView.ht_h = self.headerContentView.whiteContentView.ht_h + CommunityCellMargin;
    
    CGFloat modelHeight = self.headerContentView.ht_h;
    [model ht_setRowHeightNumber:@(modelHeight) forCellClass:self.class];
    
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    [self.headerContentView.whiteContentView ht_setBackgroundColor:highlighted ? self.contentView.backgroundColor : [UIColor whiteColor]];
}

- (HTCommunityDetailHeaderView *)headerContentView {
    if (!_headerContentView) {
        _headerContentView = [[HTCommunityDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, HTSCREENWIDTH, 0)];
    }
    return _headerContentView;
}

- (HTCommunityReplyContentView *)replyContentView {
	if (!_replyContentView) {
		_replyContentView = [[HTCommunityReplyContentView alloc] initWithFrame:CGRectMake(0, 0, HTSCREENWIDTH, 0)];
	}
	return _replyContentView;
}

@end
