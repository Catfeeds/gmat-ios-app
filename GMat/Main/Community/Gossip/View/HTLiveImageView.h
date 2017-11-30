//
//  HTLiveImageView.h
//  GMat
//
//  Created by Charles Cao on 2017/11/6.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTLiveImageView : UIView


@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, copy) void(^tap)();

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageBottomConstraint;


@end
