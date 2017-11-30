//
//  HTCourseOpenModel.h
//  GMat
//
//  Created by hublot on 2016/12/14.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTCourseOpenModel : NSObject

@property (nonatomic, assign) NSInteger joinTimes;

- (void)resetJoinTimes;

@property (nonatomic, copy) NSString *catName;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *cnName;

@property (nonatomic, copy) NSString *image;

@property (nonatomic, copy) NSString *duration;

@property (nonatomic, copy) NSString *alternatives;

@property (nonatomic, copy) NSString *sort;

@property (nonatomic, copy) NSString *viewCount;

@property (nonatomic, copy) NSString *numbering;

@property (nonatomic, copy) NSString *problemComplement;

@property (nonatomic, copy) NSString *catId;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *sentenceNumber;

@property (nonatomic, copy) NSString *answer;

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *article;

@property (nonatomic, copy) NSString *pid;

@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, copy) NSString *listeningFile;

@property (nonatomic, copy) NSString *userId;

@end
