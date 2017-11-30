//
//  HTStoryDetailController.m
//  GMat
//
//  Created by hublot on 2017/8/28.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTStoryDetailController.h"
#import "HTImageTextView.h"
#import <UIScrollView+HTRefresh.h>
#import "HTStoryModel.h"
#import "HTStoryDetailHeaderView.h"
#import "HTWebController.h"

@interface HTStoryDetailController ()

@property (nonatomic, strong) HTStoryDetailHeaderView *headerView;

@property (nonatomic, strong) HTImageTextView *textView;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation HTStoryDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDataSource];
    [self initializeUserInterface];
}

- (void)initializeDataSource {
    
    __weak typeof(self) weakSelf = self;
    [self.tableView ht_setRefreshBlock:^(NSString *pageSize, NSString *currentPage) {
        HTNetworkModel *networkModel = [HTNetworkModel modelForOnlyCacheNoInterfaceForScrollViewWithCacheStyle:HTCacheStyleAllUser];
        [HTRequestManager requestStoryDetailWithNetworkModel:networkModel storyIdString:weakSelf.storyIdString complete:^(id response, HTError *errorModel) {
            if (errorModel.existError) {
                [weakSelf.tableView ht_endRefreshWithModelArrayCount:errorModel.errorType];
                return;
            }
            HTStoryModel *storyModel = [HTStoryModel mj_objectWithKeyValues:[response[@"details"] firstObject]];
            [weakSelf.headerView setModel:storyModel];
            weakSelf.tableView.tableHeaderView = weakSelf.headerView;
            [weakSelf.tableView ht_endRefreshWithModelArrayCount:storyModel ? 1 : 0];
			
			
			
            NSMutableAttributedString *attributedString = [[[storyModel.details ht_htmlDecodeString] ht_handleFillPlaceHolderImageWithMaxWidth:HTSCREENWIDTH - 30 placeholderImage:HTPLACEHOLDERIMAGE] mutableCopy];
			[attributedString ht_EnumerateAttribute:NSFontAttributeName usingBlock:^(UIFont *font, NSRange range, BOOL *stop) {
				UIFont *minFont = [UIFont fontWithDescriptor:font.fontDescriptor size:MAX(font.pointSize, 14)];
				[attributedString addAttributes:@{NSFontAttributeName:minFont} range:range];
			}];
            [attributedString ht_clearBreakLineMaxAllowContinueCount:2];
            [attributedString ht_clearPrefixBreakLine];
            [attributedString ht_clearSuffixBreakLine];
			
            [weakSelf.textView setAttributedString:attributedString textViewMaxWidth:HTSCREENWIDTH appendImageBaseURLBlock:^NSString *(UITextView *textView, NSString *imagePath) {
                if (![imagePath containsString:@"http"]) {
                    return GmatResourse(imagePath);
                }
                return imagePath;
            } reloadHeightBlock:^(UITextView *textView, CGFloat contentHeight) {
                weakSelf.textView.ht_h = contentHeight;
                weakSelf.tableView.tableFooterView = weakSelf.textView;
            } didSelectedURLBlock:^(UITextView *textView, NSURL *URL, NSString *titleName) {
                HTWebController *webController = [[HTWebController alloc] initWithURL:URL];
                [weakSelf.navigationController pushViewController:webController animated:true];
            }];
        }];
    }];
    [self.tableView ht_startRefreshHeader];
}

- (void)initializeUserInterface {
    self.navigationItem.title = @"高分故事";
    [self.view addSubview:self.tableView];
}

- (HTStoryDetailHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[HTStoryDetailHeaderView alloc] init];
    }
    return _headerView;
}


- (HTImageTextView *)textView {
    if (!_textView) {
        _textView = [[HTImageTextView alloc] initWithFrame:self.view.bounds];
        _textView.alwaysBounceVertical = true;
        _textView.textContainerInset = UIEdgeInsetsMake(15, 15, 15, 15);
        _textView.scrollEnabled = false;
    }
    return _textView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    }
    return _tableView;
}

@end
