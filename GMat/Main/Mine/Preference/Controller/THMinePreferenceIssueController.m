//
//  THMinePreferenceIssueController.m
//  TingApp
//
//  Created by hublot on 16/9/1.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "THMinePreferenceIssueController.h"
#import <NSObject+HTTableRowHeight.h>

#ifndef DEBUG

//-----------------------------------------/ 用户界面 /-----------------------------------------//

#import "THTableButton.h"
#import <UITableView+HTSeparate.h>
#import "THMinePreferenceInputCell.h"
#import "HTPlaceholderTextView.h"
#import "NSAttributedString+HTAttributedString.h"
#import "HTNetworkSaveToBmob.h"

@interface THMinePreferenceIssueController () <UITextViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) HTPlaceholderTextView *textView;

@property (nonatomic, strong) UITextField *textField;

@end

@implementation THMinePreferenceIssueController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDataSource];
    [self initializeUserInterface];
}

- (void)initializeDataSource {
    
}

- (void)initializeUserInterface {
    self.navigationItem.title = @"意见反馈";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    __weak THMinePreferenceIssueController *weakSelf = self;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"提交" style:UIBarButtonItemStylePlain handler:^(id sender) {
        if (weakSelf.textView.hasText) {
			HTNetworkModel *networkModel = [[HTNetworkModel alloc] init];
			networkModel.autoAlertString = @"提交反馈中";
			networkModel.offlineCacheStyle = HTCacheStyleNone;
			networkModel.autoShowError = true;
			networkModel.maxRepeatCountString = @"0";
			[HTRequestManager requestSendApplicationIssueWithNetworkModel:networkModel suggestionMessage:weakSelf.textView.text userContactWay:weakSelf.textField.text complete:^(id response, HTError *errorModel) {
				if (errorModel.existError) {
					return;
				}
				[HTAlert title:@"提交成功, 谢谢"];
				[weakSelf.navigationController popViewControllerAnimated:true];
			}];
        } else {
            [HTAlert title:@"什么都没有填写哦"];
        }
    }];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor ht_colorString:@"f5f5f5"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.allowsSelection = false;
        __weak THMinePreferenceIssueController *weakSelf = self;
        [_tableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
            [sectionMaker.modelArray(@[weakSelf.textView])
			 .headerHeight(20) customCellBlock:^(UITableView *tableView, NSInteger row, __kindof UITableViewCell *cell, __kindof NSObject *model) {
                
                [model ht_setRowHeightNumber:@(240) forCellClass:cell.class];
                [cell addSubview:model];
                [weakSelf.textView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(cell).mas_offset(UIEdgeInsetsMake(0, 10, 0, 10));
                }];
            }];
        }];
        [_tableView ht_updateSection:1 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
            [sectionMaker.modelArray(@[weakSelf.textField])
			 .headerHeight(15) customCellBlock:^(UITableView *tableView, NSInteger row, __kindof UITableViewCell *cell, __kindof NSObject *model) {
                [model ht_setRowHeightNumber:@(50) forCellClass:cell.class];
                [cell addSubview:model];
                [weakSelf.textField mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(cell).mas_offset(UIEdgeInsetsMake(0, 10, 0, 10));
                }];
            }];
        }];
    }
    return _tableView;
}


- (UITextView *)textView {
    if (!_textView) {
        _textView = [[HTPlaceholderTextView alloc] init];
        _textView.font = [UIFont systemFontOfSize:15];
        NSMutableAttributedString *placeHolderAttributedString = [[NSMutableAttributedString alloc] initWithString:@"请输入反馈, 我们将为你不断改进"];
        [placeHolderAttributedString addAttributes:@{NSFontAttributeName:_textView.font,
                                                     NSForegroundColorAttributeName:[UIColor ht_colorStyle:HTColorStylePrimaryTitle]} range:NSMakeRange(0, placeHolderAttributedString.length)];
        [self.textField.attributedPlaceholder ht_EnumerateAttribute:NSForegroundColorAttributeName usingBlock:^(id value, NSRange range, BOOL *stop) {
            [placeHolderAttributedString addAttribute:NSForegroundColorAttributeName value:value range:NSMakeRange(0, placeHolderAttributedString.length)];
            *stop = true;
        }];
        _textView.ht_attributedPlaceholder = placeHolderAttributedString;
    }
    return _textView;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [UITextField new];
        _textField.textColor = [UIColor ht_colorStyle:HTColorStylePrimaryTitle];
        _textField.font = [UIFont systemFontOfSize:15];
        _textField.placeholder = @"请输入你的联系方式(可选)";
    }
    return _textField;
}

@end


#else

//-----------------------------------------/ 开发界面 /-----------------------------------------//

#import <UITableView+HTSeparate.h>
#import "UIScrollView+HTRefresh.h"
#import "HTNetworkSaveToBmob.h"
#import "NSString+HTString.h"

@interface THMinePreferenceIssueController ()

@property (nonatomic, strong) UITableView *tableView;

@end


@implementation THMinePreferenceIssueController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDataSource];
    [self initializeUserInterface];
}

- (void)initializeDataSource {
    __weak THMinePreferenceIssueController *weakSelf = self;
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

#endif
