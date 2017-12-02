//
//  HTWrongRecordReuseController.m
//  GMat
//
//  Created by hublot on 2016/11/1.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTWrongRecordReuseController.h"
#import "HTMineRecordCell.h"
#import "HTQuestionController.h"
#import "HTRecordExerciseModel.h"

@interface HTWrongRecordReuseController ()

@end

@implementation HTWrongRecordReuseController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initializeDataSource];
	[self initializeUserInterface];
}

- (void)initializeDataSource {
	
}

- (void)initializeUserInterface {
	[self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.edges.mas_equalTo(UIEdgeInsetsZero);
	}];
	__weak HTWrongRecordReuseController *weakSelf = self;
    [self.tableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
        [sectionMaker.cellClass([HTMineRecordCell class])
		 .rowHeight(90) didSelectedCellBlock:^(UITableView *tableView, NSInteger row, __kindof UITableViewCell *cell, __kindof HTRecordExerciseModel *model) {
            HTQuestionController *questionController = [[HTQuestionController alloc] init];
            questionController.blockPackage = [[HTQuestionControllerBlocks alloc] initWithQuestionId:model.questionId];
			 questionController.blockPackage.showParseEnable = YES;
			 questionController.blockPackage.defaultDisplayParse = YES;
            [weakSelf.navigationController pushViewController:questionController animated:true];
        }];
    }];
}

@end
