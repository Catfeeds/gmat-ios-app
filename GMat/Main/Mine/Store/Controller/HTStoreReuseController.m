//
//  HTStoreReuseController.m
//  GMat
//
//  Created by hublot on 2017/5/8.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTStoreReuseController.h"
#import "HTStoreCell.h"
#import "HTQuestionManager.h"
#import "HTQuestionController.h"
#import <UIScrollView+HTRefresh.h>

@interface HTStoreReuseController ()

@end

@implementation HTStoreReuseController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initializeDataSource];
	[self initializeUserInterface];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSMutableArray *modelArray = self.pageModel.modelArray;
    NSString *lastSelectedRowString = self.pageModel.lastSelectedRowString;
    if (lastSelectedRowString.length && lastSelectedRowString.integerValue < modelArray.count) {
        NSInteger selectedRow = lastSelectedRowString.integerValue;
        HTStoreModel *storeModel = modelArray[selectedRow];
        if (![HTQuestionManager isStoredWithQuestionId:storeModel.questionid]) {
			[modelArray removeObjectAtIndex:selectedRow];
			[self.tableView reloadData];
        }
    }
}

- (void)setPageModel:(HTPageModel *)pageModel {
	pageModel.lastSelectedRowString = nil;
	[super setPageModel:pageModel];
}

- (void)initializeDataSource {
	
}

- (void)initializeUserInterface {
	
	[self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.edges.mas_equalTo(UIEdgeInsetsZero);
	}];
	
	__weak HTStoreReuseController *weakSelf = self;
	[self.tableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
		[[sectionMaker.cellClass([HTStoreCell class])
		  .rowHeight(70) deleteCellBlock:^(UITableView *tableView, NSInteger row, __kindof UITableViewCell *cell, __kindof NSObject *model) {
			NSMutableArray *modelArray = weakSelf.pageModel.modelArray;
			[HTQuestionManager switchStoreStateWithQuestionId:[modelArray[row] questionid]];
			[modelArray removeObjectAtIndex:row];
		}] didSelectedCellBlock:^(UITableView *tableView, NSInteger row, __kindof UITableViewCell *cell, __kindof HTStoreModel *model) {
			weakSelf.pageModel.lastSelectedRowString = [NSString stringWithFormat:@"%ld", row];
			HTQuestionController *questionController = [[HTQuestionController alloc] init];
			questionController.blockPackage = [[HTQuestionControllerBlocks alloc] initWithQuestionId:model.questionid];
			questionController.blockPackage.showParseEnable = YES;
			questionController.blockPackage.defaultDisplayParse = YES;
			[weakSelf.navigationController pushViewController:questionController animated:true];
		}].deleteTitle(@"取消收藏");
	}];
}

@end
