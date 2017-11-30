//
//  HTPlayerController.m
//  GMat
//
//  Created by hublot on 2017/9/25.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTPlayerController.h"
#import <AVFoundation/AVFoundation.h>
#import "RTRootNavigationController.h"
#import "HTPlayerManager.h"
#import "HTPlayerView.h"
#import "HTPlayerView+HTSwitch.h"
#import "HTManagerController+HTRotate.h"
#import <UITableView+HTSeparate.h>
#import "HTPlayerTeacherDetailCell.h"

@interface HTPlayerController () <HTRotateScrren>

@property (nonatomic, strong) HTPlayerView *playerView;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation HTPlayerController

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	[self.playerView.playerModel reloadWillSeekRateWillPlay:false];
}

- (BOOL)shouldAutorotate {
	return self.playerView.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
	return UIInterfaceOrientationMaskAll;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
	return UIInterfaceOrientationPortrait;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initializeDataSource];
	[self initializeUserInterface];
}

- (void)initializeDataSource {
	[self.playerView shouldStartLoading:true];
	__weak typeof(self) weakself = self;
	self.view.reloadNetworkBlock = ^() {
//		weakself.view.placeHolderState = HTPlaceholderStateFirstRefresh;
		[[[NSOperationQueue alloc] init] addOperationWithBlock:^{
			[HTPlayerManager findPlayerXMLURLFromCourseURLString:weakself.courseModel.courseURLString complete:^(NSString *playerXMLString) {
				[HTPlayerManager findM3U8URLFromXMLURLString:playerXMLString complete:^(HTPlayerModel *model) {
					model.titleName = weakself.courseModel.courseTitleString;
					[[NSOperationQueue mainQueue] addOperationWithBlock:^{
						if (!model.m3u8URLString.length) {
							[HTAlert title:@"获取视频源失败"];
							[weakself.navigationController popViewControllerAnimated:true];
						} else {
							weakself.view.placeHolderState = HTPlaceholderStateNone;
							[weakself reloadPlayerModel:model];
						}
					}];
				}];
			}];
		}];
	};
	self.view.reloadNetworkBlock();
}

- (void)initializeUserInterface {
	self.view.backgroundColor = [UIColor blackColor];
	self.automaticallyAdjustsScrollViewInsets = false;
	UIImage *image = [[UIImage alloc] init];
	[self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
	[self.navigationController.navigationBar setShadowImage:image];
	self.navigationController.navigationBar.userInteractionEnabled = false;
	[self reloadLayoutFromStatusBar];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadLayoutFromStatusBar) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)reloadLayoutFromStatusBar {
	[self.view addSubview:self.tableView];
	[self.view addSubview:self.playerView];
	BOOL isPortrait = UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation);
	self.rt_navigationController.interactivePopGestureRecognizer.enabled = isPortrait;
	if (isPortrait) {
		CGFloat height = HTSCREENWIDTH * (9 / 16.0);
		[self.playerView mas_remakeConstraints:^(MASConstraintMaker *make) {
			make.top.mas_equalTo(MAX(20, [UIApplication sharedApplication].statusBarFrame.size.height));
			make.left.right.mas_equalTo(self.view);
			make.height.mas_equalTo(height);
		}];
	} else {
		[self.playerView mas_remakeConstraints:^(MASConstraintMaker *make) {
			make.edges.mas_equalTo(self.view);
		}];
	}
	
	[self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(self.playerView.mas_bottom);
		make.left.right.bottom.mas_equalTo(self.view);
	}];
	
	[self.view layoutIfNeeded];
	self.playerView.isPortrait = isPortrait;
	
}

- (void)reloadPlayerModel:(HTPlayerModel *)playModel {
	[self.playerView setPlayerModel:playModel];
}

- (UIBarButtonItem *)customBackItemWithTarget:(id)target action:(SEL)action {
	return nil;
}

- (HTPlayerView *)playerView {
	if (!_playerView) {
		_playerView = [[HTPlayerView alloc] init];
		_playerView.backgroundColor = [UIColor blackColor];
	}
	return _playerView;
}

- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc] initWithFrame:CGRectZero];
		_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		_tableView.allowsSelection = false;
		_tableView.backgroundColor = [UIColor ht_colorString:@"f3f3f3"];
		
		__weak typeof(self) weakSelf = self;
		[_tableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
			sectionMaker.cellClass([HTPlayerTeacherDetailCell class]).modelArray(@[weakSelf.courseModel]);
		}];
	}
	return _tableView;
}

@end
