//
//  HTCommunityReplyCell.m
//  GMat
//
//  Created by hublot on 2016/11/22.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTCommunityReplyCell.h"
#import "HTCommunityUserView.h"
#import "HTCommunityLayoutModel.h"
#import "UIImage+YYAdd.h"
#import "CALayer+YYWebImage.h"
#import <NSObject+HTTableRowHeight.h>

@interface HTCommunityReplyCell ()

@property (nonatomic, strong) HTCommunityUserView *communityUserView;

@end

@implementation HTCommunityReplyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.communityUserView];
    }
    return self;
}

- (void)setModel:(HTCommunityReplyLayoutModel *)model row:(NSInteger)row {
    UIImage *placeImage = [HTPLACEHOLDERIMAGE ht_resetSize:CGSizeMake(CommunityUserHeadImageHeight, CommunityUserHeadImageHeight)];
    placeImage = [placeImage imageByRoundCornerRadius:CommunityUserHeadImageHeight / 2 borderWidth:0 borderColor:nil];
    [self.communityUserView.headImageView.layer setImageWithURL:[NSURL URLWithString:GmatResourse(model.originReplyModel.userImage)] placeholder:placeImage options:kNilOptions manager:model.userViewLayoutModel.headImageManager progress:nil transform:nil completion:nil];
    self.communityUserView.userNameLabel.textLayout = model.userViewLayoutModel.userViewTitleNameLayout;
    self.communityUserView.creatTimeLabel.textLayout = model.userViewLayoutModel.userViewDetailNameLayout;
    
    self.communityUserView.userNameLabel.ht_h = model.userViewLayoutModel.userViewAutoLabelHeight;
    self.communityUserView.ht_h = model.userViewLayoutModel.userViewHeight;
    self.communityUserView.creatTimeLabel.ht_y = self.communityUserView.ht_h - (CommunityUserViewHeight - CommunityUserHeadImageHeight) / 2 - self.communityUserView.creatTimeLabel.ht_h;
    CGFloat modelHeight = self.communityUserView.ht_h;
    [model ht_setRowHeightNumber:@(modelHeight) forCellClass:self.class];
}

- (HTCommunityUserView *)communityUserView {
	if (!_communityUserView) {
		_communityUserView = [[HTCommunityUserView alloc] initWithFrame:CGRectMake(0, 0, HTSCREENWIDTH, CommunityUserViewHeight)];
	}
	return _communityUserView;
}

@end
