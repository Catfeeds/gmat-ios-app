//
//  HTPlayerView.h
//  GMat
//
//  Created by hublot on 2017/9/26.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTPlayerModel.h"

@interface HTPlayerView : UIView

@property (nonatomic, strong) HTPlayerModel *playerModel;

@property (nonatomic, assign) BOOL isPortrait;

@end
