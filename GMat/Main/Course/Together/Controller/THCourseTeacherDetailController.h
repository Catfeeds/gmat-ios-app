//
//  THCourseTeacherDetailController.h
//  TingApp
//
//  Created by hublot on 16/8/24.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THCourseTogetherTeacherModel.h"
#import "HTCourseTeacherCell.h"
#import <UICollectionViewCell+HTSeparate.h>

@interface THCourseTeacherDetailController : UIViewController

@property (nonatomic, strong) THCourseTogetherTeacherModel *model;

@property (nonatomic, strong) HTCourseTeacherCell *cell;

+ (void)invideButtonTeapedWithModel:(THCourseTogetherTeacherModel *)model complete:(void(^)(void))complete;

@end
