//
//  HTPlayerSpeedView.m
//  GMat
//
//  Created by hublot on 2017/9/28.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTPlayerSpeedView.h"
#import "HTPlayerSpeedCell.h"
#import <UITableView+HTSeparate.h>

@interface HTPlayerSpeedView ()

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation HTPlayerSpeedView

- (void)dealloc {
	
}

+ (CGFloat)speedCellHeight {
	return 45;
}

- (void)didMoveToSuperview {
	self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
}

- (void)setPlayerModel:(HTPlayerModel *)playerModel {
	_playerModel = playerModel;
	
	__weak typeof(self) weakSelf = self;
	[self.tableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
		sectionMaker.modelArray(weakSelf.playerModel.speedModelArray);
	}];
	
	[self addSubview:self.tableView];
	[self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.center.mas_equalTo(self);
		make.width.mas_equalTo(self);
		make.height.mas_equalTo(weakSelf.playerModel.speedModelArray.count * [weakSelf.class speedCellHeight]);
	}];
	
	[self.playerModel.speedModelArray enumerateObjectsUsingBlock:^(HTPlayerSpeedModel *model, NSUInteger index, BOOL * _Nonnull stop) {
		[weakSelf.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:false scrollPosition:UITableViewScrollPositionNone];
		if (model.isSelected) {
			*stop = true;
		}
	}];
}

- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc] initWithFrame:CGRectZero];
		_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		_tableView.backgroundColor = [UIColor clearColor];
		
		__weak typeof(self) weakSelf = self;
		[_tableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
			[[sectionMaker.cellClass([HTPlayerSpeedCell class]).rowHeight([weakSelf.class speedCellHeight]) didSelectedCellBlock:^(UITableView *tableView, NSInteger row, __kindof UITableViewCell *cell, __kindof HTPlayerSpeedModel *model) {
				model.isSelected = true;
				[weakSelf.playerModel reloadWillSeekRateWillPlay:true];
			}] diddeSelectedCellBlock:^(UITableView *tableView, NSInteger row, __kindof UITableViewCell *cell, __kindof HTPlayerSpeedModel *model) {
				model.isSelected = false;
			}];
		}];
	}
	return _tableView;
}

@end
