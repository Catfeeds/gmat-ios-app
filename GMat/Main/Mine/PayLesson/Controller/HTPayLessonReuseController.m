//
//  HTPayLessonReuseController.m
//  GMat
//
//  Created by hublot on 2016/11/4.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTPayLessonReuseController.h"
#import "HTPayLessonCell.h"
#import "HTOnlineDetailController.h"
#import "HTCourseDetailController.h"
#import "HTCourseOnlineVideoModel.h"

@interface HTPayLessonReuseController ()

@end

@implementation HTPayLessonReuseController

- (void)dealloc {
    
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initializeDataSource];
	[self initializeUserInterface];
}

- (void)initializeDataSource {
	
}

- (void)initializeUserInterface {
	__weak HTPayLessonReuseController *weakSelf = self;
	UILabel *titleNameLabel = (UILabel *)self.tableView.nothingPlaceholder;
	titleNameLabel.text = @"请在电脑端个人中心课程记录查看";
    [self.tableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
        [sectionMaker.cellClass([HTPayLessonCell class])
		 .rowHeight(HTADAPT568(80)) didSelectedCellBlock:^(UITableView *tableView, NSInteger row, __kindof UITableViewCell *cell, __kindof HTCourseOnlineVideoModel *model) {
            if ([model.contentcatid isEqualToString:@"2"]) {
                HTCourseDetailController *detailController = [[HTCourseDetailController alloc] init];
                detailController.courseModel = nil;
                //				[weakSelf.navigationController pushViewController:detailController animated:true];
            } else {
                HTOnlineDetailController *detailController = [[HTOnlineDetailController alloc] init];
                detailController.courseModel = model;
                [weakSelf.navigationController pushViewController:detailController animated:true];
            }
        }];
    }];
}
@end
