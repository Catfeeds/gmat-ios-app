//
//  HTPush.m
//  GMat
//
//  Created by hublot on 2016/11/24.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTPush.h"
#import "HTManagerController.h"
#import "HTCommunityController.h"
#import "UIScrollView+HTRefresh.h"
#import "HTCommunityMessageController.h"
#import "JPUSHService.h"
#import "HTLoginManager.h"

@implementation HTPush

+ (void)didReceiveRemoteNotification:(NSDictionary *)userInfo {
 	if ([userInfo[@"informType"] integerValue] <= 1) {
		if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
			if ([HTManagerController defaultManagerController].drawerController.tabBarController.tabBar.items.count >= 2) {
				HTCommunityController *communityController = [HTManagerController defaultManagerController].communityController;
				__weak typeof(HTCommunityController) *weakCommunityController = communityController;
				if ([HTManagerController defaultManagerController].drawerController.tabBarController.selectedIndex != 2) {
					[communityController.tableView ht_startRefreshHeader];
				} else {
					[communityController.communityHeaderView setRingCount:[userInfo[@"aps"][@"badge"] integerValue] completeBlock:^{
						weakCommunityController.tableView.tableHeaderView = weakCommunityController.communityHeaderView;
					}];
				}
			}
		} else {
			UINavigationController *navigationController = [HTManagerController defaultManagerController].drawerController.tabBarController.selectedViewController;
			if (navigationController) {
				
				HTCommunityMessageControllerType type = [userInfo[@"plate"] integerValue] == 2 ?  HTLiveMessage : HTCommunityMessage;
				HTCommunityMessageController *communityMessageController = [[HTCommunityMessageController alloc] initWithtype:type];
				
				[navigationController pushViewController:communityMessageController animated:true];
			}
		}
	} else if ([userInfo[@"informType"] integerValue] == 2) {
		
	} else {
		
	}
}

+ (void)didReceiveRemoteMessage:(NSDictionary *)message {
	if ([HTManagerController defaultManagerController].drawerController.tabBarController.tabBar.items.count >= 2) {
		if ([HTManagerController defaultManagerController].drawerController.tabBarController.selectedIndex != 2) {
			UITabBarItem *barItem = [HTManagerController defaultManagerController].drawerController.tabBarController.tabBar.items[2];
			NSInteger badgeValueInteger = barItem.badgeValue.integerValue;
			badgeValueInteger ++;
			NSString *badgeValueString = badgeValueInteger > 99 ? @"99+" : [NSString stringWithFormat:@"%ld", badgeValueInteger];
			[HTManagerController defaultManagerController].drawerController.tabBarController.tabBar.items[2].badgeValue = badgeValueString;
		}
	}
}

+ (void)saveAliasWithUid:(NSString *)uidString loginIdentifier:(NSString *)loginIdentifier {
	[JPUSHService setAlias:[NSString stringWithFormat:@"lgw%@", uidString] callbackSelector:nil object:nil];
    if (uidString.length && loginIdentifier.length) {
        [MTA trackCustomKeyValueEvent:@"userloginNormal" props:[HTUserManager currentUser].mj_keyValues];
    }
}

@end
