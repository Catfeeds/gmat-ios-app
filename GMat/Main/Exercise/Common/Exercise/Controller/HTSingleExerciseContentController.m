//
//  HTSingleExerciseContentController.m
//  GMat
//
//  Created by hublot on 2016/10/31.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTSingleExerciseContentController.h"
#import <UITableView+HTSeparate.h>
#import "HTExerciseCell.h"
#import "HTQuestionController.h"
#import "HTExerciseModel.h"
#import "HTScoreController.h"
#import "HTQuestionMockStartController.h"
#import "HTQuestionMockSleepController.h"
#import "HTPointExerciseKnowsController.h"
#import "NSString+HTString.h"
#import "HTQuestionControllerBlocks.h"

@interface HTSingleExerciseContentController ()

@end

@implementation HTSingleExerciseContentController

- (void)dealloc {
	
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initializeDataSource];
	[self initializeUserInterface];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	NSMutableArray *modelArray = self.pageModel.modelArray;
	NSString *lastSelectedRowString = self.pageModel.lastSelectedRowString;
	if (lastSelectedRowString.length && lastSelectedRowString.integerValue < modelArray.count) {
		NSInteger selectedRow = lastSelectedRowString.integerValue;
		[self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:selectedRow inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
	}
}

- (void)setPageModel:(HTPageModel *)pageModel {
	pageModel.lastSelectedRowString = nil;
	[super setPageModel:pageModel];
}

- (void)initializeDataSource {
	
}

- (void)didSelectedExerciseCell:(HTExerciseCell *)cell row:(NSInteger)row model:(HTExerciseModel *)model normalLookScore:(BOOL)normalLookScore {
	self.pageModel.lastSelectedRowString = [NSString stringWithFormat:@"%ld", row];
	HTQuestionController *questionController;
	HTQuestionControllerBlocks *questionControllerBlocks;
	HTScoreController *scoreController;
	HTPointExerciseKnowsController *konwsController;
	switch (model.modelStyle) {
		case HTExerciseModelStyleSort: {
			questionControllerBlocks = [[HTQuestionControllerBlocks alloc] initWithNavigationControllerToPushQuestionController:self.navigationController exerciseModel:model];
			if (normalLookScore && model.userlowertk.integerValue < model.lowertknumb) {
				questionController = [[HTQuestionController alloc] init];
				questionController.blockPackage = questionControllerBlocks;
			} else {
				scoreController = [HTQuestionControllerBlocks scoreControllerWithExerciseModel:model];
				scoreController.blockPacket = questionControllerBlocks;
			}
			break;
		}
		case HTExerciseModelStyleSingle: {
			questionControllerBlocks = [[HTQuestionControllerBlocks alloc] initWithNavigationControllerToPushQuestionController:self.navigationController exerciseModel:model];
			if (normalLookScore && model.userlowertk.integerValue < model.lowertknumb) {
				questionController = [[HTQuestionController alloc] init];
				questionController.blockPackage = questionControllerBlocks;
			} else {
				scoreController = [HTQuestionControllerBlocks scoreControllerWithExerciseModel:model];
				scoreController.blockPacket = questionControllerBlocks;
			}
			break;
		}
		case HTExerciseModelStylePoint:
			konwsController = [[HTPointExerciseKnowsController alloc] init];
			konwsController.navigationItem.title = model.knows;
			konwsController.knowsIdString = model.knowsid;
			break;
		case HTExerciseModelStyleHardly: {
			questionControllerBlocks = [[HTQuestionControllerBlocks alloc] initWithNavigationControllerToPushQuestionController:self.navigationController exerciseModel:model];
			if (normalLookScore && model.userlowertk.integerValue < model.lowertknumb) {
				questionController = [[HTQuestionController alloc] init];
				questionController.blockPackage = questionControllerBlocks;
			} else {
				scoreController = [HTQuestionControllerBlocks scoreControllerWithExerciseModel:model];
				scoreController.blockPacket = questionControllerBlocks;
			}
		}
			break;
		case HTExerciseModelStyleMock: {
			questionControllerBlocks = [[HTQuestionControllerBlocks alloc] initWithNavigationControllerToPushMockQuestionController:self.navigationController exerciseModel:model];
			
			if (model.markquestion.integerValue == 2) {
				scoreController = [HTQuestionControllerBlocks scoreControllerWithMockExerciseModel:model];
				scoreController.blockPacket = questionControllerBlocks;
			} else {
				questionController = [[HTQuestionController alloc] init];
				questionController.blockPackage = questionControllerBlocks;
			}
		}
			break;
	}
	[self.navigationController pushViewController:questionController.blockPackage ? questionController : ((scoreController && scoreController.blockPacket) ? scoreController : konwsController) animated:true];
}

- (void)initializeUserInterface {
	__weak HTSingleExerciseContentController *weakSelf = self;
    self.tableView.backgroundColor = [UIColor ht_colorString:@"f3f3f3"];
    self.tableView.separatorColor = self.tableView.backgroundColor;
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
	[self.tableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
		[[sectionMaker.cellClass([HTExerciseCell class])
		 .rowHeight(HTADAPT568(70)) didSelectedCellBlock:^(UITableView *tableView, NSInteger row, __kindof UITableViewCell *cell, __kindof HTExerciseModel *model) {
			 [weakSelf didSelectedExerciseCell:cell row:row model:model normalLookScore:true];
		}] customCellBlock:^(UITableView *tableView, NSInteger row, __kindof HTExerciseCell *cell, __kindof HTExerciseModel *model) {
			__weak HTExerciseCell *weakCell = cell;
			[cell.secondExerciseButton ht_whenTap:^(UIView *view) {
				[weakSelf didSelectedExerciseCell:weakCell row:row model:model normalLookScore:false];
			}];
		}];
	}];
}

@end
