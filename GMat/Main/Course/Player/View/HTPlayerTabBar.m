//
//  HTPlayerTabBar.m
//  GMat
//
//  Created by hublot on 2017/9/26.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTPlayerTabBar.h"
#import "HTPlayerSlider.h"

@interface HTPlayerTabBar ()

@property (nonatomic, strong) UIButton *startVideoButton;

@property (nonatomic, strong) UILabel *leftTimeLabel;

@property (nonatomic, strong) HTPlayerSlider *progressVideoSlider;

@property (nonatomic, strong) UILabel *rightTimeLabel;

@end

@implementation HTPlayerTabBar

- (void)dealloc {
	
}

- (void)didMoveToSuperview {
	self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
	[self addSubview:self.startVideoButton];
	[self addSubview:self.leftTimeLabel];
	[self addSubview:self.progressVideoSlider];
	[self addSubview:self.rightTimeLabel];
	
	[self.startVideoButton mas_updateConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(15);
		make.centerY.mas_equalTo(self);
	}];
	
	[self.leftTimeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(self.startVideoButton.mas_right).offset(15);
		make.centerY.mas_equalTo(self);
	}];
	[self.progressVideoSlider mas_updateConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(self.leftTimeLabel.mas_right).offset(5);
		make.right.mas_equalTo(self.rightTimeLabel.mas_left).offset(- 15);
		make.centerY.mas_equalTo(self);
		make.height.mas_equalTo(self);
	}];
	[self.rightTimeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
		make.right.mas_equalTo(self).offset(- 15);
		make.centerY.mas_equalTo(self);
	}];
	
}

- (void)setPlayerModel:(HTPlayerModel *)playerModel {
	_playerModel = playerModel;
	
	__weak typeof(self) weakSelf = self;
	[playerModel bk_addObserverForKeyPath:NSStringFromSelector(@selector(isPlaying)) options:NSKeyValueObservingOptionInitial task:^(id obj, NSDictionary *change) {
		weakSelf.startVideoButton.selected = weakSelf.playerModel.isPlaying;
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
	[self.startVideoButton ht_whenTap:^(UIView *view) {
		[weakSelf.playerModel reloadWillSeekRateWillPlay:!weakSelf.playerModel.isPlaying];
	}];
	[self.progressVideoSlider bk_addEventHandler:^(id sender) {
		if (weakSelf.progressVideoSlider.highlighted) {
			weakSelf.playerModel.dragingTime = weakSelf.progressVideoSlider.value;
		}
	} forControlEvents:UIControlEventValueChanged];
	[self.progressVideoSlider bk_addEventHandler:^(id sender) {
		weakSelf.playerModel.dragEndTime = weakSelf.progressVideoSlider.value;
	} forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
	[self.progressVideoSlider bk_addObserverForKeyPath:NSStringFromSelector(@selector(value)) options:NSKeyValueObservingOptionInitial task:^(id obj, NSDictionary *change) {
		[weakSelf setTime:weakSelf.progressVideoSlider.value label:weakSelf.leftTimeLabel];
	}];
}

- (UIButton *)startVideoButton {
	if (!_startVideoButton) {
		_startVideoButton = [[UIButton alloc] init];
		
		CGFloat imageScale = 0.9;
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
		UIColor *tintColor = [[UIColor ht_colorStyle:HTColorStylePrimaryTheme] colorWithAlphaComponent:1];
		UIImage *image = [UIImage ht_pureColor:[UIColor whiteColor]];
		image = [image ht_resetSize:CGSizeMake(8, 8)];
		image = [image ht_imageByRoundCornerRadius:image.size.width / 2.0 corners:UIRectCornerAllCorners borderWidth:0 borderColor:nil borderLineJoin:kCGLineJoinRound];
		image = [image ht_insertColor:tintColor edge:UIEdgeInsetsMake(6, 6, 6, 6)];
		image = [image ht_imageByRoundCornerRadius:image.size.width / 2.0 corners:UIRectCornerAllCorners borderWidth:0 borderColor:nil borderLineJoin:kCGLineJoinRound];
		[_progressVideoSlider setThumbImage:image forState:UIControlStateNormal];
		[_progressVideoSlider setMinimumTrackTintColor:[UIColor whiteColor]];
		[_progressVideoSlider setMaximumTrackTintColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.7]];
	}
	return _progressVideoSlider;
}

@end
