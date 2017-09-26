//
//  HTPlayerView.m
//  GMat
//
//  Created by hublot on 2017/9/26.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTPlayerView.h"
#import "HTPlayerDragView.h"
#import "HTPlayerNavigationBar.h"

@interface HTPlayerView ()

@property (nonatomic, strong) UIImageView *documentImageView;

@property (nonatomic, strong) HTPlayerDragView *playerView;

@property (nonatomic, strong) HTPlayerNavigationBar *navigationBar;

@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, assign) BOOL isDragPlayer;

@property (nonatomic, assign) CGPoint playerOriginPoint;

@end

@implementation HTPlayerView

- (void)dealloc {
	
}

- (void)didMoveToSuperview {
	self.backgroundColor = [UIColor blackColor];
	[self addSubview:self.documentImageView];
	[self addSubview:self.navigationBar];
	[self addSubview:self.playerView];
	[self.documentImageView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.edges.mas_equalTo(UIEdgeInsetsZero);
	}];
	[self.navigationBar mas_updateConstraints:^(MASConstraintMaker *make) {
		make.top.left.right.mas_equalTo(self);
		make.height.mas_equalTo([UIApplication sharedApplication].statusBarFrame.size.height + 44);
	}];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	CGRect playerFrame = self.playerView.frame;
	CGFloat height = self.bounds.size.height / 2;
	CGFloat width = height * (16 / 9.0);
	playerFrame.size = CGSizeMake(width, height);
	self.playerView.frame = playerFrame;
}

- (void)setPlayerModel:(HTPlayerModel *)playerModel {
	if (_playerModel == playerModel) {
		return;
	}
	_playerModel = playerModel;
	NSURL *URL = [NSURL URLWithString:playerModel.m3u8URLString];
	AVAsset *asset = [AVAsset assetWithURL:URL];
	if (!asset.playable) {
		return;
	}
	AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:asset];
	self.player = [AVPlayer playerWithPlayerItem:item];
	[self.playerView setPlayer:self.player];
	
	
	CMTime observerTime = CMTimeMake(1, 10.0);
	__weak typeof(self) weakSelf = self;
	
	[self.player addPeriodicTimeObserverForInterval:observerTime queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
		weakSelf.playerModel.currentTime = (CGFloat)item.currentTime.value/ item.currentTime.timescale;
	}];
	
	[playerModel bk_removeAllBlockObservers];
	[self.playerModel bk_addObserverForKeyPath:NSStringFromSelector(@selector(currentDocumentModel)) options:NSKeyValueObservingOptionInitial task:^(id obj, NSDictionary *change) {
		HTPlayerDocumentModel *documentModel = weakSelf.playerModel.currentDocumentModel;
		[weakSelf.documentImageView sd_setImageWithURL:[NSURL URLWithString:documentModel.resourceURLString] placeholderImage:nil];
	}];
	
	[self.player play];
	
}

- (void)setIsPortrait:(BOOL)isPortrait {
	_isPortrait = isPortrait;
	self.navigationBar.isPortrait = isPortrait;
	[self touchesEnded:[NSSet set] withEvent:nil];
	if (isPortrait) {
		
	} else {
		
	}
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	CGPoint location = [touches.anyObject locationInView:self];
	if (CGRectContainsPoint(self.playerView.frame, location)) {
		self.playerOriginPoint = location;
	}
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	if (!CGPointEqualToPoint(self.playerOriginPoint, CGPointZero)) {
		CGPoint location = [touches.anyObject locationInView:self];
		self.playerView.frame = CGRectMake(self.playerView.frame.origin.x + location.x - self.playerOriginPoint.x, self.playerView.frame.origin.y + location.y - self.playerOriginPoint.y, self.playerView.bounds.size.width, self.playerView.bounds.size.height);
		self.playerOriginPoint = location;
		self.isDragPlayer = true;
	}
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
	CGPoint location = [touches.anyObject locationInView:self];
	if (self.isDragPlayer) {
		[UIView animateWithDuration:0.1 animations:^{
			self.playerView.frame = CGRectMake(MAX(0, MIN(self.playerView.frame.origin.x, self.bounds.size.width - self.playerView.frame.size.width)), MAX(0, MIN(self.playerView.frame.origin.y, self.bounds.size.height - self.playerView.frame.size.height)), self.playerView.bounds.size.width, self.playerView.bounds.size.height);
		} completion:nil];
		self.isDragPlayer = false;
	} else {
		if (CGRectContainsPoint(self.playerView.frame, location)) {
			self.playerView.beHalfHidden = !self.playerView.beHalfHidden;
		}
	}
	self.playerOriginPoint = CGPointZero;
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
	[self touchesEnded:touches withEvent:event];
}

- (UIImageView *)documentImageView {
	if (!_documentImageView) {
		_documentImageView = [[UIImageView alloc] init];
	}
	return _documentImageView;
}

- (HTPlayerDragView *)playerView {
	if (!_playerView) {
		_playerView = [[HTPlayerDragView alloc] init];
	}
	return _playerView;
}

- (HTPlayerNavigationBar *)navigationBar {
	if (!_navigationBar) {
		_navigationBar = [[HTPlayerNavigationBar alloc] init];
	}
	return _navigationBar;
}

@end
