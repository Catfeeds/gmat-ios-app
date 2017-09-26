//
//  HTCommunityMessageCell.m
//  GMat
//
//  Created by hublot on 2016/11/23.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTCommunityMessageCell.h"
#import "HTCommunityUserView.h"
#import "HTCommunityMessageLayoutModel.h"
#import "YYLabel.h"
#import "CALayer+YYWebImage.h"
#import "UIImage+YYAdd.h"
#import <NSObject+HTTableRowHeight.h>

@interface HTCommunityMessageCell ()

@property (nonatomic, strong) HTCommunityUserView *communityUserView;

@property (nonatomic, strong) YYLabel *detailNameLabel;

@end

@implementation HTCommunityMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.communityUserView];
        [self.contentView addSubview:self.detailNameLabel];
    }
    return self;
}

- (void)didMoveToSuperview {
	[self.contentView addSubview:self.communityUserView];
	[self.contentView addSubview:self.detailNameLabel];
}

- (void)setModel:(HTCommunityMessageLayoutModel *)model row:(NSInteger)row {
    UIImage *placeImage = [HTPLACEHOLDERIMAGE ht_resetSize:CGSizeMake(CommunityUserHeadImageHeight, CommunityUserHeadImageHeight)];
    placeImage = [placeImage imageByRoundCornerRadius:CommunityUserHeadImageHeight / 2 borderWidth:0 borderColor:nil];
    [self.communityUserView.headImageView.layer setImageWithURL:[NSURL URLWithString:GmatResourse(model.originModel.userImage)] placeholder:placeImage options:kNilOptions manager:model.userViewLayoutModel.headImageManager progress:nil transform:nil completion:nil];
    self.communityUserView.userNameLabel.textLayout = model.userViewLayoutModel.userViewTitleNameLayout;
    self.communityUserView.creatTimeLabel.textLayout = model.userViewLayoutModel.userViewDetailNameLayout;
    self.communityUserView.creatTimeLabel.ht_h = model.userViewLayoutModel.userViewAutoLabelHeight;
    self.communityUserView.ht_h = MAX(model.userViewLayoutModel.userViewHeight, model.messageHeight + CommunityUserViewHeight - CommunityUserHeadImageHeight);
    self.detailNameLabel.textLayout = model.messageTextLayout;
    self.detailNameLabel.ht_h = model.messageHeight;
    
    
    CGFloat modelHeight = self.communityUserView.ht_h;
    self.detailNameLabel.ht_cy = modelHeight / 2;
    [model ht_setRowHeightNumber:@(modelHeight) forCellClass:self.class];
}

- (HTCommunityUserView *)communityUserView {
	if (!_communityUserView) {
		_communityUserView = [[HTCommunityUserView alloc] initWithFrame:CGRectMake(0, 0, CommunityCellContentWidth - CommunityCellContentEdge - CommunityMessageRightContentWidth, CommunityUserViewHeight)];
        _communityUserView.userNameLabel.ht_w = CommunityUserViewTextWidth - CommunityCellContentEdge - CommunityMessageRightContentWidth;
        _communityUserView.creatTimeLabel.ht_w = _communityUserView.userNameLabel.ht_w;
	}
	return _communityUserView;
}

- (YYLabel *)detailNameLabel {
	if (!_detailNameLabel) {
		_detailNameLabel = [[YYLabel alloc] initWithFrame:CGRectMake(HTSCREENWIDTH - CommunityCellContentEdge - CommunityMessageRightContentWidth, 0, CommunityMessageRightContentWidth, 0)];
		_detailNameLabel.backgroundColor = [UIColor ht_colorStyle:HTColorStylePrimaryTheme];
	}
	return _detailNameLabel;
}


@end
