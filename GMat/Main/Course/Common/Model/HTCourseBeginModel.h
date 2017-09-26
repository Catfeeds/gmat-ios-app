//
//  HTCourseBeginModel.h
//  GMat
//
//  Created by hublot on 2017/4/19.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTCourseBeginModel : NSObject

@property (nonatomic, copy) NSString *catname;

@property (nonatomic, copy) NSString *times;

@property (nonatomic, assign) NSInteger playTimes;

@property (nonatomic, strong) NSString *tintColor;

@property (nonatomic, strong) NSString *backgroundImage;

@property (nonatomic, strong) NSString *webHtmlUrlString;




@property (nonatomic, copy) NSString *contentthumb;

@property (nonatomic, copy) NSString *contentid;

@property (nonatomic, copy) NSString *contenttitle;

@property (nonatomic, copy) NSString *contentdefault;

@property (nonatomic, copy) NSString *contentlink;

@property (nonatomic, copy) NSString *contentmodifytime;

@property (nonatomic, copy) NSString *contentstatus;

@property (nonatomic, copy) NSString *contentuserid;

@property (nonatomic, copy) NSString *images_pictures;

@property (nonatomic, copy) NSString *contenttext;

@property (nonatomic, copy) NSString *views;

@property (nonatomic, copy) NSString *contentshow;

@property (nonatomic, copy) NSString *product_pictures;

@property (nonatomic, copy) NSString *contentsubtitle;

@property (nonatomic, copy) NSString *hour;

@property (nonatomic, copy) NSString *contentcatid;

@property (nonatomic, copy) NSString *contentusername;

@property (nonatomic, copy) NSString *contentinputtime;

@property (nonatomic, copy) NSString *contenttemplate;

@property (nonatomic, copy) NSString *contentdescribe;

@property (nonatomic, copy) NSString *contentinfo;

@property (nonatomic, copy) NSString *contentmoduleid;

@property (nonatomic, copy) NSString *contentsequence;


- (void)appendDataWithIndex:(NSInteger)index;

@end
