//
//  HTPlayerView.m
//  GMat
//
//  Created by hublot on 2017/9/26.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTPlayerView.h"
#import "HTPlayerView+HTSwitch.h"
#import "HTPlayerView+HTView.h"
#import "HTPlayerView+HTTouch.h"
#import <AFNetworkReachabilityManager.h>

@interface HTPlayerView ()

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation HTPlayerView

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[self.timer invalidate];
}

- (void)setPlayerModel:(HTPlayerModel *)playerModel {
	if (_playerModel == playerModel) {
		return;
	}
	_playerModel = playerModel;
	_playerModel.isLoading = true;
	NSURL *URL = [NSURL URLWithString:playerModel.m3u8URLString];
	AVAsset *asset = [AVAsset assetWithURL:URL];
	if (!asset.playable) {
		return;
	}
	AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:asset];
	self.player = [AVPlayer playerWithPlayerItem:item];
	[self.playerView setPlayer:self.player];
	
	[self.navigationBar setPlayerModel:playerModel];
	[self.playerTabBar setPlayerModel:playerModel];
	[self.toolBar setPlayerModel:playerModel];
	[self.playerSpeedView setPlayerModel:playerModel];
	
	__weak typeof(self) weakSelf = self;
	
	[self.timer invalidate];
	self.timer = [NSTimer bk_scheduledTimerWithTimeInterval:0.1 block:^(NSTimer *timer) {
		CMTime currentCMTime = weakSelf.player.currentTime;
		CGFloat currentCGTime = (CGFloat)currentCMTime.value / currentCMTime.timescale;
		weakSelf.playerModel.currentTime = currentCGTime;
	} repeats:true];
	
	[self.playerModel bk_addObserverForKeyPath:NSStringFromSelector(@selector(dragingTime)) options:NSKeyValueObservingOptionNew task:^(id obj, NSDictionary *change) {
		[weakSelf.playerSeekView setValue:weakSelf.playerModel.dragingTime minimumValue:0 maximumValue:weakSelf.playerModel.totalTime startValue:weakSelf.playerModel.currentTime];
	}];
	
	[self.playerModel bk_addObserverForKeyPath:NSStringFromSelector(@selector(dragEndTime)) options:NSKeyValueObservingOptionNew task:^(id obj, NSDictionary *change) {
		CMTime willSeekTime = CMTimeMake(weakSelf.playerModel.dragEndTime, 1);
		[weakSelf.player seekToTime:willSeekTime completionHandler:^(BOOL finished) {
		}];
	}];
	
	[self.player bk_addObserverForKeyPath:NSStringFromSelector(@selector(rate)) options:NSKeyValueObservingOptionNew task:^(id obj, NSDictionary *change) {
		weakSelf.playerModel.currentRate = weakSelf.player.rate;
	}];
	
	[self.playerModel bk_addObserverForKeyPath:NSStringFromSelector(@selector(willSeekRate)) options:NSKeyValueObservingOptionNew task:^(id obj, NSDictionary *change) {
		weakSelf.player.rate = weakSelf.playerModel.willSeekRate;
		[[UIApplication sharedApplication] setIdleTimerDisabled:weakSelf.player.rate > 0 ? true : false];
		[weakSelf switchConfigureViewHidden:true animated:true];
	}];
	[self.playerModel reloadWillSeekRateWillPlay:true];
	
	[self.playerModel bk_addObserverForKeyPath:NSStringFromSelector(@selector(currentDocumentModel)) options:NSKeyValueObservingOptionInitial task:^(id obj, NSDictionary *change) {
		HTPlayerDocumentModel *documentModel = weakSelf.playerModel.currentDocumentModel;
		[weakSelf.documentImageView sd_setImageWithURL:[NSURL URLWithString:documentModel.resourceURLString] placeholderImage:weakSelf.documentImageView.image];
	}];
	
	[self.playerModel bk_addObserverForKeyPath:NSStringFromSelector(@selector(isLoading)) options:NSKeyValueObservingOptionNew task:^(id obj, NSDictionary *change) {
		[weakSelf shouldStartLoading:weakSelf.playerModel.isLoading];
	}];
	
	
	self.playerModel.totalTime = (ceilf)(asset.duration.value / asset.duration.timescale);
	
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(playerModelDidPlayEnd:)
												 name:AVPlayerItemDidPlayToEndTimeNotification
											   object:item];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(networkStateDidChange)
												 name:AFNetworkingReachabilityDidChangeNotification
											   object:nil];
	
	[self networkStateDidChange];
	[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
	
}

- (void)setIsPortrait:(BOOL)isPortrait {
	_isPortrait = isPortrait;
	[self aligmnDragViewRightBottom];
	if (isPortrait) {
		self.toolBar.hidden = false;
		self.navigationBar.hidden = self.playerTabBar.hidden = self.playerLeftBar.hidden = true;
		[self switchConfigureViewHidden:true animated:false];
	} else {
		self.toolBar.hidden = true;
		self.navigationBar.hidden = self.playerTabBar.hidden = self.playerLeftBar.hidden = false;
	}
	[self switchClearScrrenWithAnimated:true willClear:false];
}

- (BOOL)shouldAutorotate {
	return !self.isLockPlayer;
}

// ui

- (UIImageView *)documentImageView {
	if (!_documentImageView) {
		_documentImageView = [[UIImageView alloc] init];
	}
	return _documentImageView;
}

- (UIActivityIndicatorView *)loadIndicatorView {
	if (!_loadIndicatorView) {
		_loadIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		_loadIndicatorView.hidesWhenStopped = true;
		_loadIndicatorView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
		_loadIndicatorView.layer.cornerRadius = 5;
		_loadIndicatorView.layer.masksToBounds = true;
	}
	return _loadIndicatorView;
}

- (HTPlayerDragView *)playerView {
	if (!_playerView) {
		_playerView = [[HTPlayerDragView alloc] init];
	}
	return _playerView;
}

- (HTPlayerToolBar *)toolBar {
	if (!_toolBar) {
		_toolBar = [[HTPlayerToolBar alloc] init];
	}
	return _toolBar;
}

- (HTPlayerNavigationBar *)navigationBar {
	if (!_navigationBar) {
		_navigationBar = [[HTPlayerNavigationBar alloc] init];
		
		__weak typeof(self) weakSelf = self;
		
		[_navigationBar.teacherButton ht_whenTap:^(UIView *view) {
			weakSelf.navigationBar.teacherButton.selected = !weakSelf.navigationBar.teacherButton.selected;
			weakSelf.playerView.hidden = weakSelf.navigationBar.teacherButton.selected;
		}];
		
		[_navigationBar.speedButton ht_whenTap:^(UIView *view) {
			[weakSelf.configureView showView:weakSelf.playerSpeedView];
			[weakSelf switchConfigureViewHidden:false animated:true];
			[weakSelf switchClearScrrenWithAnimated:true willClear:true];
		}];
	}
	return _navigationBar;
}

- (HTPlayerTabBar *)playerTabBar {
	if (!_playerTabBar) {
		_playerTabBar = [[HTPlayerTabBar alloc] init];
	}
	return _playerTabBar;
}

- (HTPlayerLeftView *)playerLeftBar {
	if (!_playerLeftBar) {
		_playerLeftBar = [[HTPlayerLeftView alloc] init];
		__weak typeof(self) weakSelf = self;
		[_playerLeftBar.lockPlayerButton ht_whenTap:^(UIView *view) {
			weakSelf.playerLeftBar.lockPlayerButton.selected = !weakSelf.playerLeftBar.lockPlayerButton.selected;
			if (weakSelf.playerLeftBar.lockPlayerButton.selected) {
				[weakSelf switchClearScrrenWithAnimated:false willClear:true];
			} else {
				[weakSelf switchClearScrrenWithAnimated:true willClear:false];
			}
		}];
	}
	return _playerLeftBar;
}

- (UISlider *)volumeSlider {
	if (!_volumeSlider) {
		MPVolumeView *volumeView = [[MPVolumeView alloc] init];
		[volumeView.subviews enumerateObjectsUsingBlock:^(__kindof UIView *view, NSUInteger index, BOOL * _Nonnull stop) {
			if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
				_volumeSlider = (UISlider *)view;
				*stop = true;
			}
		}];
	}
	return _volumeSlider;
}

- (HTPlayerSeekView *)playerSeekView {
	if (!_playerSeekView) {
		_playerSeekView = [[HTPlayerSeekView alloc] init];
	}
	return _playerSeekView;
}

- (HTPlayerConfigureView *)configureView {
	if (!_configureView) {
		_configureView = [[HTPlayerConfigureView alloc] init];
	}
	return _configureView;
}

- (HTPlayerSpeedView *)playerSpeedView {
	if (!_playerSpeedView) {
		_playerSpeedView = [[HTPlayerSpeedView alloc] init];
	}
	return _playerSpeedView;
}

@end
