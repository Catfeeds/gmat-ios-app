//
//  HTPlayerToolBar.m
//  GMat
//
//  Created by hublot on 2017/9/28.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTPlayerToolBar.h"
#import "HTPlayerSlider.h"
#import "HTManagerController+HTRotate.h"

@interface HTPlayerToolBar ()

@property (nonatomic, strong) UIButton *backItemButton;

@property (nonatomic, strong) UIView *bottomContentView;

@property (nonatomic, strong) UIButton *startVideoButton;

@property (nonatomic, strong) UILabel *leftTimeLabel;

@property (nonatomic, strong) HTPlayerSlider *progressVideoSlider;

@property (nonatomic, strong) UILabel *rightTimeLabel;

@property (nonatomic, strong) UIButton *orientationInterfaceButton;

@property (nonatomic, strong) UIButton *orientationGestureButton;

@end

@implementation HTPlayerToolBar

- (void)dealloc {
	
}

- (void)didMoveToSuperview {
	self.backgroundColor = [UIColor clearColor];
	self.bottomContentView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
	[self addSubview:self.backItemButton];
	[self addSubview:self.bottomContentView];
	[self addSubview:self.startVideoButton];
	[self addSubview:self.leftTimeLabel];
	[self addSubview:self.progressVideoSlider];
	[self addSubview:self.rightTimeLabel];
	[self addSubview:self.orientationInterfaceButton];
	[self addSubview:self.orientationGestureButton];
	[self.backItemButton mas_updateConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(15);
		make.left.mas_equalTo(15);
		make.width.height.mas_equalTo(30);
	}];
	
	[self.bottomContentView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.left.right.bottom.mas_equalTo(self);
		make.height.mas_equalTo(44);
	}];
	
	[self.startVideoButton mas_updateConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(self.bottomContentView).offset(15);
		make.centerY.mas_equalTo(self.bottomContentView);
	}];
	
	[self.leftTimeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(self.startVideoButton.mas_right).offset(15);
		make.centerY.mas_equalTo(self.bottomContentView);
	}];
	[self.progressVideoSlider mas_updateConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(self.leftTimeLabel.mas_right).offset(5);
		make.right.mas_equalTo(self.rightTimeLabel.mas_left).offset(- 15);
		make.centerY.mas_equalTo(self.bottomContentView);
		make.height.mas_equalTo(self.bottomContentView);
	}];
	[self.rightTimeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
		make.right.mas_equalTo(self.orientationInterfaceButton.mas_left).offset(- 15);
		make.centerY.mas_equalTo(self.bottomContentView);
	}];
	[self.orientationInterfaceButton mas_updateConstraints:^(MASConstraintMaker *make) {
		make.centerY.mas_equalTo(self.bottomContentView);
		make.right.mas_equalTo(self.bottomContentView).offset(- 15);
	}];
	[self.orientationGestureButton mas_updateConstraints:^(MASConstraintMaker *make) {
		make.right.mas_equalTo(self);
		make.left.mas_equalTo(self.orientationInterfaceButton.mas_left).offset(- 15);
		make.top.bottom.mas_equalTo(self);
	}];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	self.backItemButton.layer.cornerRadius = self.backItemButton.bounds.size.height / 2;
}

- (void)setPlayerModel:(HTPlayerModel *)playerModel {
	_playerModel = playerModel;
	
	__weak typeof(self) weakSelf = self;
	[playerModel bk_addObserverForKeyPath:NSStringFromSelector(@selector(isPlaying)) options:NSKeyValueObservingOptionInitial task:^(id obj, NSDictionary *change) {
		weakSelf.startVideoButton.selected = weakSelf.playerModel.isPlaying;
	}];
	[self.startVideoButton ht_whenTap:^(UIView *view) {
		[weakSelf.playerModel reloadWillSeekRateWillPlay:!weakSelf.playerModel.isPlaying];
	}];
	
	[playerModel bk_addObserverForKeyPath:NSStringFromSelector(@selector(currentTime)) options:NSKeyValueObservingOptionInitial task:^(id obj, NSDictionary *change) {
		if (!weakSelf.progressVideoSlider.highlighted) {
			weakSelf.progressVideoSlider.value = weakSelf.playerModel.currentTime;
		}
	}];
	[playerModel bk_addObserverForKeyPath:NSStringFromSelector(@selector(totalTime)) options:NSKeyValueObservingOptionInitial task:^(id obj, NSDictionary *change) {
		[weakSelf setTime:weakSelf.playerModel.totalTime label:weakSelf.rightTimeLabel];
		weakSelf.progressVideoSlider.maximumValue = weakSelf.playerModel.totalTime;
	}];
	[self.progressVideoSlider bk_addEventHandler:^(id sender) {
//		if (weakSelf.progressVideoSlider.highlighted) {
//			weakSelf.playerModel.dragingTime = weakSelf.progressVideoSlider.value;
//		}
	} forControlEvents:UIControlEventValueChanged];
	[self.progressVideoSlider bk_addEventHandler:^(id sender) {
		weakSelf.playerModel.dragEndTime = weakSelf.progressVideoSlider.value;
	} forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
	[self.progressVideoSlider bk_addObserverForKeyPath:NSStringFromSelector(@selector(value)) options:NSKeyValueObservingOptionInitial task:^(id obj, NSDictionary *change) {
		[weakSelf setTime:weakSelf.progressVideoSlider.value label:weakSelf.leftTimeLabel];
	}];
}

- (UIButton *)backItemButton {
	if (!_backItemButton) {
		_backItemButton = [[UIButton alloc] init];
		UIImage *image = [UIImage imageNamed:@"Back"];
		image = [image ht_resetSizeZoomNumber:0.8];
		image = [image ht_tintColor:[UIColor whiteColor]];
		image = [image ht_insertColor:[UIColor clearColor] edge:UIEdgeInsetsMake(0, 0, 0, 2)];
		[_backItemButton setImage:image forState:UIControlStateNormal];
		_backItemButton.layer.masksToBounds = true;
		_backItemButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
		
		__weak typeof(self) weakSelf = self;
		[self.backItemButton ht_whenTap:^(UIView *view) {
			[weakSelf.ht_controller.navigationController popViewControllerAnimated:true];
		}];
		
	}
	return _backItemButton;
}

- (UIView *)bottomContentView {
	if (!_bottomContentView) {
		_bottomContentView = [[UIView alloc] init];
	}
	return _bottomContentView;
}

- (UIButton *)startVideoButton {
	if (!_startVideoButton) {
		_startVideoButton = [[UIButton alloc] init];
		
		CGFloat imageScale = 0.7;
		UIImage *normalImage = [UIImage imageNamed:@"cn_player_stoping"];
		normalImage = [normalImage ht_resetSizeZoomNumber:imageScale];
		UIImage *selectedImage = [UIImage imageNamed:@"cn_player_playing"];
		selectedImage =[selectedImage ht_resetSizeZoomNumber:imageScale];
		[_startVideoButton setImage:normalImage forState:UIControlStateNormal];
		[_startVideoButton setImage:normalImage forState:UIControlStateNormal | UIControlStateHighlighted];
		[_startVideoButton setImage:selectedImage forState:UIControlStateSelected];
		[_startVideoButton setImage:selectedImage forState:UIControlStateSelected | UIControlStateHighlighted];
	}
	return _startVideoButton;
}

- (UILabel *)createTimeLabel {
	UILabel *label = [[UILabel alloc] init];
	label.textColor = [UIColor whiteColor];
	label.font = [UIFont systemFontOfSize:11];
	[self setTime:0 label:label];
	return label;
}

- (void)setTime:(NSTimeInterval)time label:(UILabel *)label {
	NSInteger second = (NSInteger)time % 60;
	NSInteger minute = (NSInteger)time / 60;
	label.text = [NSString stringWithFormat:@"%.2ld:%.2ld", minute, second];
}

- (UILabel *)leftTimeLabel {
	if (!_leftTimeLabel) {
		_leftTimeLabel = [self createTimeLabel];
	}
	return _leftTimeLabel;
}

- (UILabel *)rightTimeLabel {
	if (!_rightTimeLabel) {
		_rightTimeLabel = [self createTimeLabel];
	}
	return _rightTimeLabel;
}

- (HTPlayerSlider *)progressVideoSlider {
	if (!_progressVideoSlider) {
		_progressVideoSlider = [[HTPlayerSlider alloc] init];
		
		UIColor *thumbTintColor = [[UIColor ht_colorStyle:HTColorStylePrimaryTheme] colorWithAlphaComponent:1];
		UIImage *thumbImage = [UIImage ht_pureColor:[UIColor whiteColor]];
		thumbImage = [thumbImage ht_resetSize:CGSizeMake(8, 8)];
		thumbImage = [thumbImage ht_imageByRoundCornerRadius:thumbImage.size.width / 2.0 corners:UIRectCornerAllCorners borderWidth:0 borderColor:nil borderLineJoin:kCGLineJoinRound];
		thumbImage = [thumbImage ht_insertColor:thumbTintColor edge:UIEdgeInsetsMake(6, 6, 6, 6)];
		thumbImage = [thumbImage ht_imageByRoundCornerRadius:thumbImage.size.width / 2.0 corners:UIRectCornerAllCorners borderWidth:0 borderColor:nil borderLineJoin:kCGLineJoinRound];
		[_progressVideoSlider setThumbImage:thumbImage forState:UIControlStateNormal];
		[_progressVideoSlider setMinimumTrackTintColor:[UIColor whiteColor]];
		[_progressVideoSlider setMaximumTrackTintColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.7]];
	}
	return _progressVideoSlider;
}

- (UIButton *)orientationInterfaceButton {
	if (!_orientationInterfaceButton) {
		_orientationInterfaceButton = [[UIButton alloc] init];
		
		CGFloat imageScale = 0.6;
		UIImage *normalImage = [UIImage imageNamed:@"cn_player_zoom"];
		normalImage = [normalImage ht_resetSizeZoomNumber:imageScale];
		UIImage *selectedImage = [normalImage ht_resetSize:CGSizeMake(0, 0)];
		[_orientationInterfaceButton setImage:normalImage forState:UIControlStateNormal];
		[_orientationInterfaceButton setImage:normalImage forState:UIControlStateNormal | UIControlStateHighlighted];
		[_orientationInterfaceButton setImage:selectedImage forState:UIControlStateSelected];
		[_orientationInterfaceButton setImage:selectedImage forState:UIControlStateSelected | UIControlStateHighlighted];
		_orientationInterfaceButton.userInteractionEnabled = false;
	}
	return _orientationInterfaceButton;
}

- (UIButton *)orientationGestureButton {
	if (!_orientationGestureButton) {
		_orientationGestureButton = [[UIButton alloc] init];
		[_orientationGestureButton ht_whenTap:^(UIView *view) {
			[HTManagerController setDeviceOrientation:UIDeviceOrientationLandscapeLeft];
		}];
	}
	return _orientationGestureButton;
}

@end
