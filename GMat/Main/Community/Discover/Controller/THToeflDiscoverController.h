//
//  THToeflDiscoverController.h
//  TingApp
//
//  Created by hublot on 16/8/22.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTPageController.h"

typedef NS_ENUM(NSInteger, HTDiscoverType) {
	HTDiscoverTypeInformation,
	HTDiscoverTypeKeyking,
	HTDiscoverTypeDatum
};

@interface THToeflDiscoverController : HTPageController

- (void)ht_startRefreshHeader;

@property (nonatomic, assign) CGFloat discoverContentOffX;

@end
