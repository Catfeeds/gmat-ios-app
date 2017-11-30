//
//  HTPlayerView+HTTouch.m
//  GMat
//
//  Created by hublot on 2017/9/28.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTPlayerView+HTTouch.h"
#import "HTPlayerView+HTSwitch.h"
#import "HTPlayerView+HTView.h"

@interface HTPlayerView ()

@end

@implementation HTPlayerView (HTTouch)

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	CGPoint location = [touches.anyObject locationInView:self];
	if (CGRectContainsPoint(self.playerView.frame, location) &&
		!self.isPortrait &&
		!self.playerView.hidden) {
		self.touchType = HTPlayerDragTypePlayerLayer;
	}
	self.touchStartPoint = location;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	if (self.isLockPlayer || self.isShowConfigureView) {
		return;
	}
	CGPoint location = [touches.anyObject locationInView:self];
	if (self.touchType == HTPlayerDragTypePlayerLayer) {
		if (CGPointEqualToPoint(self.lastMovePoint, CGPointZero)) {
			self.playerView.frame = CGRectMake(self.playerView.frame.origin.x + location.x - self.touchStartPoint.x, self.playerView.frame.origin.y + location.y - self.touchStartPoint.y, self.playerView.bounds.size.width, self.playerView.bounds.size.height);
		} else {
			self.playerView.frame = CGRectMake(self.playerView.frame.origin.x + location.x - self.lastMovePoint.x, self.playerView.frame.origin.y + location.y - self.lastMovePoint.y, self.playerView.bounds.size.width, self.playerView.bounds.size.height);
		}
	} else {
		if (self.toolBar.hidden) {
			CGFloat bottomMove = self.touchStartPoint.y - location.y;
			CGFloat rightMove = location.x - self.touchStartPoint.x;
			CGFloat fabsBottomMove = fabs(bottomMove);
			CGFloat fabsRightMove = fabs(rightMove);
			CGFloat bottomAppendValue = bottomMove / self.bounds.size.height;
			CGFloat rightAppendValue = rightMove / self.bounds.size.width;
			if (self.touchType == HTPlayerDragTypeNone) {
				if (fabsRightMove > fabsBottomMove) {
					if (fabsRightMove > 14) {
						self.touchType = HTPlayerDragTypeToResetVideoProgress;
						self.touchStartValue = self.playerModel.currentTime;
					}
				} else {
					if (fabsBottomMove > 7) {
						if (self.touchStartPoint.x > self.bounds.size.width / 2) {
							self.touchType = HTPlayerDragTypeToResetVolume;
							self.touchStartValue = self.volumeSlider.value;
						} else {
							self.touchType = HTPlayerDragTypeToResetLight;
							self.touchStartValue = [UIScreen mainScreen].brightness;
						}
					}
				}
			} else if (self.touchType == HTPlayerDragTypeToResetVolume) {
				[self appendDragValue:bottomAppendValue];
			} else if (self.touchType == HTPlayerDragTypeToResetLight) {
				[self appendDragValue:bottomAppendValue];
			} else if (self.touchType == HTPlayerDragTypeToResetVideoProgress) {
				[self appendDragValue:rightAppendValue];
			}
		}
	}
	self.lastMovePoint = location;
}

- (void)appendDragValue:(CGFloat)dragValue {
	if (self.touchType == HTPlayerDragTypeToResetVolume) {
		CGFloat volmeValue = MAX(0, MIN(self.touchStartValue + dragValue, 1));
		CGFloat singleValue = 1 / 30.0;
		if (fabs(self.volumeSlider.value - volmeValue) > singleValue
			|| (volmeValue <= 0 && self.volumeSlider.value > 0)
			|| (volmeValue >= 1 && self.volumeSlider.value < 1)) {
			[self.volumeSlider setValue:volmeValue animated:false];
		}
	} else if (self.touchType == HTPlayerDragTypeToResetLight) {
		[UIScreen mainScreen].brightness = MAX(0, MIN(self.touchStartValue + dragValue, 1));
	} else if (self.touchType == HTPlayerDragTypeToResetVideoProgress) {
		self.playerModel.dragingTime = self.touchStartValue + (dragValue * 0.1 * self.playerModel.totalTime);
	}
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
	if (self.isLockPlayer) {
		[self switchClearScrrenWithAnimated:true];
	} else if (self.isShowConfigureView) {
		[self switchConfigureViewHidden:true animated:true];
	} else if (self.touchType == HTPlayerDragTypePlayerLayer) {
		[UIView animateWithDuration:0.1 animations:^{
			[self reloadDragViewFrame];
		} completion:nil];
	} else if (self.touchType == HTPlayerDragTypeToResetVideoProgress) {
		self.playerModel.dragEndTime = self.playerModel.dragingTime;
	} else if (self.touchType == HTPlayerDragTypeNone) {
		[self switchClearScrrenWithAnimated:true];
	}
	self.touchStartPoint = self.lastMovePoint = CGPointZero;
	self.touchType = HTPlayerDragTypeNone;
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
	[self touchesEnded:touches withEvent:event];
}



- (BOOL)isHighlighted {
	__block BOOL isHighlighted = false;
	NSArray *superViewArray = @[self.navigationBar, self.playerTabBar, self.toolBar];
	[superViewArray enumerateObjectsUsingBlock:^(UIView *superView, NSUInteger index, BOOL * _Nonnull outStop) {
		[superView.subviews enumerateObjectsUsingBlock:^(__kindof UIControl *control, NSUInteger index, BOOL * _Nonnull inStop) {
			if ([control isKindOfClass:[UIControl class]] && control.isHighlighted) {
				isHighlighted = true;
				*outStop = true;
				*inStop = true;
			}
		}];
	}];
	return isHighlighted;
}

- (BOOL)isShowConfigureView {
	return !CGAffineTransformEqualToTransform(self.configureView.transform, CGAffineTransformIdentity);
}

- (BOOL)isLockPlayer {
	return self.playerLeftBar.lockPlayerButton.selected;
}

@end
