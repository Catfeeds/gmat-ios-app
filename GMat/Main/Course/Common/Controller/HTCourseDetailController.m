//
//  HTCourseDetailController.m
//  GMat
//
//  Created by hublot on 2017/5/9.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTCourseDetailController.h"
#import "HTCourseDetailHeaderView.h"
#import "THShareView.h"
#import "HTCourseDetailTextCell.h"
#import <UITableView+HTSeparate.h>
#import "HTWebController.h"
#import "HTManagerController+HTRotate.h"

@interface HTCourseDetailController () <HTRotateEveryOne, HTRotateVisible>

@property (nonatomic, strong) HTCourseDetailHeaderView *courseHeaderView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *connectSaleButton;

@end

@implementation HTCourseDetailController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initializeDataSource];
	[self initializeUserInterface];
}

- (void)initializeDataSource {
	
}

- (void)initializeUserInterface {
	[[NSNotificationCenter defaultCenter] addObserver:self.tableView selector:@selector(reloadData) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
	
	self.automaticallyAdjustsScrollViewInsets = false;
	UIImage *image = [[UIImage alloc] init];
	[self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
	[self.navigationController.navigationBar setShadowImage:image];
	self.navigationController.navigationBar.translucent = true;
	
	__weak HTCourseDetailController *weakSelf = self;
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[[UIImage imageNamed:@"Toeflshare"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] style:UIBarButtonItemStylePlain handler:^(id sender) {
		if (!weakSelf.courseModel) {
			[HTAlert title:@"还没有获取到课程呢"];
			return;
		}
		[THShareView showTitle:weakSelf.courseModel.contenttitle detail:weakSelf.courseModel.contenttitle image:GmatResourse(weakSelf.courseModel.contentthumb) url:GmatResourse(@"") type:SSDKContentTypeWebPage];
	}];
	[self.view addSubview:self.tableView];
	[self.view addSubview:self.connectSaleButton];
	
	[self.connectSaleButton mas_updateConstraints:^(MASConstraintMaker *make) {
		make.left.right.bottom.mas_equalTo(self.view);
		make.height.mas_equalTo(49);
	}];
	[self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.left.right.top.mas_equalTo(self.view);
		make.bottom.mas_equalTo(self.connectSaleButton.mas_top);
	}];
	
	[self.navigationController.view insertSubview:self.courseHeaderView belowSubview:self.navigationController.navigationBar];
	CGFloat headerViewHeight = 250;
	[self.courseHeaderView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.left.right.top.mas_equalTo(self.navigationController.view);
		make.height.mas_equalTo(headerViewHeight);
	}];
	self.tableView.contentInset = UIEdgeInsetsMake(headerViewHeight, 0, 0, 0);
	self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
	
	[self.courseHeaderView setModel:self.courseModel row:0];
	[self.tableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
		sectionMaker.modelArray(@[weakSelf.courseModel.contenttext.length ? weakSelf.courseModel.contenttext : @""]);
	}];
}

- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc] init];
		_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		_tableView.allowsSelection = false;
		
		__weak HTCourseDetailController *weakSelf = self;
		[_tableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
			sectionMaker.cellClass([HTCourseDetailTextCell class]);
		}];
		[_tableView bk_addObserverForKeyPath:NSStringFromSelector(@selector(contentOffset)) options:NSKeyValueObservingOptionInitial task:^(id obj, NSDictionary *change) {
			CGFloat contentOffsetY = MIN(- 64, weakSelf.tableView.contentOffset.y);
			CGFloat courseHeaderHeight = - contentOffsetY;
			[weakSelf.courseHeaderView mas_updateConstraints:^(MASConstraintMaker *make) {
				make.height.mas_equalTo(courseHeaderHeight);
			}];
			weakSelf.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(courseHeaderHeight, 0, 0, 0);
			weakSelf.courseHeaderView.blurProgress = (1 - (courseHeaderHeight - 64) / (250 - 64));
		}];
	}
	return _tableView;
}

- (HTCourseDetailHeaderView *)courseHeaderView {
	if (!_courseHeaderView) {
		_courseHeaderView = [[HTCourseDetailHeaderView alloc] init];
	}
	return _courseHeaderView;
}

- (UIButton *)connectSaleButton {
	if (!_connectSaleButton) {
		_connectSaleButton = [[UIButton alloc] init];
		_connectSaleButton.backgroundColor = [UIColor ht_colorString:@"f8b62c"];
		[_connectSaleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		NSString *titleName = @"点击咨询";
		if (self.courseModel.courseConnectTitle.length) {
			titleName = self.courseModel.courseConnectTitle;
		}
		[_connectSaleButton setTitle:titleName forState:UIControlStateNormal];
		_connectSaleButton.titleLabel.font = [UIFont systemFontOfSize:15];
		
		__weak HTCourseDetailController *weakSelf = self;
		[_connectSaleButton ht_whenTap:^(UIView *view) {
			NSString *urlString = @"http://p.qiao.baidu.com/im/index?siteid=7905926&ucid=18329536&cp=&cr=&cw=";
			NSMutableURLRequest *urlRequest = [[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] mutableCopy];
			[urlRequest setValue:GmatResourse(@"") forHTTPHeaderField:@"Referer"];
			HTWebController *webController = [[HTWebController alloc] initWithRequest:urlRequest];
			[weakSelf.navigationController pushViewController:webController animated:true];
		}];
	}
	return _connectSaleButton;
}

@end
