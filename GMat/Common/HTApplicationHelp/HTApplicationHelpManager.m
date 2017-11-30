//
//  HTApplicationHelpManager.m
//  GMat
//
//  Created by hublot on 17/5/23.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTApplicationHelpManager.h"
#import "HTManagerController.h"

@implementation HTApplicationHelpManager

+ (BOOL)helpUserIsHadDisplayWithIdentifier:(NSString *)identifier {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (![userDefaults valueForKey:identifier]) {
        [userDefaults setValue:identifier forKey:identifier];
        return false;
    }
    return true;
}

+ (UIImage *)isoscelesTriangleImageBase:(CGFloat)base altitude:(CGFloat)altitude color:(UIColor *)color {
	CGSize size = CGSizeMake(base, altitude);
	UIGraphicsBeginImageContextWithOptions(size, false, 0);
	UIBezierPath *bezierPath = [UIBezierPath bezierPath];
	[bezierPath moveToPoint:CGPointMake(0, altitude)];
	[bezierPath addLineToPoint:CGPointMake(base / 2, 0)];
	[bezierPath addLineToPoint:CGPointMake(base, altitude)];
	[bezierPath closePath];
	[bezierPath addClip];
	
	[color set];
	UIRectFill((CGRect){{0, 0}, size});
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return image;
}

+ (void)helpUserToKnowOFFLineExerciseUpdateWithView:(UIView *)view {
	NSString *helpUserToKnowOFFLineExerciseUpdateKey =  @"helpUserToKnowOFFLineExerciseUpdate";
	NSInteger helpUserToKnowOFFLineExerciseUpdateTag = 701;
	
	UIView *superView = view.ht_controller.view;
	
	if ([superView viewWithTag:helpUserToKnowOFFLineExerciseUpdateTag]) {
		return;
	}
	
	if (![self helpUserIsHadDisplayWithIdentifier:helpUserToKnowOFFLineExerciseUpdateKey]) {
		UIImageView *displayImageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
		displayImageView.tag = helpUserToKnowOFFLineExerciseUpdateTag;
		displayImageView.image = [UIImage imageNamed:@"MineTeachUserOffLineButton"];
		[superView addSubview:displayImageView];
		
		__weak typeof(displayImageView) weakDisplayImageView = displayImageView;
		[displayImageView ht_whenTap:^(UIView *view) {
			[UIView animateWithDuration:0.2 animations:^{
				weakDisplayImageView.alpha = 0;
			} completion:^(BOOL finished) {
				[weakDisplayImageView removeFromSuperview];
			}];
		}];
	} else {
		
//		
//		UIButton *titleButton = [[UIButton alloc] initWithFrame:CGRectZero];
//		[titleButton setTitle:@"点我, 同步做题数据到电脑端啦" forState:UIControlStateNormal];
//		titleButton.titleLabel.font = [UIFont systemFontOfSize:14];
//		[titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//		
//		CGFloat triangleWidth = 25;
//		CGFloat triangleHeight = 25;
//		CGFloat triangleCircelPadding = - 15;
//		[titleButton setContentEdgeInsets:UIEdgeInsetsMake(5, 10, 5, triangleWidth + triangleCircelPadding + 5)];
//		titleButton.tag = helpUserToKnowOFFLineExerciseUpdateTag;
//		[superView addSubview:titleButton];
//		[titleButton sizeToFit];
//		
//		UIColor *backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
//		UIImage *circelImage = [UIImage ht_pureColor:[UIColor orangeColor]];
//		circelImage = [circelImage ht_resetSize:CGSizeMake(titleButton.bounds.size.width, titleButton.bounds.size.height)];
//		circelImage = [circelImage ht_imageByRoundCornerRadius:titleButton.bounds.size.height corners:UIRectCornerAllCorners borderWidth:0 borderColor:nil borderLineJoin:kCGLineJoinRound];
//		
//		UIImage *triangleImage = [self isoscelesTriangleImageBase:triangleHeight altitude:triangleWidth color:[UIColor orangeColor]];
//		triangleImage = [triangleImage ht_customOrientationDisplay:UIImageOrientationRight];
//		
//		UIImage *backgroundImage = [UIImage ht_pureColor:[UIColor clearColor]];
//		backgroundImage = [backgroundImage ht_resetSize:CGSizeMake(circelImage.size.width + circelImage.size.height + triangleCircelPadding, circelImage.size.height)];
//		backgroundImage = [backgroundImage ht_appendImage:circelImage atRect:CGRectMake(0, 0, circelImage.size.width, circelImage.size.height)];
//		backgroundImage = [backgroundImage ht_appendImage:triangleImage atRect:CGRectMake(circelImage.size.width + triangleCircelPadding, (backgroundImage.size.height - triangleImage.size.height) / 2, triangleImage.size.width, triangleImage.size.height)];
//		backgroundImage = [backgroundImage ht_tintColor:backgroundColor];
//		[titleButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
//		
//		[titleButton mas_updateConstraints:^(MASConstraintMaker *make) {
//			make.right.mas_equalTo(view.mas_left).offset(- 2);
//			make.centerY.mas_equalTo(view);
//		}];
//		
//		__weak typeof(titleButton) weakTitleButton = titleButton;
//		[titleButton ht_whenTap:^(UIView *view) {
//			[UIView animateWithDuration:0.25 animations:^{
//				weakTitleButton.alpha = 0;
//			} completion:^(BOOL finished) {
//				[weakTitleButton removeFromSuperview];
//			}];
//		}];
	}
}

@end
