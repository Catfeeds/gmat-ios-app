//
//  HTPlayerView.h
//  GMat
//
//  Created by hublot on 2017/9/26.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "HTPlayerModel.h"
#import "HTPlayerDragView.h"
#import "HTPlayerSeekView.h"
#import "HTPlayerToolBar.h"
#import "HTPlayerNavigationBar.h"
#import "HTPlayerTabBar.h"
#import "HTPlayerLeftView.h"
#import "HTPlayerConfigureView.h"
#import "HTPlayerSpeedView.h"

typedef NS_ENUM(NSInteger, HTPlayerDragType) {
	HTPlayerDragTypeNone,
	HTPlayerDragTypePlayerLayer,
	HTPlayerDragTypeToResetVolume,
	HTPlayerDragTypeToResetLight,
	HTPlayerDragTypeToResetVideoProgress,
};

@interface HTPlayerView : UIView

@property (nonatomic, strong) UIImageView *documentImageView;

@property (nonatomic, strong) HTPlayerDragView *playerView;

@property (nonatomic, strong) UIActivityIndicatorView *loadIndicatorView;

@property (nonatomic, strong) HTPlayerToolBar *toolBar;

@property (nonatomic, strong) HTPlayerNavigationBar *navigationBar;

@property (nonatomic, strong) HTPlayerTabBar *playerTabBar;

@property (nonatomic, strong) HTPlayerLeftView *playerLeftBar;

@property (nonatomic, strong) HTPlayerConfigureView *configureView;

@property (nonatomic, strong) HTPlayerSpeedView *playerSpeedView;

@property (nonatomic, strong) HTPlayerSeekView *playerSeekView;

@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, strong) UISlider *volumeSlider;

@end

@interface HTPlayerView ()

@property (nonatomic, assign) BOOL willClearAnimated;

@property (nonatomic, assign) BOOL willClearScreen;

@end

@interface HTPlayerView ()

@property (nonatomic, assign) HTPlayerDragType touchType;

@property (nonatomic, assign) CGPoint touchStartPoint;

@property (nonatomic, assign) CGFloat touchStartValue;

@property (nonatomic, assign) CGPoint lastMovePoint;

@end

@interface HTPlayerView ()

@property (nonatomic, strong) HTPlayerModel *playerModel;

@property (nonatomic, assign) BOOL isPortrait;

- (BOOL)shouldAutorotate;

@end
