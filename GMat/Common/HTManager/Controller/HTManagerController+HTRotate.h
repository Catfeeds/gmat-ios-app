//
//  HTManagerController+HTRotate.h
//  GMat
//
//  Created by hublot on 2017/7/14.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTManagerController.h"

// ipad 和 iphone 都 随便旋转
@protocol HTRotateEveryOne <NSObject>

@end

// 只有 ipad 可以 随便旋转, iphone 固定竖屏
@protocol HTRotateEveryOneOnlyIpad <NSObject>

@end


// 自定义, 重写对应的三个方法即可
@protocol HTRotateScrren <NSObject>

@end


// 自己就是显示的 visibleController, 不再往下遍历寻找, 包括 navigationController 不再往上穿透
@protocol HTRotateVisible <NSObject>

@end



@interface HTManagerController (HTRotate)

// 强制旋转
+ (void)setDeviceOrientation:(UIDeviceOrientation)orientation;

@end
