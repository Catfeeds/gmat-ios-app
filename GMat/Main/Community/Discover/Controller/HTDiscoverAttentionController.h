//
//  HTDiscoverAttentionController.h
//  GMat
//
//  Created by hublot on 2017/7/5.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTReuseController.h"

@interface HTDiscoverAttentionController : HTReuseController

@property (nonatomic, copy) void(^didScrollBlock)(UITableView *tableView);

@end
