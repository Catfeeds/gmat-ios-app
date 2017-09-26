//
//  HTAboutUsController.m
//  GMat
//
//  Created by hublot on 2016/10/21.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTAboutUsController.h"

@interface HTAboutUsController ()

@property (nonatomic, strong) UITextView *textView;

@end

@implementation HTAboutUsController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initializeDataSource];
	[self initializeUserInterface];
}

- (void)initializeDataSource {
	
}

- (void)initializeUserInterface {
	self.navigationItem.title = @"关于我们";
	[self.view addSubview:self.textView];
}

- (UITextView *)textView {
	if (!_textView) {
		_textView = [[UITextView alloc] initWithFrame:self.view.bounds];
		_textView.alwaysBounceVertical = true;
		_textView.textColor = [UIColor ht_colorStyle:HTColorStylePrimaryTitle];
		_textView.font = [UIFont ht_fontStyle:HTFontStyleTitleLarge];
		_textView.textContainerInset = UIEdgeInsetsMake(15, 15, 15, 15);
		_textView.text = @"雷哥GMAT在线，互联网GMAT一站式在线学习平台。提供包含GMAT在线做题、 在线模考、在线测评、在线答疑、在线学习计划定制、录播视频课程、在线直播课程、免费公开课等一系列在线GMAT学习服务。\n\n  雷哥GMAT在线是在线教育领域里提供“在线做题+在线模考+在线答疑＋视频课程＋直播课程”一站式 GMAT在线生态学习系统。集结了GMAT行业教学专家以及来自哈佛、耶鲁、哥大、MIT 、LSE等海外名师团队任教， 为用户提供“名师专家课程”与“课后练习模考”的在线生态GMAT学习系统。";
	}
	return _textView;
}


@end
