//
//  HTWebController.m
//  GMat
//
//  Created by hublot on 2017/4/24.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTWebController.h"
#import "THShareView.h"
#import "HTManagerController+HTRotate.h"
#import "HTAppDelegate.h"

@interface HTWebController () <UIWebViewDelegate, HTRotateScrren>

@property (nonatomic, copy) NSString *webviewTitle;

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) NSURLRequest *request;

@end

@implementation HTWebController

- (instancetype)initWithAddress:(NSString *)address {
	NSURL *URL = [NSURL URLWithString:address];
	return [self initWithURL:URL];
}

- (instancetype)initWithURL:(NSURL *)URL {
	NSURLRequest *request = [NSURLRequest requestWithURL:URL];
	return [self initWithRequest:request];
}

- (instancetype)initWithRequest:(NSURLRequest *)request {
	if (self = [super init]) {
		self.request = request;
	}
	return self;
}



- (void)viewDidLoad {
	[super viewDidLoad];
	[self initializeDataSource];
	[self initializeUserInterface];
}

- (void)initializeDataSource {
	self.webView.delegate = self;
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(playerDidExitFullscreen)
												 name:UIWindowDidResignKeyNotification
											   object:nil];
	self.webView.placeHolderState = HTPlaceholderStateFirstRefresh;
	[self.webView loadRequest:self.request];
}

- (void)initializeUserInterface {
	__weak typeof(self) weakController = self;
	UIBarButtonItem *shareBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"Toeflshare"] style:UIBarButtonItemStylePlain handler:^(id sender) {
		NSString *titleName = weakController.webviewTitle;
		NSString *urlString = weakController.request.URL.absoluteString;
		if (weakController.customShareBlock) {
			weakController.customShareBlock(titleName, urlString);
		} else {
			[THShareView showTitle:nil detail:urlString image:nil url:nil type:SSDKContentTypeText];
		}
	}];
	shareBarButtonItem.tintColor = [UIColor whiteColor];
	self.navigationItem.rightBarButtonItems = @[shareBarButtonItem];
	[self.view addSubview:self.webView];
	[self.webView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.edges.mas_equalTo(UIEdgeInsetsZero);
	}];
	self.navigationItem.title = @"加载中...";
}





- (BOOL)shouldAutorotate {
	HTAppDelegate *delegate = (HTAppDelegate *)[UIApplication sharedApplication].delegate;
	return [UIApplication sharedApplication].keyWindow == delegate.window;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
	return UIInterfaceOrientationMaskAll;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
	return UIInterfaceOrientationPortrait;
}

- (void)playerDidExitFullscreen {
	[[UIApplication sharedApplication] setStatusBarHidden:false withAnimation:UIStatusBarAnimationNone];
}






- (void)webViewDidFinishLoad:(UIWebView *)webView {
	NSString *resetImageSize = @"resizeImageWidth";
	NSString *resetImageScript = [NSString stringWithFormat:@"%@();", resetImageSize];
	CGFloat maxAllowImageWidth = [UIScreen mainScreen].bounds.size.width - 15;

	void(^javaScriptBlock)(NSString *javaScriptString, void(^complete)(id response)) = ^(NSString *javaScriptString, void(^complete)(id response)) {
		id response = [webView stringByEvaluatingJavaScriptFromString:javaScriptString];
		if (complete) {
			complete(response);
		}
	};

	NSString *javaScriptImage = @"var script = document.createElement('script');"
	"script.type = 'text/javascript';"
	"script.text = \"function resizeImageWidth() {"
	"var image;"
	"var screenWidth = %f;"
	"for (i = 0; i < document.images.length; i ++) {"
	"image = document.images[i];"
	"if (image.width > screenWidth) {"
	"image.width = screenWidth"
	"}"
	"}"
	"}\";"
	"document.getElementsByTagName('head')[0].appendChild(script);";
	javaScriptImage = [NSString stringWithFormat:javaScriptImage, maxAllowImageWidth];

	NSString *javaScriptScale = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";

	javaScriptBlock(javaScriptImage, ^(id response) {
		javaScriptBlock(resetImageScript, ^(id response) {
			javaScriptBlock(javaScriptScale, ^(id response) {

			});
		});
	});
	self.webviewTitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
	self.navigationItem.title = self.webviewTitle;
	self.webView.placeHolderState = HTPlaceholderStateNone;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	self.webView.placeHolderState = HTPlaceholderStateNone;
}

- (UIWebView *)webView {
	if (!_webView) {
		_webView = [[UIWebView alloc] init];
		_webView.scalesPageToFit = true;
	}
	return _webView;
}

@end
