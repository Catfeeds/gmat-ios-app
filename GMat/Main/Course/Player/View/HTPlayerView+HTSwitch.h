//
//  HTPlayerView+HTSwitch.h
//  GMat
//
//  Created by hublot on 2017/9/28.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTPlayerView.h"

@interface HTPlayerView (HTSwitch)

- (void)shouldStartLoading:(BOOL)loading;

- (void)switchClearScrrenWithAnimated:(BOOL)animated;

- (void)switchClearScrrenWithAnimated:(BOOL)animated willClear:(BOOL)willClear;

- (void)switchConfigureViewHidden:(BOOL)hidden animated:(BOOL)animated;

- (void)playerModelDidPlayEnd:(AVPlayerItem *)item;

- (void)networkStateDidChange;

@end
