//
//  HTReuseController.h
//  GMat
//
//  Created by hublot on 2016/11/1.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UITableView+HTSeparate.h>
#import "HTPageModel.h"

@interface HTReuseController : UIViewController

@property (nonatomic, strong) HTPageModel *pageModel;

@property (nonatomic, strong) UITableView *tableView;

@end
