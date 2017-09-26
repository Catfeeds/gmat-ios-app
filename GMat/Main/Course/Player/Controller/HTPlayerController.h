//
//  HTPlayerController.h
//  GMat
//
//  Created by hublot on 2017/9/25.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTPlayerController : UIViewController

- (instancetype)initWithCourseURLString:(NSString *)courseURLString;

@property (nonatomic, strong) NSString *titleName;

@end
