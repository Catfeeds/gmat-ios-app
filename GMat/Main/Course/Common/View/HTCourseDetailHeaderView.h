//
//  HTCourseDetailHeaderView.h
//  GMat
//
//  Created by hublot on 2017/5/11.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTCourseDetailHeaderView : UIImageView

@property (nonatomic, assign) CGFloat blurProgress;

- (void)setModel:(HTCourseOnlineVideoModel *)model row:(NSInteger)row;

@end
