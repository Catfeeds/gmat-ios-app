//
//  HTSearchQuestionController.m
//  GMat
//
//  Created by hublot on 2017/3/24.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTSearchQuestionController.h"
#import "HTRecognizeManager.h"
#import "HTQuestionManager.h"
#import "HTQuestionController.h"
#import <UITableView+HTSeparate.h>
#import "HTSearchListController.h"
#import "HTSearchController.h"

@interface HTSearchQuestionController ()

@property (nonatomic, strong) UITableView *originTableView;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) HTSearchController *searchController;

@end

@implementation HTSearchQuestionController

- (void)dealloc {
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	__weak HTSearchQuestionController *weakSelf = self;
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"重新拍照" style:UIBarButtonItemStylePlain handler:^(id sender) {
		[weakSelf.navigationController popViewControllerAnimated:true];
	}];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"重新剪切" style:UIBarButtonItemStylePlain handler:^(id sender) {
		if (weakSelf.tryAgainCutImageBlock) {
			weakSelf.tryAgainCutImageBlock();
		}
	}];	
}

- (void)recognizeImage:(UIImage *)image activeSearchBar:(BOOL)activeSearchBar {
	__weak HTSearchQuestionController *weakSelf = self;
	weakSelf.navigationItem.title = @"正在解析";
	[weakSelf.imageView addSubview:weakSelf.indicatorView];
	weakSelf.textView.text = @"";
	[HTRecognizeManager recognizeImage:weakSelf.image complte:^(NSString *result) {
		[weakSelf.indicatorView removeFromSuperview];
		if (result.length) {
			NSString *reverseResult = [result stringByReplacingOccurrencesOfString:@"\n" withString:@"/n"];
			weakSelf.navigationItem.title = @"解析成功";
			NSAttributedString *textAttributedString = [[NSAttributedString alloc] initWithString:result
																					   attributes:@{NSForegroundColorAttributeName:[UIColor orangeColor],
																									NSFontAttributeName:[UIFont systemFontOfSize:15]}];
			weakSelf.textView.attributedText = textAttributedString;
			weakSelf.searchController.searchBar.text = reverseResult;
			if (activeSearchBar) {
                weakSelf.originTableView.contentOffset = CGPointMake(0, - 64);
				weakSelf.searchController.active = true;
			}
		} else {
			weakSelf.navigationItem.title = @"解析失败";
		}
	}];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initializeDataSource];
	[self initializeUserInterface];
}

- (void)initializeDataSource {
	[self recognizeImage:self.image activeSearchBar:true];
}

- (void)initializeUserInterface {
	[self.view addSubview:self.originTableView];
}

- (UIActivityIndicatorView *)indicatorView {
	if (!_indicatorView) {
		_indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:self.imageView.bounds];
		_indicatorView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
		_indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
		_indicatorView.hidesWhenStopped = false;
	}
	return _indicatorView;
}

- (UIImageView *)imageView {
	if (!_imageView) {
		_imageView = [[UIImageView alloc] init];
		_imageView.frame = CGRectMake(15, 15, self.view.bounds.size.width - 30, self.image.size.height * (self.view.bounds.size.width - 30) / self.image.size.width);
		_imageView.image = self.image;
		self.indicatorView.center = CGPointMake(_imageView.bounds.size.width / 2, _imageView.bounds.size.height / 2);
		
		__weak HTSearchQuestionController *weakSelf = self;
		[_imageView ht_whenTap:^(UIView *view) {
			[weakSelf recognizeImage:weakSelf.image activeSearchBar:false];
		}];
	}
	return _imageView;
}

- (UITextView *)textView {
	if (!_textView) {
		_textView = [[UITextView alloc] initWithFrame:self.imageView.frame];
		_textView.editable = false;
		_textView.selectable = true;
		_textView.bounces = false;
	}
	return _textView;
}

- (UITableView *)originTableView {
	if (!_originTableView) {
		_originTableView = [[UITableView alloc] initWithFrame:self.view.bounds];
		_originTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		_originTableView.allowsSelection = false;
		_originTableView.tableHeaderView = self.searchController.searchBar;
		__weak HTSearchQuestionController *weakSelf = self;
        
        [_originTableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
            [sectionMaker.rowHeight(weakSelf.imageView.bounds.size.height + 15)
			 .modelArray(@[weakSelf.imageView, weakSelf.textView]) customCellBlock:^(UITableView *tableView, NSInteger row, __kindof UITableViewCell *cell, __kindof NSObject *model) {
                [weakSelf.indicatorView startAnimating];
                [cell addSubview:model];
            }];
        }];
	}
	return _originTableView;
}

- (HTSearchController *)searchController {
	if (!_searchController) {
		HTSearchListController *searchListController = [[HTSearchListController alloc] init];
		_searchController = [[HTSearchController alloc] initWithSearchResultsController:searchListController];
		_searchController.searchResultsUpdater = searchListController;
	}
	return _searchController;
}

@end
