//
//  HTSqliteUpdateModel.h
//  GMat
//
//  Created by hublot on 2017/8/11.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HTSqliteParseModel,HTSqliteQuestionModel,HTSqliteExerciseModel, HTSqliteSortQuestionModel, HTSqliteSortExerciseModel, HTSqliteSortExerciseModel;

@interface HTSqliteUpdateModel : NSObject

@property (nonatomic, strong) NSArray<HTSqliteParseModel *> *parse;

@property (nonatomic, strong) NSArray<HTSqliteQuestionModel *> *question;

@property (nonatomic, strong) NSArray<HTSqliteExerciseModel *> *tiku;

@property (nonatomic, strong) NSArray<HTSqliteSortQuestionModel *> *xuhaoquestion;

@property (nonatomic, strong) NSArray<HTSqliteSortExerciseModel *> *xuhao;



@end

@interface HTSqliteParseModel : NSObject

@property (nonatomic, copy) NSString *parsid;

@property (nonatomic, copy) NSString *userid;

@property (nonatomic, copy) NSString *p_time;

@property (nonatomic, copy) NSString *p_type;

@property (nonatomic, copy) NSString *price;

@property (nonatomic, copy) NSString *p_content;

@property (nonatomic, copy) NSString *p_audit;

@property (nonatomic, copy) NSString *p_questionid;

@end

@interface HTSqliteQuestionModel : NSObject

@property (nonatomic, copy) NSString *sectiontype;

@property (nonatomic, copy) NSString *question;

@property (nonatomic, copy) NSString *questionhtml;

@property (nonatomic, copy) NSString *questionselect;

@property (nonatomic, copy) NSString *mathfoundation;

@property (nonatomic, copy) NSString *discussmark;

@property (nonatomic, copy) NSString *readArticleId;

@property (nonatomic, copy) NSString *subjecttype;

@property (nonatomic, copy) NSString *questiontype;

@property (nonatomic, copy) NSString *questionNumber;

@property (nonatomic, copy) NSString *questionparent;

@property (nonatomic, copy) NSString *questionuserid;

@property (nonatomic, copy) NSString *views;

@property (nonatomic, copy) NSString *questionarticle;

@property (nonatomic, copy) NSString *articleContent;

@property (nonatomic, copy) NSString *articletitle;

@property (nonatomic, copy) NSString *questionstatus;

@property (nonatomic, copy) NSString *questionid;

@property (nonatomic, copy) NSString *questiontitle;

@property (nonatomic, copy) NSString *questionusername;

@property (nonatomic, copy) NSString *questioncreatetime;

@property (nonatomic, copy) NSString *questionlevel;

@property (nonatomic, copy) NSString *discusstime;

@property (nonatomic, copy) NSString *twoobjecttype;

@property (nonatomic, copy) NSString *questionsequence;

@property (nonatomic, copy) NSString *comments;

@property (nonatomic, copy) NSString *questionlastmodifyuser;

@property (nonatomic, copy) NSString *questionanswer;

@property (nonatomic, copy) NSString *questiondescribe;

@property (nonatomic, copy) NSString *questionknowsid;

@property (nonatomic, copy) NSString *questionselectnumber;

@property (nonatomic, copy) NSString *oneobjecttype;

@end

@interface HTSqliteExerciseModel : NSObject

@property (nonatomic, copy) NSString *stname;

@property (nonatomic, copy) NSString *sectionid;

@property (nonatomic, copy) NSString *subjectid;

@property (nonatomic, copy) NSString *stid;

@property (nonatomic, copy) NSString *knowsid;

@property (nonatomic, copy) NSString *questionsid;

@property (nonatomic, copy) NSString *twoobjectid;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *levelid;

@end

@interface HTSqliteSortQuestionModel : NSObject

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *tikuId;

@property (nonatomic, copy) NSString *questionid;

@property (nonatomic, copy) NSString *createTIme;

@end

@interface HTSqliteSortExerciseModel : NSObject

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *twoobject;

@property (nonatomic, copy) NSString *section;

@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, copy) NSString *number;

@property (nonatomic, copy) NSString *sort;

@property (nonatomic, copy) NSString *type;

@end
