//
//  HTDiscoverInformationController.m
//  GMat
//
//  Created by hublot on 2017/6/28.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTDiscoverInformationController.h"
#import <UIScrollView+HTRefresh.h>
#import "THToeflDiscoverTableCell.h"
#import "HTDiscoverDownloadCell.h"
#import "THToeflDiscoverDetailController.h"
#import "THToeflDiscoverController.h"
#import <UITableViewCell_HTSeparate.h>

@interface HTDiscoverInformationController ()

@end

@implementation HTDiscoverInformationController

@synthesize tableView = _tableView;

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initializeDataSource];
	[self initializeUserInterface];
}

- (void)initializeDataSource {
	
}

- (void)initializeUserInterface {
	
}

- (void)didSelectedTableView:(UITableView *)tableView cell:(UITableViewCell *)cell row:(NSInteger)row model:(id)model {
	THToeflDiscoverDetailController *detailController = [[THToeflDiscoverDetailController alloc] init];
	detailController.discoverId = [model id];
	[detailController setDetailDidDismissBlock:^(THToeflDiscoverModel *detailModel) {
		[self.pageModel.modelArray replaceObjectAtIndex:row withObject:detailModel];
		[[[NSOperationQueue alloc] init] addOperationWithBlock:^{
			[detailModel creatDetailAttributedString];
			[[NSOperationQueue mainQueue] addOperationWithBlock:^{
				[cell setModel:detailModel row:row];
			}];
		}];
	}];
	[self.navigationController pushViewController:detailController animated:true];
}

- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.ht_w, [UIScreen mainScreen].bounds.size.height - 64 - 49 - 44)];
		_tableView.backgroundColor = [UIColor ht_colorStyle:HTColorStyleCompareBackground];
		_tableView.ht_pageSize = 20;
		_tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
		
		__weak typeof(self) weakSelf = self;
		[_tableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
            [[sectionMaker.cellClass([HTDiscoverDownloadCell class]).rowHeight(80) didSelectedCellBlock:^(UITableView *tableView, NSInteger row, __kindof UITableViewCell *cell, __kindof NSObject *model) {
                [weakSelf didSelectedTableView:tableView cell:cell row:row model:model];
            }] didScrollBlock:^(UIScrollView *scrollView, CGPoint contentOffSet, UIEdgeInsets contentInSet) {
                if (weakSelf.didScrollBlock) {
                    weakSelf.didScrollBlock(weakSelf.tableView);
                }
            }];
		}];
	}
	return _tableView;
}

@end
