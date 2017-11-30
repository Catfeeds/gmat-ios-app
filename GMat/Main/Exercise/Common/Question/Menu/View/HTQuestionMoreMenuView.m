//
//  HTQuestionMoreMenuView.m
//  GMat
//
//  Created by hublot on 2017/8/23.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTQuestionMoreMenuView.h"
#import <UITableView+HTSeparate.h>
#import "HTQuestionMoreMenuCell.h"

@interface HTQuestionMoreMenuView ()

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *backgroundView;

@end

@implementation HTQuestionMoreMenuView

+ (instancetype)defaultMoreMenuView {
	static HTQuestionMoreMenuView *menuView;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		menuView = [[HTQuestionMoreMenuView alloc] init];
	});
	return menuView;
}

+ (void)showModelArray:(NSArray <HTQuestionMoreMenuModel *> *)modelArray screenEdge:(UIEdgeInsets)screenEdge didSelectedBlock:(HTQuestionMoreItemDidSelected)didSelectedBlock {
	HTQuestionMoreMenuView *menuView = [HTQuestionMoreMenuView defaultMoreMenuView];
	[[UIApplication sharedApplication].keyWindow addSubview:menuView.backgroundView];
	[menuView.backgroundView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.edges.mas_equalTo(UIEdgeInsetsZero);
	}];
	[menuView.backgroundView addSubview:menuView];
	[menuView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.edges.mas_equalTo(UIEdgeInsetsZero);
	}];
	
	__weak typeof(menuView) weakMenuView = menuView;
	
	[menuView.backgroundView ht_whenTap:^(UIView *view) {
		[weakMenuView willMoveToSuperview:nil];
	} customResponderBlock:^BOOL(UIView *receiveView) {
		if ([NSStringFromClass([receiveView class]) isEqualToString:@"UITableViewCellContentView"]) {
			return false;
		}
		return true;
	}];

	[menuView.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
		if (screenEdge.right > - 1) {
			make.right.mas_equalTo(screenEdge.right);
		} else {
			make.left.mas_equalTo(screenEdge.left);
		}
		
		if (screenEdge.top > - 1) {
			make.top.mas_equalTo(screenEdge.top);
		} else {
			make.bottom.mas_equalTo(screenEdge.bottom);
		}
		make.height.mas_equalTo(weakMenuView.tableView.rowHeight * modelArray.count);
	}];
	
	[menuView.tableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
		[sectionMaker.modelArray(modelArray) didSelectedCellBlock:^(UITableView *tableView, NSInteger row, __kindof UITableViewCell *cell, __kindof HTQuestionMoreMenuModel *model) {
			if (didSelectedBlock) {
				didSelectedBlock(model);
			}
			[weakMenuView willMoveToSuperview:nil];
		}];
	}];
}

+ (void)removeUpdateAlerView {
	[[HTQuestionMoreMenuView defaultMoreMenuView] willMoveToSuperview:nil];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
	[super willMoveToSuperview:newSuperview];
	[self setAnimationWillShow:!newSuperview];
	[UIView animateWithDuration:0.25 animations:^{
		[self setAnimationWillShow:newSuperview];
	} completion:^(BOOL finished) {
		if (!newSuperview) {
			[self removeFromSuperview];
			[self.backgroundView removeFromSuperview];
		} else {
			
		}
	}];
}

- (void)setAnimationWillShow:(BOOL)willShow {
	if (willShow) {
		self.backgroundView.alpha = 1;
		self.transform = CGAffineTransformIdentity;
	} else {
		self.backgroundView.alpha = 0;
		CGAffineTransform transform = CGAffineTransformMakeTranslation(150, - 240);
		transform = CGAffineTransformScale(transform, 0.1, 0.1);
		self.transform = transform;
	}
}

- (void)didMoveToSuperview {
	[self addSubview:self.tableView];
	[self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.width.mas_equalTo(150);
	}];
}

- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc] init];
		_tableView.rowHeight = 45;
		_tableView.separatorInset = UIEdgeInsetsZero;
		_tableView.scrollEnabled = false;
		
		__weak typeof(self) weakSelf = self;
		[_tableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
			sectionMaker.cellClass([HTQuestionMoreMenuCell class]).rowHeight(weakSelf.tableView.rowHeight);
		}];
	}
	return _tableView;
}

- (UIView *)backgroundView {
	if (!_backgroundView) {
		_backgroundView = [[UIView alloc] init];
		_backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
	}
	return _backgroundView;
}


@end
