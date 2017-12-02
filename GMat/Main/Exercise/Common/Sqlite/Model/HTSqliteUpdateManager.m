//
//  HTSqliteUpdateManager.m
//  GMat
//
//  Created by hublot on 2017/8/22.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTSqliteUpdateManager.h"
#import "HTQuestionManager.h"
#import "HTManagerController.h"

@implementation HTSqliteUpdateManager

+ (void)valiteSqliteUpdateComplete:(void(^)(BOOL show))complete {
	HTNetworkModel *networkModel = [HTNetworkModel modelForOnlyCacheNoInterfaceForScrollViewWithCacheStyle:HTCacheStyleNone];
	NSString *localSqliteLastUpdateTime = [HTQuestionManager localSqliteLastUpdateTime];
	[HTRequestManager requestSqliteUpdateWithNetworkModel:networkModel localSqliteLastUpdateTime:localSqliteLastUpdateTime complete:^(id response, HTError *errorModel) {
		BOOL needUpdate = false;
		if (errorModel.existError && errorModel.errorType != HTErrorTypeUnknown) {
			needUpdate = false;
		} else {
			NSInteger code = [[response valueForKey:@"code"] integerValue];
			if (code == 1) {
				needUpdate = true;
			} else {
				needUpdate = false;
			}
		}
		BOOL notAppStoreReviewVersion = ![HTManagerController defaultManagerController].managerModel.isAppStoreOnReviewingVersion;
		BOOL notFirstLaunch = ![HTManagerController defaultManagerController].managerModel.isDownloadFirstLaunch;
		BOOL show = needUpdate && notAppStoreReviewVersion && notFirstLaunch;
		if (complete) {
			complete(show);
		}
	}];
}

@end
