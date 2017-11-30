//
//  HTLoginManager.m
//  GMat
//
//  Created by hublot on 2017/5/25.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTLoginManager.h"
#import "HTManagerController.h"
#import "HTRootLoginNavigationController.h"
#import "HTLoginController.h"
#import "HTPush.h"
#import "THMinePreferenceController.h"
#import <Bugly/Bugly.h>
#import "HTQuestionManager.h"
#import "HTSureNicknameController.h"



NSString *const kHTLoginNotification = @"kHTLoginNotification";

static NSString *const KLoginAutoFillUsername = @"KLoginAutoFillUsername";

static NSString *const KLoginAutoFillPassword = @"KLoginAutoFillPassword";

@implementation HTLoginManager

//------------------------------------/ 弹出登录 /------------------------------------//


+ (void)presentAndLoginSuccess:(void(^)(void))success {
//	if ([HTUserManager currentUser].permission >= HTUserPermissionExerciseNotFullThreeUser) {
	if ([HTUserManager currentUser].permission >= HTUserPermissionExerciseAbleUser) {
		[HTAlert title:@"已经登录了啦"];
	} else {
		HTLoginController *loginController = [[HTLoginController alloc] init];
		HTRootLoginNavigationController *navigationController = [[HTRootLoginNavigationController alloc] initWithRootViewController:loginController];
		[navigationController setDismissLoginControllerComplete:^{
			[[NSNotificationCenter defaultCenter] postNotificationName:LOGINSUCCESS object:nil];
			if (success && [HTUserManager currentUser].permission >= HTUserPermissionExerciseAbleUser) {
				success();
			}
		}];
		[[HTManagerController defaultManagerController] presentViewController:navigationController animated:true completion:nil];
	}
}

//------------------------------------/ 正常登录 /------------------------------------//

+ (void)loginUsername:(NSString *)username password:(NSString *)password alert:(BOOL)alert complete:(void(^)(BOOL success, NSString *alertString))complete {
	if (alert) {
		[HTAlert showProgress];
	}
	HTNetworkModel *networkModel = [[HTNetworkModel alloc] init];
	networkModel.autoAlertString = alert ? @"登录中" : nil;
	networkModel.offlineCacheStyle = HTCacheStyleNone;
	networkModel.autoShowError = false;
	[HTRequestManager requestNormalLoginWithNetworkModel:networkModel usernameString:username passwordString:password complete:^(id response, HTError *errorModel) {
		if (errorModel.existError) {
			[self loginAlertTitlt:errorModel.errorString alert:alert complete:complete loginSuccess:false];
			return;
		}
		[self saveUserDefaultsUserName:username];
		[self saveUserDefaultsPassword:password];
		[self loginSuccessAndReloadSessionWithLoginRequestParameterDictionary:@{@"username":username, @"password":password} responseParameterDictionary:response alert:alert complete:complete loginIdentifier:@"NormalLogin"];
		
		
	}];
}

//------------------------------------/ 三方登录 /------------------------------------//

//+ (void)loginWithThreeLoginStyle:(SSDKPlatformType)threeLoginStyle complete:(void(^)(BOOL success, NSString *alertString))complete {
//	[ShareSDK cancelAuthorize:threeLoginStyle];
//	[ShareSDK getUserInfo:threeLoginStyle onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
//		if (!error && state == SSDKResponseStateSuccess) {
//			if (user.uid.length && user.nickname.length && user.icon.length) {
//				[self loginWithThreeLoginOpenId:user.uid name:user.nickname iconurl:user.icon alert:true complete:complete];
//			} else {
//				[HTAlert title:@"授权成功, 获取用户信息失败"];
//			}
//		} else {
//			[HTAlert title:@"获取三方授权失败"];
//		}
//	}];
//}

//+ (void)loginWithThreeLoginOpenId:(NSString *)openId name:(NSString *)name iconurl:(NSString *)iconurl alert:(BOOL)alert complete:(void(^)(BOOL success, NSString *alertString))complete {
//	if (alert) {
//		[HTAlert showProgress];
//	}
//	HTNetworkModel *networkModel = [[HTNetworkModel alloc] init];
//	networkModel.autoAlertString = alert ? @"三方登录中" : nil;
//	networkModel.offlineCacheStyle = HTCacheStyleNone;
//	networkModel.autoShowError = false;
//	[HTRequestManager requestThirdLoginWithNetworkModel:networkModel openIdString:openId nicknameString:name thirdIconSource:iconurl complete:^(id response, HTError *errorModel) {
//		if (errorModel.existError) {
//			[self loginAlertTitlt:response[@"message"] alert:alert complete:complete loginSuccess:false];
//			return;
//		}
//		[self loginSuccessAndReloadSessionWithLoginRequestParameterDictionary:@{@"openId":openId, @"name":name, @"iconUrl":iconurl} responseParameterDictionary:response alert:alert complete:complete loginIdentifier:@"QQLogin"];
//	}];
//}

//------------------------------------/ 重置 Session /------------------------------------//

+ (void)loginSuccessAndReloadSessionWithLoginRequestParameterDictionary:(NSDictionary *)requestParameterDictionary responseParameterDictionary:(NSDictionary *)responseParameterDictionary alert:(BOOL)alert complete:(void(^)(BOOL success, NSString *alertString))complete loginIdentifier:(NSString *)loginIdentifier {
	HTNetworkModel *networkModel = [[HTNetworkModel alloc] init];
	networkModel.autoAlertString = alert ? @"重置 session 中" : nil;
	networkModel.offlineCacheStyle = HTCacheStyleNone;
	networkModel.autoShowError = false;
	NSString *uidString = HTPlaceholderString(responseParameterDictionary[@"uid"], @"");
	NSString *nickname = HTPlaceholderString(responseParameterDictionary[@"nickname"], @"");
	
	[HTRequestManager requestResetLoginSessionWithNetworkModel:networkModel requestParameterDictionary:requestParameterDictionary responseParameterDictionary:responseParameterDictionary complete:^(id response, HTError *errorModel) {
		if (errorModel.existError) {
			[self loginAlertTitlt:errorModel.errorString alert:alert complete:complete loginSuccess:false];
			return;
		}
		NSMutableDictionary *loginPackageDictionary = [requestParameterDictionary mutableCopy];
		[loginPackageDictionary setValue:uidString forKey:@"uid"];
		[HTUserManager updateUserDetailComplete:^(BOOL success) {
			if (success) {
				if (nickname.length) {
					[self loginAllSuccessWithUidString:uidString loginIdentifier:loginIdentifier alert:alert complete:complete];
				} else {
					UIViewController *presentController = [HTManagerController defaultManagerController].presentedViewController;
					if ([presentController isKindOfClass:[HTRootLoginNavigationController class]]) {
						HTRootLoginNavigationController *loginNavigationController = (HTRootLoginNavigationController *)presentController;
						[loginNavigationController popToRootViewControllerAnimated:true complete:^(BOOL finished) {
							[HTSureNicknameController presentFromController:loginNavigationController dismissNicknameBlock:^(NSString *nickname) {
								if (nickname.length) {
									NSString *username = HTPlaceholderString(requestParameterDictionary[@"username"], @"");
									NSString *password = HTPlaceholderString(requestParameterDictionary[@"password"], @"");
									[self loginUsername:username password:password alert:alert complete:^(BOOL success, NSString *alertString) {
										if (complete) {
											complete(success, alertString);
										}
										if (success) {
											[loginNavigationController dismissViewControllerAnimated:true completion:nil];
										}
									}];
								} else {
									[self exitLoginWithComplete:^{
										[self loginAlertTitlt:@"需要先完善昵称" alert:alert complete:complete loginSuccess:false];
									}];
								}
							}];
						}];
					} else {
						[self exitLoginWithComplete:^{
							[self loginAlertTitlt:@"需要先完善昵称" alert:alert complete:complete loginSuccess:false];
						}];
					}
				}
			} else {
				[self loginAlertTitlt:@"登录成功, 获取用户信息失败" alert:alert complete:complete loginSuccess:false];
			}
		} userLoginDictionary:loginPackageDictionary];
	}];
}

//-----------------------------------------/ 登录成功 /-----------------------------------------//

+ (void)loginAllSuccessWithUidString:(NSString *)uidString loginIdentifier:(NSString *)loginIdentifier alert:(BOOL)alert complete:(void(^)(BOOL success, NSString *alertString))complete {
	[HTPush saveAliasWithUid:uidString loginIdentifier:loginIdentifier];
	[self loginAlertTitlt:@"" alert:alert complete:complete loginSuccess:true];
	[[HTUserManager defaultUserManager] startSynchronousExerciseRecordCompleteHandleBlock:nil];
}

//------------------------------------/ 登录反馈 /------------------------------------//

+ (void)loginAlertTitlt:(NSString *)alertTitlte alert:(BOOL)alert complete:(void(^)(BOOL success, NSString *alertString))complete loginSuccess:(BOOL)loginSuccess {
	if (alert && alertTitlte.length) {
		[HTAlert centerTitle:alertTitlte];
	}
	if (!loginSuccess) {
		[self deleteCookie];
	} else {
		[self saveAlwaysCookie];
	}
	[[HTUserManager currentUser].mj_keyValues enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
		[Bugly setUserValue:obj forKey:key];
	}];
	[HTAlert hideProgress];
	if (complete) {
		complete(loginSuccess, alertTitlte);
	}
}

//------------------------------------/ 自动登录 /------------------------------------//

+ (void)autoLoginWithComplete:(void(^)(BOOL success))complete {
	HTUser *user = [HTUserManager currentUser];
	NSString *username = nil;
	if (user.phone.length || user.useremail.length) {
		username = [self userDefaultsUserName];
	}
	NSString *password = user.password;
	NSString *threeLoginOpenId = user.openId;
	NSString *threeLoginName = user.name;
	NSString *threeLoginIconurl = user.iconUrl;
	if (username.length && password.length) {
		[self loginUsername:username password:password alert:false complete:^(BOOL success, NSString *alertString) {
			if (complete) {
				complete(success);
			}
		}];
	} else if (threeLoginOpenId.length && threeLoginName.length && threeLoginIconurl.length) {
//		[self loginWithThreeLoginOpenId:threeLoginOpenId name:threeLoginName iconurl:threeLoginIconurl alert:false complete:^(BOOL success, NSString *alertString) {
//			if (complete) {
//				complete(success);
//			}
//		}];
		[self exitLoginWithComplete:^{
			if (complete) {
				complete(false);
			}
		}];
	} else {
		if (complete) {
			complete(false);
		}
	}
}

//------------------------------------/ 退出登录 /------------------------------------//

+ (void)handleLoginCookieBlock:(void(^)(NSHTTPCookie * _Nonnull cookie, NSUInteger idx, BOOL * _Nonnull stop))loginCookieBlock {
	NSArray <NSHTTPCookie *> *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies;
	[cookies enumerateObjectsUsingBlock:^(NSHTTPCookie * _Nonnull cookie, NSUInteger idx, BOOL * _Nonnull stop) {
		if ([cookie.name isEqualToString:@"PHPSESSID"]) {
			if (loginCookieBlock) {
				loginCookieBlock(cookie, idx, stop);
			}
		}
	}];
}

+ (void)saveAlwaysCookie {
	[self handleLoginCookieBlock:^(NSHTTPCookie * _Nonnull cookie, NSUInteger idx, BOOL * _Nonnull stop) {
		NSMutableDictionary *properties = [[cookie properties] mutableCopy];
		[properties setValue:[NSDate distantFuture] forKey:NSHTTPCookieExpires];
		[properties removeObjectForKey:NSHTTPCookieDiscard];
		[[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:[NSHTTPCookie cookieWithProperties:properties]];
	}];
}

+ (void)deleteCookie {
	[self handleLoginCookieBlock:^(NSHTTPCookie * _Nonnull cookie, NSUInteger idx, BOOL * _Nonnull stop) {
		NSMutableDictionary *properties = [[cookie properties] mutableCopy];
		[properties setValue:[NSDate distantPast] forKey:NSHTTPCookieExpires];
		[properties setValue:@(1) forKey:NSHTTPCookieDiscard];
		[[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:[NSHTTPCookie cookieWithProperties:properties]];
		[[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
	}];
}

+ (void)exitLoginWithComplete:(void(^)(void))complete {
	[HTUserManager saveToUserTableWithUser:nil];
	[HTPush saveAliasWithUid:@"" loginIdentifier:@""];
	[self deleteCookie];
	[[NSNotificationCenter defaultCenter] postNotificationName:kHTLoginNotification object:nil];
	
	if (complete) {
		complete();
	}
}














+ (void)saveUserDefaultsUserName:(NSString *)username {
	[[NSUserDefaults standardUserDefaults] setValue:HTPlaceholderString(username, @"") forKey:KLoginAutoFillUsername];
}

+ (void)saveUserDefaultsPassword:(NSString *)password {
	[[NSUserDefaults standardUserDefaults] setValue:HTPlaceholderString(password, @"") forKey:KLoginAutoFillPassword];
}

+ (NSString *)userDefaultsUserName {
	NSString *username = [[NSUserDefaults standardUserDefaults] valueForKey:KLoginAutoFillUsername];
	username = HTPlaceholderString(username, @"");
	return username;
}

+ (NSString *)userDefaultsPassword {
	NSString *password = [[NSUserDefaults standardUserDefaults] valueForKey:KLoginAutoFillPassword];
	password = HTPlaceholderString(password, @"");
	return password;
}


@end
