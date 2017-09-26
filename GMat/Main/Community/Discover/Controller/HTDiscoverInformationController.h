//
//  HTDiscoverInformationController.h
//  GMat
//
//  Created by hublot on 2017/6/28.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTReuseController.h"

@interface HTDiscoverInformationController : HTReuseController

@property (nonatomic, copy) void(^didScrollBlock)(UITableView *tableView);

@end
