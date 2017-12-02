//
//  HTKnowledgeSubjectController.m
//  GMat
//
//  Created by hublot on 16/10/12.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTKnowledgeSubjectController.h"
#import "HTKnowledgeSubjectCell.h"
#import <UITableView+HTSeparate.h>
#import "HTKnowledgeDetailController.h"
#import "HTSchoolRoomDetailController.h"

@interface HTKnowledgeSubjectController ()

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation HTKnowledgeSubjectController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initializeDataSource];
	[self initializeUserInterface];
}

- (void)initializeDataSource {
	
}

- (void)initializeUserInterface {
	self.navigationItem.title = self.categoryModel.catname;
	[self.view addSubview:self.tableView];
	[self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.edges.mas_equalTo(UIEdgeInsetsZero);
	}];
}

- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc] init];
		_tableView.backgroundColor = [UIColor ht_colorStyle:HTColorStyleCompareBackground];
        __weak HTKnowledgeSubjectController *weakSelf = self;
        
        [_tableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
            [sectionMaker.cellClass([HTKnowledgeSubjectCell class])
			 .rowHeight(45)
			 .modelArray(self.categoryModel.categoryContent) didSelectedCellBlock:^(UITableView *tableView, NSInteger row, __kindof UITableViewCell *cell, __kindof NSObject *model) {
               // HTKnowledgeDetailController *detailController = [[HTKnowledgeDetailController alloc] init];
				 HTSchoolRoomDetailController *detailController = STORYBOARD_VIEWCONTROLLER(@"Schoolroom", @"HTSchoolRoomDetailController")
                detailController.detailModel = model;
                [weakSelf.navigationController pushViewController:detailController animated:true];
            }];
        }];
	}
	return _tableView;
}


@end
