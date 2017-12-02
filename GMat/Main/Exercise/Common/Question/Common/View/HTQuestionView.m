//
//  HTQuestionView.m
//  GMat
//
//  Created by hublot on 2016/11/9.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTQuestionView.h"
#import <UITableView+HTSeparate.h>
#import "HTQuestionCell.h"
#import "HTQuestionParseCell.h"
#import "NSString+HTString.h"
#import "NSAttributedString+HTAttributedString.h"
#import "NSMutableAttributedString+HTMutableAttributedString.h"
#import "NSTextAttachment+HTTextAttachment.h"
#import "HTMineFontSizeController.h"
#import <UIButton+HTButtonCategory.h>
#import "HTDiscussController.h"

@interface HTQuestionView () <UITextViewDelegate>

@property (nonatomic, strong) UITextView *headerReadTextView;

@property (nonatomic, strong) UITextView *titleQuestionTextView;

@property (nonatomic, strong) UIView *titleQuestionLineSelctedView;

@property (nonatomic, strong) UITableView *answerSelectedTableView;

@property (nonatomic, strong) UILabel *userExerciseDurationLabel;


@property (nonatomic, strong) UIButton *bottomDiscussButton;

@property (nonatomic, strong) UITableView *bottomUserParseTableView;

@property (nonatomic, strong) UITableView *superForHeaderTableView;

@property (nonatomic, assign) NSInteger answerSelectedIndex;



@property (nonatomic, strong) HTQuestionModel *model;

@end

@implementation HTQuestionView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
	if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(computeQuestionViewHeight) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadQuestionViewFontNotifacation) name:kHTFontChangeNotification object:nil];
		
		[self immobilizationEdgeAndAddSubView];
	}
	return self;
}

- (void)immobilizationEdgeAndAddSubView {
	
	[self addSubview:self.headerReadTextView];
	[self addSubview:self.titleQuestionTextView];
	[self addSubview:self.titleQuestionLineSelctedView];
	[self addSubview:self.answerSelectedTableView];
	
	[self addSubview:self.userExerciseDurationLabel];
	[self addSubview:self.bottomRightAnswerLabel];
	[self addSubview:self.bottomDiscussButton];
	[self addSubview:self.bottomUserParseTableView];
	
    __weak HTQuestionView *weakSelf = self;
	void(^sameEdgeForLeftAndRight)(MASConstraintMaker *make) = ^(MASConstraintMaker *make) {
		make.left.mas_equalTo(weakSelf).offset(15);
		make.right.mas_equalTo(weakSelf).offset(- 15);
	};
	
	[self.headerReadTextView mas_updateConstraints:^(MASConstraintMaker *make) {
		sameEdgeForLeftAndRight(make);
	}];
	
	[self.titleQuestionTextView mas_updateConstraints:^(MASConstraintMaker *make) {
		sameEdgeForLeftAndRight(make);
		make.top.mas_equalTo(weakSelf.headerReadTextView.mas_bottom).offset(15);
	}];
	[self.titleQuestionLineSelctedView mas_updateConstraints:^(MASConstraintMaker *make) {
		sameEdgeForLeftAndRight(make);
		make.top.mas_equalTo(weakSelf.titleQuestionTextView.mas_bottom).offset(0);
		make.height.mas_equalTo(1 / [UIScreen mainScreen].scale);
	}];
	[self.answerSelectedTableView mas_updateConstraints:^(MASConstraintMaker *make) {
		sameEdgeForLeftAndRight(make);
		make.top.mas_equalTo(weakSelf.titleQuestionLineSelctedView.mas_bottom);
	}];
	
	[self.userExerciseDurationLabel mas_updateConstraints:^(MASConstraintMaker *make) {
		sameEdgeForLeftAndRight(make);
		make.top.mas_equalTo(weakSelf.answerSelectedTableView.mas_bottom).offset(7.5);
	}];
	[self.bottomRightAnswerLabel mas_updateConstraints:^(MASConstraintMaker *make) {
		sameEdgeForLeftAndRight(make);
		make.top.mas_equalTo(weakSelf.userExerciseDurationLabel.mas_bottom).offset(7.5);
		make.height.mas_equalTo(40);
	}];
	[self.bottomDiscussButton mas_updateConstraints:^(MASConstraintMaker *make) {
		make.right.mas_equalTo(- 30);
		make.centerY.mas_equalTo(self.bottomRightAnswerLabel);
	}];
	[self.bottomUserParseTableView mas_updateConstraints:^(MASConstraintMaker *make) {
		sameEdgeForLeftAndRight(make);
		make.top.mas_equalTo(weakSelf.bottomRightAnswerLabel.mas_bottom);
	}];
}

- (void)reloadQuestionViewFontNotifacation {
	NSInteger answerSelectedIndex = self.answerSelectedIndex;
	NSString *userSelectedAnswer = self.userSelectedAnswer;
	[self setModel:self.model tableView:self.superForHeaderTableView];
	if (answerSelectedIndex > - 1) {
		self.answerSelectedIndex = answerSelectedIndex;
		self.userSelectedAnswer = userSelectedAnswer;
		@try {
			[self.answerSelectedTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.answerSelectedIndex inSection:0] animated:false scrollPosition:UITableViewScrollPositionNone];
		} @catch (NSException *exception) {
		} @finally {
		}
	}
}

- (void)setModel:(HTQuestionModel *)model tableView:(UITableView *)tableView {
	_model = model;
	self.superForHeaderTableView = tableView;
	self.answerSelectedIndex = - 1;
	self.userSelectedAnswer = @"";
	__weak HTQuestionView *weakSelf = self;
	CGFloat userFontZoomNumber = [HTMineFontSizeController fontZoomNumber];
	
	// 阅读材料
	NSMutableAttributedString *originFontHeaderAttributedString = [[[model.questionRead ht_htmlDecodeString] ht_attributedStringNeedDispatcher:nil] mutableCopy];
    [originFontHeaderAttributedString ht_clearPrefixBreakLine];
    [originFontHeaderAttributedString ht_clearSuffixBreakLine];
	[originFontHeaderAttributedString ht_changeFontWithPointSize:16 * userFontZoomNumber];
	self.headerReadTextView.attributedText = originFontHeaderAttributedString;
	
//	[self.headerReadTextView scrollRectToVisible:CGRectZero animated:true];
//	[self.headerReadTextView.attributedText ht_EnumerateAttribute:NSBackgroundColorAttributeName usingBlock:^(UIColor *backgroundColor, NSRange range, BOOL *stop) {
//		[weakSelf.headerReadTextView scrollRangeToVisible:range];
//		*stop = true;
//	}];
	
	// 问题
	NSMutableAttributedString *originFontTitleAttributedString = [[[model.questionTitle ht_htmlDecodeString] ht_handleFillPlaceHolderImageWithMaxWidth:HTSCREENWIDTH - 60 placeholderImage:[UIImage imageNamed:@"ExerciseReloadImageSmall"]] mutableCopy];
    [originFontTitleAttributedString ht_clearPrefixBreakLine];
    [originFontTitleAttributedString ht_clearSuffixBreakLine];
	[originFontTitleAttributedString ht_changeFontWithPointSize:16 * userFontZoomNumber];
	self.titleQuestionTextView.attributedText = originFontTitleAttributedString;
	[self.titleQuestionTextView scrollRectToVisible:CGRectZero animated:true];
	self.titleQuestionTextView.delegate = self;
	[originFontTitleAttributedString ht_EnumerateAttribute:NSAttachmentAttributeName usingBlock:^(NSTextAttachment *textAttachment, NSRange range, BOOL * _Nonnull stop) {
		[weakSelf textView:weakSelf.titleQuestionTextView shouldInteractWithTextAttachment:textAttachment inRange:range];
	}];
	
	// 选项
	
	NSMutableArray *questionSelectedAttributedArray = [@[] mutableCopy];
	[model.questionSelectedArray enumerateObjectsUsingBlock:^(NSString * _Nonnull selectedString, NSUInteger idx, BOOL * _Nonnull stop) {
		NSMutableAttributedString *originTitleAttributedString = [[selectedString ht_handleFillPlaceHolderImageWithMaxWidth:HTSCREENWIDTH - 60 placeholderImage:[UIImage imageNamed:@"ExerciseReloadImageSmall"]] mutableCopy];
        [originTitleAttributedString ht_clearBreakLineMaxAllowContinueCount:0];
		[originTitleAttributedString ht_changeFontWithPointSize:16 * userFontZoomNumber];
		[questionSelectedAttributedArray addObject:originTitleAttributedString];
	}];
	
	[self.answerSelectedTableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
		[[[[sectionMaker.modelArray(questionSelectedAttributedArray) customCellBlock:^(UITableView *tableView, NSInteger row, __kindof HTQuestionCell *cell, __kindof NSObject *stringModel) {
			if (model.userAnswer && model.trueAnswer) {
				cell.userInteractionEnabled = true;
				NSString *rowTitleName = [NSString stringWithFormat:@"%c", (char)('A' + row)];
				if ([model.userSelectedAnswer isEqualToString:rowTitleName]) {
					[tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] animated:false scrollPosition:UITableViewScrollPositionNone];
					cell.selected = true;
				}
				if ([model.userAnswer isEqualToString:rowTitleName]) {
					cell.userInteractionEnabled = false;
					cell.cellSelectedColor = [UIColor ht_colorStyle:HTColorStyleAnswerWrong];
				}
				if ([model.trueAnswer isEqualToString:rowTitleName]) {
					cell.userInteractionEnabled = false;
					cell.cellSelectedColor = [UIColor ht_colorStyle:HTColorStyleAnswerRight];
				}
			}
		}] didSelectedCellBlock:^(UITableView *tableView, NSInteger row, __kindof HTQuestionCell *cell, __kindof NSObject *stringModel) {
			weakSelf.answerSelectedIndex = row;
			weakSelf.userSelectedAnswer = [NSString stringWithFormat:@"%c", (char)('A' + row)];
			model.userSelectedAnswer = weakSelf.userSelectedAnswer;
			[cell.detailTextView.textStorage ht_EnumerateAttribute:NSAttachmentAttributeName usingBlock:^(NSTextAttachment *textAttachment, NSRange range, BOOL *stop) {
				[weakSelf textView:cell.detailTextView shouldInteractWithTextAttachment:textAttachment inRange:range];
			}];
		}] diddeSelectedCellBlock:^(UITableView *tableView, NSInteger row, __kindof UITableViewCell *cell, __kindof NSObject *model) {
			
		}] willDisplayCellBlock:^(UITableView *tableView, NSInteger row, __kindof HTQuestionCell *cell, __kindof NSObject *model) {
			cell.detailTextView.delegate = weakSelf;
			[cell.detailTextView.textStorage ht_EnumerateAttribute:NSAttachmentAttributeName usingBlock:^(NSTextAttachment *textAttachment, NSRange range, BOOL *stop) {
				[weakSelf textView:cell.detailTextView shouldInteractWithTextAttachment:textAttachment inRange:range];
			}];
		}];
	}];
	
	// 做题时间
	NSMutableAttributedString *exerciseDurationAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"用时: %ld s", model.questionDuration]];
	[exerciseDurationAttributedString addAttributes:@{NSForegroundColorAttributeName:[UIColor ht_colorStyle:HTColorStylePrimaryTheme]} range:NSMakeRange(0, exerciseDurationAttributedString.length)];
	[exerciseDurationAttributedString addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:13 * userFontZoomNumber]} range:NSMakeRange(0, 3)];
	[exerciseDurationAttributedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13 * userFontZoomNumber]} range:NSMakeRange(3, exerciseDurationAttributedString.length - 3)];
	self.userExerciseDurationLabel.attributedText = exerciseDurationAttributedString;
	
	// 正确答案
	NSMutableAttributedString *rightAnswerAttribuedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"正确答案: %@", model.trueAnswer]];
	NSMutableParagraphStyle *rightAnswerParagraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
	rightAnswerParagraphStyle.firstLineHeadIndent = 15;
	rightAnswerParagraphStyle.headIndent = 15;
	rightAnswerParagraphStyle.tailIndent = - 15;
	[rightAnswerAttribuedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:[UIColor ht_colorStyle:HTColorStylePrimaryTheme], NSParagraphStyleAttributeName:rightAnswerParagraphStyle} range:NSMakeRange(0, rightAnswerAttribuedString.length)];
	self.bottomRightAnswerLabel.attributedText = rightAnswerAttribuedString;
	
	// 用户解析
	[model.questionParseArray enumerateObjectsUsingBlock:^(HTQuestionParseModel *parseModel, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableAttributedString *parseContentAttributedString = [[[parseModel.parseDetailContent ht_htmlDecodeString] ht_attributedStringNeedDispatcher:nil] mutableCopy];
        [parseContentAttributedString ht_clearPrefixBreakLine];
        [parseContentAttributedString ht_clearSuffixBreakLine];
		parseModel.parseContentAttributedString = parseContentAttributedString;
	}];
	[self.bottomUserParseTableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
		sectionMaker.modelArray(model.questionParseArray);
	}];

	[self computeQuestionViewHeight];
}

- (void)computeQuestionViewHeight {
	
	if (!self.superForHeaderTableView) {
		return;
	}
    __weak typeof(self) weakSelf = self;
	
	// 控件高度
	CGFloat headerTextViewHeight = 0;
	CGFloat titleTextViewHeight = 0;
	__block CGFloat answerSelectedTableViewHeight = 0;
	__block CGFloat showAnswerUserParseTabelViewHeight = 0;
	
	// 可变分块的高度
	__block CGFloat mutableHeaderContentTextViewHeight = 0;
	__block CGFloat mutableUserExerciseDurationHeight = 0;
	__block CGFloat mutableRightAndParseContentHeight = 0;
	
	/**
	 * MARK: 阅读材料
	 */
	CGFloat originReallyHeaderTextViewHeight = [self.headerReadTextView.textStorage ht_attributedStringHeightWithWidth:HTSCREENWIDTH - 30 textView:self.headerReadTextView];
	if (!self.headerReadTextView.textStorage.length) {
		originReallyHeaderTextViewHeight = 0;
	}
	if (!self.headerReadTextView.scrollEnabled) {
		headerTextViewHeight = originReallyHeaderTextViewHeight;
	} else {
		headerTextViewHeight = MIN(200, originReallyHeaderTextViewHeight);
	}
	
	[self.headerReadTextView mas_updateConstraints:^(MASConstraintMaker *make) {
		if (headerTextViewHeight > 0) {
			make.top.mas_equalTo(15);
			mutableHeaderContentTextViewHeight = 15;
		} else {
			make.top.mas_equalTo(weakSelf);
		}
		mutableHeaderContentTextViewHeight += headerTextViewHeight;
		make.height.mas_equalTo(headerTextViewHeight);
	}];
	
	/**
	 * MARK: 问题
	 */
	titleTextViewHeight = [self.titleQuestionTextView.textStorage ht_attributedStringHeightWithWidth:HTSCREENWIDTH - 30 textView:self.titleQuestionTextView];
	
	CGFloat width = CGRectGetWidth(self.titleQuestionTextView.frame);
	CGSize newSize = [self.titleQuestionTextView sizeThatFits:CGSizeMake(width,MAXFLOAT)];

	[self.titleQuestionTextView mas_updateConstraints:^(MASConstraintMaker *make) {
		
	//	make.height.mas_equalTo(titleTextViewHeight);
		make.height.mas_equalTo(fmax(titleTextViewHeight, newSize.height));
	}];
	
	
	

	
	/**
	 * MARK: 选项
	 */
	
	[self.answerSelectedTableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
		sectionMaker.modelArray([sectionMaker.section.modelArray mutableCopy]);
	}];
	
	[self.answerSelectedTableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
		answerSelectedTableViewHeight = sectionMaker.section.sumRowHeight;
	}];
	if (self.userSelectedAnswer.length) {
		NSInteger userSelectedIndex = [self.userSelectedAnswer characterAtIndex:0] - 'A';
		if ([self.answerSelectedTableView.dataSource tableView:self.answerSelectedTableView numberOfRowsInSection:0] > userSelectedIndex) {
			[self.answerSelectedTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:userSelectedIndex inSection:0] animated:false scrollPosition:UITableViewScrollPositionNone];
		}
	}
	
	[self.answerSelectedTableView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.height.mas_equalTo(answerSelectedTableViewHeight);
	}];
	
	/**
	 * MARK: 做题时间
	 */
	[self.userExerciseDurationLabel mas_updateConstraints:^(MASConstraintMaker *make) {
		if (weakSelf.showUserExerciseDuration) {
			make.height.mas_equalTo(20);
			mutableUserExerciseDurationHeight = 20 + 7.5;
			weakSelf.userExerciseDurationLabel.hidden = false;
		} else {
			make.height.mas_equalTo(0);
			mutableUserExerciseDurationHeight = 0;
			weakSelf.userExerciseDurationLabel.hidden = true;
		}
	}];
	
	/**
	 * MARK: 用户解析
	 */
    [self.bottomUserParseTableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
        sectionMaker.modelArray([sectionMaker.section.modelArray mutableCopy]);
    }];
	[self.bottomUserParseTableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
		showAnswerUserParseTabelViewHeight = sectionMaker.section.sumRowHeight;
	}];
	
	[self.bottomUserParseTableView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.height.mas_equalTo(showAnswerUserParseTabelViewHeight);
		if (weakSelf.showUserAnswerParse) {
			mutableRightAndParseContentHeight = 7.5 + 40 + showAnswerUserParseTabelViewHeight;
			weakSelf.bottomRightAnswerLabel.hidden = false;
			weakSelf.bottomDiscussButton.hidden = false;
			weakSelf.bottomUserParseTableView.hidden = false;
		} else {
			mutableRightAndParseContentHeight = 0;
			weakSelf.bottomRightAnswerLabel.hidden = true;
			weakSelf.bottomDiscussButton.hidden = true;
			weakSelf.bottomUserParseTableView.hidden = true;
		}
	}];
	
	CGFloat questionViewSumHeight = 0;
	
	questionViewSumHeight = 0;
	questionViewSumHeight += mutableHeaderContentTextViewHeight;
	questionViewSumHeight += 15;
	questionViewSumHeight += titleTextViewHeight;
	questionViewSumHeight += 1 / [UIScreen mainScreen].scale;
	questionViewSumHeight += answerSelectedTableViewHeight;
	questionViewSumHeight += mutableUserExerciseDurationHeight;
	questionViewSumHeight += mutableRightAndParseContentHeight;
	questionViewSumHeight += 15;
    
	self.ht_h = questionViewSumHeight;
    
	self.superForHeaderTableView.tableHeaderView = self;
	
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange {
    if (textAttachment.ht_imageSourceString.length) {
        __weak HTQuestionView *weakSelf = self;
        NSAttributedString *attributedString = [textView.attributedText mutableCopy];
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:GmatResourse(textAttachment.ht_imageSourceString)] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
            if (image) {
                textAttachment.image = image;
                textAttachment.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
                [textAttachment ht_sizeThatFitWithMaxWidth:HTSCREENWIDTH - 60];
                textAttachment.fileWrapper = nil;
                textAttachment.ht_imageSourceString = @"";
                textView.attributedText = nil;
                textView.attributedText = attributedString;
				
				[NSObject cancelPreviousPerformRequestsWithTarget:weakSelf selector:@selector(computeQuestionViewHeight) object:nil];
				[weakSelf performSelector:@selector(computeQuestionViewHeight) withObject:nil afterDelay:0.2];
            }
        }];
    }
    return true;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    return [self textView:textView shouldInteractWithTextAttachment:textAttachment inRange:characterRange];
}

- (UITextView *)headerReadTextView {
	if (!_headerReadTextView) {
		_headerReadTextView = [[UITextView alloc] initWithFrame:CGRectZero];
		_headerReadTextView.textContainerInset = UIEdgeInsetsMake(10, 15, 10, 15);
		_headerReadTextView.alwaysBounceVertical = true;
		_headerReadTextView.backgroundColor = [UIColor whiteColor];
		_headerReadTextView.layer.cornerRadius = 3;
		_headerReadTextView.layer.masksToBounds = true;
		_headerReadTextView.editable = false;
		_headerReadTextView.selectable = false;
		_headerReadTextView.scrollsToTop = false;
        __weak HTQuestionView *weakSelf = self;
		[_headerReadTextView ht_whenTap:^(UIView *view) {
			weakSelf.headerReadTextView.scrollEnabled = !weakSelf.headerReadTextView.scrollEnabled;
			[weakSelf computeQuestionViewHeight];
		}];
	}
	return _headerReadTextView;
}

- (UITextView *)titleQuestionTextView {
	if (!_titleQuestionTextView) {
		_titleQuestionTextView = [[UITextView alloc] initWithFrame:CGRectZero];
		_titleQuestionTextView.textContainerInset = UIEdgeInsetsMake(10, 15, 10, 15);
		_titleQuestionTextView.editable = false;
		_titleQuestionTextView.selectable = true;
		_titleQuestionTextView.scrollsToTop = false;
		_titleQuestionTextView.scrollEnabled = false;
	}
	return _titleQuestionTextView;
}

- (UIView *)titleQuestionLineSelctedView {
	if (!_titleQuestionLineSelctedView) {
		_titleQuestionLineSelctedView = [[UIView alloc] init];
		_titleQuestionLineSelctedView.backgroundColor = [UIColor ht_colorStyle:HTColorStyleCompareBackground];
	}
	return _titleQuestionLineSelctedView;
}

- (UITableView *)answerSelectedTableView {
	if (!_answerSelectedTableView) {
		_answerSelectedTableView = [[UITableView alloc] init];
		_answerSelectedTableView.scrollEnabled = false;
		_answerSelectedTableView.scrollsToTop = false;
		_answerSelectedTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_answerSelectedTableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
            sectionMaker.cellClass([HTQuestionCell class]);
        }];
	}
	return _answerSelectedTableView;
}

- (UILabel *)userExerciseDurationLabel {
	if (!_userExerciseDurationLabel) {
		_userExerciseDurationLabel = [[UILabel alloc] init];
	}
	return _userExerciseDurationLabel;
}

- (UILabel *)bottomRightAnswerLabel {
	if (!_bottomRightAnswerLabel) {
		_bottomRightAnswerLabel = [[UILabel alloc] init];
		_bottomRightAnswerLabel.backgroundColor = [UIColor whiteColor];
	}
	return _bottomRightAnswerLabel;
}

- (UIButton *)bottomDiscussButton {
	if (!_bottomDiscussButton) {
		_bottomDiscussButton = [[UIButton alloc] init];
		_bottomDiscussButton.titleLabel.font = [UIFont systemFontOfSize:15];
		[_bottomDiscussButton setTitleColor:[UIColor ht_colorStyle:HTColorStylePrimaryTheme] forState:UIControlStateNormal];
		[_bottomDiscussButton setTitle:@"参与讨论" forState:UIControlStateNormal];
		UIImage *image = [UIImage imageNamed:@"cn_question_discuss"];
		image = [image ht_resetSizeZoomNumber:0.6];
		image = [image ht_tintColor:[UIColor ht_colorStyle:HTColorStylePrimaryTheme]];
		[_bottomDiscussButton setImage:image forState:UIControlStateNormal];
		[_bottomDiscussButton ht_makeEdgeWithDirection:HTButtonEdgeDirectionHorizontal imageViewToTitleLabelSpeceOffset:4];
		
		__weak typeof(self) weakSelf = self;
		[_bottomDiscussButton ht_whenTap:^(UIView *view) {
			HTDiscussController *discussController = [[HTDiscussController alloc] init];
			discussController.questionIdString = weakSelf.model.questionId;
			[weakSelf.ht_controller.navigationController pushViewController:discussController animated:true];
		}];
	}
	return _bottomDiscussButton;
}

- (UITableView *)bottomUserParseTableView {
	if (!_bottomUserParseTableView) {
		_bottomUserParseTableView = [[UITableView alloc] init];
		_bottomUserParseTableView.scrollEnabled = false;
		_bottomUserParseTableView.allowsSelection = false;
		_bottomUserParseTableView.scrollsToTop = false;
		_bottomUserParseTableView.separatorColor = [UIColor ht_colorStyle:HTColorStyleCompareBackground];
		_bottomUserParseTableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
        [_bottomUserParseTableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
            sectionMaker.cellClass([HTQuestionParseCell class]);
        }];
	}
	return _bottomUserParseTableView;
}

@end
