//
//  HTManager+HTManagerDelegate.m
//  GMat
//
//  Created by hublot on 2017/5/22.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTManager+HTManagerDelegate.h"
#import <HTNetworkManager+HTNetworkError.h>
#import <NSObject+HTObjectCategory.h>
#import "HTUserManager.h"
#import "HTLoginManager.h"
#import "HTAlert.h"
#import <HTDevicePermissionManager.h>

@implementation HTManager (HTManagerDelegate)

+ (void)load {
	[self ht_swizzleClassNativeSelector:@selector(networkCacheUserIdentifier) customSelector:@selector(ht_networkCacheUserIdentifier)];
	[self ht_swizzleClassNativeSelector:@selector(refreshPlaceholderPresentLogin) customSelector:@selector(ht_refreshPlaceholderPresentLogin)];
	[self ht_swizzleClassNativeSelector:@selector(shouldHiddenProgress:alertString:) customSelector:@selector(ht_shouldHiddenProgress:alertString:)];
	[self ht_swizzleClassNativeSelector:@selector(showErrorString:) customSelector:@selector(ht_showErrorString:)];
	[self ht_swizzleClassNativeSelector:@selector(requestFaildLoginThenRepeatRequest) customSelector:@selector(ht_requestFaildLoginThenRepeatRequest)];
}

+ (NSString *)ht_networkCacheUserIdentifier {
	return [HTUserManager currentUser].uid;
}

+ (void(^)(void(^presentAndLoginSuccess)(void)))ht_refreshPlaceholderPresentLogin {
	void(^completeLoginPresnet)(void(^presentAndLoginSuccess)(void)) = ^(void(^presentAndLoginSuccess)(void)) {
		[HTLoginManager presentAndLoginSuccess:^{
			if (presentAndLoginSuccess) {
				presentAndLoginSuccess();
			}
		}];
	};
	return completeLoginPresnet;
}

+ (void)ht_shouldHiddenProgress:(BOOL)hiddenProgress alertString:(NSString *)alertString {
	if (!hiddenProgress) {
		[HTAlert showProgress];
	} else {
		[HTAlert hideProgress];
	}
}

+ (void)ht_showErrorString:(NSString *)errorString {
	[HTAlert centerTitle:errorString];
}

+ (void(^)(void(^autoLoginAndSuccess)(void)))ht_requestFaildLoginThenRepeatRequest {
	void(^autoLoginBlock)(void(^repeatRequest)(void)) = ^(void(^repeatRequest)(void)) {
		[HTLoginManager autoLoginWithComplete:^(BOOL success) {
			if (success) {
				if (repeatRequest) {
					repeatRequest();
				}
			} else {
				if ([HTUserManager currentUser].permission > HTUserPermissionExerciseAbleVisitor) {
					[HTAlert title:kHTServerClearCookieReLoginMessage];
					[HTLoginManager exitLoginWithComplete:^{
						[HTLoginManager presentAndLoginSuccess:^{
							if (repeatRequest) {
								repeatRequest();
							}
						}];
					}];
				}
			}
		}];
	};
	return autoLoginBlock;
}

@end
