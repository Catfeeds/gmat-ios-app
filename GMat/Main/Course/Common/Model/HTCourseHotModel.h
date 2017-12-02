//
//  HTCourseHotModel.h
//  GMat
//
//  Created by hublot on 2017/4/19.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CourseResult;

@interface HTCourseHotModel : NSObject

@property (nonatomic, assign) NSInteger joinTimes;

- (void)resetJoinTimesWithIndex:(NSInteger)index;


@property (nonatomic, copy) NSString *catimg;

@property (nonatomic, copy) NSString *catid;

@property (nonatomic, copy) NSString *catparent;

@property (nonatomic, copy) NSString *caturl;

@property (nonatomic, copy) NSString *catname;

@property (nonatomic, copy) NSString *catlite;

@property (nonatomic, copy) NSString *catdes;

@property (nonatomic, copy) NSString *cattpl;

@property (nonatomic, copy) NSString *catinmenu;

@property (nonatomic, copy) NSString *catapp;

@property (nonatomic, strong) CourseResult *result;

@property (nonatomic, copy) NSString *catuseurl;

@property (nonatomic, copy) NSString *catmanager;

@property (nonatomic, copy) NSString *catindex;

@end

@interface CourseResult : NSObject

@property (nonatomic, copy) NSString *contentthumb;

@property (nonatomic, copy) NSString *contentid;

@property (nonatomic, copy) NSString *contenttitle;

@property (nonatomic, copy) NSString *contentdefault;

@property (nonatomic, copy) NSString *time;

@property (nonatomic, copy) NSString *contentlink;

@property (nonatomic, copy) NSString *contentmodifytime;

@property (nonatomic, copy) NSString *teacher;

@property (nonatomic, copy) NSString *contentstatus;

@property (nonatomic, copy) NSString *contentuserid;

@property (nonatomic, copy) NSString *images_pictures;

@property (nonatomic, copy) NSString *contenttext;

@property (nonatomic, copy) NSString *views;

@property (nonatomic, copy) NSString *contentshow;

@property (nonatomic, copy) NSString *product_pictures;

@property (nonatomic, copy) NSString *contentsubtitle;

@property (nonatomic, copy) NSString *contentcatid;

@property (nonatomic, copy) NSString *contentusername;

@property (nonatomic, copy) NSString *contentinputtime;

@property (nonatomic, copy) NSString *contenttemplate;

@property (nonatomic, copy) NSString *contentdescribe;

@property (nonatomic, copy) NSString *contentinfo;

@property (nonatomic, copy) NSString *contentmoduleid;

@property (nonatomic, copy) NSString *price;

@property (nonatomic, copy) NSString *contentsequence;

@end
