//
//  HTPlayerController.m
//  GMat
//
//  Created by hublot on 2017/9/25.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTPlayerController.h"
#import <AVFoundation/AVFoundation.h>
#import "HTPlayerManager.h"
#import "HTPlayerView.h"
#import "HTManagerController+HTRotate.h"

@interface HTPlayerController () <HTRotateEveryOne, HTRotateVisible>

@property (nonatomic, copy) NSString *courseURLString;

@property (nonatomic, strong) HTPlayerView *playerView;

@property (nonatomic, strong) UITextView *textView;

@end

@implementation HTPlayerController

- (void)dealloc {
	
}

- (instancetype)initWithCourseURLString:(NSString *)courseURLString {
	if (self = [super init]) {
		self.courseURLString = HTPlaceholderString(courseURLString, @"");
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initializeDataSource];
	[self initializeUserInterface];
}

- (void)initializeDataSource {
	__weak typeof(self) weakself = self;
	self.view.reloadNetworkBlock = ^() {
		weakself.view.placeHolderState = HTPlaceholderStateFirstRefresh;
		[[[NSOperationQueue alloc] init] addOperationWithBlock:^{
			[HTPlayerManager findPlayerXMLURLFromCourseURLString:weakself.courseURLString complete:^(NSString *playerXMLString) {
				[HTPlayerManager findM3U8URLFromXMLURLString:playerXMLString complete:^(HTPlayerModel *model) {
					[[NSOperationQueue mainQueue] addOperationWithBlock:^{
						if (!model.m3u8URLString.length) {
							weakself.view.placeHolderState = HTPlaceholderStateNetwork;
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
	self.automaticallyAdjustsScrollViewInsets = false;
	UIImage *image = [[UIImage alloc] init];
	[self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
	[self.navigationController.navigationBar setShadowImage:image];
	self.navigationController.navigationBar.userInteractionEnabled = false;
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadLayoutFromStatusBar) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
	[self reloadLayoutFromStatusBar];
}

- (void)reloadLayoutFromStatusBar {
	[self.view addSubview:self.textView];
	[self.view addSubview:self.playerView];
	BOOL isPortrait = UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation);
	
	if (isPortrait) {
		CGFloat height = HTSCREENWIDTH * (9 / 16.0);
		[self.playerView mas_remakeConstraints:^(MASConstraintMaker *make) {
			make.top.mas_equalTo([UIApplication sharedApplication].statusBarFrame.size.height);
			make.left.right.mas_equalTo(self.view);
			make.height.mas_equalTo(height);
		}];
	} else {
		[self.playerView mas_remakeConstraints:^(MASConstraintMaker *make) {
			make.edges.mas_equalTo(self.view);
		}];
	}
	
	self.playerView.isPortrait = isPortrait;
	
	[self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(self.playerView.mas_bottom);
		make.left.right.bottom.mas_equalTo(self.view);
	}];
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
	}
	return _playerView;
}

- (UITextView *)textView {
	if (!_textView) {
		_textView = [[UITextView alloc] init];
		_textView.alwaysBounceVertical = true;
		_textView.textColor = [UIColor ht_colorStyle:HTColorStylePrimaryTitle];
		_textView.font = [UIFont systemFontOfSize:30 weight:0.1];
		_textView.text = @"快速搭建GMAT商科思维系统讲述GMAT框架知识点详细讲解解题方法技巧";
	}
	return _textView;
}

@end
