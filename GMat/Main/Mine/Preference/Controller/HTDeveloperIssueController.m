//
//  HTDeveloperIssueController.m
//  GMat
//
//  Created by hublot on 2017/10/12.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTDeveloperIssueController.h"
#import <NSObject+HTTableRowHeight.h>
#import <UITableView+HTSeparate.h>
#import "UIScrollView+HTRefresh.h"
#import "HTNetworkSaveToBmob.h"
#import "NSString+HTString.h"

@interface HTDeveloperIssueController ()

@property (nonatomic, strong) UITableView *tableView;

@end


@implementation HTDeveloperIssueController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initializeDataSource];
	[self initializeUserInterface];
}

- (void)initializeDataSource {
	__weak typeof(self) weakSelf = self;
	[self.tableView ht_setRefreshBlock:^(NSString *pageSize, NSString *currentPage) {
		[HTNetworkSaveToBmob requestUserSuggestionModelArrayComplete:^(NSArray *suggesstionModelArray) {
			[weakSelf.tableView ht_endRefreshWithModelArrayCount:suggesstionModelArray.count];
			[weakSelf.tableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
				sectionMaker.modelArray(suggesstionModelArray);
			}];
		}];
	}];
	[self.tableView ht_startRefreshHeader];
}

- (void)initializeUserInterface {
	self.navigationItem.title = @"用户反馈";
	[self.view addSubview:self.tableView];
}

- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
		[_tableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
			[[sectionMaker customCellBlock:^(UITableView *tableView, NSInteger row, __kindof UITableViewCell *cell, __kindof NSObject *model) {
				NSString *contactWay = [model objectForKey:@"contactWay"];
				if (!contactWay.length) {
					contactWay = @"匿名";
				}
				NSString *suggestionMessage = [model objectForKey:@"suggestionMessage"];
				
				UILabel *titleNameLabel = [cell viewWithTag:101];
				UILabel *detailNameLabel = [cell viewWithTag:102];
				if (!titleNameLabel) {
					titleNameLabel = [[UILabel alloc] init];
					titleNameLabel.font = [UIFont systemFontOfSize:14];
					titleNameLabel.textColor = [UIColor orangeColor];
					titleNameLabel.tag = 101;
					[cell addSubview:titleNameLabel];
					[titleNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
						make.left.mas_equalTo(cell).offset(15);
						make.top.mas_equalTo(cell).offset(10);
						make.right.mas_equalTo(cell).offset(- 15);
						make.height.mas_equalTo(17);
					}];
				}
				if (!detailNameLabel) {
					detailNameLabel = [[UILabel alloc] init];
					detailNameLabel.font = [UIFont systemFontOfSize:14];
					detailNameLabel.textColor = [UIColor ht_colorStyle:HTColorStylePrimaryTitle];
					detailNameLabel.numberOfLines = 0;
					detailNameLabel.tag = 102;
					[cell addSubview:detailNameLabel];
					[detailNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
						make.top.mas_equalTo(titleNameLabel.mas_bottom).offset(15);
						make.left.mas_equalTo(titleNameLabel);
						make.right.mas_equalTo(titleNameLabel);
					}];
				}
				
				titleNameLabel.text = contactWay;
				detailNameLabel.text = suggestionMessage;
				CGFloat modelHeight = [detailNameLabel.text ht_stringHeightWithWidth:HTSCREENWIDTH - 30 font:detailNameLabel.font textView:nil] + 10 + 15 + 17 + 10;
				[model ht_setRowHeightNumber:@(modelHeight) forCellClass:cell.class];
			}] didSelectedCellBlock:^(UITableView *tableView, NSInteger row, __kindof UITableViewCell *cell, __kindof NSObject *model) {
				
			}];
		}];
	}
	return _tableView;
}

@end

