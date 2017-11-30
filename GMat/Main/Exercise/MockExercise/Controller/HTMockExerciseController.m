//
//  HTMockExerciseController.m
//  GMat
//
//  Created by hublot on 2016/10/18.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTMockExerciseController.h"
#import <UITableView+HTSeparate.h>
#import "HTMockExerciseModel.h"
#import "HTMockExerciseCell.h"
#import "HTMockExerciseSectionController.h"
#import "HTManagerController+HTRotate.h"

@interface HTMockExerciseController () <HTRotateVisible, HTRotateEveryOne>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *modelArray;

@end

@implementation HTMockExerciseController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initializeDataSource];
	[self initializeUserInterface];
}

- (void)initializeDataSource {
	
}

- (void)initializeUserInterface {
	self.navigationItem.title = @"仿真模考";
	[self.view addSubview:self.tableView];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
	UIImage *backgroundImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForAuxiliaryExecutable:@"Exercise11@2x.png"]];
	backgroundImage = [backgroundImage ht_croppedAtRect:CGRectInset(CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height), 5, 5)];
	UIImageView *imageView = [[UIImageView alloc] initWithImage:backgroundImage];
	self.tableView.backgroundView = imageView;
}

- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc] init];
		_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        __weak HTMockExerciseController *weakSelf = self;
        
        CGFloat height = MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        [_tableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
            [[sectionMaker.cellClass([HTMockExerciseCell class])
			  .modelArray(weakSelf.modelArray)
			  .rowHeight((height - 64 - 30) / weakSelf.modelArray.count) customCellBlock:^(UITableView *tableView, NSInteger row, __kindof HTMockExerciseCell *cell, __kindof HTMockExerciseModel *model) {
                [cell.startButton ht_whenTap:^(UIView *view) {
                    HTMockExerciseSectionController *sectionController = [[HTMockExerciseSectionController alloc] init];
                    sectionController.mockStyle = row;
                    sectionController.mockExerciseString = model.titleName;
                    [weakSelf.navigationController pushViewController:sectionController animated:true];
                }];
            }] didSelectedCellBlock:^(UITableView *tableView, NSInteger row, __kindof HTMockExerciseCell *cell, __kindof HTMockExerciseModel *model) {
                HTMockExerciseSectionController *sectionController = [[HTMockExerciseSectionController alloc] init];
                sectionController.mockStyle = row;
                sectionController.mockExerciseString = model.titleName;
                [weakSelf.navigationController pushViewController:sectionController animated:true];
            }];
        }];
	}
	return _tableView;
}

- (NSArray *)modelArray {
	if (!_modelArray) {
		_modelArray = [HTMockExerciseModel packModelArray];
	}
	return _modelArray;
}

@end
