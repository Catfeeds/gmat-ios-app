//
//  HTReportExerciseController.h
//  GMat
//
//  Created by hublot on 2016/10/18.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HTReportStyle) {
	HTReportStyleAll,
	HTReportStyleSC,
	HTReportStyleRC,
	HTReportStyleCR,
	HTReportStyleQuant
};

@interface HTReportExerciseController : UIViewController

@property (nonatomic, assign) HTReportStyle reportStyle;

@end
