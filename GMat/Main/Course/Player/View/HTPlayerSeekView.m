//
//  HTPlayerSeekView.m
//  GMat
//
//  Created by hublot on 2017/10/11.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTPlayerSeekView.h"

@interface HTPlayerSeekView ()

@property (nonatomic, strong) UIButton *stateImageButton;

@property (nonatomic, strong) UILabel *titleNameLabel;

@property (nonatomic, assign) BOOL willHiddenBrightness;

@property (nonatomic, assign) BOOL willHiddenAnimated;

@end

@implementation HTPlayerSeekView

- (void)dealloc {
	
}

- (void)setValue:(float)value minimumValue:(float)minimumValue maximumValue:(float)maximumValue startValue:(float)startValue {
	CGFloat maxValue = MAX(minimumValue, maximumValue);
	CGFloat seekValue = MIN(MAX(minimumValue, value), maxValue);
	self.stateImageButton.selected = seekValue > startValue;
	
	NSString *seekTimeString = [self stringWithTimeInterval:seekValue];
	NSString *maximumString = [self stringWithTimeInterval:maxValue];
	NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	paragraphStyle.alignment = NSTextAlignmentCenter;
	NSDictionary *normalDictionary = @{NSFontAttributeName:[UIFont systemFontOfSize:15],
									   NSForegroundColorAttributeName:[UIColor blackColor],
									   NSParagraphStyleAttributeName:paragraphStyle};
	NSDictionary *selectedDictionary = @{NSFontAttributeName:[UIFont systemFontOfSize:15],
										 NSForegroundColorAttributeName:[UIColor orangeColor],
										 NSParagraphStyleAttributeName:paragraphStyle};
	NSMutableAttributedString *attributedString = [[[NSAttributedString alloc] initWithString:seekTimeString attributes:selectedDictionary] mutableCopy];
	NSAttributedString *appendAttributedString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" / %@", maximumString] attributes:normalDictionary];
	[attributedString appendAttributedString:appendAttributedString];
	self.titleNameLabel.attributedText = attributedString;
	
	self.willHiddenBrightness = false;
	self.willHiddenAnimated = true;
	[self switchSeekViewHidden];
}

- (NSString *)stringWithTimeInterval:(NSTimeInterval)timeInterval {
	NSInteger second = (NSInteger)timeInterval % 60;
	NSInteger minute = (NSInteger)timeInterval / 60;
 	NSString *string = [NSString stringWithFormat:@"%.2ld:%.2ld", minute, second];
	return string;
}

- (void)didMoveToSuperview {
	if (!self.superview) {
		return;
	}
	self.userInteractionEnabled = false;
	self.layer.cornerRadius = 10;
	self.layer.masksToBounds = true;
	[self mas_updateConstraints:^(MASConstraintMaker *make) {
		make.width.height.mas_equalTo(155);
		make.center.mas_equalTo(self.superview);
	}];
	
	[self addSubview:self.stateImageButton];
	[self addSubview:self.titleNameLabel];
	[self.stateImageButton mas_updateConstraints:^(MASConstraintMaker *make) {
		make.centerX.mas_equalTo(self);
		make.top.mas_equalTo(30);
	}];
	[self.titleNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(self.stateImageButton.mas_bottom).offset(10);
		make.left.mas_equalTo(15);
		make.right.mas_equalTo(- 15);
	}];
	self.willHiddenBrightness = true;
	self.willHiddenAnimated = false;
	[self switchSeekViewHidden];
}

- (void)switchSeekViewHidden {
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(switchSeekViewHidden) object:nil];
	[UIView animateWithDuration:self.willHiddenAnimated ? 0.15 : 0 animations:^{
		if (self.willHiddenBrightness) {
			self.alpha = 0;
		} else {
			self.alpha = 1;
		}
	} completion:^(BOOL finished) {
		if (!self.willHiddenBrightness) {
			self.willHiddenBrightness = true;
			self.willHiddenAnimated = true;
			[self performSelector:@selector(switchSeekViewHidden) withObject:nil afterDelay:1];
		}
	}];
}

- (UIButton *)stateImageButton {
	if (!_stateImageButton) {
		_stateImageButton = [[UIButton alloc] init];
		CGFloat scale = 0.8;
		UIImage *normalImage = [UIImage imageNamed:@"cn_player_seek_sub"];
		normalImage = [normalImage ht_resetSizeZoomNumber:scale];
		UIImage *selectedImage = [UIImage imageNamed:@"cn_player_seek_add"];
		selectedImage = [selectedImage ht_resetSizeZoomNumber:scale];
		[_stateImageButton setImage:normalImage forState:UIControlStateNormal];
		[_stateImageButton setImage:selectedImage forState:UIControlStateSelected];
	}
	return _stateImageButton;
}

- (UILabel *)titleNameLabel {
	if (!_titleNameLabel) {
		_titleNameLabel = [[UILabel alloc] init];
	}
	return _titleNameLabel;
}

@end
