//
//  HTKnowledgeDetailController.m
//  GMat
//
//  Created by hublot on 16/10/12.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTKnowledgeDetailController.h"
#import "NSString+HTString.h"
#import "NSMutableAttributedString+HTMutableAttributedString.h"
#import "UIScrollView+HTRefresh.h"
#import "HTMineFontSizeController.h"

@interface HTKnowledgeDetailController ()

@property (nonatomic, strong) UITextView *textView;

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
			
			NSAttributedString *attributedString = [[response[@"data"][@"contenttext"] ht_htmlDecodeString] ht_attributedStringNeedDispatcher:nil];
			weakSelf.textView.attributedText = attributedString;
			[weakSelf.textView.textStorage ht_changeFontWithPointSize:14 * userFontZoomNumber];
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

- (UITextView *)textView {
	if (!_textView) {
		_textView = [[UITextView alloc] init];
		_textView.alwaysBounceVertical = true;
		_textView.textContainerInset = UIEdgeInsetsMake(15, 15, 15, 15);
        _textView.editable = false;
	}
	return _textView;
}


@end
