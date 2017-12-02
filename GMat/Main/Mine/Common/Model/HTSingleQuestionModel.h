//
//  HTSingleQuestionModel.h
//  GMat
//
//  Created by hublot on 2016/11/18.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SingleQuestionQuestion,SingleQuestionQanswer,SingleQuestionQslctarr,SingleQuestionQuestionknowsid,SingleQuestionPars_Audit,SingleQuestionSameknow,SingleQuestionParseall;
@interface HTSingleQuestionModel : NSObject

@property (nonatomic, strong) SingleQuestionPars_Audit *pars_audit;

@property (nonatomic, strong) NSArray<SingleQuestionParseall *> *parseall;

@property (nonatomic, strong) NSArray<SingleQuestionSameknow *> *sameknow;

@property (nonatomic, assign) BOOL sectionid;

@property (nonatomic, strong) SingleQuestionQuestion *question;

@property (nonatomic, copy) NSString *tikuname;

@property (nonatomic, assign) BOOL comment;

@property (nonatomic, assign) BOOL originid;


@end

@interface SingleQuestionQuestion : NSObject

@property (nonatomic, copy) NSString *questioncreatetime;

@property (nonatomic, copy) NSString *questionid;

@property (nonatomic, assign) BOOL questionhtml;

@property (nonatomic, copy) NSString *correct;

@property (nonatomic, assign) BOOL collect;

@property (nonatomic, copy) NSString *totaluser;

@property (nonatomic, copy) NSString *level;

@property (nonatomic, copy) NSString *questionselect;

@property (nonatomic, copy) NSString *tureusernum;

@property (nonatomic, copy) NSString *level_s;

@property (nonatomic, copy) NSString *oneobjecttype;

@property (nonatomic, copy) NSString *comments;

@property (nonatomic, copy) NSString *twoname;

@property (nonatomic, copy) NSString *questionlastmodifyuser;

@property (nonatomic, copy) NSString *totaltime;

@property (nonatomic, copy) NSString *questiontitle;

@property (nonatomic, assign) NSInteger commentnumb;

@property (nonatomic, copy) NSString *discussmark;

@property (nonatomic, strong) NSArray<SingleQuestionQuestionknowsid *> *questionknowsid;

@property (nonatomic, copy) NSString *articletitle;

@property (nonatomic, copy) NSString *questionuserid;

@property (nonatomic, copy) NSString *questionselectnumber;

@property (nonatomic, copy) NSString *views;

@property (nonatomic, copy) NSString *questionarticle;

@property (nonatomic, copy) NSString *discusstime;

@property (nonatomic, copy) NSString *mathfoundation;

@property (nonatomic, copy) NSString *readArticleId;

@property (nonatomic, copy) NSString *meantime;

@property (nonatomic, copy) NSString *questionparent;

@property (nonatomic, strong) SingleQuestionQanswer *qanswer;

@property (nonatomic, copy) NSString *questionanswer;

@property (nonatomic, copy) NSString *questiondescribe;

@property (nonatomic, copy) NSString *qtitle;

@property (nonatomic, copy) NSString *questionstatus;

@property (nonatomic, copy) NSString *subjecttype;

@property (nonatomic, copy) NSString *questiontype;

@property (nonatomic, strong) NSArray<SingleQuestionQslctarr *> *qslctarr;

@property (nonatomic, copy) NSString *twoobjecttype;

@property (nonatomic, copy) NSString *questionusername;

@property (nonatomic, copy) NSString *sectiontype;

@property (nonatomic, copy) NSString *questionlevel;

@property (nonatomic, copy) NSString *sections;

@property (nonatomic, copy) NSString *question;

@property (nonatomic, copy) NSString *questionsequence;

@end

@interface SingleQuestionQanswer : NSObject

@property (nonatomic, copy) NSString *userid;

@property (nonatomic, copy) NSString *qanswertype;

@property (nonatomic, copy) NSString *answertime;

@property (nonatomic, copy) NSString *time;

@property (nonatomic, copy) NSString *questionid;

@property (nonatomic, copy) NSString *duration;

@property (nonatomic, copy) NSString *answerid;

@property (nonatomic, copy) NSString *qanswer;

@property (nonatomic, copy) NSString *usertikuid;

@end

@interface SingleQuestionQslctarr : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *select;

@end

@interface SingleQuestionQuestionknowsid : NSObject

@property (nonatomic, copy) NSString *knowsid;

@property (nonatomic, copy) NSString *knows;

@end

@interface SingleQuestionPars_Audit : NSObject

@property (nonatomic, copy) NSString *parsid;

@property (nonatomic, copy) NSString *userid;

@property (nonatomic, copy) NSString *p_time;

@property (nonatomic, copy) NSString *p_type;

@property (nonatomic, copy) NSString *price;

@property (nonatomic, copy) NSString *p_content;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, copy) NSString *p_audit;

@property (nonatomic, copy) NSString *p_questionid;

@end

@interface SingleQuestionSameknow : NSObject

@property (nonatomic, copy) NSString *meantime;

@property (nonatomic, copy) NSString *tureusernum;

@property (nonatomic, copy) NSString *totaltime;

@property (nonatomic, copy) NSString *questiontitle;

@property (nonatomic, copy) NSString *totaluser;

@property (nonatomic, copy) NSString *section;

@property (nonatomic, copy) NSString *question;

@property (nonatomic, copy) NSString *questionid;

@property (nonatomic, copy) NSString *correct;

@property (nonatomic, copy) NSString *level;

@property (nonatomic, assign) NSInteger commentnumb;

@end

@interface SingleQuestionParseall : NSObject

@property (nonatomic, copy) NSString *parsid;

@property (nonatomic, copy) NSString *userid;

@property (nonatomic, copy) NSString *p_time;

@property (nonatomic, copy) NSString *p_type;

@property (nonatomic, copy) NSString *price;

@property (nonatomic, copy) NSString *p_content;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, copy) NSString *p_audit;

@property (nonatomic, copy) NSString *p_questionid;

@end

