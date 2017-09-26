//
//  HTSureNicknameController.m
//  GMat
//
//  Created by hublot on 2017/7/3.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTSureNicknameController.h"
#import "HTRootNavigationController.h"
#import "HTRootLoginNavigationController.h"
#import "HTLoginController.h"
#import <UITableView+HTSeparate.h>
#import <HTValidateManager.h>

@interface HTSureNicknameController ()

@property (nonatomic, copy) void(^dismissNicknameBlock)(NSString *nickname);

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) NSString *nickname;

@end

@implementation HTSureNicknameController

+ (void)presentFromController:(UIViewController *)viewController dismissNicknameBlock:(void(^)(NSString *nickname))dismissNicknameBlock {
	HTSureNicknameController *nicknameController = [[HTSureNicknameController alloc] init];
	nicknameController.dismissNicknameBlock = dismissNicknameBlock;
	HTRootNavigationController *navigationController = [[HTRootNavigationController alloc] initWithRootViewController:nicknameController];
	[viewController presentViewController:navigationController animated:true completion:nil];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self.textField becomeFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	if (self.dismissNicknameBlock) {
		self.dismissNicknameBlock(self.nickname);
	}
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initializeDataSource];
	[self initializeUserInterface];
}

- (void)initializeDataSource {
	
}

- (void)initializeUserInterface {
	self.navigationItem.title = @"先起一个闪亮亮的昵称吧";
	[self.view addSubview:self.tableView];
	self.tableView.tableHeaderView = self.headerView;
	
	__weak typeof(self) weakSelf = self;
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"取消" style:UIBarButtonItemStylePlain handler:^(id sender) {
		[weakSelf dismissViewControllerAnimated:true completion:nil];
	}];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"确认" style:UIBarButtonItemStylePlain handler:^(id sender) {
		NSString *inputNickname = weakSelf.textField.text;
		if (![HTValidateManager ht_validateNickname:inputNickname]) {
			[HTAlert title:@"昵称格式不大对哦"];
			return;
		}
		HTNetworkModel *networkModel = [[HTNetworkModel alloc] init];
		networkModel.autoAlertString = @"修改昵称中";
		networkModel.offlineCacheStyle = HTCacheStyleNone;
		networkModel.autoShowError = true;
		[HTRequestManager requestUpdateUserNicknameWithNetworkModel:networkModel changeNickname:weakSelf.textField.text complete:^(id response, HTError *errorModel) {
			if (errorModel.existError) {
				return;
			}
			weakSelf.nickname = inputNickname;
			[weakSelf dismissViewControllerAnimated:true completion:nil];
		}];
	}];
	weakSelf.navigationItem.rightBarButtonItem.enabled = weakSelf.textField.hasText;
	[self.textField bk_addEventHandler:^(id sender) {
		weakSelf.navigationItem.rightBarButtonItem.enabled = weakSelf.textField.hasText;
	} forControlEvents:UIControlEventEditingChanged];
}

- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
		_tableView.backgroundColor = [UIColor ht_colorStyle:HTColorStyleCompareBackground];
		[_tableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
			[sectionMaker.modelArray(@[self.textField]).rowHeight(50) customCellBlock:^(UITableView *tableView, NSInteger row, __kindof UITableViewCell *cell, __kindof UIView *textField) {
				[cell addSubview:textField];
				[textField mas_updateConstraints:^(MASConstraintMaker *make) {
					make.edges.mas_equalTo(UIEdgeInsetsMake(0, 30, 0, 30));
				}];
			}];
		}];
		[_tableView ht_whenTap:^(UIView *view) {
			[HTKeyboardController resignFirstResponder];
		}];
	}
	return _tableView;
}

- (UIView *)headerView {
	if (!_headerView) {
		_headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HTSCREENWIDTH, 50)];
		UILabel *titleNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 20, HTSCREENWIDTH - 60, _headerView.bounds.size.height - 20)];
		titleNameLabel.textColor = [UIColor ht_colorStyle:HTColorStyleSpecialTitle];
		titleNameLabel.font = [UIFont systemFontOfSize:13];
		titleNameLabel.text = @"昵称 2 - 8 位, 不可有特殊字符, 以后可随时更改";
		[_headerView addSubview:titleNameLabel];
	}
	return _headerView;
}

- (UITextField *)textField {
	if (!_textField) {
		_textField = [[UITextField alloc] init];
		_textField.textColor = [UIColor ht_colorStyle:HTColorStylePrimaryTitle];
		_textField.font = [UIFont systemFontOfSize:15];
		_textField.placeholder = @"请输入昵称";
		_textField.clearButtonMode = UITextFieldViewModeWhileEditing;
	}
	return _textField;
}

@end
