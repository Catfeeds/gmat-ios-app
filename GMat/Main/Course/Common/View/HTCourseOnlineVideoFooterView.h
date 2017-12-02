//
//  HTCourseOnlineVideoFooterView.h
//  GMat
//
//  Created by hublot on 2017/4/19.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTCourseOnlineVideoFooterView : UIView

@property (nonatomic, strong) NSMutableDictionary *onlienVideoDictionary;

@property (nonatomic, strong) void(^resetHeightBlock)(void);

- (void)setModel:(id)model row:(NSInteger)row;

@end
