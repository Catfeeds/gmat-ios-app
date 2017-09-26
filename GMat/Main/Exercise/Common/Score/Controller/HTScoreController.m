//
//  HTScoreController.m
//  GMat
//
//  Created by hublot on 2016/11/11.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTScoreController.h"
#import <UITableView+HTSeparate.h>
#import "THExerciseReadWaterHeaderView.h"
#import "THExerciseWriteResultCell.h"
#import "HTScoreDetailContentController.h"
#import "HTQuestionController.h"
#import "THShareView.h"
#import "NSString+HTString.h"
#import "RTRootNavigationController.h"
#import <UIScrollView+HTRefresh.h>

@interface HTScoreController ()

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) THExerciseReadWaterHeaderView *headerView;

@property (nonatomic, copy) NSString *scoreRequestAddress;

@property (nonatomic, strong) NSDictionary *scoreRequestParameter;

@property (nonatomic, strong) HTScoreModel *(^scoreModelBlock)(id response);

@property (nonatomic, strong) HTScoreModel *scoreModel;

@end

@implementation HTScoreController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initializeDataSource];
	[self initializeUserInterface];
}

- (void)initializeDataSource {
	__weak HTScoreController *weakSelf = self;
	[self.tableView ht_setRefreshBlock:^(NSString *pageSize, NSString *currentPage) {
		void(^requestScoreModelStatus)(HTScoreModel *scoreModel, HTError *errorModel) = ^(HTScoreModel *scoreModel, HTError *errorModel) {
			if (errorModel.existError) {
				[weakSelf.tableView ht_endRefreshWithModelArrayCount:errorModel.errorType];
				return;
			}
			[weakSelf.tableView ht_endRefreshWithModelArrayCount:1];
			weakSelf.scoreModel = scoreModel;
			[weakSelf.headerView setModel:weakSelf.scoreModel row:0];
			weakSelf.tableView.tableHeaderView = weakSelf.headerView;
		};
		weakSelf.requestScoreModelBlock(requestScoreModelStatus);
	}];
	[self.tableView ht_startRefreshHeader];
}

- (void)initializeUserInterface {
	self.automaticallyAdjustsScrollViewInsets = false;
	self.navigationItem.title = @"答题结果";
	[self.view addSubview:self.tableView];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    __weak HTScoreController *weakSelf = self;
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[[UIImage imageNamed:@"Toeflshare"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] style:UIBarButtonItemStylePlain handler:^(id sender) {
		if (!weakSelf.scoreModel) {
			[HTAlert title:@"还没有获取到题目呢"];
			return;
		}
		UIImage *shotScreentImage = [UIImage ht_shotScreen];
		[THShareView showTitle:@"答题结果" detail:@"我在雷哥 GMAT 的答题结果" image:shotScreentImage url:GmatResourse(@"") type:SSDKContentTypeImage];
	}];
	self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
}

- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc] init];
		_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		_tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
		_tableView.scrollIndicatorInsets = _tableView.contentInset;
        __weak HTScoreController *weakSelf = self;
        [_tableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
            [sectionMaker.cellClass([THExerciseWriteResultCell class])
			 .modelArray(@[@"查看详情", @"重新做题"])
			 .rowHeight(60) didSelectedCellBlock:^(UITableView *tableView, NSInteger row, UITableViewCell *cell, id model) {
                if (row == 0) {
                    void(^requestDetailModelStatus)(NSArray <HTQuestionModel *> *questionModelArray) = ^(NSArray <HTQuestionModel *> *questionModelArray) {
                        HTScoreDetailContentController *detailContentController = [[HTScoreDetailContentController alloc] init];
                        detailContentController.questionModelArray = questionModelArray;
                        [weakSelf.navigationController pushViewController:detailContentController animated:true];
                    };
                    weakSelf.requestDetailModelBlock(weakSelf.scoreModel, requestDetailModelStatus);
                } else {
                    [HTAlert title:@"警告" message:@"重新做题之后, 之前的记录会被清除" sureAction:^{
                        void(^clearQuestionGroupStatus)(NSString *errorString) = ^(NSString *errorString) {
                            HTQuestionController *questionController = [[HTQuestionController alloc] init];
                            questionController.blockPackage = weakSelf.blockPacket;
                            UINavigationController *naviagationController = weakSelf.rt_navigationController;
                            [naviagationController popViewControllerAnimated:false];
                            [naviagationController pushViewController:questionController animated:true];
                        };
                        weakSelf.clearQuestoinGroupBlock(clearQuestionGroupStatus);
                    }];
                }
            }];
        }];
	}
	return _tableView;
}

- (THExerciseReadWaterHeaderView *)headerView {
	if (!_headerView) {
		_headerView = [[THExerciseReadWaterHeaderView alloc] initWithFrame:CGRectMake(0, 0, 0, 300)];
	}
	return _headerView;
}

@end
