//
//  HTAppStoreStarView.m
//  GMat
//
//  Created by hublot on 2017/8/3.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTAppStoreStarView.h"
#import "HTAppStoreStarModel.h"
#import <UITableView+HTSeparate.h>
#import "HTAppStoreStarCell.h"
#import "HTRequestManager.h"
#import "HTManagerController.h"
#import "THMinePreferenceIssueController.h"

@interface HTAppStoreStarView ()

@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, strong) UIImageView *handImageView;

@property (nonatomic, strong) UIView *whiteContentView;

@property (nonatomic, strong) UILabel *titleNameLabel;

@property (nonatomic, strong) UILabel *fiveStarLabel;

@property (nonatomic, strong) UITableView *tableView;


@property (nonatomic, strong) NSArray *modelArray;

@property (nonatomic, assign) CGFloat modelHeight;

@end

@implementation HTAppStoreStarView

+ (void)showWithAnimted:(BOOL)animated superView:(UIView *)superView {
	HTAppStoreStarView *starView = [[HTAppStoreStarView alloc] init];
//	__weak typeof(starView) weakStartView = starView;
	[superView addSubview:starView.backgroundView];
	[starView.backgroundView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.edges.mas_equalTo(UIEdgeInsetsZero);
	}];
	[starView.backgroundView addSubview:starView];
	[starView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.edges.mas_equalTo(UIEdgeInsetsZero);
	}];
//	[starView.backgroundView ht_whenTap:^(UIView *view) {
//		[weakStartView dismissWithAnimated:animated];
//	} customResponderBlock:^BOOL(UIView *receiveView) {
//		return ![NSStringFromClass([receiveView class]) isEqualToString:@"UITableViewCellContentView"];
//	}];
	[starView startAnimation:animated show:true];
}

- (void)startAnimation:(BOOL)animated show:(BOOL)show {
	void(^willShowStateBlock)(void) = ^() {
		self.backgroundView.alpha = 0;
		self.transform = CGAffineTransformMakeScale(0.8, 0.8);
	};
	void(^willHiddenStateBlock)(void) = ^() {
		self.backgroundView.alpha = 1;
		self.transform = CGAffineTransformIdentity;
	};
	if (show) {
		willShowStateBlock();
	} else {
		willHiddenStateBlock();
	}
	[UIView animateWithDuration:animated ? 0.25 : 0 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.7 options:UIViewAnimationOptionCurveEaseInOut animations:^{
		if (show) {
			willHiddenStateBlock();
		} else {
			willShowStateBlock();
		}
	} completion:^(BOOL finished) {
		if (!show) {
			[self.backgroundView removeFromSuperview];
			[self removeFromSuperview];
		}
	}];
}

- (void)dismissWithAnimated:(BOOL)animated {
	[self startAnimation:animated show:false];
}

- (void)didMoveToSuperview {
	[self addSubview:self.handImageView];
	[self addSubview:self.whiteContentView];
	[self.whiteContentView addSubview:self.titleNameLabel];
	[self.whiteContentView addSubview:self.fiveStarLabel];
	[self.whiteContentView addSubview:self.tableView];
	[self.handImageView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.center.mas_equalTo(self);
		make.height.mas_equalTo(330);
	}];
	UIEdgeInsets contentEdge = UIEdgeInsetsMake(100, 40, 4, 20);
	[self.whiteContentView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.edges.mas_equalTo(self.handImageView).mas_offset(contentEdge);
	}];
	[self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.left.right.bottom.mas_equalTo(self.whiteContentView);
		CGFloat tableHeight = self.modelHeight * self.modelArray.count;
		make.height.mas_equalTo(tableHeight);
	}];
	[self.fiveStarLabel mas_updateConstraints:^(MASConstraintMaker *make) {
		make.bottom.mas_equalTo(self.tableView.mas_top);
		make.left.right.mas_equalTo(self.whiteContentView);
		make.height.mas_equalTo(50);
	}];
	[self.titleNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
		make.top.left.right.mas_equalTo(self.whiteContentView);
		make.bottom.mas_equalTo(self.fiveStarLabel.mas_top);
	}];
}

- (UIView *)backgroundView {
	if (!_backgroundView) {
		_backgroundView = [[UIView alloc] init];
		_backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
	}
	return _backgroundView;
}

- (UIImageView *)handImageView {
	if (!_handImageView) {
		_handImageView = [[UIImageView alloc] init];
		UIImage *image = [UIImage imageNamed:@"cn_mine_appstore_hand"];
		image = [image ht_resetSizeZoomNumber:300 / image.size.width];
		UIEdgeInsets handImageEdge = UIEdgeInsetsMake(230, 0, 40, 0);
		image = [image resizableImageWithCapInsets:handImageEdge resizingMode:UIImageResizingModeStretch];
		_handImageView.image = image;
	}
	return _handImageView;
}

- (UIView *)whiteContentView {
	if (!_whiteContentView) {
		_whiteContentView = [[UIView alloc] init];
		_whiteContentView.layer.cornerRadius = 12;
		_whiteContentView.layer.masksToBounds = true;
	}
	return _whiteContentView;
}

- (UILabel *)titleNameLabel {
	if (!_titleNameLabel) {
		_titleNameLabel = [[UILabel alloc] init];
		_titleNameLabel.font = [UIFont systemFontOfSize:15];
		_titleNameLabel.textColor = [UIColor ht_colorStyle:HTColorStylePrimaryTitle];
		_titleNameLabel.numberOfLines = 0;
		_titleNameLabel.textAlignment = NSTextAlignmentCenter;
		_titleNameLabel.text = @"喜欢雷哥GMAT的做题模考功能?\n去应用商店给个5星好评吧";
	}
	return _titleNameLabel;
}

- (UILabel *)fiveStarLabel {
	if (!_fiveStarLabel) {
		_fiveStarLabel = [[UILabel alloc] init];
		UIImage *image = [UIImage imageNamed:@"cn_mine_appstore_star"];
		image = [image ht_resetSizeWithStandard:20 isMinStandard:false];
		image = [image ht_insertColor:[UIColor clearColor] edge:UIEdgeInsetsMake(0, 3, 0, 3)];
		NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
		textAttachment.image = image;
		textAttachment.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
		NSMutableAttributedString *attributedString = [[[NSAttributedString alloc] initWithString:@""] mutableCopy];
		for (NSInteger index = 0; index < 5; index ++) {
			NSAttributedString *appendAttributedString = [NSAttributedString attributedStringWithAttachment:textAttachment];
			[attributedString appendAttributedString:appendAttributedString];
		}
		NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
		paragraphStyle.alignment = NSTextAlignmentCenter;
		[attributedString addAttributes:@{NSParagraphStyleAttributeName:paragraphStyle} range:NSMakeRange(0, attributedString.length)];
		_fiveStarLabel.attributedText = attributedString;
	}
	return _fiveStarLabel;
}

- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc] init];
		_tableView.scrollEnabled = false;
		_tableView.separatorColor = [UIColor ht_colorStyle:HTColorStylePrimarySeparate];
		_tableView.backgroundColor = [UIColor clearColor];
		
		__weak typeof(self) weakSelf = self;
		[_tableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
			[sectionMaker.cellClass([HTAppStoreStarCell class]).modelArray(self.modelArray).rowHeight(self.modelHeight) didSelectedCellBlock:^(UITableView *tableView, NSInteger row, __kindof UITableViewCell *cell, __kindof HTAppStoreStarModel *model) {
				switch (model.type) {
					case HTAppStoreStarTypeGood: {
						[HTRequestManager requestOpenAppStore];
						break;
					}
					case HTAppStoreStarTypeIssue: {
						UINavigationController *navigationController = [HTManagerController defaultManagerController].drawerController.tabBarController.selectedViewController;
						THMinePreferenceIssueController *issueController = [[THMinePreferenceIssueController alloc] init];
						[navigationController pushViewController:issueController animated:true];
						break;
					}
					case HTAppStoreStarTypeReject: {
						break;
					}
				}
				[weakSelf dismissWithAnimated:true];
			}];
		}];
	}
	return _tableView;
}

- (NSArray *)modelArray {
	if (!_modelArray) {
		_modelArray = [HTAppStoreStarModel packModelArray];
	}
	return _modelArray;
}

- (CGFloat)modelHeight {
	if (!_modelHeight) {
		_modelHeight = 40;
	}
	return _modelHeight;
}

@end
