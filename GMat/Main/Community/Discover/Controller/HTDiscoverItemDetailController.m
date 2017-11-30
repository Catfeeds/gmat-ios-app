//
//  HTDiscoverItemDetailController.m
//  GMat
//
//  Created by hublot on 2017/7/5.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTDiscoverItemDetailController.h"
#import "HTImageTextView.h"
#import "UIScrollView+HTRefresh.h"
#import "HTMineFontSizeController.h"
#import "HTWebController.h"

@interface HTDiscoverItemDetailController () <UITextViewDelegate>

@property (nonatomic, strong) HTImageTextView *textView;

@end

@implementation HTDiscoverItemDetailController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initializeDataSource];
	[self initializeUserInterface];
}

- (void)initializeDataSource {
	
	__weak typeof(self) weakSelf = self;
	HTNetworkModel *networkModel = [HTNetworkModel modelForOnlyCacheNoInterfaceForScrollViewWithCacheStyle:HTCacheStyleAllUser];
	CGFloat userFontZoomNumber = [HTMineFontSizeController fontZoomNumber];
	
	[self.textView ht_setRefreshBlock:^(NSString *pageSize, NSString *currentPage) {		
		[HTRequestManager requestDiscoverGmatExamAttentionWithNetworkModel:networkModel attentionId:weakSelf.attentionModel.itemId complete:^(id response, HTError *errorModel) {
			if (errorModel.existError) {
				[weakSelf.textView ht_endRefreshWithModelArrayCount:errorModel.errorType];
				return;
			}
			[weakSelf.textView ht_endRefreshWithModelArrayCount:1];
			
			NSMutableAttributedString *attributedString = [[[response[@"contenttext"] ht_htmlDecodeString] ht_handleFillPlaceHolderImageWithMaxWidth:HTSCREENWIDTH - 30 placeholderImage:HTPLACEHOLDERIMAGE] mutableCopy];
			[attributedString ht_changeFontWithPointSize:14 * userFontZoomNumber];
			
			[attributedString ht_EnumerateAttribute:NSParagraphStyleAttributeName usingBlock:^(NSParagraphStyle *style, NSRange range, BOOL *stop) {
				NSMutableParagraphStyle *resetStyle = [style mutableCopy];
				resetStyle.paragraphSpacing /= 6;
				[attributedString addAttributes:@{NSParagraphStyleAttributeName:resetStyle} range:range];
			}];
			
			[weakSelf.textView setAttributedString:attributedString textViewMaxWidth:HTSCREENWIDTH - 30 appendImageBaseURLBlock:^NSString *(UITextView *textView, NSString *imagePath) {
				if (![imagePath containsString:@"http"]) {
					return GmatResourse(imagePath);
				}
				return imagePath;
			} reloadHeightBlock:^(UITextView *textView, CGFloat contentHeight) {
				
			} didSelectedURLBlock:^(UITextView *textView, NSURL *URL, NSString *titleName) {
				HTWebController *webController = [[HTWebController alloc] initWithURL:URL];
				[weakSelf.navigationController pushViewController:webController animated:true];
			}];
			
		}];
	}];
	[self.textView ht_startRefreshHeader];
}

- (void)initializeUserInterface {
	self.navigationItem.title = self.attentionModel.titleName;
	[self.view addSubview:self.textView];
}

- (HTImageTextView *)textView {
	if (!_textView) {
		_textView = [[HTImageTextView alloc] initWithFrame:self.view.bounds];
		_textView.alwaysBounceVertical = true;
		_textView.textContainerInset = UIEdgeInsetsMake(15, 15, 15, 15);
		_textView.scrollEnabled = true;
	}
	return _textView;
}

@end
