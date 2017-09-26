//
//  HTPreviewController.m
//  GMat
//
//  Created by hublot on 2017/6/29.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTPreviewController.h"
#import "RTRootNavigationController.h"
#import "HTManagerController+HTRotate.h"

@interface HTPreviewController () <QLPreviewControllerDataSource, HTRotateEveryOne, HTRotateVisible>

@end

@implementation HTPreviewController

- (void)dealloc {
	
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initializeDataSource];
	[self initializeUserInterface];
}

- (void)initializeDataSource {
	self.dataSource = self;
	self.currentPreviewItemIndex = self.currentIndex;
}

- (void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	NSArray *subViews = self.view.subviews.lastObject.subviews;
	for (UIView *view in subViews) {
		if ([view isKindOfClass:[UINavigationBar class]]) {
			UINavigationBar *navigationBar = (UINavigationBar *)view;
			navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:18],
												  NSForegroundColorAttributeName:[UIColor whiteColor]};
			navigationBar.barTintColor = [UIColor ht_colorStyle:HTColorStyleSecondaryTheme];
			navigationBar.tintColor = [UIColor whiteColor];
		} else if ([view isKindOfClass:[UIToolbar class]]) {
			UIToolbar *toorBar = (UIToolbar *)view;
			toorBar.tintColor = [UIColor whiteColor];
			toorBar.barStyle = UIBarStyleBlack;
		}
	}
}

- (void)initializeUserInterface {
	
}

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller {
	return self.filePathArray.count;
}

- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index {
	NSString *filePath = self.filePathArray[index];
	NSURL *fileURL = [NSURL fileURLWithPath:filePath];
	return fileURL;
}

//- (BOOL)prefersStatusBarHidden {
//	return false;
//}

@end
