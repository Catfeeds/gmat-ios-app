//
//  THToeflDiscoverDetailHeaderView.m
//  TingApp
//
//  Created by hublot on 16/9/7.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "THToeflDiscoverDetailHeaderView.h"
#import "THToeflDiscoverModel.h"
#import "HTImageTextView.h"
#import <UIButton+HTButtonCategory.h>
#import "HTWebController.h"
#import "HTDownloadProgressController.h"
#import "HTFileDownloadManager.h"
#import "HTUserManager.h"
#import "HTLoginManager.h"
#import <UIScrollView+HTRefresh.h>

static NSString *kHTAppleDataURLString = @"applewebdata://";

static NSString *kHTPermissionURLString = @"-ht_permission-";

static NSString *kHTDownloadURLPrefixString = @"http://bbs.viplgw.cn";

@interface THToeflDiscoverDetailHeaderView () <UITextViewDelegate>

@property (nonatomic, strong) UITableView *superForHeaderTableView;

@property (nonatomic, strong) UILabel *titleNameLabel;

@property (nonatomic, strong) UIButton *detailLookButton;

@property (nonatomic, strong) UIButton *detailReceiveButton;

@property (nonatomic, strong) UIButton *sendTimeButton;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) HTImageTextView *contentTextView;

@property (nonatomic, strong) THToeflDiscoverModel *model;

@end

@implementation THToeflDiscoverDetailHeaderView

- (void)didMoveToSuperview {
	self.backgroundColor = [UIColor whiteColor];
	[self addSubview:self.titleNameLabel];
	[self addSubview:self.detailLookButton];
	[self addSubview:self.detailReceiveButton];
	[self addSubview:self.sendTimeButton];
	[self addSubview:self.lineView];
	[self addSubview:self.contentTextView];
	[self.titleNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(15);
		make.left.mas_equalTo(15);
		make.right.mas_equalTo(- 15);
	}];
	[self.detailLookButton mas_updateConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(self.titleNameLabel.mas_bottom).offset(15);
		make.left.mas_equalTo(self.titleNameLabel);
	}];
	[self.detailReceiveButton mas_updateConstraints:^(MASConstraintMaker *make) {
		make.centerY.mas_equalTo(self.detailLookButton);
		make.left.mas_equalTo(self.detailLookButton.mas_right).offset(20);
	}];
	[self.sendTimeButton mas_updateConstraints:^(MASConstraintMaker *make) {
		make.centerY.mas_equalTo(self.detailLookButton);
		make.left.mas_equalTo(self.detailReceiveButton.mas_right).offset(20);
	}];
	[self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(self.titleNameLabel);
		make.right.mas_equalTo(self.titleNameLabel);
		make.height.mas_equalTo(1 / [UIScreen mainScreen].scale);
		make.top.mas_equalTo(self.detailLookButton.mas_bottom).offset(15);
	}];
	[self.contentTextView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(self.titleNameLabel);
		make.right.mas_equalTo(self.titleNameLabel);
		make.top.mas_equalTo(self.lineView.mas_bottom).offset(10);
		make.bottom.mas_equalTo(- 10);
	}];
}

- (void)setModel:(THToeflDiscoverModel *)model tableView:(UITableView *)tableView {
	_model = model;
	__weak typeof(self) weakSelf = self;
	self.superForHeaderTableView = tableView;
	self.titleNameLabel.font = [[UIFont ht_fontStyle:HTFontStyleHeadSmall] ht_userSizeFont];
	self.titleNameLabel.text = model.title;
	[self.detailLookButton setTitle:model.viewCount forState:UIControlStateNormal];
	[self.detailReceiveButton setTitle:[NSString stringWithFormat:@"%ld", model.Reply.count] forState:UIControlStateNormal];
	[self.sendTimeButton setTitle:[NSString stringWithFormat:@"发布于 %@", model.dateTime] forState:UIControlStateNormal];
	
	NSMutableAttributedString *attributedString = [[model.content ht_handleFillPlaceHolderImageWithMaxWidth:HTSCREENWIDTH - 30 placeholderImage:HTPLACEHOLDERIMAGE] mutableCopy];
	
	
	
	
	NSMutableArray *resourseArray = [@[] mutableCopy];
	[resourseArray addObjectsFromArray:model.datum];
	[resourseArray addObjectsFromArray:model.radio];
	
	NSMutableArray *resoureTitleArray = [@[] mutableCopy];
	[resoureTitleArray addObjectsFromArray:model.datumTitle];
	[resoureTitleArray addObjectsFromArray:model.radioTitle];
	
	[resourseArray enumerateObjectsUsingBlock:^(NSString *address, NSUInteger index, BOOL * _Nonnull stop) {
		if (resoureTitleArray.count > index) {
			NSString *resourseTitle = resoureTitleArray[index];
			NSString *permissionAddress = [NSString stringWithFormat:@"%@%@", kHTPermissionURLString, address];
			
			NSMutableAttributedString *appendAttributedString = [[[NSAttributedString alloc] initWithString:resourseTitle] mutableCopy];
			[appendAttributedString addAttributes:@{NSLinkAttributeName:permissionAddress,
													NSFontAttributeName:[UIFont systemFontOfSize:15],
													NSUnderlineStyleAttributeName:@(1)} range:NSMakeRange(0, appendAttributedString.length)];
			
			[attributedString appendAttributedString:appendAttributedString];
			appendAttributedString = [[[NSAttributedString alloc] initWithString:@"\n\n"] mutableCopy];
			[attributedString appendAttributedString:appendAttributedString];
			
		}
	}];
	
	
	
	
	[attributedString ht_EnumerateAttribute:NSFontAttributeName usingBlock:^(UIFont *font, NSRange range, BOOL *stop) {
		if (font.pointSize < 14) {
			UIFont *resetFont = [UIFont fontWithDescriptor:font.fontDescriptor size:14];
			[attributedString addAttributes:@{NSFontAttributeName:resetFont} range:range];
		}
	}];
	
	[self.contentTextView setAttributedString:attributedString textViewMaxWidth:HTSCREENWIDTH - 30 appendImageBaseURLBlock:^NSString *(UITextView *textView, NSString *imagePath) {
		if (![imagePath containsString:@"http"]) {
			return [NSString stringWithFormat:@"http://bbs.viplgw.cn/%@", imagePath];
		}
		return imagePath;
	} reloadHeightBlock:^(UITextView *textView, CGFloat contentHeight) {
		[weakSelf computeQuestionViewHeightWithContentTextViewHeight:contentHeight];
	} didSelectedURLBlock:^(UITextView *textView, NSURL *URL, NSString *titleName) {
		NSString *absoluteString = URL.absoluteString;
		
		void(^startDownloadBlock)(NSString *downloadURL, NSString *fileName) = ^(NSString *downloadURL, NSString *fileName) {
			
			[HTFileDownloadManager startDownloadFileUrlString:downloadURL saveFileName:fileName];
			
			HTDownloadProgressController *downloadController = [[HTDownloadProgressController alloc] init];
			[weakSelf.ht_controller.navigationController pushViewController:downloadController animated:true];
		};
		
		if ([absoluteString containsString:kHTAppleDataURLString]) {
			
			NSRange fileStartRange = [absoluteString rangeOfString:@"/" options:NSCaseInsensitiveSearch range:NSMakeRange(kHTAppleDataURLString.length, absoluteString.length - kHTAppleDataURLString.length)];
			NSString *fileURLString = [absoluteString substringFromIndex:fileStartRange.location];
			fileURLString = [NSString stringWithFormat:@"%@%@", kHTDownloadURLPrefixString, fileURLString];
			
			startDownloadBlock(fileURLString, titleName);
			
		} else if ([absoluteString containsString:kHTPermissionURLString]) {
			NSString *fileURLString = [absoluteString stringByReplacingOccurrencesOfString:kHTPermissionURLString withString:@""];
			fileURLString = [NSString stringWithFormat:@"%@%@", kHTDownloadURLPrefixString, fileURLString];
			
			if (!weakSelf.model.isReply) {
				if ([HTUserManager currentUser].permission >= HTUserPermissionExerciseAbleUser) {
					if (weakSelf.callReplyKeyboard) {
						weakSelf.callReplyKeyboard();
					}
				} else {
					[HTAlert title:@"需要登录才能继续哦😲" sureAction:^{
						[HTLoginManager presentAndLoginSuccess:^{
							[weakSelf.superForHeaderTableView ht_startRefreshHeader];
						}];
					}];
				}
			} else {
				startDownloadBlock(fileURLString, titleName);
			}
		} else {
			HTWebController *webController = [[HTWebController alloc] initWithURL:URL];
			[weakSelf.ht_controller.navigationController pushViewController:webController animated:true];
		}
	}];
}

- (void)computeQuestionViewHeightWithContentTextViewHeight:(CGFloat)textViewHeight {
	self.ht_h = textViewHeight + 20 + 90;
	self.superForHeaderTableView.tableHeaderView = self;
}

- (UILabel *)titleNameLabel {
	if (!_titleNameLabel) {
		_titleNameLabel = [[UILabel alloc] init];
		_titleNameLabel.textColor = [UIColor ht_colorStyle:HTColorStylePrimaryTitle];
	}
	return _titleNameLabel;
}

- (UIButton *)detailLookButton {
	if (!_detailLookButton) {
		_detailLookButton = [[UIButton alloc] init];
		[_detailLookButton setImage:[[UIImage imageNamed:@"Toeflxiaoxi"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
		[_detailLookButton setTitleColor:[UIColor ht_colorStyle:HTColorStyleSecondaryTitle] forState:UIControlStateNormal];
		_detailLookButton.titleLabel.font = [UIFont ht_fontStyle:HTFontStyleDetailSmall];
		[_detailLookButton ht_makeEdgeWithDirection:HTButtonEdgeDirectionHorizontal imageViewToTitleLabelSpeceOffset:3];
	}
	return _detailLookButton;
}

- (UIButton *)detailReceiveButton {
	if (!_detailReceiveButton) {
		_detailReceiveButton = [[UIButton alloc] init];
		[_detailReceiveButton setImage:[[UIImage imageNamed:@"Toeflliaotian"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
		[_detailReceiveButton setTitleColor:[UIColor ht_colorStyle:HTColorStyleSecondaryTitle] forState:UIControlStateNormal];
		_detailReceiveButton.titleLabel.font = [UIFont ht_fontStyle:HTFontStyleDetailSmall];
		[_detailReceiveButton ht_makeEdgeWithDirection:HTButtonEdgeDirectionHorizontal imageViewToTitleLabelSpeceOffset:3];
	}
	return _detailReceiveButton;
}

- (UIButton *)sendTimeButton {
	if (!_sendTimeButton) {
		_sendTimeButton = [[UIButton alloc] init];
		_sendTimeButton.titleLabel.font = [UIFont ht_fontStyle:HTFontStyleDetailSmall];
		[_sendTimeButton setTitleColor:[UIColor ht_colorStyle:HTColorStyleSecondaryTitle] forState:UIControlStateNormal];
	}
	return _sendTimeButton;
}

- (UIView *)lineView {
	if (!_lineView) {
		_lineView = [[UIView alloc] init];
		_lineView.backgroundColor = [UIColor ht_colorString:@"e6e6e6"];
	}
	return _lineView;
}

- (HTImageTextView *)contentTextView {
	if (!_contentTextView) {
		_contentTextView = [[HTImageTextView alloc] init];
		_contentTextView.font = [UIFont ht_fontStyle:HTFontStyleDetailLarge];
		_contentTextView.textColor = [UIColor ht_colorStyle:HTColorStylePrimaryTitle];
	}
	return _contentTextView;
}

@end
