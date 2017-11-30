//
//  HTKnowledgeModel.h
//  GMat
//
//  Created by hublot on 16/10/12.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KnowledgeCategorytype,KnowledgeCategorycontent;

@interface HTKnowledgeModel : NSObject

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

@property (nonatomic, strong) NSArray<KnowledgeCategorytype *> *categoryType;

@property (nonatomic, copy) NSString *catuseurl;

@property (nonatomic, copy) NSString *catmanager;

@property (nonatomic, copy) NSString *catindex;

@property (nonatomic, copy) NSString *sum;

@property (nonatomic, copy) NSString *views;


@end

@interface KnowledgeCategorytype : NSObject

@property (nonatomic, strong) UIColor *cellBackgroundColor;

@property (nonatomic, copy) NSString *catimg;

@property (nonatomic, copy) NSString *catid;

@property (nonatomic, copy) NSString *catparent;

@property (nonatomic, strong) NSArray<KnowledgeCategorycontent *> *categoryContent;

@property (nonatomic, copy) NSString *caturl;

@property (nonatomic, copy) NSString *catname;

@property (nonatomic, copy) NSString *catlite;

@property (nonatomic, copy) NSString *catdes;

@property (nonatomic, copy) NSString *cattpl;

@property (nonatomic, copy) NSString *catinmenu;

@property (nonatomic, copy) NSString *catapp;

@property (nonatomic, copy) NSString *catuseurl;

@property (nonatomic, copy) NSString *catmanager;

@property (nonatomic, copy) NSString *catindex;

@end

@interface KnowledgeCategorycontent : NSObject

@property (nonatomic, copy) NSString *contentid;

@property (nonatomic, copy) NSString *contenttitle;

@property (nonatomic, copy) NSString *contentdetail;

@end

