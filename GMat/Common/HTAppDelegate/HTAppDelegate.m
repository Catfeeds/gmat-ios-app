//
//  HTAppDelegate.m
//  GMat
//
//  Created by hublot on 16/10/11.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTAppDelegate.h"
#import "HTManagerController.h"
#import "JPUSHService.h"
#import <HTCacheManager.h>
#import "HTLoginManager.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"
#import "WeiboSDK.h"

//#import <PgySDK/PgyManager.h>
//#import <PgyUpdate/PgyUpdateManager.h>
#import "MTA.h"
#import "MTAConfig.h"
#import <Bugly/Bugly.h>
#import "THDeveloperModelView.h"
#import "HTPush.h"
#import <BmobSDK/Bmob.h>
//#import <JSPatchPlatform/JSPatch.h>
#ifdef __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif
#import <iflyMSC/iflyMSC.h>
#import "HTAppStoreStarManager.h"

@interface HTAppDelegate () <JPUSHRegisterDelegate>

@end

@implementation HTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	
	//-----------------------------------------/ 测试热修复 /-----------------------------------------//
	
//	[JSPatch testScriptInBundle];
	
//	//-----------------------------------------/ 热修复 /-----------------------------------------//
//    
//	NSString *jspatchAppKey =  @"c5ad6398188e5f36";
//	[JSPatch startWithAppKey:jspatchAppKey];
//    [JSPatch updateConfigWithAppKey:jspatchAppKey withInterval:15 * 60];
//	#ifdef DEBUG
//		[JSPatch setupDevelopment];
//	#endif
//	[JSPatch sync];
	
    //-----------------------------------------/ 泄漏排查 /-----------------------------------------//
	
	
	
	//-----------------------------------------/ 应用统计 /-----------------------------------------//
	
	[MTA startWithAppkey:@"IXK8A72T9XIF"];
	[[MTAConfig getInstance] setReportStrategy:MTA_STRATEGY_INSTANT];
	[[MTAConfig getInstance] setAutoExceptionCaught:false];
	
	//-----------------------------------------/ 评分统计 /-----------------------------------------//
	
	[[HTAppStoreStarManager defaultManager] startMonitoringShouldAppStoreStar];
	
    //-----------------------------------------/ 崩溃捕获 /-----------------------------------------//
	
	#ifndef DEBUG
		[Bugly startWithAppId:@"f0700a355a"];
	#endif
	
	
	//-----------------------------------------/ Bmob 三方数据存取 /-----------------------------------------//
	
	[Bmob registerWithAppKey:@"803d17d13c46bcb74640a568d2ecacfa"];
	
	//-----------------------------------------/ 推送 /-----------------------------------------//
	
	if (@available(iOS 11.0, *)) {
		JPUSHRegisterEntity *entity = [[JPUSHRegisterEntity alloc] init];
		entity.types = UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound;
		[JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
	} else {
		[JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
														  UIUserNotificationTypeSound |
														  UIUserNotificationTypeAlert)
											  categories:nil];
	}
	
	BOOL apsForProduction = false;
	#ifdef DEBUG
		apsForProduction = NO;
	#else
		apsForProduction = true;
	#endif
	
	[JPUSHService setupWithOption:launchOptions appKey:@"c26b8b85850bd1e386eff92b"
						  channel:@"Publish channel"
				 apsForProduction:apsForProduction
			advertisingIdentifier:nil];
	[JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
		
	}];
	NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
	[defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
	
    //-----------------------------------------/ 分享 /-----------------------------------------//
    
    [ShareSDK registerApp:@"1a625e75679a8" activePlatforms:@[@(SSDKPlatformTypeSinaWeibo), @(SSDKPlatformTypeWechat), @(SSDKPlatformTypeQQ)] onImport:^(SSDKPlatformType platformType) {
        switch (platformType) {
            case SSDKPlatformTypeWechat:
                [ShareSDKConnector connectWeChat:[WXApi class]];
                break;
            case SSDKPlatformTypeQQ:
                [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                break;
            case SSDKPlatformTypeSinaWeibo:
                [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                break;
            default:
                break;
        }
    } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
        switch (platformType) {
            case SSDKPlatformTypeSinaWeibo:
                [appInfo SSDKSetupSinaWeiboByAppKey:@"870601458"
                                          appSecret:@"b7006e1cd051475faa47dcc7b4797c45"
                                        redirectUri:@"http://sns.whalecloud.com/sina2/callback"
                                           authType:SSDKAuthTypeBoth];
                break;
            case SSDKPlatformTypeWechat:
                [appInfo SSDKSetupWeChatByAppId:@"wx4971333e2d943a4f"
                                      appSecret:@"d4624c36b6795d1d99dcf0547af5443d"];
                break;
            case SSDKPlatformTypeQQ:
                [appInfo SSDKSetupQQByAppId:@"101228026"
                                     appKey:@"31b2c819816b03598809bf9ef2f2172d"
                                   authType:SSDKAuthTypeBoth];
                break;
            default:
                break;
        }
    }];
		
	//-----------------------------------------/ 测试 /-----------------------------------------//
	//-----------------------------------------/ 上线版本请注释掉 /-----------------------------------------//
	
//	[[PgyManager sharedPgyManager] startManagerWithAppId:@"ffe3580fe9833c356cb8a25443ee96f4"];
//	[[PgyUpdateManager sharedPgyManager] startManagerWithAppId:@"ffe3580fe9833c356cb8a25443ee96f4"];
//	[[PgyUpdateManager sharedPgyManager] checkUpdate];
//	[UMessage setLogEnabled:true];
//	[MobClick setLogEnabled:true];
    
    //-----------------------------------------/ 讯飞语音识别 /-----------------------------------------//
    
    [IFlySetting setLogFile:LVL_NONE];
    [IFlySetting showLogcat:false];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    [IFlySetting setLogFilePath:cachePath];
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@", @"58e4b6f1"];
    [IFlySpeechUtility createUtility:initString];

	
	//-----------------------------------------/ 缓存 /-----------------------------------------//
	
	NSURLCache *cache = [[NSURLCache alloc] initWithMemoryCapacity:20 * 1024 * 1024 diskCapacity:100 * 1024 * 1024 diskPath:[HTCacheManager rootCacheFloderPath]];
	[NSURLCache setSharedURLCache:cache];
	
	//-----------------------------------------/ 休眠 /-----------------------------------------//
	
	//	[NSThread sleepForTimeInterval:2];
	
	//-----------------------------------------/ 主控制器 /-----------------------------------------//
	
	[application setStatusBarOrientation:UIInterfaceOrientationPortrait animated:false];
	self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
	[self.window makeKeyAndVisible];
	self.window.backgroundColor = [UIColor whiteColor];
	self.window.rootViewController = [HTManagerController defaultManagerController];
    
	return true;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	[[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
	[JPUSHService resetBadge];
	[THDeveloperModelView updateDeveloperModelView];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
	[JPUSHService registerDeviceToken:deviceToken];
}

- (void)networkDidReceiveMessage:(NSNotification *)notification {
	[HTPush didReceiveRemoteMessage:@{}];
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
	if (@available(iOS 10.0, *)) {
		NSDictionary *userInfo = notification.request.content.userInfo;
		if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
			[JPUSHService handleRemoteNotification:userInfo];
			[HTPush didReceiveRemoteNotification:userInfo];
		}
		completionHandler(UNNotificationPresentationOptionAlert);
	}
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
	if (@available(iOS 10.0, *)) {
		NSDictionary *userInfo = response.notification.request.content.userInfo;
		if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
			[JPUSHService handleRemoteNotification:userInfo];
			[HTPush didReceiveRemoteNotification:userInfo];
		}
		completionHandler();
	}
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
	[JPUSHService handleRemoteNotification:userInfo];
	[HTPush didReceiveRemoteNotification:userInfo];
	completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
	[JPUSHService handleRemoteNotification:userInfo];
	[HTPush didReceiveRemoteNotification:userInfo];
}

@end
