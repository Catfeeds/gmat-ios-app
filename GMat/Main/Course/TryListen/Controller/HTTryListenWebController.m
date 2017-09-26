//
//  HTTryListenWebController.m
//  GMat
//
//  Created by hublot on 2017/8/3.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTTryListenWebController.h"
#import "HTTryListenMorePeopleAlert.h"
#import "HTManagerController.h"

@interface HTTryListenWebController () <AXWebViewControllerDelegate>

@end

@implementation HTTryListenWebController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.delegate = self;
}

- (void)webViewControllerDidStartLoad:(AXWebViewController *)webViewController {
	NSString *urlString = webViewController.webView.URL.absoluteString;
	BOOL fullPeople = [urlString containsString:@"http://static.gensee.com/webcast/static"];
	if (fullPeople) {
		[self trylistenPeopleFullPop];
	}
}

- (void)trylistenPeopleFullPop {
	[self.navigationController popViewControllerAnimated:true];
	[HTTryListenMorePeopleAlert showWithAnimted:true superView:[HTManagerController defaultManagerController].view];
}

@end
