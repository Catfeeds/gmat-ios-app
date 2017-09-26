//
//  HTQuestionMockSleepController.m
//  GMat
//
//  Created by hublot on 2016/11/29.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTQuestionMockSleepController.h"
#import "THTableButton.h"
#import "UICollectionView+HTSeparate.h"
#import "NSTimer+HTBackground.h"

@interface HTQuestionMockSleepController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) THTableButton *continueButton;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIImageView *sleepImageView;

@property (nonatomic, strong) UICollectionReusableView *footerReusableView;

@property (nonatomic, strong) NSArray <NSString *> *modelArray;

@property (nonatomic, assign) NSInteger second;

@end

@implementation HTQuestionMockSleepController

- (void)dealloc {
	
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initializeDataSource];
	[self initializeUserInterface];
}

- (void)initializeDataSource {
	self.second = 8 * 60;
    __weak HTQuestionMockSleepController *weakSelf = self;
	self.timer = [NSTimer ht_scheduledTimerWithTimeInterval:1 block:^(NSTimer *timer) {
		weakSelf.second --;
		weakSelf.modelArray = @[@"0", [NSString stringWithFormat:@"%ld", weakSelf.second / 60], @":", [NSString stringWithFormat:@"%ld", (weakSelf.second % 60) / 10], [NSString stringWithFormat:@"%ld", weakSelf.second % 10]];
		[weakSelf.collectionView reloadData];
		if (weakSelf.second <= 0) {
			[weakSelf.continueButton ht_responderTap];
		}
	} repeats:true];
	[self.timer fire];
	[[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
	if (self.popControllerBlock) {
		self.popControllerBlock();
	}
	[self.timer invalidate];
}

- (void)initializeUserInterface {
	[self.view addSubview:self.collectionView];
	[self.view addSubview:self.continueButton];
	
	[self.continueButton mas_updateConstraints:^(MASConstraintMaker *make) {
		make.left.right.bottom.mas_equalTo(self.view);
		make.height.mas_equalTo(49);
	}];
	[self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.left.right.top.mas_equalTo(self.view);
		make.bottom.mas_equalTo(self.continueButton.mas_top);
	}];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return self.modelArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 2) {
		return CGSizeMake(20, 100);
	} else {
		return CGSizeMake((HTSCREENWIDTH - 20 - 5 * 4 - 50 - 50) / 4, 100);
	}
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
	return UIEdgeInsetsMake(100, 50, 0, 50);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
	return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
	return 5;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
	return CGSizeMake(self.sleepImageView.image.size.width, self.sleepImageView.image.size.height + 60);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
	if (kind == UICollectionElementKindSectionFooter) {
		UICollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"1" forIndexPath:indexPath];
		self.footerReusableView = reusableView;
		[self.footerReusableView addSubview:self.sleepImageView];
		[self.sleepImageView mas_updateConstraints:^(MASConstraintMaker *make) {
			make.center.mas_equalTo(self.footerReusableView);
		}];
		return self.footerReusableView;
	} else {
		return nil;
	}
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"1" forIndexPath:indexPath];
	UIButton *titleNameButton = [[UIButton alloc] init];
	[titleNameButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	titleNameButton.titleLabel.font = [UIFont systemFontOfSize:40 weight:0.7];
	[titleNameButton setTitle:self.modelArray[indexPath.row] forState:UIControlStateNormal];
	if (indexPath.row != 2) {
		[titleNameButton setBackgroundImage:[UIImage imageNamed:@"Question3"] forState:UIControlStateNormal];
	} else {
		[titleNameButton setTitleColor:[UIColor ht_colorStyle:HTColorStyleSecondarySeparate] forState:UIControlStateNormal];
	}
	titleNameButton.tag = 101;
	[[cell viewWithTag:101] removeFromSuperview];
	[cell addSubview:titleNameButton];
	[titleNameButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.mas_equalTo(UIEdgeInsetsZero);
	}];
	return cell;
}

- (UICollectionView *)collectionView {
	if (!_collectionView) {
		UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
		_collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
		[_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"1"];
		[_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"1"];
		_collectionView.delegate = self;
		_collectionView.dataSource = self;
		_collectionView.backgroundColor = [UIColor whiteColor];
		_collectionView.alwaysBounceVertical = true;
	}
	return _collectionView;
}

- (THTableButton *)continueButton {
	if (!_continueButton) {
		_continueButton = [[THTableButton alloc] init];
		[_continueButton setTitle:@"跳过休息时间" forState:UIControlStateNormal];
        __weak HTQuestionMockSleepController *weakSelf = self;
		[_continueButton ht_whenTap:^(UIView *view) {
			[weakSelf.navigationController popViewControllerAnimated:true];
		}];
	}
	return _continueButton;
}

- (UIImageView *)sleepImageView {
	if (!_sleepImageView) {
		_sleepImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Question4"]];
	}
	return _sleepImageView;
}

@end
