//
//  HTKnowledgeCategoryController.m
//  GMat
//
//  Created by hublot on 16/10/12.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTKnowledgeCategoryController.h"
#import <UITableView+HTSeparate.h>
#import "HTKnowledgeCategoryCell.h"
#import "HTKnowledgeSubjectController.h"
#import "HTManagerController+HTRotate.h"

@interface HTKnowledgeCategoryController () <HTRotateEveryOne, HTRotateVisible>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation HTKnowledgeCategoryController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initializeDataSource];
	[self initializeUserInterface];
}

- (void)initializeDataSource {
	
}

- (void)initializeUserInterface {
	self.navigationItem.title = self.knowledgeModel.catname;
	self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 15)];
	[self.view addSubview:self.tableView];
	[self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.edges.mas_equalTo(UIEdgeInsetsZero);
	}];
}

- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc] init];
		_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		_tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForAuxiliaryExecutable:@"Knowledge1@2x.png"]]];
        __weak HTKnowledgeCategoryController *weakSelf = self;
        
        [_tableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
            [sectionMaker.cellClass([HTKnowledgeCategoryCell class])
			 .rowHeight(45)
			 .modelArray(self.knowledgeModel.categoryType) didSelectedCellBlock:^(UITableView *tableView, NSInteger row, __kindof UITableViewCell *cell, __kindof NSObject *model) {
                HTKnowledgeSubjectController *subjectController = [[HTKnowledgeSubjectController alloc] init];
                subjectController.categoryModel = model;
                [weakSelf.navigationController pushViewController:subjectController animated:true];
            }];
        }];
	}
	return _tableView;
}


@end
