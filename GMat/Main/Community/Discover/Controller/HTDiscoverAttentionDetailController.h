//
//  HTDiscoverAttentionDetailController.h
//  GMat
//
//  Created by hublot on 2017/7/5.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTDiscoverAttentionModel.h"

@interface HTDiscoverAttentionDetailController : UIViewController

@property (nonatomic, strong) void(^detailDidDismissBlock)(HTDiscoverAttentionModel *discoverModel);

@property (nonatomic, strong) NSString *attentionId;

@end
