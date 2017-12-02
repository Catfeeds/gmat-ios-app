//
//  THBootAdvertModel.h
//  TingApp
//
//  Created by hublot on 2016/11/3.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kHTBroadCastImage64Key;

@interface THBroadCastModel : NSObject

@property (nonatomic, copy) NSString *word;

@property (nonatomic, assign) BOOL judge;

@property (nonatomic, copy) NSString *image;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, assign) NSInteger time;

@property (nonatomic, strong) NSString *ht_image_64;

@end
