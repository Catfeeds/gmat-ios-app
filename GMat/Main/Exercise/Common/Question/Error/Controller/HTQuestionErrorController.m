//
//  HTQuestionErrorController.m
//  GMat
//
//  Created by hublot on 2017/8/23.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTQuestionErrorController.h"
#import "HTQuestionErrorCell.h"
#import "HTQuestionErrorModel.h"
#import <UITableView+HTSeparate.h>
#import <HTPlaceholderTextView.h>
#import <HTKeyboardController.h>
#import "HTUserManager.h"

@interface HTQuestionErrorController ()

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIBarButtonItem *barButtonItem;

@property (nonatomic, strong) HTPlaceholderTextView *errorTextView;

@end

@implementation HTQuestionErrorController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initializeDataSource];
	[self initializeUserInterface];
}

- (void)viewDidDisappear:(BOOL)animated {
	self.questionModel.errorString = self.errorTextView.text;
}

- (void)validateBarButtonItem {
	self.barButtonItem.enabled = self.errorTextView.hasText;
}

- (void)initializeDataSource {
	
}

- (void)initializeUserInterface {
	self.navigationItem.title = @"题目纠错";
	[self.view addSubview:self.tableView];
	[self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.edges.mas_equalTo(UIEdgeInsetsZero);
	}];
	
	self.tableView.tableFooterView = self.errorTextView;
	
	__weak typeof(self) weakSelf = self;
	UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"提交" style:UIBarButtonItemStylePlain handler:^(id sender) {
        [HTUserManager surePermissionHighOrEqual:HTUserPermissionExerciseAbleUser passCompareBlock:^(HTUser *user) {
            HTNetworkModel *networkModel = [[HTNetworkModel alloc] init];
            networkModel.autoAlertString = @"提交题目错误";
            networkModel.offlineCacheStyle = HTCacheStyleNone;
            networkModel.autoShowError = true;
            __block HTQuestionErrorModel *errorModel = nil;
            [weakSelf.questionModel.errorModelArray enumerateObjectsUsingBlock:^(HTQuestionErrorModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
                if (model.isSelected) {
                    errorModel = model;
                    *stop = true;
                }
            }];
            [HTRequestManager requestQuestionErrorReportWithNetworkModel:networkModel questionIdString:weakSelf.questionModel.questionId errorSelectedModel:errorModel errorContentString:weakSelf.errorTextView.text complete:^(id response, HTError *errorModel) {
                if (errorModel.existError) {
                    return;
                }
                [HTAlert title:@"谢谢"];
                [weakSelf.navigationController popViewControllerAnimated:true];
            }];
        }];
	}];
	self.navigationItem.rightBarButtonItem = barButtonItem;
	self.barButtonItem = barButtonItem;
	self.errorTextView.text = self.questionModel.errorString;
	
	[self validateBarButtonItem];
}

- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc] init];
		_tableView.backgroundColor = [UIColor ht_colorString:@"f3f3f3"];
		_tableView.separatorColor = _tableView.backgroundColor;
		_tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
		__weak typeof(self) weakSelf = self;
		[_tableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
			UIView *footerView = [[UIView alloc] init];
			footerView.opaque = false;
			[[[sectionMaker.cellClass([HTQuestionErrorCell class]).rowHeight(45).footerClass([UITableViewHeaderFooterView class]).footerHeight(10).modelArray(weakSelf.questionModel.errorModelArray) didSelectedCellBlock:^(UITableView *tableView, NSInteger row, __kindof UITableViewCell *cell, __kindof HTQuestionErrorModel *model) {
				[weakSelf validateBarButtonItem];
				model.isSelected = true;
			}] diddeSelectedCellBlock:^(UITableView *tableView, NSInteger row, __kindof UITableViewCell *cell, __kindof HTQuestionErrorModel *model) {
				model.isSelected = false;
			}] customFooterBlock:^(UITableView *tableView, NSInteger section, __kindof UITableViewHeaderFooterView *reuseView, __kindof NSArray *modelArray) {
				reuseView.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage alloc] init]];
			}];
		}];
		
		[weakSelf.questionModel.errorModelArray enumerateObjectsUsingBlock:^(HTQuestionErrorModel *model, NSUInteger index, BOOL * _Nonnull stop) {
			if (model.isSelected) {
				@try {
					[weakSelf.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:false scrollPosition:UITableViewScrollPositionNone];
				} @catch (NSException *exception) {
					
				} @finally {
					
				}
			}
		}];
	}
	return _tableView;
}

- (HTPlaceholderTextView *)errorTextView {
	if (!_errorTextView) {
		_errorTextView = [[HTPlaceholderTextView alloc] initWithFrame:CGRectMake(0, 0, 0, 170)];
		_errorTextView.backgroundColor = [UIColor whiteColor];
		_errorTextView.textColor = [UIColor ht_colorStyle:HTColorStylePrimaryTitle];
		_errorTextView.font = [UIFont systemFontOfSize:14];
		_errorTextView.ht_placeholder = @"请输入题目纠错信息";
		_errorTextView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
		
		__weak typeof(self) weakSelf = self;
		[_errorTextView bk_addObserverForKeyPath:NSStringFromSelector(@selector(ht_currentText)) options:NSKeyValueObservingOptionInitial task:^(id obj, NSDictionary *change) {
			[weakSelf validateBarButtonItem];
		}];
	}
	return _errorTextView;
}

@end
