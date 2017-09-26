//
//  HTQuestionViewGroup.m
//  GMat
//
//  Created by hublot on 16/11/27.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTQuestionViewGroup.h"
#import "THTableButton.h"
#import "NSString+HTString.h"
#import "NSMutableAttributedString+HTMutableAttributedString.h"

@interface HTQuestionViewGroup ()

@property (nonatomic, strong) UIImageView *clockImageView;

@property (nonatomic, strong) NSArray <HTQuestionMoreMenuModel *> *moreModelArray;

@property (nonatomic, strong) UIButton *moreBarButton;

@end

@implementation HTQuestionViewGroup

- (void)dealloc {
    
}

- (UIToolbar *)statusEffectBar {
	if (!_statusEffectBar) {
		_statusEffectBar = [[UIToolbar alloc] init];
		_statusEffectBar.barTintColor = [UIColor ht_colorStyle:HTColorStyleSecondaryTheme];
		_statusEffectBar.translucent = true;
	}
	return _statusEffectBar;
}

- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc] init];
		_tableView.backgroundColor = [UIColor ht_colorStyle:HTColorStyleCompareBackground];
		_tableView.allowsSelection = false;
		_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	}
	return _tableView;
}

- (HTQuestionView *)questionView {
	if (!_questionView) {
		_questionView = [[HTQuestionView alloc] init];
		_questionView.ht_w = HTSCREENWIDTH;
        __weak HTQuestionViewGroup *weakSelf = self;
		[_questionView bk_addObserverForKeyPath:@"userSelectedAnswer" options:NSKeyValueObservingOptionInitial task:^(id obj, NSDictionary *change) {
			weakSelf.bottomSureButton.enabled = weakSelf.questionView.userSelectedAnswer.length;
		}];
	}
	return _questionView;
}

- (UIButton *)bottomSureButton {
	if (!_bottomSureButton) {
		_bottomSureButton = [[THTableButton alloc] init];
		_bottomSureButton.layer.masksToBounds = true;
		[_bottomSureButton setTitle:@"下一题" forState:UIControlStateNormal];
		[_bottomSureButton setBackgroundImage:[UIImage ht_pureColor:[UIColor ht_colorStyle:HTColorStylePrimarySeparate]] forState:UIControlStateDisabled];
		_bottomSureButton.enabled = false;
	}
	return _bottomSureButton;
}

- (UIButton *)storeBarButton {
	if (!_storeBarButton) {
		_storeBarButton = [[UIButton alloc] init];
		_storeBarButton.tintColor = [UIColor orangeColor];
		[_storeBarButton setImage:[[[UIImage imageNamed:@"Question6"] ht_resetSizeZoomNumber:1.3] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
		[_storeBarButton setImage:[[[UIImage imageNamed:@"Question8"] ht_resetSizeZoomNumber:1.3] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateSelected];
		[_storeBarButton sizeToFit];
	}
	return _storeBarButton;
}

- (void)switchTimeClockImageView {
	if (self.timeBarButtonItem.customView != self.timeBarButton) {
		[self.timeBarButton sizeToFit];
		self.timeBarButton.ht_w += 4;
		self.timeBarButtonItem.customView = self.timeBarButton;
	} else {
		[self.clockImageView sizeToFit];
		self.timeBarButtonItem.customView = self.clockImageView;
	}
	__weak typeof(self) weakSelf = self;
	[self.timeBarButtonItem.customView ht_whenTap:^(UIView *view) {
		[weakSelf switchTimeClockImageView];
	}];
}

- (UIButton *)timeBarButton {
	if (!_timeBarButton) {
		_timeBarButton = [[UIButton alloc] init];
		_timeBarButton.tintColor = [UIColor whiteColor];
		[_timeBarButton setTitle:@"00:00:00" forState:UIControlStateNormal];
	}
	return _timeBarButton;
}

- (UIImageView *)clockImageView {
	if (!_clockImageView) {
		_clockImageView = [[UIImageView alloc] init];
		UIImage *image = [UIImage imageNamed:@"cn_question_navigationitem_clock"];
		image = [image ht_resetSize:CGSizeMake(20, 20)];
		_clockImageView.image = image;
	}
	return _clockImageView;
}


- (UIBarButtonItem *)closeBarButtonItem {
	if (!_closeBarButtonItem) {
		_closeBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Question1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:nil action:nil];
	}
	return _closeBarButtonItem;
}


- (UIBarButtonItem *)storeBarButtonItem {
	if (!_storeBarButtonItem) {
		_storeBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.storeBarButton];;
	}
	return _storeBarButtonItem;
}

- (UIButton *)moreBarButton {
	if (!_moreBarButton) {
		_moreBarButton = [[UIButton alloc] init];
		UIImage *image = [UIImage imageNamed:@"cn_question_more"];
		image = [image ht_resetSizeZoomNumber:0.75];
		image = [image ht_tintColor:[UIColor whiteColor]];
		[_moreBarButton setImage:image forState:UIControlStateNormal];
		[_moreBarButton sizeToFit];
		
		__weak typeof(self) weakSelf = self;
		[_moreBarButton ht_whenTap:^(UIView *view) {
			[weakSelf moreBarButtonDidTapedBarButtonItem:nil event:nil];
		}];
	}
	return _moreBarButton;
}


- (UIBarButtonItem *)moreBarButtonItem {
	if (!_moreBarButtonItem) {
		_moreBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.moreBarButton];
	}
	return _moreBarButtonItem;
}

- (UIBarButtonItem *)timeBarButtonItem {
	if (!_timeBarButtonItem) {
		_timeBarButtonItem = [[UIBarButtonItem alloc] init];
		[self switchTimeClockImageView];
	}
	return _timeBarButtonItem;
}

- (void)setEnable:(BOOL)enable {
	_enable = enable;
	self.storeBarButtonItem.enabled = self.moreBarButtonItem.enabled = enable;
}


- (NSArray<HTQuestionMoreMenuModel *> *)moreModelArray {
	if (!_moreModelArray) {
		_moreModelArray = [HTQuestionMoreMenuModel packModelArray];
	}
	return _moreModelArray;
}

- (HTQuestionMoreMenuModel *)menuModelWithType:(HTQuestionMoreItemType)type {
	for (HTQuestionMoreMenuModel *model in self.moreModelArray) {
		if (model.type == type) {
			return model;
		}
	}
	return nil;
}

- (void)moreBarButtonDidTapedBarButtonItem:(UIBarButtonItem *)barButtonItem event:(UIEvent *)event {
	UIEdgeInsets edge = UIEdgeInsetsMake(64 + 0, - 1, - 1, 0);
	NSMutableArray *modelArray = [self.moreModelArray mutableCopy];
	[self.moreModelArray enumerateObjectsUsingBlock:^(HTQuestionMoreMenuModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
		if (model.isHidden) {
			[modelArray removeObject:model];
		}
	}];
	[HTQuestionMoreMenuView showModelArray:modelArray screenEdge:edge didSelectedBlock:self.moreItemDidSelected];
}

- (void)setQuestionParseHidden:(BOOL)questionParseHidden {
	HTQuestionMoreMenuModel *model = [self menuModelWithType:HTQuestionMoreItemTypeParse];
	model.isHidden = questionParseHidden;
}

- (BOOL)questionParseHidden {
	HTQuestionMoreMenuModel *model = [self menuModelWithType:HTQuestionMoreItemTypeParse];
	return model.isHidden;
}

- (void)setQuestionParseSelected:(BOOL)questionParseSelected {
	HTQuestionMoreMenuModel *model = [self menuModelWithType:HTQuestionMoreItemTypeParse];
	model.isSelected = questionParseSelected;
}

- (BOOL)questionParseSelected {
	HTQuestionMoreMenuModel *model = [self menuModelWithType:HTQuestionMoreItemTypeParse];
	return model.isSelected;
}

@end
