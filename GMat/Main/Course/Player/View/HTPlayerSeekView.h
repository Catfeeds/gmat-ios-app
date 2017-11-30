//
//  HTPlayerSeekView.h
//  GMat
//
//  Created by hublot on 2017/10/11.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTPlayerSeekView : UIToolbar

- (void)setValue:(float)value minimumValue:(float)minimumValue maximumValue:(float)maximumValue startValue:(float)startValue;

@end
