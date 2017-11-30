//
//  HTLeftController.m
//  GMat
//
//  Created by hublot on 16/10/12.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTLeftController.h"
#import <UITableView+HTSeparate.h>
#import "HTLeftModel.h"
#import "HTLeftCell.h"
#import "HTManagerController.h"
#import "HTLoginManager.h"

@interface HTLeftController ()

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation HTLeftController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initializeDataSource];
	[self initializeUserInterface];
}

- (void)initializeDataSource {
	
}

- (void)initializeUserInterface {
	self.view.backgroundColor = [UIColor ht_colorString:@"333436"];
	[self.view addSubview:self.tableView];
}

- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (self.view.ht_h - HTADAPT568(40) * 4) / 2, self.view.ht_w, HTADAPT568(40) * 4)];
		_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		_tableView.backgroundColor = [UIColor clearColor];
        
        [_tableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
            [sectionMaker.cellClass([HTLeftCell class])
			 .modelArray([HTLeftModel packModelArray])
			 .rowHeight(HTADAPT568(40)) didSelectedCellBlock:^(UITableView *tableView, NSInteger row, __kindof UITableViewCell *cell, __kindof HTLeftModel *model) {
                [[HTManagerController defaultManagerController].drawerController switchDrawerState];
                UIViewController *viewController = [[model.controllerClass alloc] init];
                UINavigationController *navigationController = (UINavigationController *)[HTManagerController defaultManagerController].drawerController.tabBarController.selectedViewController;
                [navigationController pushViewController:viewController animated:true];
            }];
        }];
	}
	return _tableView;
}


@end
