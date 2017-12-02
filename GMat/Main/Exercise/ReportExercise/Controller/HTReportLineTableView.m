//
//  HTReportLineTableView.m
//  GMat
//
//  Created by hublot on 16/11/30.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTReportLineTableView.h"
#import <UITableView+HTSeparate.h>
#import "HTReportLineTableCell.h"
#import <NSObject+HTTableRowHeight.h>

@implementation HTReportLineTableView

- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		self.separatorStyle = UITableViewCellSeparatorStyleNone;
		self.allowsSelection = false;
		self.scrollEnabled = false;
        [self ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
            sectionMaker.cellClass([HTReportLineTableCell class]);
        }];
	}
	return self;
}

- (void)setModelArray:(NSArray<NSDictionary *> *)modelArray {
	_modelArray = modelArray;
	[self ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
		[sectionMaker customCellBlock:^(UITableView *tableView, NSInteger row, __kindof UITableViewCell *cell, __kindof NSObject *model) {
            [model ht_setRowHeightNumber:@(40) forCellClass:cell.class];
		}].modelArray(modelArray);
	}];
	[self ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
		self.ht_h = sectionMaker.section.sumRowHeight;
	}];
}

@end
