//
//  HTKnowledgeDetailController.m
//  GMat
//
//  Created by hublot on 16/10/12.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTKnowledgeDetailController.h"
#import "NSString+HTString.h"
#import <NSAttributedString+HTAttributedString.h>
#import "NSMutableAttributedString+HTMutableAttributedString.h"
#import "UIScrollView+HTRefresh.h"
#import "HTMineFontSizeController.h"
#import "HTImageTextView.h"
#import "HTWebController.h"

@interface HTKnowledgeDetailController ()

@property (nonatomic, strong) HTImageTextView *textView;

@end

@implementation HTKnowledgeDetailController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initializeDataSource];
	[self initializeUserInterface];
}

- (void)initializeDataSource {
    __weak HTKnowledgeDetailController *weakSelf = self;
	HTNetworkModel *networkModel = [HTNetworkModel modelForOnlyCacheNoInterfaceForScrollViewWithCacheStyle:HTCacheStyleAllUser];
	
	CGFloat userFontZoomNumber = [HTMineFontSizeController fontZoomNumber];
	
	[self.textView ht_setRefreshBlock:^(NSString *pageSize, NSString *currentPage) {
		
		[HTRequestManager requestKnowledgeDetailWithNetworkModel:networkModel knowledgeContentId:weakSelf.detailModel.contentid complete:^(id response, HTError *errorModel) {
			
			if (errorModel.existError) {
				[weakSelf.textView ht_endRefreshWithModelArrayCount:errorModel.errorType];
				return;
			}
			[weakSelf.textView ht_endRefreshWithModelArrayCount:1];
			
			NSMutableAttributedString *attributedString = [[[response[@"data"][@"contenttext"] ht_htmlDecodeString] ht_handleFillPlaceHolderImageWithMaxWidth:HTSCREENWIDTH - 30 placeholderImage:HTPLACEHOLDERIMAGE] mutableCopy];
			[attributedString ht_changeFontWithPointSize:14 * userFontZoomNumber];
//			[attributedString ht_clearSuffixBreakLine];
//			[attributedString ht_clearPrefixBreakLine];
			[attributedString ht_clearBreakLineMaxAllowContinueCount:1];
			
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
	self.navigationItem.title = self.detailModel.contenttitle;
	[self.view addSubview:self.textView];
	[self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.edges.mas_equalTo(UIEdgeInsetsZero);
	}];
}

- (HTImageTextView *)textView {
	if (!_textView) {
		_textView = [[HTImageTextView alloc] init];
		_textView.textContainerInset = UIEdgeInsetsMake(15, 15, 15, 15);
		_textView.alwaysBounceVertical = true;
		_textView.scrollEnabled = true;
		_textView.selectable = true;
        _textView.editable = false;
	}
	return _textView;
}


@end
