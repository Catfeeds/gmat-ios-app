//
//  HTReportDropMenuButton.m
//  GMat
//
//  Created by hublot on 16/11/30.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTReportDropMenuButton.h"
#import <UITableView+HTSeparate.h>
#import <UIButton+HTButtonCategory.h>
#import <NSObject+HTTableRowHeight.h>

@interface HTReportDropMenuButton ()

@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, copy) void(^selectedBlock)(NSInteger index);

@property (nonatomic, assign) BOOL isShowTableView;

@end

@implementation HTReportDropMenuButton

- (void)dealloc {
    
}

- (instancetype)initWithTitleArray:(NSArray <NSString *> *)titleArray selectedBlock:(void(^)(NSInteger index))selectedBlock {
	if (self = [super init]) {
        __weak HTReportDropMenuButton *weakSelf = self;
		[self setImage:[UIImage imageNamed:@"Exercise15"] forState:UIControlStateNormal];
		[self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		self.titleLabel.font = [UIFont ht_fontStyle:HTFontStyleHeadSmall];
		self.titleArray = titleArray;
		[self.tableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
			sectionMaker.modelArray(weakSelf.titleArray);
		}];
		[self.tableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
            [weakSelf.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(sectionMaker.section.sumRowHeight);
            }];
		}];
		[[UIApplication sharedApplication].keyWindow addSubview:self.backgroundView];
		[[UIApplication sharedApplication].keyWindow bringSubviewToFront:self.backgroundView];
        [self.backgroundView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
		
		self.backgroundView.alpha = 0;
		self.selectedBlock = selectedBlock;
		self.selecteIndex = 0;
		[self ht_whenTap:^(UIView *view) {
			[weakSelf.backgroundView.layer removeAllAnimations];
			[UIView animateWithDuration:0.25 animations:^{
				weakSelf.backgroundView.alpha = !weakSelf.isShowTableView;
				weakSelf.imageView.transform = weakSelf.isShowTableView ? CGAffineTransformIdentity : CGAffineTransformMakeRotation(M_PI);
			} completion:^(BOOL finished) {
				if (finished) {
					weakSelf.isShowTableView = !weakSelf.isShowTableView;
				}
			}];
		}];
	}
	return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	[self ht_makeEdgeWithDirection:HTButtonEdgeDirectionHorizontal imageViewToTitleLabelSpeceOffset:- 10];
}

- (void)setSelecteIndex:(NSInteger)selecteIndex {
	_selecteIndex = selecteIndex;
	[self setTitle:self.titleArray[selecteIndex] forState:UIControlStateNormal];
	if (self.selectedBlock) {
		self.selectedBlock(selecteIndex);
	}
}

- (UIView *)backgroundView {
	if (!_backgroundView) {
		_backgroundView = [[UIView alloc] init];
		[_backgroundView addSubview:self.tableView];
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(150);
            make.top.mas_equalTo(64 + 8);
            make.centerX.mas_equalTo(_backgroundView);
        }];
		CAShapeLayer *shapeLayer = [CAShapeLayer layer];
		shapeLayer.bounds = CGRectMake(0, 0, 12, 8);
        shapeLayer.position = CGPointMake(6, 4);
		UIBezierPath *bezierPath = [UIBezierPath bezierPath];
		[bezierPath moveToPoint:CGPointMake(6, 0)];
		[bezierPath addLineToPoint:CGPointMake(12, 8)];
		[bezierPath addLineToPoint:CGPointMake(0, 8)];
		[bezierPath closePath];
		shapeLayer.fillColor = [UIColor ht_colorStyle:HTColorStyleSecondarySeparate].CGColor;
		shapeLayer.path = bezierPath.CGPath;
        UIView *shapeView = [[UIView alloc] initWithFrame:CGRectZero];
        [shapeView.layer addSublayer:shapeLayer];
		[_backgroundView addSubview:shapeView];
        [shapeView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(shapeLayer.bounds.size.width);
            make.height.mas_equalTo(shapeLayer.bounds.size.height);
            make.centerX.mas_equalTo(_backgroundView);
            make.top.mas_equalTo(64);
        }];
        
        __weak HTReportDropMenuButton *weakSelf = self;
		[_backgroundView ht_whenTap:^(UIView *view) {
			[weakSelf ht_responderTap];
		} customResponderBlock:^BOOL(UIView *receiveView) {
			if ([NSStringFromClass([receiveView class]) isEqualToString:@"UITableViewCellContentView"]) {
				return false;
			}
			return true;
		}];
	}
	return _backgroundView;
}


- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc] init];
		_tableView.backgroundColor = [UIColor ht_colorStyle:HTColorStyleBackground];
		_tableView.layer.borderColor = [UIColor ht_colorStyle:HTColorStyleSecondarySeparate].CGColor;
		_tableView.layer.borderWidth = 3;
		_tableView.layer.cornerRadius = 3;
        
        __weak HTReportDropMenuButton *weakSelf = self;
        [_tableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
            [[sectionMaker customCellBlock:^(UITableView *tableView, NSInteger row, __kindof UITableViewCell *cell, __kindof NSObject *model) {
                cell.textLabel.font = [UIFont ht_fontStyle:HTFontStyleTitleSmall];
                cell.textLabel.text = model;
                [model ht_setRowHeightNumber:@(HTADAPT568(40)) forCellClass:cell.class];
            }] didSelectedCellBlock:^(UITableView *tableView, NSInteger row, __kindof UITableViewCell *cell, __kindof NSObject *model) {
                [weakSelf ht_responderTap];
                weakSelf.selecteIndex = row;
            }];
        }];
	}
	return _tableView;
}

@end
