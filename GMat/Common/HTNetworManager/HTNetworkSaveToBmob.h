//
//  THThirdData.h
//  TingApp
//
//  Created by hublot on 16/9/30.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTNetworkSaveToBmob : NSObject

+ (void)saveUserSuggestionWithUserContactWay:(nonnull NSString *)userContactWay suggestionMessage:(nonnull NSString *)suggestionMessage complete:(void(^_Nonnull)(void))complete failure:(void(^_Nullable)(NSString * _Nullable description))failure;

+ (void)requestUserSuggestionModelArrayComplete:(void(^_Nonnull)(NSArray *_Nonnull))complete;

@end
