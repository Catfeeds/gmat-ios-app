//
//  HTPointExerciseKnowsController.m
//  GMat
//
//  Created by hublot on 2016/11/29.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTPointExerciseKnowsController.h"
#import <UITableView+HTSeparate.h>
#import "UIScrollView+HTRefresh.h"
#import "HTPointExerciseDetailModel.h"
#import "HTQuestionController.h"
#import "HTPointExerciseDetailCell.h"
#import "HTQuestionManager.h"
#import "UITableViewCell_HTSeparate.h"

@interface HTPointExerciseKnowsController ()

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *modelArray;

@property (nonatomic, strong) HTExerciseModel *selectedExerciseModel;

@end

@implementation HTPointExerciseKnowsController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initializeDataSource];
	[self initializeUserInterface];
}

- (void)initializeDataSource {
    __weak HTPointExerciseKnowsController *weakSelf = self;
	[self.tableView ht_setRefreshBlock:^(NSString *pageSize, NSString *currentPage) {
        NSMutableArray *modelArray = [HTQuestionManager packExerciseModelArrayWithKnowsid:weakSelf.knowsIdString];
		weakSelf.modelArray = modelArray;
        [weakSelf.tableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
            sectionMaker.modelArray(weakSelf.modelArray);
        }];
        [weakSelf.tableView ht_endRefreshWithModelArrayCount:modelArray.count];
	}];
	[self.tableView ht_startRefreshHeader];
}

- (void)initializeUserInterface {
	[self.view addSubview:self.tableView];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.selectedExerciseModel && [self.modelArray containsObject:self.selectedExerciseModel]) {
        NSInteger selectedRow = [self.modelArray indexOfObject:self.selectedExerciseModel];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedRow inSection:0]];
        if (cell) {
            [cell setModel:self.selectedExerciseModel row:selectedRow];
        }
    }
}

- (void)didSelectedExerciseCell:(HTPointExerciseDetailCell *)cell row:(NSInteger)row model:(HTExerciseModel *)model normalLookScore:(BOOL)normalLookScore {
	HTQuestionController *questionController;
	HTQuestionControllerBlocks *questionControllerBlocks;
	HTScoreController *scoreController;
	questionControllerBlocks = [[HTQuestionControllerBlocks alloc] initWithNavigationControllerToPushQuestionController:self.navigationController exerciseModel:model];
	self.selectedExerciseModel = model;
	if (normalLookScore && model.userlowertk.integerValue < model.lowertknumb) {
		questionController = [[HTQuestionController alloc] init];
		questionController.blockPackage = questionControllerBlocks;
		[self.navigationController pushViewController:questionController animated:true];
	} else {
		scoreController = [HTQuestionControllerBlocks scoreControllerWithExerciseModel:model];
		scoreController.blockPacket = questionControllerBlocks;
		[self.navigationController pushViewController:scoreController animated:true];
	}
}

- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
		_tableView.backgroundColor = [UIColor ht_colorStyle:HTColorStyleCompareBackground];
		_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		_tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 15)];
        __weak HTPointExerciseKnowsController *weakSelf = self;
        
        [_tableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
            [[sectionMaker.cellClass([HTPointExerciseDetailCell class])
			 .rowHeight(HTADAPT568(110)) customCellBlock:^(UITableView *tableView, NSInteger row, __kindof HTPointExerciseDetailCell *cell, __kindof NSObject *model) {
				 __weak HTPointExerciseDetailCell *weakCell = cell;
				[cell.lookScoreButton ht_whenTap:^(UIView *view) {
					[weakSelf didSelectedExerciseCell:weakCell row:row model:model normalLookScore:false];
				}];
			 }] didSelectedCellBlock:^(UITableView *tableView, NSInteger row, __kindof UITableViewCell *cell, __kindof HTExerciseModel *model) {
				[weakSelf didSelectedExerciseCell:cell row:row model:model normalLookScore:true];
            }];
        }];
	}
	return _tableView;
}


@end
