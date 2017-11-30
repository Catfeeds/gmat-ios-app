//
//  HTDiscussIssueController.m
//  GMat
//
//  Created by hublot on 17/8/24.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTDiscussIssueController.h"
#import <HTPlaceholderTextView.h>
#import "HTUserManager.h"

@interface HTDiscussIssueController ()

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) HTPlaceholderTextView *textView;

@property (nonatomic, strong) UIBarButtonItem *barButtonItem;

@end

@implementation HTDiscussIssueController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDataSource];
    [self initializeUserInterface];
}

- (void)initializeDataSource {
	
}

- (void)initializeUserInterface {
    self.navigationItem.title = @"参与讨论";
    [self.view addSubview:self.tableView];
	[self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.edges.mas_equalTo(UIEdgeInsetsZero);
	}];
	
    self.tableView.tableFooterView = self.textView;
    
    __weak typeof(self) weakSelf = self;
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"发表" style:UIBarButtonItemStylePlain handler:^(id sender) {
        [HTUserManager surePermissionHighOrEqual:HTUserPermissionExerciseAbleUser passCompareBlock:^(HTUser *user) {
            HTNetworkModel *networkModel = [[HTNetworkModel alloc] init];
            networkModel.autoAlertString = @"发表新的讨论";
            networkModel.offlineCacheStyle = HTCacheStyleNone;
            networkModel.autoShowError = true;
            [HTRequestManager requestQuestionDiscussCreateWithNetworkModel:networkModel questionIdString:weakSelf.questionIdString discussContentString:weakSelf.textView.text willReplyIdString:nil complete:^(id response, HTError *errorModel) {
                if (errorModel.existError) {
                    return;
                }
                [HTAlert title:@"发表成功"];
                if (weakSelf.issueSuccessBlock) {
                    weakSelf.issueSuccessBlock();
                }
                [weakSelf.navigationController popViewControllerAnimated:true];
            }];
        }];
    }];
    self.navigationItem.rightBarButtonItem = barButtonItem;
    self.barButtonItem = barButtonItem;
    [self validateBarButtonItem];
}

- (void)validateBarButtonItem {
    self.barButtonItem.enabled = self.textView.hasText;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.backgroundColor = [UIColor ht_colorString:@"f3f3f3"];
    }
    return _tableView;
}

- (HTPlaceholderTextView *)textView {
    if (!_textView) {
        _textView = [[HTPlaceholderTextView alloc] initWithFrame:CGRectMake(0, 0, 0, 170)];
        _textView.textColor = [UIColor ht_colorStyle:HTColorStylePrimaryTitle];
        _textView.font = [UIFont systemFontOfSize:15];
        _textView.ht_placeholder = @"请输入内容";
        _textView.textContainerInset = UIEdgeInsetsMake(15, 15, 15, 15);
        
        __weak typeof(self) weakSelf = self;
        [_textView bk_addObserverForKeyPath:NSStringFromSelector(@selector(ht_currentText)) options:NSKeyValueObservingOptionInitial task:^(id obj, NSDictionary *change) {
            [weakSelf validateBarButtonItem];
        }];
    }
    return _textView;
}


@end
