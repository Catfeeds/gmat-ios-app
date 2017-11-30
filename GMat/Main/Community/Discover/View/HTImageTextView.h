//
//  HTImageTextView.h
//  GMat
//
//  Created by hublot on 2017/7/6.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NSAttributedString+HTAttributedString.h>
#import <NSTextAttachment+HTTextAttachment.h>
#import <NSString+HTString.h>
#import <NSMutableAttributedString+HTMutableAttributedString.h>

typedef NSString *(^HTAppendImageBaseURLBlock)(UITextView *textView, NSString *imagePath);

typedef void(^HTReloadHeightBlock)(UITextView *textView, CGFloat contentHeight);

typedef void(^HTDidSelectedURLBlock)(UITextView *textView, NSURL *URL, NSString *titleName);

@interface HTImageTextView : UITextView

- (void)setAttributedString:(NSAttributedString *)attributedString textViewMaxWidth:(CGFloat)textViewMaxWidth appendImageBaseURLBlock:(HTAppendImageBaseURLBlock)appendImageBaseURLBlock reloadHeightBlock:(HTReloadHeightBlock)reloadHeightBlock didSelectedURLBlock:(HTDidSelectedURLBlock)didSelectedURLBlock;

@end
