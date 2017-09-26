//
//  HTImageTextView.m
//  GMat
//
//  Created by hublot on 2017/7/6.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTImageTextView.h"

@interface HTImageTextView () <UITextViewDelegate>

@property (nonatomic, assign) CGFloat textViewMaxWidth;

@property (nonatomic, copy) HTDidSelectedURLBlock didSelectedURLBlock;

@property (nonatomic, copy) HTReloadHeightBlock reloadHeightBlock;

@end

@implementation HTImageTextView

- (instancetype)init {
	if (self = [super init]) {
		[self initalizeDefault];
	}
	return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self initalizeDefault];
	}
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super initWithCoder:aDecoder]) {
		[self initalizeDefault];
	}
	return self;
}

- (void)initalizeDefault {
	self.delegate = self;
	self.textContainerInset = UIEdgeInsetsZero;
	self.selectable = true;
	self.editable = false;
	self.scrollEnabled = false;
	self.dataDetectorTypes = UIDataDetectorTypeLink | UIDataDetectorTypeAddress;
}

- (void)setAttributedString:(NSAttributedString *)attributedString textViewMaxWidth:(CGFloat)textViewMaxWidth appendImageBaseURLBlock:(HTAppendImageBaseURLBlock)appendImageBaseURLBlock reloadHeightBlock:(HTReloadHeightBlock)reloadHeightBlock didSelectedURLBlock:(HTDidSelectedURLBlock)didSelectedURLBlock {
	
	self.textViewMaxWidth = textViewMaxWidth;
	self.reloadHeightBlock = reloadHeightBlock;
	self.didSelectedURLBlock = didSelectedURLBlock;
	
	__weak typeof(self) weakSelf = self;
	NSAttributedString *imageAttributedString = [attributedString mutableCopy];
	[attributedString ht_EnumerateAttribute:NSAttachmentAttributeName usingBlock:^(NSTextAttachment *textAttachment, NSRange range, BOOL *stop) {
		if (textAttachment.ht_imageSourceString.length) {
			NSString *imageSourceString = textAttachment.ht_imageSourceString;
			if (appendImageBaseURLBlock) {
				imageSourceString = appendImageBaseURLBlock(weakSelf, imageSourceString);
			}
			[[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:imageSourceString] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
				if (image) {
					textAttachment.image = image;
					textAttachment.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
					[textAttachment ht_sizeThatFitWithMaxWidth:textViewMaxWidth];
					textAttachment.fileWrapper = nil;
					textAttachment.ht_imageSourceString = nil;
					
					weakSelf.attributedText = nil;
					weakSelf.attributedText = imageAttributedString;
					
					[NSObject cancelPreviousPerformRequestsWithTarget:weakSelf selector:@selector(computeQuestionViewHeight) object:nil];
					[weakSelf performSelector:@selector(computeQuestionViewHeight) withObject:nil afterDelay:0.1];
					
				}
			}];
		}
	}];
	
	self.attributedText = attributedString;
	[self computeQuestionViewHeight];

}

- (void)computeQuestionViewHeight {
	CGFloat contentHeight = [self.attributedText ht_attributedStringHeightWithWidth:self.textViewMaxWidth textView:self];
	if (self.reloadHeightBlock) {
		self.reloadHeightBlock(self, contentHeight);
	}
}


- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
	NSString *titleName = [textView.textStorage.string substringWithRange:characterRange];
	if (self.didSelectedURLBlock) {
		self.didSelectedURLBlock(self, URL, titleName);
	}
	return false;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
	return [self textView:textView shouldInteractWithURL:URL inRange:characterRange interaction:UITextItemInteractionInvokeDefaultAction];
}

@end
