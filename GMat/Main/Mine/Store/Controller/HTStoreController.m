//
//  HTStoreController.m
//  GMat
//
//  Created by hublot on 2016/10/19.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTStoreController.h"
#import "HTStoreReuseController.h"
#import "UIScrollView+HTRefresh.h"
#import "HTStoreModel.h"
#import "HTQuestionManager.h"
#import "HTManagerController+HTRotate.h"

@interface HTStoreController () <UIGestureRecognizerDelegate, HTRotateEveryOne, HTRotateVisible>

@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

@end

@implementation HTStoreController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initializeDataSource];
	[self initializeUserInterface];
}

- (void)initializeDataSource {
	
}

- (void)initializeUserInterface {
	self.magicView.scrollEnabled = false;
	self.navigationItem.title = @"收藏记录";
	self.reuseControllerClass = [HTStoreReuseController class];
	NSArray *sectionidArray = @[@"6", @"8", @"7", @"4", @"5"];
	NSArray *twoObjectArray = @[@[@"12", @"13"],
								@[@"1", @"15", @"16", @"18"],
								@[@"8", @"10", @"11"],
								@[@"2"],
								@[@"9"]];
	
	[self setModelArrayBlock:^(NSString *firstSelectedIndex, NSString *secondSelectedIndex, NSString *pageCount, NSString *currentPage, void (^modelArrayStatus)(NSArray <HTStoreModel *> *, HTError *errorModel)) {
		NSArray *twoObject = twoObjectArray[firstSelectedIndex.integerValue];
		NSString *sectionid = sectionidArray[secondSelectedIndex.integerValue];
		NSMutableArray <HTStoreModel *> *modelArray = [HTQuestionManager packStoreItemWithSectionId:sectionid twoObjectIdArray:twoObject currentPage:currentPage pageCount:pageCount];
		modelArrayStatus(modelArray, nil);
	}];
	[self.magicView reloadData];
}

- (void)magicView:(VTMagicView *)magicView viewDidAppear:(__kindof HTStoreReuseController *)viewController atPage:(NSUInteger)pageIndex {
	[super magicView:magicView viewDidAppear:viewController atPage:pageIndex];
	[viewController.tableView addGestureRecognizer:self.panGestureRecognizer];
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer {
	[self.magicView handlePanGesture:recognizer];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
	return true;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
	if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
		return false;
	}
	return true;
}

- (UIPanGestureRecognizer *)panGestureRecognizer {
	if (!_panGestureRecognizer) {
		_panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
		_panGestureRecognizer.cancelsTouchesInView = true;
		_panGestureRecognizer.delegate = self;
	}
	return _panGestureRecognizer;
}

@end
