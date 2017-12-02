//
//  THToeflDiscoverIssueController.m
//  TingApp
//
//  Created by hublot on 17/6/4.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "THToeflDiscoverIssueController.h"
#import <HTPlaceholderTextView.h>
#import <UITableView+HTSeparate.h>
#import <NSObject+HTTableRowHeight.h>
#import <UIScrollView+HTRefresh.h>
#import "HTUserManager.h"
#import "HTManagerController.h"

@interface THToeflDiscoverIssueController ()

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UITextField *titleTextField;

@property (nonatomic, strong) HTPlaceholderTextView *contentTextView;

@end

@implementation THToeflDiscoverIssueController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDataSource];
    [self initializeUserInterface];
}

- (void)initializeDataSource {
    
}

- (void)initializeUserInterface {
    self.navigationItem.title = @"发表帖子";
    [self ht_addFallowKeyBoardView:self.contentTextView style:HTKeyBoardStyleHeight customKeyBoardHeight:nil];
    __weak THToeflDiscoverIssueController *weakSelf = self;
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"发表" style:UIBarButtonItemStylePlain handler:^(id sender) {
        [HTUserManager surePermissionHighOrEqual:HTUserPermissionExerciseAbleUser passCompareBlock:^(HTUser *user) {
            HTNetworkModel *networkModel = [[HTNetworkModel alloc] init];
            networkModel.autoAlertString = @"发表帖子";
            networkModel.offlineCacheStyle = HTCacheStyleNone;
            networkModel.autoShowError = true;
            [HTRequestManager requestDiscoverIssueWithNetworkModel:networkModel titleString:weakSelf.titleTextField.text contentString:weakSelf.contentTextView.text complete:^(id response, HTError *errorModel) {
                if (errorModel.existError) {
                    return;
                }
                [HTAlert title:@"发表成功"];
                [weakSelf.navigationController popViewControllerAnimated:true];
                [[HTManagerController defaultManagerController].discoverController ht_startRefreshHeader];
            }];
        }];
    }];
    [barButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    [barButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[[UIColor whiteColor] colorWithAlphaComponent:0.6]} forState:UIControlStateDisabled];
    barButtonItem.enabled = false;
    self.navigationItem.rightBarButtonItem = barButtonItem;
    [self.view addSubview:self.tableView];
    
    [self.titleTextField bk_addEventHandler:^(id sender) {
        [weakSelf inputTextDidChange];
    } forControlEvents:UIControlEventEditingChanged];
    [self.contentTextView bk_addObserverForKeyPath:NSStringFromSelector(@selector(ht_currentText)) task:^(id target) {
        [weakSelf inputTextDidChange];
    }];
}

- (void)inputTextDidChange {
    self.navigationItem.rightBarButtonItems.firstObject.enabled = self.titleTextField.hasText && self.contentTextView.hasText;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.allowsSelection = false;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
            [sectionMaker.modelArray(@[self.titleTextField, self.contentTextView]) customCellBlock:^(UITableView *tableView, NSInteger row, __kindof UITableViewCell *cell, __kindof UIView *model) {
                [cell addSubview:model];
                [model ht_setRowHeightNumber:@(model.ht_h) forCellClass:cell.class];
                if (row > 0) {
                    cell.separatorInset = UIEdgeInsetsMake(0, HTSCREENWIDTH, 0, 0);
                }
            }];
        }];
    }
    return _tableView;
}

- (UITextField *)titleTextField {
    if (!_titleTextField) {
        _titleTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, self.view.ht_w - 30, 50)];
        _titleTextField.textColor = [UIColor ht_colorStyle:HTColorStylePrimaryTitle];
        _titleTextField.font = [UIFont systemFontOfSize:14];
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@" 标题" attributes:@{NSForegroundColorAttributeName:[UIColor ht_colorStyle:HTColorStyleSecondaryTitle], NSFontAttributeName:_titleTextField.font}];
        _titleTextField.attributedPlaceholder = attributedString;
    }
    return _titleTextField;
}

- (HTPlaceholderTextView *)contentTextView {
    if (!_contentTextView) {
        _contentTextView = [[HTPlaceholderTextView alloc] initWithFrame:CGRectMake(10, 0, self.view.ht_w - 20, self.view.ht_h - 64 - self.titleTextField.ht_h)];
        _contentTextView.textColor = [UIColor ht_colorStyle:HTColorStylePrimaryTitle];
        _contentTextView.font = [UIFont systemFontOfSize:14];
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@" 请输入内容" attributes:@{NSForegroundColorAttributeName:[UIColor ht_colorStyle:HTColorStyleSecondaryTitle], NSFontAttributeName:_titleTextField.font}];
        _contentTextView.ht_attributedPlaceholder = attributedString;
    }
    return _contentTextView;
}

@end
