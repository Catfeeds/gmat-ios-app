//
//  HTQuestionMockStartController.m
//  GMat
//
//  Created by hublot on 2016/11/29.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTQuestionMockStartController.h"
#import "HTQuestionMockStartSum.h"
#import "THTableButton.h"
#import <MLeaksFinder.h>

@interface HTQuestionMockStartController ()

@property (nonatomic, strong) UIImageView *clockImageView;

@property (nonatomic, strong) UILabel *titleNameLabel;

@property (nonatomic, strong) HTQuestionMockStartSum *primaryStartSum;

@property (nonatomic, strong) HTQuestionMockStartSum *secondStartSum;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) THTableButton *startMockButton;

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) NSString *signString;

@end

@implementation HTQuestionMockStartController

- (void)dealloc {
	
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initializeDataSource];
	[self initializeUserInterface];
}

- (void)initializeDataSource {
	
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
	if (self.popControllerBlock) {
		self.popControllerBlock();
	}
}

- (void)initializeUserInterface {
	[self.view addSubview:self.tableView];
	[self.view addSubview:self.startMockButton];
	[self.startMockButton mas_updateConstraints:^(MASConstraintMaker *make) {
		make.left.right.bottom.mas_equalTo(self.view);
		make.height.mas_equalTo(49);
	}];
	[self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.left.right.top.mas_equalTo(self.view);
		make.bottom.mas_equalTo(self.startMockButton.mas_top);
	}];
	
	
	CGFloat clockImageTop = 60;
	CGFloat clockImageHeight = self.clockImageView.image.size.height;
	CGFloat titleNameTop = 30;
	CGFloat titleNameHeight = 50;
	CGFloat startSumTop = 60;
	CGFloat startSumHeight = 200;
	CGFloat startSumBottom = 60;
	CGFloat sumHeight = clockImageTop + clockImageHeight + titleNameTop + titleNameHeight + startSumTop + startSumHeight + startSumBottom;
	
	self.headerView.ht_h = sumHeight;
	[self.headerView addSubview:self.clockImageView];
	[self.headerView addSubview:self.titleNameLabel];
	[self.headerView addSubview:self.primaryStartSum];
	[self.headerView addSubview:self.secondStartSum];
	self.tableView.tableHeaderView = self.headerView;
	[self.clockImageView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.centerX.mas_equalTo(self.headerView);
		make.top.mas_equalTo(clockImageTop);
	}];
	[self.titleNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(self.clockImageView.mas_bottom).offset(titleNameTop);
		make.left.right.mas_equalTo(self.headerView);
		make.height.mas_equalTo(titleNameHeight);
	}];
	[self.primaryStartSum mas_updateConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(30);
		make.height.mas_equalTo(startSumHeight);
		make.top.mas_equalTo(self.titleNameLabel.mas_bottom).offset(startSumTop);
	}];
	[self.secondStartSum mas_updateConstraints:^(MASConstraintMaker *make) {
		make.width.mas_equalTo(self.primaryStartSum);
		make.height.mas_equalTo(self.primaryStartSum);
		make.right.mas_equalTo(self.headerView).offset(- 20);
		make.top.mas_equalTo(self.primaryStartSum);
	}];
}

- (void)setMockStartType:(NSInteger)mockStartType {
	[self initializeUserInterface];
	switch (mockStartType) {
		case 1: {
			[self.secondStartSum mas_updateConstraints:^(MASConstraintMaker *make) {
				make.centerX.mas_equalTo(self.headerView);
			}];
			self.secondStartSum.hidden = false;
			self.primaryStartSum.hidden = true;
			break;
		}
		case 2:{
			[self.primaryStartSum mas_updateConstraints:^(MASConstraintMaker *make) {
				make.centerX.mas_equalTo(self.headerView);
			}];
			self.primaryStartSum.hidden = false;
			self.secondStartSum.hidden = true;
			break;
		}
		case 3: {
			self.primaryStartSum.hidden = false;
			self.secondStartSum.hidden = false;
			[self.primaryStartSum mas_updateConstraints:^(MASConstraintMaker *make) {
				make.right.mas_equalTo(self.secondStartSum.mas_left).offset(- 30);
			}];
			break;
		}
		default:
			
			break;
	}
}

- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc] init];
		_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	}
	return _tableView;
}

- (THTableButton *)startMockButton {
	if (!_startMockButton) {
		_startMockButton = [[THTableButton alloc] init];
		[_startMockButton setTitle:@"开始模考" forState:UIControlStateNormal];
        __weak HTQuestionMockStartController *weakSelf = self;
		[_startMockButton ht_whenTap:^(UIView *view) {
			[weakSelf.navigationController popViewControllerAnimated:true];
		}];
	}
	return _startMockButton;
}


- (UIImageView *)clockImageView {
	if (!_clockImageView) {
		UIImage *clockImage = [UIImage imageNamed:@"Question2"];
		_clockImageView = [[UIImageView alloc] init];
		_clockImageView.image = clockImage;
		_clockImageView.contentMode = UIViewContentModeScaleAspectFill;
	}
	return _clockImageView;
}

- (UILabel *)titleNameLabel {
	if (!_titleNameLabel) {
		_titleNameLabel = [[UILabel alloc] init];
		_titleNameLabel.textColor = [UIColor ht_colorStyle:HTColorStylePrimaryTitle];
		_titleNameLabel.font = [UIFont ht_fontStyle:HTFontStyleHeadLarge];
		_titleNameLabel.textAlignment = NSTextAlignmentCenter;
		_titleNameLabel.text = @"模考马上考试";
	}
	return _titleNameLabel;
}


- (HTQuestionMockStartSum *)primaryStartSum {
	if (!_primaryStartSum) {
		_primaryStartSum = [[HTQuestionMockStartSum alloc] init];
		[_primaryStartSum setHeadString:@"Quant部分" titleString:@"共计37题" detailString:@"限时75分钟"];
	}
	return _primaryStartSum;
}

- (HTQuestionMockStartSum *)secondStartSum {
	if (!_secondStartSum) {
		_secondStartSum = [[HTQuestionMockStartSum alloc] init];
		[_secondStartSum setHeadString:@"Verbal部分" titleString:@"共计41题" detailString:@"限时75分钟"];
	}
	return _secondStartSum;
}

- (UIView *)headerView {
	if (!_headerView) {
		_headerView = [[UIView alloc] init];
	}
	return _headerView;
}

@end
