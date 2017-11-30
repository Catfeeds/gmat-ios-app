//
//  HTCommunityWebPayViewController.h
//  GMat
//
//  Created by Charles Cao on 2017/11/8.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HTCommunityWebPayViewControllerDelegate <NSObject>

//支付成功
- (void) paySuccess;

@end

@interface HTCommunityWebPayViewController : UIViewController

@property (nonatomic, assign) id<HTCommunityWebPayViewControllerDelegate> delegate;

@end
