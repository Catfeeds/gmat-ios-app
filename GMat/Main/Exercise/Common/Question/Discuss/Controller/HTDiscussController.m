//
//  HTDiscussController.m
//  GMat
//
//  Created by hublot on 2017/8/23.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTDiscussController.h"
#import <UITableView+HTSeparate.h>
#import <UIScrollView+HTRefresh.h>
#import "HTDiscussModel.h"
#import "HTDiscussCell.h"
#import "HTDiscussIssueController.h"
#import "HTCommunityReplyKeyBoardView.h"
#import "HTUserManager.h"

@interface HTDiscussController ()

@property (nonatomic, strong) NSMutableArray *modelArray;

@end

@implementation HTDiscussController

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self.tableView];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initializeDataSource];
	[self initializeUserInterface];
}

- (void)initializeDataSource {
	
	[[NSNotificationCenter defaultCenter] addObserver:self.tableView selector:@selector(reloadData) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
	
	__weak typeof(self) weakSelf = self;
	[self.tableView ht_setRefreshBlock:^(NSString *pageSize, NSString *currentPage) {
		HTNetworkModel *networkModel = [HTNetworkModel modelForOnlyCacheNoInterfaceForScrollViewWithCacheStyle:HTCacheStyleAllUser];
		[HTRequestManager requestQuestionDiscussListWithNetworkModel:networkModel questionIdString:weakSelf.questionIdString pageSize:pageSize currentPage:currentPage complete:^(id response, HTError *errorModel) {
			if (errorModel.existError) {
				[weakSelf.tableView ht_endRefreshWithModelArrayCount:errorModel.errorType];
				return;
			}
			NSMutableArray *modelArray = [HTDiscussModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
			if (currentPage.integerValue <= 1) {
				weakSelf.modelArray = modelArray;
			} else {
				[weakSelf.modelArray addObjectsFromArray:modelArray];
			}
			[weakSelf.tableView ht_endRefreshWithModelArrayCount:modelArray.count];
			[weakSelf.tableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
				sectionMaker.modelArray(weakSelf.modelArray);
			}];
		}];
	}];
	[self.tableView ht_startRefreshHeader];
}

- (void)initializeUserInterface {
	self.navigationItem.title = @"题目讨论";
	[self.view addSubview:self.tableView];
	[self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.edges.mas_equalTo(UIEdgeInsetsZero);
	}];
    
    __weak typeof(self) weakSelf = self;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"参与" style:UIBarButtonItemStylePlain handler:^(id sender) {
        HTDiscussIssueController *issueController = [[HTDiscussIssueController alloc] init];
        issueController.questionIdString = weakSelf.questionIdString;
        [issueController setIssueSuccessBlock:^{
            [weakSelf.tableView ht_startRefreshHeader];
        }];
        [weakSelf.navigationController pushViewController:issueController animated:true];
    }];
}

- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc] init];
		_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		_tableView.backgroundColor = [UIColor ht_colorString:@"f3f3f3"];
        
        __weak typeof(self) weakSelf = self;
		[_tableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
			[sectionMaker.cellClass([HTDiscussCell class]) didSelectedCellBlock:^(UITableView *tableView, NSInteger row, __kindof UITableViewCell *cell, __kindof HTDiscussModel *model) {
                
                NSString *placholder = [NSString stringWithFormat:@"回复%@", HTPlaceholderString(model.nickname, model.username)];
                UIKeyboardAppearance appearance = UIKeyboardAppearanceDark;
                [HTCommunityReplyKeyBoardView showReplyKeyBoardViewPlaceHodler:placholder keyBoardAppearance:appearance completeBlock:^(NSString *replyText) {
                    HTNetworkModel *networkModel = [[HTNetworkModel alloc] init];
                    networkModel.autoAlertString = @"发表回复";
                    networkModel.autoShowError = true;
                    networkModel.offlineCacheStyle = HTCacheStyleNone;
                    [HTRequestManager requestQuestionDiscussCreateWithNetworkModel:networkModel questionIdString:weakSelf.questionIdString discussContentString:replyText willReplyIdString:model.commentid complete:^(id response, HTError *errorModel) {
                        if (errorModel.existError) {
                            return;
                        }
                        [HTAlert title:@"回复成功"];
                        [weakSelf.tableView ht_startRefreshHeader];
                    }];
                }];
            }];
		}];
	}
	return _tableView;
}

@end
