//
//  HTSearchListController.m
//  GMat
//
//  Created by hublot on 2017/3/29.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTSearchListController.h"
#import "HTQuestionManager.h"
#import "HTQuestionController.h"
#import <UITableView+HTSeparate.h>
#import "HTSearchController.h"
#import "HTRootNavigationController.h"
#import <NSString+HTString.h>
#import <NSMutableAttributedString+HTMutableAttributedString.h>

@interface HTSearchListController ()

@property (nonatomic, copy) NSString *searchText;

@end

@implementation HTSearchListController

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
	[self.view addSubview:self.tableView];
}

- (void)updateSearchResultsForSearchController:(HTSearchController *)searchController {
	self.searchText = searchController.searchBar.text;
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(searchResultsFromQuestionManager) object:nil];
	[self performSelector:@selector(searchResultsFromQuestionManager) withObject:nil afterDelay:0.4];
}

- (void)searchResultsFromQuestionManager {
	NSString *searchText = self.searchText;
	searchText = [searchText stringByReplacingOccurrencesOfString:@"/n" withString:@"\n"];
	[HTQuestionManager searchWithKeyword:searchText pageNumber:@"1" pageSize:@"10" complete:^(NSArray<HTQuestionModel *> *searchQuestionModelArray) {
		self.tableView.separatorStyle = searchQuestionModelArray.count ? UITableViewCellSeparatorStyleSingleLine : UITableViewCellSeparatorStyleNone;
		[self.tableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
			sectionMaker.modelArray(searchQuestionModelArray);
		}];
	}];
}

- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
		_tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
		_tableView.backgroundColor = [UIColor clearColor];
		_tableView.separatorColor = [UIColor colorWithWhite:1 alpha:0.2];
		UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithFrame:self.view.bounds];
		effectView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
		_tableView.backgroundView = effectView;
		
		__weak HTSearchListController *weakSelf = self;
        
        [_tableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
            [[sectionMaker.rowHeight(50) customCellBlock:^(UITableView *tableView, NSInteger row, __kindof UITableViewCell *cell, __kindof HTQuestionModel *model) {
                cell.selectedBackgroundView = [[UIView alloc] init];
                cell.selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.4];
                cell.backgroundColor = [UIColor clearColor];
                cell.textLabel.font = [UIFont systemFontOfSize:14];
                cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
                cell.textLabel.textColor = [UIColor whiteColor];
                cell.detailTextLabel.textColor = [UIColor whiteColor];
                
                NSMutableAttributedString *attributedString = [[[model.plainQuestionTitle ht_htmlDecodeString] ht_attributedStringNeedDispatcher:nil] mutableCopy];
                [attributedString ht_clearBreakLineMaxAllowContinueCount:0];
                cell.textLabel.text = attributedString.string;
                cell.detailTextLabel.text = model.questionId;
            }] didSelectedCellBlock:^(UITableView *tableView, NSInteger row, __kindof UITableViewCell *cell, __kindof HTQuestionModel *model) {
                HTQuestionController *questionController = [[HTQuestionController alloc] init];
                questionController.blockPackage = [[HTQuestionControllerBlocks alloc] initWithSearchQuestionId:model.questionId];
                HTRootNavigationController *navigationController = [[HTRootNavigationController alloc] initWithRootViewController:questionController];
                [weakSelf presentViewController:navigationController animated:true completion:nil];
            }];
        }];
	}
	return _tableView;
}

@end
