//
//  HTUserIssueController.m
//  GMat
//
//  Created by hublot on 2017/10/12.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTUserIssueController.h"
#import <NSObject+HTTableRowHeight.h>
#import "THTableButton.h"
#import <UITableView+HTSeparate.h>
#import "THMinePreferenceInputCell.h"
#import "HTPlaceholderTextView.h"
#import "NSAttributedString+HTAttributedString.h"
#import "HTNetworkSaveToBmob.h"

@interface HTUserIssueController () <UITextViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) HTPlaceholderTextView *textView;

@property (nonatomic, strong) UITextField *textField;

@end

@implementation HTUserIssueController

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
	
	__weak typeof(self) weakSelf = self;
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
		__weak typeof(self) weakSelf = self;
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

