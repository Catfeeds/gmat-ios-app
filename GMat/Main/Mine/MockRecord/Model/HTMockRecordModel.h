//
//  HTMockRecordModel.h
//  GMat
//
//  Created by hublot on 2016/11/4.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MockRecordReleattr,MockRecordPace,MockRecordCorrect,MockRecordS,MockRecordSc,MockRecordRc,MockRecordCr,MockRecordPs,MockRecordDs,MockRecordCredit,MockRecordQuestionanswer;
@interface HTMockRecordModel : NSObject

@property (nonatomic, copy) NSString *Id;

@property (nonatomic, copy) NSString *mid;

@property (nonatomic, copy) NSString *endtime;

@property (nonatomic, copy) NSString *userid;

@property (nonatomic, copy) NSString *mktime;

@property (nonatomic, copy) NSString *mkid;

@property (nonatomic, copy) NSString *nameid;

@property (nonatomic, copy) NSString *mkscoreid;

@property (nonatomic, copy) NSString *num;

@property (nonatomic, copy) NSString *mktype;

@property (nonatomic, strong) MockRecordReleattr *releattr;

@property (nonatomic, copy) NSString *mkscore;

@property (nonatomic, copy) NSString *mark;

@property (nonatomic, copy) NSString *markquestion;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) NSArray<MockRecordQuestionanswer *> *questionanswer;

@end
@interface MockRecordReleattr : NSObject

@property (nonatomic, copy) NSString *meantime;

@property (nonatomic, strong) MockRecordCredit *credit;

@property (nonatomic, copy) NSString *QuantNum;

@property (nonatomic, copy) NSString *Qtruenum;

@property (nonatomic, copy) NSString *totluser;

@property (nonatomic, strong) MockRecordPace *Pace;

@property (nonatomic, strong) MockRecordCorrect *correct;

@property (nonatomic, copy) NSString *VerbalNum;

@property (nonatomic, strong) MockRecordS *S;

@property (nonatomic, copy) NSString *totletime;

@property (nonatomic, copy) NSString *qyesnum;

@end

@interface MockRecordPace : NSObject

@property (nonatomic, copy) NSString *Pace_msg;

@property (nonatomic, copy) NSString *Pace_s;

@property (nonatomic, copy) NSString *Pace;

@end

@interface MockRecordCorrect : NSObject

@property (nonatomic, copy) NSString *numTrue;

@property (nonatomic, copy) NSString *numAll;

@property (nonatomic, assign) CGFloat correct;

@end

@interface MockRecordS : NSObject

@property (nonatomic, strong) MockRecordSc *SC;

@property (nonatomic, strong) MockRecordRc *RC;

@property (nonatomic, strong) MockRecordCr *CR;

@property (nonatomic, strong) MockRecordPs *PS;

@property (nonatomic, strong) MockRecordDs *DS;

@end

@interface MockRecordSc : NSObject

@property (nonatomic, copy) NSString *numTrue;

@property (nonatomic, copy) NSString *numAll;

@property (nonatomic, assign) NSInteger correct;

@end

@interface MockRecordRc : NSObject

@property (nonatomic, copy) NSString *numTrue;

@property (nonatomic, copy) NSString *numAll;

@property (nonatomic, assign) NSInteger correct;

@end

@interface MockRecordCr : NSObject

@property (nonatomic, copy) NSString *numTrue;

@property (nonatomic, copy) NSString *numAll;

@property (nonatomic, assign) CGFloat correct;

@end

@interface MockRecordPs : NSObject

@property (nonatomic, copy) NSString *numTrue;

@property (nonatomic, copy) NSString *numAll;

@property (nonatomic, assign) NSInteger correct;

@end

@interface MockRecordDs : NSObject

@property (nonatomic, copy) NSString *numTrue;

@property (nonatomic, copy) NSString *numAll;

@property (nonatomic, assign) NSInteger correct;

@end

@interface MockRecordCredit : NSObject

@property (nonatomic, copy) NSString *V_score;

@property (nonatomic, copy) NSString *Q_score;

@property (nonatomic, copy) NSString *Totalscore;

@end

@interface MockRecordQuestionanswer : NSObject

@property (nonatomic, copy) NSString *userid;

@property (nonatomic, copy) NSString *score;

@property (nonatomic, copy) NSString *answertime;

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *mkid;

@property (nonatomic, copy) NSString *answertype;

@property (nonatomic, copy) NSString *questionid;

@property (nonatomic, copy) NSString *duration;

@property (nonatomic, copy) NSString *mkscoreid;

@property (nonatomic, copy) NSString *useranswer;

@property (nonatomic, copy) NSString *usertikuid;

@end

