//
//  HTDownloadProgressController.m
//  GMat
//
//  Created by hublot on 2017/6/28.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTDownloadProgressController.h"
#import <UITableView+HTSeparate.h>
#import <UIScrollView+HTRefresh.h>
#import "HTDownloadSectionHeaderView.h"
#import "HTFileDownloadModel.h"
#import "HTDownloadProgressCell.h"
#import "HTFileDownloadManager.h"
#import "HTPreviewController.h"
#import <QuickLook/QuickLook.h>

@interface HTDownloadProgressController ()

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray <HTFileDownloadModel *> *downloadCompleteModelArray;

@end

@implementation HTDownloadProgressController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initializeDataSource];
	[self initializeUserInterface];
}

- (void)initializeDataSource {
	__weak typeof(self) weakSelf = self;
	[self.tableView ht_setRefreshBlock:^(NSString *pageSize, NSString *currentPage) {
		NSArray *downloadingModelArray = [HTFileDownloadManager packDownloadingModelArray];
        for (HTFileDownloadModel *model in downloadingModelArray) {
            [model setDownloadComplete:^{
                [weakSelf.tableView ht_startRefreshHeader];
            }];
        }
        weakSelf.downloadCompleteModelArray = [HTFileDownloadManager packDownloadCompleteModelArray];
        BOOL hiddenHeader = !downloadingModelArray.count && !weakSelf.downloadCompleteModelArray.count;
		[weakSelf.tableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
            sectionMaker.modelArray(downloadingModelArray).headerHeight(hiddenHeader ? 0 : 35);
		}];
		[weakSelf.tableView ht_updateSection:1 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
			sectionMaker.modelArray(weakSelf.downloadCompleteModelArray).headerHeight(hiddenHeader ? 0 : 35);
		}];
        if (hiddenHeader) {
            [weakSelf.tableView ht_endRefreshWithModelArrayCount:0];
        } else {
            [weakSelf.tableView ht_endRefreshWithModelArrayCount:1];
        }
	}];
	[self.tableView ht_startRefreshHeader];
}

- (void)initializeUserInterface {
	[self.view addSubview:self.tableView];
	self.navigationItem.title = @"文件列表";
}

- (void)deleteFileModel:(HTFileDownloadModel *)fileModel {
	[HTFileDownloadManager deleteDownloadFileUrlSaveFileName:fileModel.fileTitleName];
	[self.tableView ht_startRefreshHeader];
}

- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
		_tableView.backgroundColor = [UIColor ht_colorStyle:HTColorStyleCompareBackground];
		_tableView.separatorColor = _tableView.backgroundColor;
		
		__weak typeof(self) weakSelf = self;
		[_tableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
			[[sectionMaker.cellClass([HTDownloadProgressCell class]).rowHeight(80).headerClass([HTDownloadSectionHeaderView class]) didSelectedCellBlock:^(UITableView *tableView, NSInteger row, __kindof HTDownloadProgressCell *cell, __kindof NSObject *model) {
				
			}] deleteCellBlock:^(UITableView *tableView, NSInteger row, __kindof UITableViewCell *cell, __kindof HTFileDownloadModel *model) {
				[weakSelf deleteFileModel:model];
			}];
		}];
		[_tableView ht_updateSection:1 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
			[[sectionMaker.cellClass([HTDownloadProgressCell class]).rowHeight(80).headerClass([HTDownloadSectionHeaderView class]) didSelectedCellBlock:^(UITableView *tableView, NSInteger row, __kindof HTDownloadProgressCell *cell, __kindof HTFileDownloadModel *model) {
				NSMutableArray *filePathArray = [@[] mutableCopy];
				for (HTFileDownloadModel *model in weakSelf.downloadCompleteModelArray) {
					NSString *filePath = [HTFileDownloadManager filePathWithSaveFileName:model.fileTitleName];
					if (filePath.length) {
						[filePathArray addObject:filePath];
					}
				}
				HTPreviewController *previewController = [[HTPreviewController alloc] init];
				previewController.filePathArray = filePathArray;
				previewController.currentIndex = row;
				[weakSelf.navigationController presentViewController:previewController animated:true completion:nil];
			}] deleteCellBlock:^(UITableView *tableView, NSInteger row, __kindof UITableViewCell *cell, __kindof HTFileDownloadModel *model) {
				[weakSelf deleteFileModel:model];
			}];
		}];
	}
	return _tableView;
}

@end
