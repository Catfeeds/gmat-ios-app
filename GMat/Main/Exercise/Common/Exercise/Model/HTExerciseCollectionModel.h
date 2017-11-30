//
//  HTExerciseCollectionModel.h
//  GMat
//
//  Created by hublot on 2016/10/18.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, HTExerciseCollectionModelType) {
	HTExerciseCollectionModelTypeSingle = 0,
	HTExerciseCollectionModelTypePoint,
	HTExerciseCollectionModelTypeHardly,
	HTExerciseCollectionModelTypeMock,
	HTExerciseCollectionModelTypeSort,
	HTExerciseCollectionModelTypeReport,
};

@interface HTExerciseCollectionModel : NSObject

@property (nonatomic, copy) NSString *titleName;

@property (nonatomic, copy) NSString *imageName;

@property (nonatomic, assign) BOOL isShowContinue; //是否显示继续做题

@property (nonatomic, assign) Class controllerClass;

@property (nonatomic, assign) HTExerciseCollectionModelType modelType;

+ (NSArray <HTExerciseCollectionModel *> *)packModelArray;

@end
