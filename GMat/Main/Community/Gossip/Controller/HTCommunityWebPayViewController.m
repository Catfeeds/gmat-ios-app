//
//  HTCommunityWebPayViewController.m
//  GMat
//
//  Created by Charles Cao on 2017/11/8.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTCommunityWebPayViewController.h"
#import <WebKit/WebKit.h>
#import "HTUserManager.h"
#import "HTGmatController.h"

#define PAY_SUCCESS_BACK	@"paySuccessBack"

@interface HTCommunityWebPayViewController () <WKScriptMessageHandler,WKNavigationDelegate,WKUIDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) WKWebView *myWebView;

@end

@implementation HTCommunityWebPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	[self loadWeb];
}

- (void)loadWeb
{
	self.title = @"支付";
	self.navigationController.delegate = self;
	WKUserContentController *userContent = [WKUserContentController new];
	[userContent addScriptMessageHandler:self name:PAY_SUCCESS_BACK];
	WKWebViewConfiguration *config = [WKWebViewConfiguration new];
	config.userContentController = userContent;
	
	self.myWebView  = [[WKWebView alloc]initWithFrame:self.view.bounds configuration:config];
	self.myWebView.navigationDelegate = self;
	self.myWebView.UIDelegate = self;
	self.myWebView.allowsBackForwardNavigationGestures = YES;
	self.myWebView.scrollView.showsHorizontalScrollIndicator = NO;
	self.myWebView.scrollView.showsVerticalScrollIndicator = NO;
	[self.view addSubview:self.myWebView];
	
	HTUser *user = [HTUserManager currentUser];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://order.viplgw.cn/pay/order/wap-integral?uid=%@",user.uid]]];
	[self.myWebView loadRequest:request];
}

#pragma makr - WKScriptMessageHandler

/**
 *  接受js发出事件
 */
- (void)userContentController:(WKUserContentController *)userContentController
	  didReceiveScriptMessage:(WKScriptMessage *)message {
	
	if ([message.name isEqualToString:PAY_SUCCESS_BACK]){
		
		[self removeWebView];
		if (self.delegate) {
			[self.delegate paySuccess];
		}
		[self.navigationController popToRootViewControllerAnimated:YES];

	}
}

#pragma mark - UIDelegate

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
	
	if (message) {
		UIAlertView* customAlert = [[UIAlertView alloc] initWithTitle:nil
															  message:message
															 delegate:nil
													cancelButtonTitle:@"确定"
													otherButtonTitles:nil];
		
		[customAlert show];
	}
	
	completionHandler();
}

/**
 *  移除所有Handler 移除所有userScript
 */
- (void)removeWebView
{
	[self.myWebView.configuration.userContentController removeScriptMessageHandlerForName:PAY_SUCCESS_BACK];
	[self.myWebView.configuration.userContentController removeAllUserScripts];
	self.myWebView = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
	//返回首页
	if ([viewController isKindOfClass:[HTGmatController class]]){
			[self removeWebView];
		}
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
