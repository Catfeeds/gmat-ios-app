//
//  HTReportSumController.h
//  GMat
//
//  Created by hublot on 16/11/30.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTReportModel.h"
#import "HTReportExerciseController.h"

@interface HTReportSumController : UIViewController

@property (nonatomic, strong) HTReportModel *reportModel;

@property (nonatomic, assign) HTReportStyle reportStyle;

@end
