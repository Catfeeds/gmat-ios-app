//
//  HTStoreModel.h
//  GMat
//
//  Created by hublot on 16/11/7.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import <Foundation/Foundation.h>

@class StoreQanswer,StoreQslctarr;

@interface HTStoreModel : NSObject

@property (nonatomic, copy) NSString *questioncreatetime;

@property (nonatomic, copy) NSString *questionid;

@property (nonatomic, copy) NSString *questionhtml;

@property (nonatomic, copy) NSString *correct;

@property (nonatomic, assign) BOOL collect;

@property (nonatomic, copy) NSString *totaluser;

@property (nonatomic, copy) NSString *level;

@property (nonatomic, copy) NSString *questionselect;

@property (nonatomic, copy) NSString *tureusernum;

@property (nonatomic, copy) NSString *level_s;

@property (nonatomic, copy) NSString *oneobjecttype;

@property (nonatomic, copy) NSString *comments;

@property (nonatomic, copy) NSString *questionlastmodifyuser;

@property (nonatomic, copy) NSString *totaltime;

@property (nonatomic, copy) NSString *questiontitle;

@property (nonatomic, assign) NSInteger commentnumb;

@property (nonatomic, copy) NSString *section;

@property (nonatomic, copy) NSString *questionknowsid;

@property (nonatomic, copy) NSString *discussmark;

@property (nonatomic, copy) NSString *articletitle;

@property (nonatomic, copy) NSString *questionuserid;

@property (nonatomic, copy) NSString *questionselectnumber;

@property (nonatomic, copy) NSString *twbname;

@property (nonatomic, copy) NSString *views;

@property (nonatomic, copy) NSString *questionarticle;

@property (nonatomic, copy) NSString *discusstime;

@property (nonatomic, copy) NSString *mathfoundation;

@property (nonatomic, copy) NSString *readArticleId;

@property (nonatomic, copy) NSString *meantime;

@property (nonatomic, copy) NSString *questionparent;

@property (nonatomic, strong) StoreQanswer *qanswer;

@property (nonatomic, copy) NSString *questionanswer;

@property (nonatomic, copy) NSString *questiondescribe;

@property (nonatomic, copy) NSString *qtitle;

@property (nonatomic, copy) NSString *questionstatus;

@property (nonatomic, copy) NSString *subjecttype;

@property (nonatomic, copy) NSString *questiontype;

@property (nonatomic, strong) NSArray<StoreQslctarr *> *qslctarr;

@property (nonatomic, copy) NSString *twoobjecttype;

@property (nonatomic, copy) NSString *questionusername;

@property (nonatomic, copy) NSString *sectiontype;

@property (nonatomic, copy) NSString *questionlevel;

@property (nonatomic, copy) NSString *question;

@property (nonatomic, copy) NSString *questionsequence;

@end
@interface StoreQanswer : NSObject

@property (nonatomic, copy) NSString *answertime;

@end

@interface StoreQslctarr : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *select;

@end

