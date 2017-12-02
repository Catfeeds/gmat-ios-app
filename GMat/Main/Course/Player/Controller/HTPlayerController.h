//
//  HTPlayerController.h
//  GMat
//
//  Created by hublot on 2017/9/25.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HTPlayerCourseProtocol <NSObject>

@required

- (NSString *)courseURLString;

- (NSString *)courseTitleString;

- (NSString *)courseTeacherImage;

- (NSAttributedString *)courseTeacherTitle;

- (NSAttributedString *)courseTeacherDetail;

@end



@interface HTPlayerController : UIViewController

@property (nonatomic, strong) id <HTPlayerCourseProtocol> courseModel;

@end
