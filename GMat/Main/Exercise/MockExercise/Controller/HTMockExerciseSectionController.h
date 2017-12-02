//
//  HTMockExerciseSectionController.h
//  GMat
//
//  Created by hublot on 2016/10/26.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTPageController.h"

typedef NS_ENUM(NSInteger, HTMockStyle) {
	HTMockStyleVerbal,
	HTMockStyleQuant,
	HTMockStyleQuantAndVerbal
};

typedef NS_ENUM(NSInteger, HTTypeClass) {
	HTTypeClassPrep,
	HTTypeClassGwd,
	HTTypeClassChosen
};

@interface HTMockExerciseSectionController : HTPageController

@property (nonatomic, assign) HTMockStyle mockStyle;

@property (nonatomic, strong) NSString *mockExerciseString;

@end
