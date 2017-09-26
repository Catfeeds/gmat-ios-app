//
//  THManagerModel.h
//  GMat
//
//  Created by hublot on 17/1/20.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTUpdateModel.h"

@interface THManagerModel : NSObject

@property (nonatomic, strong) HTUpdateModel *updateModel;

@property (nonatomic, assign) BOOL isDownloadFirstLaunch;

@property (nonatomic, assign) BOOL isAppStoreOnReviewingVersion;

@end
