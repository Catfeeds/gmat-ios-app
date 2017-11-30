//
//  HTHardlyExerciseController.m
//  GMat
//
//  Created by hublot on 2016/10/18.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTHardlyExerciseController.h"
#import <UITableView+HTSeparate.h>
#import "HTHardlyExerciseCell.h"
#import "HTHardlySectionController.h"
#import "HTManagerController+HTRotate.h"

@interface HTHardlyExerciseController () <HTRotateVisible, HTRotateEveryOne>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *modelArray;

@end

@implementation HTHardlyExerciseController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initializeDataSource];
	[self initializeUserInterface];
}

- (void)initializeDataSource {
	
}

- (void)initializeUserInterface {
	self.navigationItem.title = @"难度做题";
	[self.view addSubview:self.tableView];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
	UIImage *backgroundImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForAuxiliaryExecutable:@"Exercise12@2x.png"]];
	backgroundImage = [backgroundImage ht_croppedAtRect:CGRectInset(CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height), 5, 5)];
	UIImageView *imageView = [[UIImageView alloc] initWithImage:backgroundImage];
	self.tableView.backgroundView = imageView;
}

- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc] init];
		_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        __weak HTHardlyExerciseController *weakSelf = self;
        
        CGFloat height = MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        [_tableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
            [[sectionMaker.cellClass([HTHardlyExerciseCell class])
			  .rowHeight((height - 64 - 10) / weakSelf.modelArray.count)
			  .modelArray(weakSelf.modelArray) didSelectedCellBlock:^(UITableView *tableView, NSInteger row, __kindof UITableViewCell *cell, __kindof NSObject *model) {
                HTHardlySectionController *sectionController = [[HTHardlySectionController alloc] init];
                sectionController.hardlyString = model;
                sectionController.hardlyIdString = [NSString stringWithFormat:@"%ld", row + 1];
                [weakSelf.navigationController pushViewController:sectionController animated:true];
            }] customCellBlock:^(UITableView *tableView, NSInteger row, __kindof HTHardlyExerciseCell *cell, __kindof NSObject *model) {
                [cell.startButton ht_whenTap:^(UIView *view) {
                    HTHardlySectionController *sectionController = [[HTHardlySectionController alloc] init];
                    sectionController.hardlyString = model;
                    sectionController.hardlyIdString = [NSString stringWithFormat:@"%ld", row + 1];
                    [weakSelf.navigationController pushViewController:sectionController animated:true];
                }];
            }];
        }];
	}
	return _tableView;
}

- (NSArray *)modelArray {
	if (!_modelArray) {
		_modelArray = @[@"600以下", @"600~650", @"650~680", @"680~700", @"700~730", @"730以上"];
	}
	return _modelArray;
}


@end
