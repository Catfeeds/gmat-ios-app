//
//  HTWebController.h
//  GMat
//
//  Created by hublot on 2017/4/24.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTWebController : UIViewController

@property (nonatomic, copy) void(^customShareBlock)(NSString *currentTitle, NSString *currentUrl);

- (instancetype)initWithAddress:(NSString *)address;

- (instancetype)initWithURL:(NSURL *)URL;

- (instancetype)initWithRequest:(NSURLRequest *)request;

@end
