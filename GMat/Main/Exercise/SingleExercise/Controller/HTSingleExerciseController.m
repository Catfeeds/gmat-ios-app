//
//  HTSingleExerciseController.m
//  GMat
//
//  Created by hublot on 2016/10/18.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTSingleExerciseController.h"
#import "HTSingleExerciseContentController.h"
#import "UIScrollView+HTRefresh.h"
#import "HTExerciseModel.h"
#import "HTMagicDelegate.h"
#import "HTQuestionManager.h"
#import "HTManagerController+HTRotate.h"
#import "HTSingleVersionForUserManager.h"

@interface HTSingleExerciseController () <HTRotateVisible, HTRotateEveryOne>

@end

@implementation HTSingleExerciseController

- (void)viewDidLoad {
    self.firstRowTitleArray = @[@"SC", @"CR", @"RC", @"PS", @"DS"];
	self.secondRowTitleArray = @[@"OG", @"PREP", @"讲义", @"GWD", @"Manhattan"];
	[super viewDidLoad];
	[self initializeDataSource];
	[self initializeUserInterface];
}

- (void)initializeDataSource {
	
}

- (void)initializeUserInterface {
    
    __weak typeof(self) weakSelf = self;
	self.navigationItem.title = @"单项练习";
    UIButton *button = [[UIButton alloc] init];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [button setTitle:@"切到旧版" forState:UIControlStateNormal];
	[button setTitle:@"切到旧版" forState:UIControlStateNormal | UIControlStateHighlighted];
    [button setTitle:@"切到新版" forState:UIControlStateSelected];
	[button setTitle:@"切到新版" forState:UIControlStateSelected | UIControlStateHighlighted];
    [button sizeToFit];
    
    __weak typeof(button) weakButton = button;
    [button ht_whenTap:^(UIView *view) {
        weakButton.selected = !weakButton.selected;
        [weakSelf reloadRefreshStateWithButton:weakButton];
    }];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = barButtonItem;
    
	self.reuseControllerClass = [HTSingleExerciseContentController class];
    
    HTSingleExerciseVersion userVersion = [HTSingleVersionForUserManager readUserVersion];
    BOOL selected;
    if (userVersion == HTSingleExerciseVersionOld) {
        selected = true;
    } else {
        selected = false;
    }
    button.selected = selected;
    [self reloadRefreshStateWithButton:button];
}

- (void)reloadRefreshStateWithButton:(UIButton *)button {
    HTSingleExerciseVersion singleExerciseVersion;
    if (button.selected) {
        singleExerciseVersion = HTSingleExerciseVersionOld;
    } else {
        singleExerciseVersion = HTSingleExerciseVersionNew;
    }
    [HTSingleVersionForUserManager saveUserVersion:singleExerciseVersion];
    [self refreshSingleExerciseStateWithSingleExerciseVersion:singleExerciseVersion];
}

- (void)refreshSingleExerciseStateWithSingleExerciseVersion:(HTSingleExerciseVersion)singleExerciseVersion {
    NSArray *sectionidArray = @[@"6",
                                @"8",
                                @"7",
                                @"4",
                                @"5"];
    
    NSArray *twoObjectArray = @[@[@"1", @"15", @"18"],
                                @[@"8", @"10", @"11"],
                                @[@"12"],
                                @[@"2"],
                                @[@"9"]];
    
    
    [self setModelArrayBlock:^(NSString *firstSelectedIndex, NSString *secondSelectedIndex, NSString *pageCount, NSString *currentPage, void (^modelArrayStatus)(NSArray <HTExerciseModel *> *, HTError *errorModel)) {
        if (currentPage.integerValue > 1) {
            modelArrayStatus(@[], nil);
            return;
        }
        NSString *sectionId = sectionidArray[firstSelectedIndex.integerValue];
        NSArray *towObject = twoObjectArray[secondSelectedIndex.integerValue];
        NSMutableArray <HTExerciseModel *> *modelArray = [HTQuestionManager packExerciseModelArrayWithSectionId:sectionId twoObjectIdArray:towObject singleExerciseVersion:singleExerciseVersion];
        [modelArray enumerateObjectsUsingBlock:^(HTExerciseModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.modelStyle = HTExerciseModelStyleSingle;
        }];
        modelArrayStatus(modelArray, nil);
    }];
    [self reloadMagicView];
}

@end
