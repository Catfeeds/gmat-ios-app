//
//  HTOnlineHeaderView.h
//  GMat
//
//  Created by hublot on 16/10/14.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTCourseOnlineVideoModel.h"

@interface HTOnlineHeaderView : UICollectionReusableView

- (void)setModel:(HTCourseOnlineVideoModel *)model section:(NSInteger)section;

@end
