//
//  HTOnlineDetailController.h
//  GMat
//
//  Created by hublot on 16/10/17.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTCourseOnlineVideoModel.h"

@interface HTOnlineDetailController : UIViewController

@property (nonatomic, strong) HTCourseOnlineVideoModel *courseModel;



+ (BOOL)hiddenCourcePriceTag;

+ (BOOL)hiddenPayLessonButton;

@end
