//
//  HTQuestionModel.h
//  GMat
//
//  Created by hublot on 2016/11/9.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HTQuestionContentData,HTQuestionSelectedQslctarr;
@interface HTGroupQuestionModel : NSObject


@property (nonatomic, assign) NSInteger isread;

@property (nonatomic, strong) HTQuestionContentData *data;

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, assign) NSInteger collect;

@property (nonatomic, assign) NSInteger Do;

@property (nonatomic, assign) NSInteger showtime;

@property (nonatomic, assign) NSInteger mkid;

@property (nonatomic, assign) NSInteger all;

@property (nonatomic, copy) NSString *name;


@end

@interface HTQuestionContentData : NSObject

@property (nonatomic, copy) NSString *questioncreatetime;

@property (nonatomic, copy) NSString *questionid;

@property (nonatomic, copy) NSString *questionhtml;

@property (nonatomic, copy) NSString *questionselect;

@property (nonatomic, copy) NSString *level_s;

@property (nonatomic, copy) NSString *oneobjecttype;

@property (nonatomic, copy) NSString *comments;

@property (nonatomic, copy) NSString *questionlastmodifyuser;

@property (nonatomic, copy) NSString *questiontitle;

@property (nonatomic, copy) NSString *discussmark;

@property (nonatomic, copy) NSString *questionknowsid;

@property (nonatomic, copy) NSString *articletitle;

@property (nonatomic, copy) NSString *questionuserid;

@property (nonatomic, copy) NSString *articleContent;

@property (nonatomic, copy) NSString *questionselectnumber;

@property (nonatomic, copy) NSString *views;

@property (nonatomic, copy) NSString *questionarticle;

@property (nonatomic, copy) NSString *discusstime;

@property (nonatomic, copy) NSString *mathfoundation;

@property (nonatomic, copy) NSString *readArticleId;

@property (nonatomic, copy) NSString *questionparent;

@property (nonatomic, copy) NSString *questionanswer;

@property (nonatomic, copy) NSString *questiondescribe;

@property (nonatomic, copy) NSString *qtitle;

@property (nonatomic, copy) NSString *questionstatus;

@property (nonatomic, copy) NSString *subjecttype;

@property (nonatomic, copy) NSString *questiontype;

@property (nonatomic, strong) NSArray<HTQuestionSelectedQslctarr *> *qslctarr;

@property (nonatomic, copy) NSString *questionNumber;

@property (nonatomic, copy) NSString *twoobjecttype;

@property (nonatomic, copy) NSString *questionusername;

@property (nonatomic, copy) NSString *sectiontype;

@property (nonatomic, copy) NSString *questionlevel;

@property (nonatomic, copy) NSString *question;

@property (nonatomic, copy) NSString *questionsequence;

@end

@interface HTQuestionSelectedQslctarr : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *select;

@end

