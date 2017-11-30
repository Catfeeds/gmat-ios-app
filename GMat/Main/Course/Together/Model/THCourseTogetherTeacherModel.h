//
//  THCourseTogethreTeacherModel.h
//  TingApp
//
//  Created by hublot on 16/8/31.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THCourseTogetherTeacherModel : NSObject

@property (nonatomic, assign) NSInteger joinTimes;

- (void)resetJoinTimes;

@property (nonatomic, copy) NSString *teacherName;

@property (nonatomic, copy) NSString *teacherIamge;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *introduce;

@property (nonatomic, strong) NSAttributedString *introduceAttributedString;

@property (nonatomic, copy) NSString *teacherId;

@end
