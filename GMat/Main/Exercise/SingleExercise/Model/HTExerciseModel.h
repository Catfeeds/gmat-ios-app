//
//  HTExerciseModel.h
//  GMat
//
//  Created by hublot on 2016/10/31.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTQuestionModel.h"

typedef NS_ENUM(NSInteger, HTExerciseModelStyle) {
	HTExerciseModelStyleSingle, //单项
	HTExerciseModelStylePoint,  //知识点
	HTExerciseModelStyleHardly, //难度
	HTExerciseModelStyleMock,  //模考
	HTExerciseModelStyleSort,  //书本
};

@interface HTExerciseModel : NSObject

@property (nonatomic, assign) HTExerciseModelStyle modelStyle;



// 共有

@property (nonatomic, copy) NSString *stname;

@property (nonatomic, copy) NSString *sectionid;

@property (nonatomic, copy) NSString *subjectid;

@property (nonatomic, copy) NSString *stid;

@property (nonatomic, copy) NSString *knowsid;

@property (nonatomic, copy) NSString *questionsid;

@property (nonatomic, copy) NSString *twoobjectid;

@property (nonatomic, copy) NSString *userlowertk;

@property (nonatomic, assign) NSInteger lowertknumb;

@property (nonatomic, assign) NSInteger correct;

@property (nonatomic, strong) HTQuestionModel *lastRandomQuestionModel;


// 知识点


@property (nonatomic, assign) NSInteger num;

@property (nonatomic, assign) NSInteger totalnum;

@property (nonatomic, copy) NSString *knows;

// 知识点小题库

@property (nonatomic, assign) NSInteger meanTime;




// 模考

@property (nonatomic, copy) NSString *markquestion;

@property (nonatomic, strong) NSArray<NSString *> *basedata_arr;

@property (nonatomic, copy) NSString *Id;

@property (nonatomic, copy) NSString *mkscore;

@property (nonatomic, assign) NSInteger totalusernum;

@property (nonatomic, copy) NSString *questionids;

@property (nonatomic, copy) NSString *mkscoreid;

@property (nonatomic, assign) NSInteger averscore;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *basedata;

@property (nonatomic, assign) NSInteger mockStartType;



@property (nonatomic, copy) NSString *mockSignString;





// 序号题库

@property (nonatomic, copy) NSString *xuhaotikuId;

@end
