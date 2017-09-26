//
//  HTCommunityRingHeaderView.h
//  GMat
//
//  Created by hublot on 2016/11/24.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTCommunityRingView.h"

@interface HTCommunityRingHeaderView : UIView

@property (nonatomic, strong) HTCommunityRingView *communityRingView;

- (void)setRingCount:(NSInteger)ringCount completeBlock:(void(^)(void))completeBlock;

@end
