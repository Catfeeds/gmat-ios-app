//
//  HTScoreModel.h
//  GMat
//
//  Created by hublot on 2016/11/11.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MockScoreS,MockScoreSc,MockScoreRc,MockScoreCr,MockScorePs,MockScoreDs,MockScoreMkinfo,MockScoreCredit,MockScoreQuestionrecord,MockScoreQanswer,MockScoreParse,MockScoreQslctarr;
@interface HTScoreModel : NSObject

@property (nonatomic, assign) BOOL subject;

@property (nonatomic, assign) BOOL section;

@property (nonatomic, copy) NSString *meantime;

@property (nonatomic, copy) NSString *qyesnum;

@property (nonatomic, copy) NSString *Qtruenum;

@property (nonatomic, copy) NSString *totluser;

@property (nonatomic, assign) NSInteger mkid;

@property (nonatomic, assign) NSInteger mkscoreid;

@property (nonatomic, copy) NSString *QuantNum;

@property (nonatomic, strong) MockScoreS *S;

@property (nonatomic, strong) NSArray<MockScoreQuestionrecord *> *questionrecord;

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, strong) MockScoreCredit *credit;

@property (nonatomic, assign) CGFloat correct;

@property (nonatomic, copy) NSString *totletime;

@property (nonatomic, copy) NSString *mark;

@property (nonatomic, strong) MockScoreMkinfo *mkinfo;

@property (nonatomic, assign) NSInteger mockStartType;

@property (nonatomic, copy) NSString *VerbalNum;

@end

@interface MockScoreS : NSObject

@property (nonatomic, strong) MockScoreSc *SC;

@property (nonatomic, strong) MockScoreRc *RC;

@property (nonatomic, strong) MockScoreCr *CR;

@property (nonatomic, strong) MockScorePs *PS;

@property (nonatomic, strong) MockScoreDs *DS;

@end

@interface MockScoreSc : NSObject

@property (nonatomic, copy) NSString *numTrue;

@property (nonatomic, copy) NSString *numAll;

@property (nonatomic, assign) CGFloat correct;

@end

@interface MockScoreRc : NSObject

@property (nonatomic, copy) NSString *numTrue;

@property (nonatomic, copy) NSString *numAll;

@property (nonatomic, assign) CGFloat correct;

@end

@interface MockScoreCr : NSObject

@property (nonatomic, copy) NSString *numTrue;

@property (nonatomic, copy) NSString *numAll;

@property (nonatomic, assign) CGFloat correct;

@end

@interface MockScorePs : NSObject

@property (nonatomic, copy) NSString *numTrue;

@property (nonatomic, copy) NSString *numAll;

@property (nonatomic, assign) NSInteger correct;

@end

@interface MockScoreDs : NSObject

@property (nonatomic, copy) NSString *numTrue;

@property (nonatomic, copy) NSString *numAll;

@property (nonatomic, assign) NSInteger correct;

@end

@interface MockScoreMkinfo : NSObject

@property (nonatomic, copy) NSString *nameid;

@property (nonatomic, copy) NSString *remark;

@property (nonatomic, copy) NSString *num;

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *basedata;

@property (nonatomic, copy) NSString *mktype;

@property (nonatomic, copy) NSString *questionids;

@property (nonatomic, copy) NSString *mkttime;

@property (nonatomic, copy) NSString *args;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *argsmd5;

@end

@interface MockScoreCredit : NSObject

@property (nonatomic, copy) NSString *V_score;

@property (nonatomic, copy) NSString *Q_score;

@property (nonatomic, copy) NSString *Totalscore;

@end

@interface MockScoreQuestionrecord : NSObject

@property (nonatomic, copy) NSString *questioncreatetime;

@property (nonatomic, copy) NSString *questionsequence;

@property (nonatomic, copy) NSString *questionid;

@property (nonatomic, copy) NSString *mkscoreid;

@property (nonatomic, copy) NSString *questionhtml;

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *totaluser;

@property (nonatomic, copy) NSString *correct;

@property (nonatomic, copy) NSString *questionselect;

@property (nonatomic, copy) NSString *tureusernum;

@property (nonatomic, assign) BOOL collect;

@property (nonatomic, copy) NSString *oneobjecttype;

@property (nonatomic, copy) NSString *comments;

@property (nonatomic, copy) NSString *answertype;

@property (nonatomic, copy) NSString *duration;

@property (nonatomic, copy) NSString *questionlastmodifyuser;

@property (nonatomic, copy) NSString *totaltime;

@property (nonatomic, copy) NSString *score;

@property (nonatomic, copy) NSString *questiontitle;

@property (nonatomic, copy) NSString *discussmark;

@property (nonatomic, copy) NSString *questionknowsid;

@property (nonatomic, assign) NSInteger commentnumb;

@property (nonatomic, copy) NSString *articletitle;

@property (nonatomic, copy) NSString *questionuserid;

@property (nonatomic, copy) NSString *questionselectnumber;

@property (nonatomic, copy) NSString *mkid;

@property (nonatomic, copy) NSString *views;

@property (nonatomic, copy) NSString *questionarticle;

@property (nonatomic, copy) NSString *discusstime;

@property (nonatomic, copy) NSString *mathfoundation;

@property (nonatomic, copy) NSString *readArticleId;

@property (nonatomic, copy) NSString *meantime;

@property (nonatomic, copy) NSString *questionparent;

@property (nonatomic, strong) MockScoreQanswer *qanswer;

@property (nonatomic, copy) NSString *questionanswer;

@property (nonatomic, copy) NSString *questiondescribe;

@property (nonatomic, copy) NSString *questionstatus;

@property (nonatomic, copy) NSString *subjecttype;

@property (nonatomic, copy) NSString *questiontype;

@property (nonatomic, strong) MockScoreParse *parse;

@property (nonatomic, strong) NSArray<MockScoreQslctarr *> *qslctarr;

@property (nonatomic, copy) NSString *twoobjecttype;

@property (nonatomic, copy) NSString *questionusername;

@property (nonatomic, copy) NSString *sectiontype;

@property (nonatomic, copy) NSString *answertime;

@property (nonatomic, copy) NSString *questionlevel;

@property (nonatomic, copy) NSString *useranswer;

@property (nonatomic, copy) NSString *usertikuid;

@property (nonatomic, copy) NSString *question;

@property (nonatomic, copy) NSString *userid;

@end

@interface MockScoreQanswer : NSObject

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *questionid;

@property (nonatomic, copy) NSString *userid;

@property (nonatomic, copy) NSString *mkid;

@property (nonatomic, copy) NSString *mkscoreid;

@property (nonatomic, copy) NSString *answertype;

@property (nonatomic, copy) NSString *time;

@property (nonatomic, copy) NSString *duration;

@property (nonatomic, copy) NSString *useranswer;

@property (nonatomic, copy) NSString *usertikuid;

@property (nonatomic, copy) NSString *answertime;

@property (nonatomic, copy) NSString *score;

@end

@interface MockScoreParse : NSObject

@property (nonatomic, copy) NSString *parsid;

@property (nonatomic, copy) NSString *userid;

@property (nonatomic, copy) NSString *p_time;

@property (nonatomic, copy) NSString *p_type;

@property (nonatomic, copy) NSString *price;

@property (nonatomic, copy) NSString *p_content;

@property (nonatomic, copy) NSString *p_audit;

@property (nonatomic, copy) NSString *p_questionid;

@end

@interface MockScoreQslctarr : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *select;

@end

