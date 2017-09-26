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

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initializeDataSource];
	[self initializeUserInterface];
}

- (void)initializeDataSource {
	CGFloat fontZoomNumber = [self.class fontZoomNumber];
	CGFloat progress = [self.class progressWithZoomNumber:fontZoomNumber];
	self.fontSlider.value = progress;
	[self sliderValueDidChange];
}

- (void)initializeUserInterface {
	self.navigationItem.title = @"字体大小";
	[self.view addSubview:self.tableView];
	[self.tableView addSubview:self.titleNameLabel];
	[self.tableView addSubview:self.fontSlider];
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
		_tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
		_tableView.backgroundColor = [UIColor whiteColor];
	}
	return _tableView;
}

- (UILabel *)titleNameLabel {
	if (!_titleNameLabel) {
		_titleNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, self.view.ht_w - 60, self.view.ht_h - 64 - self.fontSlider.ht_h)];
		_titleNameLabel.textColor = [UIColor orangeColor];
		_titleNameLabel.numberOfLines = 0;
		_titleNameLabel.textAlignment = NSTextAlignmentCenter;
		_titleNameLabel.text = @"拖动下面的滑块, 可设置字体大小, 设置后\n会改变题目练习、社区、小讲堂的字体大小。\nA simple question";
	}
	return _titleNameLabel;
}

- (UISlider *)fontSlider {
	if (!_fontSlider) {
		CGFloat height = 250;
		_fontSlider = [[UISlider alloc] initWithFrame:CGRectMake(40, self.view.ht_h - 64 - height, self.view.ht_w - 80, height)];
		UIImage *image = [[UIImage alloc] init];
		[_fontSlider setMinimumTrackImage:image forState:UIControlStateNormal];
		[_fontSlider setMaximumTrackImage:image forState:UIControlStateNormal];
		UIImage *backgroundImage = [UIImage imageNamed:@"fontSliderBakground"];
		CGFloat thumbWidth = 33;
		CGFloat zoomNumber = (_fontSlider.ht_w - thumbWidth) / (backgroundImage.size.width);
		backgroundImage = [backgroundImage ht_resetSizeZoomNumber:zoomNumber];
		UIImageView *imageView = [[UIImageView alloc] initWithImage:backgroundImage];
		imageView.ht_x = thumbWidth / 2.0;
		imageView.ht_cy = height / 2;
		[_fontSlider insertSubview:imageView atIndex:0];
		[_fontSlider addTarget:self action:@selector(sliderValueDidChange) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
	}
	return _fontSlider;
}

@end
