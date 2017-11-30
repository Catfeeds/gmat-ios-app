//
//  HTMineFontSizeController.m
//  TingApp
//
//  Created by hublot on 2017/5/27.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTMineFontSizeController.h"

@interface HTMineFontSizeController ()

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UILabel *titleNameLabel;

@property (nonatomic, strong) UISlider *fontSlider;

@end

NSString *kHTFontChangeNotification = @"kHTFontChangeNotification";

static NSString *kHTFontSizeKey = @"kHTFontSizeKey";

static CGFloat kHTStartFontZoomNumber = 0.85;

static NSInteger kHTProgressCount = 4;

@implementation HTMineFontSizeController

+ (CGFloat)fontZoomNumber {
	NSNumber *zoomNumber = [[NSUserDefaults standardUserDefaults] valueForKey:kHTFontSizeKey];
	if (!zoomNumber) {
		zoomNumber = @(1);
	}
	return zoomNumber.floatValue;
}

+ (void)setFontZoomNumber:(CGFloat)zoomNumber {
	[[NSUserDefaults standardUserDefaults] setValue:@(zoomNumber) forKey:kHTFontSizeKey];
	[[NSNotificationCenter defaultCenter] postNotificationName:kHTFontChangeNotification object:nil];
}

+ (CGFloat)zoomNumberWithProgress:(CGFloat)progress {
	/*
	0 >> 0.8
	0.25 >> 1
	0.5 >> 1.2
	0.75 >> 1.4
	1 >> 1.6
	 
	*/
	
	return kHTStartFontZoomNumber + progress * ((1.0 - kHTStartFontZoomNumber) / (1.0 / kHTProgressCount));
}

+ (CGFloat)progressWithZoomNumber:(CGFloat)zoomNumber {
	return (zoomNumber - kHTStartFontZoomNumber) / ((1.0 - kHTStartFontZoomNumber) / (1.0 / kHTProgressCount));
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initializeDataSource];
	[self initializeUserInterface];
}

- (void)initializeDataSource {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadFontSliderConstraints) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
	[self reloadFontSliderConstraints];
	CGFloat fontZoomNumber = [self.class fontZoomNumber];
	CGFloat progress = [self.class progressWithZoomNumber:fontZoomNumber];
	self.fontSlider.value = progress;
	[self sliderValueDidChange];
}

- (void)initializeUserInterface {
	self.navigationItem.title = @"字体大小";
	[self initializeAppendSubview];
	[self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.edges.mas_equalTo(UIEdgeInsetsZero);
	}];
	[self.titleNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
		make.width.mas_equalTo(300);
		make.top.mas_equalTo(self.view.mas_top).offset(15);
		make.bottom.mas_equalTo(self.fontSlider.mas_top).offset(- 15);
		make.centerX.mas_equalTo(self.view);
	}];
	[self.fontSlider mas_updateConstraints:^(MASConstraintMaker *make) {
		make.width.mas_equalTo(300);
		make.height.mas_equalTo(40);
		make.centerX.mas_equalTo(self.view);
	}];
}

- (void)initializeAppendSubview {
	[self.view addSubview:self.tableView];
	[self.tableView addSubview:self.titleNameLabel];
	[self.tableView addSubview:self.fontSlider];
}

- (void)reloadFontSliderConstraints {
	[self initializeAppendSubview];
	BOOL isPortrait = UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation);
	[self.fontSlider mas_updateConstraints:^(MASConstraintMaker *make) {
		make.bottom.mas_equalTo(self.view).offset(isPortrait ? - 120 : - 20);
	}];
}

- (void)sliderValueDidChange {
	CGFloat progress = self.fontSlider.value;
	NSArray *progressValueArray = @[@0, @0.25, @0.5, @0.75, @1];
	__block CGFloat minValueDistance = 1;
	__block CGFloat willChangeProgress = progress;
	[progressValueArray enumerateObjectsUsingBlock:^(NSNumber *progressValue, NSUInteger index, BOOL * _Nonnull stop) {
		CGFloat valueDistance = fabs(progressValue.doubleValue - progress);
		if (valueDistance < minValueDistance) {
			minValueDistance = valueDistance;
			willChangeProgress = progressValue.floatValue;
		}
	}];
	[self.fontSlider setValue:willChangeProgress animated:true];
	CGFloat fontZoomNumber = [self.class zoomNumberWithProgress:willChangeProgress];
	[self.class setFontZoomNumber:fontZoomNumber];
	UIFont *titleNameFont = [UIFont systemFontOfSize: 16 * fontZoomNumber];
	self.titleNameLabel.font = titleNameFont;
}

- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc] init];
		_tableView.backgroundColor = [UIColor whiteColor];
	}
	return _tableView;
}

- (UILabel *)titleNameLabel {
	if (!_titleNameLabel) {
		_titleNameLabel = [[UILabel alloc] init];
		_titleNameLabel.textColor = [UIColor orangeColor];
		_titleNameLabel.numberOfLines = 0;
		_titleNameLabel.textAlignment = NSTextAlignmentCenter;
		_titleNameLabel.text = @"拖动下面的滑块, 可设置字体大小, 设置后\n会改变题目练习、社区、小讲堂的字体大小。\nA simple question";
	}
	return _titleNameLabel;
}

- (UISlider *)fontSlider {
	if (!_fontSlider) {
		_fontSlider = [[UISlider alloc] init];
		UIImage *image = [[UIImage alloc] init];
		[_fontSlider setMinimumTrackImage:image forState:UIControlStateNormal];
		[_fontSlider setMaximumTrackImage:image forState:UIControlStateNormal];
		UIImage *backgroundImage = [UIImage imageNamed:@"fontSliderBakground"];
		CGFloat thumbWidth = [_fontSlider thumbRectForBounds:CGRectZero trackRect:CGRectZero value:0].size.width;
		UIImageView *imageView = [[UIImageView alloc] initWithImage:backgroundImage];
		[_fontSlider insertSubview:imageView atIndex:0];
		[imageView mas_updateConstraints:^(MASConstraintMaker *make) {
			make.centerY.mas_equalTo(self.fontSlider);
			make.left.mas_equalTo(thumbWidth / 2);
			make.right.mas_equalTo(- thumbWidth / 2);
			make.height.mas_equalTo(10);
		}];
		[_fontSlider addTarget:self action:@selector(sliderValueDidChange) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
	}
	return _fontSlider;
}

@end
