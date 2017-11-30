//
//  HTExerciseSearchModel.h
//  GMat
//
//  Created by hublot on 2017/5/17.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, HTExerciseSearchModelType) {
	HTExerciseSearchModelTypeTakePhoto,
	HTExerciseSearchModelTypeVoice,
	HTExerciseSearchModelTypeSearch
};

@interface HTExerciseSearchModel : NSObject

@property (nonatomic, assign) HTExerciseSearchModelType searchType;

@property (nonatomic, strong) NSString *titleName;

@property (nonatomic, strong) NSString *imageName;

+ (NSArray <HTExerciseSearchModel *> *)packModelArray;

@end
