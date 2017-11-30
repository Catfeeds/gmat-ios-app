//
//  HTMockRecordReuseController.m
//  GMat
//
//  Created by hublot on 2016/11/4.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTMockRecordReuseController.h"
#import "HTMockRecordCell.h"
#import "HTQuestionController.h"
#import "HTMockRecordModel.h"
#import "HTQuestionMockSleepController.h"
#import "HTQuestionMockStartController.h"
#import "HTScoreController.h"

@interface HTMockRecordReuseController ()

@property (nonatomic, strong) HTExerciseModel *selectedExerciseModel;

@end

@implementation HTMockRecordReuseController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initializeDataSource];
	[self initializeUserInterface];
}

- (void)initializeDataSource {
	
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    __block HTMockRecordModel *recordModel;
    if (self.selectedExerciseModel) {
        [self.pageModel.modelArray enumerateObjectsUsingBlock:^(HTMockRecordModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.mkid isEqualToString:self.selectedExerciseModel.Id]) {
                recordModel = obj;
                recordModel.markquestion = self.selectedExerciseModel.markquestion;
				recordModel.releattr.correct.numAll = self.selectedExerciseModel.userlowertk;
            }
        }];
    }
    if (recordModel) {
        NSInteger selectedRow = [self.pageModel.modelArray indexOfObject:recordModel];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:selectedRow inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)initializeUserInterface {
	[self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.edges.mas_equalTo(UIEdgeInsetsZero);
	}];
	
	__weak HTMockRecordReuseController *weakSelf = self;
    
    [self.tableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
        [sectionMaker.cellClass([HTMockRecordCell class])
		 .rowHeight(75) didSelectedCellBlock:^(UITableView *tableView, NSInteger row, __kindof UITableViewCell *cell, __kindof HTMockRecordModel *model) {
            HTExerciseModel *exerciseModel = [[HTExerciseModel alloc] init];
            exerciseModel.Id = model.mkid;
            exerciseModel.mkscoreid = model.mkscoreid;
            exerciseModel.mockStartType = weakSelf.mockStartType;
            exerciseModel.name = model.name;
			exerciseModel.markquestion = model.markquestion;
            HTQuestionControllerBlocks *questionControllerBlocks = [[HTQuestionControllerBlocks alloc] initWithNavigationControllerToPushMockQuestionController:weakSelf.navigationController exerciseModel:exerciseModel];
            HTQuestionController *questionController;
            HTScoreController *scoreController;
            if (model.markquestion.integerValue == 2) {
                scoreController = [HTQuestionControllerBlocks scoreControllerWithMockExerciseModel:exerciseModel];
                scoreController.blockPacket = questionControllerBlocks;
            } else {
                questionController = [[HTQuestionController alloc] init];
                questionController.blockPackage = questionControllerBlocks;
            }
			weakSelf.selectedExerciseModel = exerciseModel;
            if (questionController) {
                [weakSelf.navigationController pushViewController:questionController animated:true];
            } else if (scoreController) {
                [weakSelf.navigationController pushViewController:scoreController animated:true];
            }
        }];
    }];
}

@end
