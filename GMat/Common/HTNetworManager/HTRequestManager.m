//
//  HTRequestManager.m
//  GMat
//
//  Created by hublot on 2017/5/3.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTRequestManager.h"
#import "HTUserManager.h"
#import "HTLoginManager.h"
#import <HTValidateManager.h>
#import "HTNetworkSaveToBmob.h"
#import <HTNetworkManager+HTNetworkCache.h>
#import <HTEncodeDecodeManager.h>

static NSString *kHTApplicationIdString = @"1067751179";

@implementation HTRequestManager

+ (void)requestBroadcastComplete:(HTUserTaskCompleteBlock)complete {
	NSDate *date = [NSDate date];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	dateFormatter.dateFormat = @"yyyy-MM-dd";
	NSString *dateString = [dateFormatter stringFromDate:date];
	NSString *url = @"http://www.gmatonline.cn/index.php?web/webapi/AppAd";
	NSDictionary *parameter = @{@"date":dateString};
	
	NSDictionary *apiResponse = [HTNetworkManager cacheResponse:nil url:url parameter:parameter cacheStyle:HTCacheStyleAllUser];
	if (apiResponse && [apiResponse valueForKey:kHTBroadCastImage64Key]) {
		if (complete) {
			complete(apiResponse, nil);
		}
	} else {
		HTError *error = [[HTError alloc] init];
		error.errorType = HTErrorTypeUnknown;
		complete(nil, error);
		HTNetworkModel *apiNetworkModel = [HTNetworkModel modelForOnlyCacheNoInterfaceForScrollViewWithCacheStyle:HTCacheStyleNone];
		[HTNetworkManager requestModel:apiNetworkModel method:HTNetworkRequestMethodGet url:url parameter:parameter complete:^(NSDictionary *response, HTError *errorModel) {
			if (errorModel.existError) {
				return;
			}
			NSDictionary *responseDictionary = [response mutableCopy];
			NSString *imageUrl = [response valueForKey:@"image"];
			BOOL show = [[responseDictionary valueForKey:@"judge"] boolValue];
			if (!show) {
				return;
			}
			imageUrl = GmatResourse(imageUrl);
			HTNetworkModel *imageNetworkModel = [[HTNetworkModel alloc] init];
			imageNetworkModel.autoAlertString = nil;
			imageNetworkModel.autoShowError = false;
			imageNetworkModel.offlineCacheStyle = HTCacheStyleNone;
			[HTNetworkManager requestModel:imageNetworkModel method:HTNetworkRequestMethodDownload url:imageUrl parameter:nil complete:^(NSData *response, HTError *errorModel) {
				if (errorModel.existError || ![response isKindOfClass:[NSData class]]) {
					return;
				}
				NSString *image64 = [HTEncodeDecodeManager ht_encodeWithBase64:response];
				if (image64.length) {
					[responseDictionary setValue:image64 forKey:kHTBroadCastImage64Key];
					[HTNetworkManager cacheResponse:responseDictionary url:url parameter:parameter cacheStyle:HTCacheStyleAllUser];
				}
			}];
		}];
	}
}

+ (void)requestActivityComplete:(HTUserTaskCompleteBlock)complete {
	NSDate *date = [NSDate date];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	dateFormatter.dateFormat = @"yyyy-MM-dd HH";
	NSString *dateString = [dateFormatter stringFromDate:date];
	NSString *url = @"http://www.gmatonline.cn/index.php?web/appapi/activity";
	NSDictionary *parameter = @{@"date":dateString};
	
	NSDictionary *apiResponse = [HTNetworkManager cacheResponse:nil url:url parameter:parameter cacheStyle:HTCacheStyleAllUser];
	if (apiResponse && [apiResponse valueForKey:kHTBroadCastImage64Key]) {
		if (complete) {
			complete(apiResponse, nil);
		}
	} else {
		HTError *error = [[HTError alloc] init];
		error.errorType = HTErrorTypeUnknown;
		complete(nil, error);
		HTNetworkModel *apiNetworkModel = [HTNetworkModel modelForOnlyCacheNoInterfaceForScrollViewWithCacheStyle:HTCacheStyleNone];
		[HTNetworkManager requestModel:apiNetworkModel method:HTNetworkRequestMethodGet url:url parameter:parameter complete:^(NSDictionary *response, HTError *errorModel) {
			if (errorModel.existError) {
				return;
			}
			NSDictionary *responseDictionary = [response mutableCopy];
			NSString *imageUrl = [response valueForKey:@"image"];
			BOOL show = [[responseDictionary valueForKey:@"judge"] boolValue];
			if (!show) {
				return;
			}
			imageUrl = GmatResourse(imageUrl);
			HTNetworkModel *imageNetworkModel = [[HTNetworkModel alloc] init];
			imageNetworkModel.autoAlertString = nil;
			imageNetworkModel.autoShowError = false;
			imageNetworkModel.offlineCacheStyle = HTCacheStyleNone;
			[HTNetworkManager requestModel:imageNetworkModel method:HTNetworkRequestMethodDownload url:imageUrl parameter:nil complete:^(NSData *response, HTError *errorModel) {
				if (errorModel.existError || ![response isKindOfClass:[NSData class]]) {
					return;
				}
				NSString *image64 = [HTEncodeDecodeManager ht_encodeWithBase64:response];
				if (image64.length) {
					[responseDictionary setValue:image64 forKey:kHTBroadCastImage64Key];
					[HTNetworkManager cacheResponse:responseDictionary url:url parameter:parameter cacheStyle:HTCacheStyleAllUser];
				}
			}];
		}];
	}
}

+ (void)requestSqliteUpdateWithNetworkModel:(HTNetworkModel *)networkModel localSqliteLastUpdateTime:(NSString *)localSqliteLastUpdateTime complete:(HTUserTaskCompleteBlock)complete {
	[HTNetworkManager requestModel:networkModel
							method:HTNetworkRequestMethodGet
							   url:@"http://www.gmatonline.cn/index.php?web/appapi/apptikuupdate"
						 parameter:@{@"lasttime":HTPlaceholderString(localSqliteLastUpdateTime, @"")} complete:complete];
}

+ (void)requestSqliteUpdateFileDownloadWithNetworkModel:(HTNetworkModel *)networkModel downloadSqliteUrl:(NSString *)downloadSqliteUrl complete:(HTUserTaskCompleteBlock)complete {
	[HTNetworkManager requestModel:networkModel method:HTNetworkRequestMethodDownload url:downloadSqliteUrl parameter:nil complete:complete];
}

+ (void)requestGossipListWithNetworkModel:(HTNetworkModel *)networkModel pageSize:(NSString *)pageSize currentPage:(NSString *)currentPage complete:(HTUserTaskCompleteBlock)complete {
	[HTNetworkManager requestModel:networkModel method:HTNetworkRequestMethodPost url:@"http://bbs.viplgw.cn/cn/app-api/gossip-list" parameter:@{@"page":HTPlaceholderString(currentPage, @"1"), @"pageSize":HTPlaceholderString(pageSize, @"10"), @"belong":@"1"} complete:complete];
}

+ (void)requestLiveListWithNetworkModel:(HTNetworkModel *)networkModel pageSize:(NSString *)pageSize currentPage:(NSString *)currentPage complete:(HTUserTaskCompleteBlock)complete {
	[HTNetworkManager requestModel:networkModel method:HTNetworkRequestMethodPost url:@"http://bbs.viplgw.cn/cn/app-api/live-list" parameter:@{@"page":HTPlaceholderString(currentPage, @"1"), @"pageSize":HTPlaceholderString(pageSize, @"10"), @"belong":@"1"} complete:complete];
}
+ (void)requestRewardWithNetworkModel:(HTNetworkModel *)networkModel replyID:(NSString *)replyID number:(NSInteger)number complete:(HTUserTaskCompleteBlock)complete {
	[HTNetworkManager requestModel:networkModel method:HTNetworkRequestMethodPost url:@"http://bbs.viplgw.cn/cn/app-api/add-reward" parameter:@{@"replyId":replyID, @"number":@(number).stringValue, @"belong":@"1"} complete:complete];
}

+ (void)requestLiveDetailWithNetworkModel:(HTNetworkModel *)networkModel liveId:(NSString *)liveId complete:(HTUserTaskCompleteBlock)complete {
	[HTNetworkManager requestModel:networkModel method:HTNetworkRequestMethodPost url:@"http://bbs.viplgw.cn/cn/app-api/live-details" parameter:@{@"liveId":liveId} complete:complete];
}

+ (void)requestRewardLikeWithNetworkModel:(HTNetworkModel *)networkModel replyID:(NSString *)replyID  complete:(HTUserTaskCompleteBlock)complete {
	[HTNetworkManager requestModel:networkModel method:HTNetworkRequestMethodPost url:@"http://bbs.viplgw.cn/cn/app-api/add-reply-like" parameter:@{@"replyId":replyID, @"belong":@"1",@"replyType":@"2"} complete:complete];
}

+ (void)requestToPay:(HTNetworkModel *)networkModel complete:(HTUserTaskCompleteBlock)complete{
	[HTNetworkManager requestModel:networkModel method:HTNetworkRequestMethodPost url:@"http://bbs.viplgw.cn/cn/app-api/to-pay" parameter:nil complete:complete];
}

+ (void)requestGossipDetailWithNetworkModel:(HTNetworkModel *)networkModel gossipIdString:(NSString *)gossipIdString complete:(HTUserTaskCompleteBlock)complete {
	[HTNetworkManager requestModel:networkModel method:HTNetworkRequestMethodPost url:@"http://bbs.viplgw.cn/cn/app-api/gossip-details" parameter:@{@"gossipId":HTPlaceholderString(gossipIdString, @"0")} complete:complete];
}

+ (void)requestGossipReplyGossipOwnerWithNetworkModel:(HTNetworkModel *)networkModel replyContent:(NSString *)replyContent communityLayoutModel:(HTCommunityLayoutModel *)communityLayoutModel complete:(HTUserTaskCompleteBlock)complete {
	[self requestGossipReplyGossipLoopReplyWithNetworkModel:networkModel replyContent:replyContent communityLayoutModel:communityLayoutModel beingReplyModel:nil complete:complete];
}


+ (void)requestGossipReplyGossipLoopReplyWithNetworkModel:(HTNetworkModel *)networkModel replyContent:(NSString *)replyContent communityLayoutModel:(HTCommunityLayoutModel *)communityLayoutModel beingReplyModel:(HTCommunityReplyLayoutModel *)beingReplyModel complete:(HTUserTaskCompleteBlock)complete {
	NSString *typeString = @"1";
	if (beingReplyModel) {
		typeString = @"2";
	}
	[HTUserManager surePermissionHighOrEqual:HTUserPermissionExerciseAbleUser passCompareBlock:^(HTUser *user) {
		[HTNetworkManager requestModel:networkModel
								method:HTNetworkRequestMethodPost
								   url:@"http://bbs.viplgw.cn/cn/app-api/reply"
							 parameter:@{@"content":HTPlaceholderString(replyContent, @""),
										 @"type":typeString,
										 @"id":HTPlaceholderString(communityLayoutModel.originModel.Id, @"0"),
										 @"gossipUser":HTPlaceholderString(communityLayoutModel.originModel.uid, @"0"),
										 @"uName":HTPlaceholderString([HTUserManager currentUser].nickname, @""),
										 @"userImage":HTPlaceholderString([HTUserManager currentUser].photo, @""),
										 @"replyUser":HTPlaceholderString(beingReplyModel.originReplyModel.uid, @"0"),
										 @"replyUserName":HTPlaceholderString(beingReplyModel.originReplyModel.uName, @""),
										 @"belong":@"1"} complete:complete];
	}];
}

+ (void)requestReplyLiveReplyWithNetworkModel:(HTNetworkModel *)networkModel replyContent:(NSString *)replyContent communityModel:(HTCommunityModel *)communityModel beingReplyModel:(CommunityReply *)beingReplyModel complete:(HTUserTaskCompleteBlock)complete{
    
    NSString *typeString = @"1";
	NSString *pid = @"0";
	NSString *replyUserID = @"";
	
    if (beingReplyModel) {
        typeString = @"2";
		pid = [beingReplyModel.pid isEqualToString:@"0"] ? beingReplyModel.Id : beingReplyModel.pid;
		replyUserID = beingReplyModel.uid;
		
    }
    [HTUserManager surePermissionHighOrEqual:HTUserPermissionExerciseAbleUser passCompareBlock:^(HTUser *user) {
        [HTNetworkManager requestModel:networkModel
                                method:HTNetworkRequestMethodPost
                                   url:@"http://bbs.viplgw.cn/cn/app-api/live-reply"
                             parameter:@{@"content":HTPlaceholderString(replyContent, @""),
                                         @"type":typeString,
                                         @"id":HTPlaceholderString(communityModel.Id, @"0"),
                                         @"liveUser":HTPlaceholderString(communityModel.uid, @"0"),
										 @"replyUser":replyUserID,
                                         @"userImage":HTPlaceholderString([HTUserManager currentUser].photo, @""),
                                         @"belong":@"1",
										 @"pid":pid
										 } complete:complete];
    }];
}

+ (void)deleteGossipWithNetworkModel:(HTNetworkModel *)networkModel gossipIdString:(NSString *)gossipIdString complete:(HTUserTaskCompleteBlock)complete{
    [HTNetworkManager requestModel:networkModel method:HTNetworkRequestMethodGet url:@"http://bbs.viplgw.cn/cn/app-api/delete-gossip" parameter:@{@"gossipId":HTPlaceholderString(gossipIdString, @"0")} complete:complete];
}

+ (void)requestGossipGoodGossipWithNetworkModel:(HTNetworkModel *)networkModel gossipIdString:(NSString *)gossipIdString complete:(HTUserTaskCompleteBlock)complete {
	[HTUserManager surePermissionHighOrEqual:HTUserPermissionExerciseAbleUser passCompareBlock:^(HTUser *user) {
		[HTNetworkManager requestModel:networkModel method:HTNetworkRequestMethodPost url:@"http://bbs.viplgw.cn/cn/app-api/add-like" parameter:@{@"gossipId":HTPlaceholderString(gossipIdString, @"0"), @"belong":@"1"} complete:complete];
	}];
}

+ (void)requestLiveAddLikeWithNetworkModel:(HTNetworkModel *)networkModel liveIdString:(NSString *)liveIdString complete:(HTUserTaskCompleteBlock)complete {
    [HTUserManager surePermissionHighOrEqual:HTUserPermissionExerciseAbleUser passCompareBlock:^(HTUser *user) {
        [HTNetworkManager requestModel:networkModel method:HTNetworkRequestMethodPost url:@"http://bbs.viplgw.cn/cn/app-api/add-live-like" parameter:@{@"liveId":HTPlaceholderString(liveIdString, @"0"), @"belong":@"1"} complete:complete];
    }];
}

+ (void)requestGossipUploadGossipImageWithNetworkModel:(HTNetworkModel *)networkModel complete:(HTUserTaskCompleteBlock)complete {
	[HTUserManager surePermissionHighOrEqual:HTUserPermissionExerciseAbleUser passCompareBlock:^(HTUser *user) {
		[HTNetworkManager requestModel:networkModel method:HTNetworkRequestMethodUpload url:@"http://bbs.viplgw.cn/cn/app-api/app-image" parameter:nil complete:complete];
	}];
}

+ (void)requestGossipSendGossipWithNetworkModel:(HTNetworkModel *)networkModel gossipTitleString:(NSString *)gossipTitleString gossipDetailString:(NSString *)gossipDetailString imageSourceArray:(NSArray <NSString *> *)imageSourceArray complete:(HTUserTaskCompleteBlock)complete {
	if (!imageSourceArray) {
		imageSourceArray = @[];
	}
	[HTUserManager surePermissionHighOrEqual:HTUserPermissionExerciseAbleUser passCompareBlock:^(HTUser *user) {
		[HTNetworkManager requestModel:networkModel
								method:HTNetworkRequestMethodPost
								   url:@"http://bbs.viplgw.cn/cn/app-api/add-gossip"
							 parameter:@{@"title":HTPlaceholderString(gossipTitleString, @""),
										 @"content":HTPlaceholderString(gossipDetailString, @""),
										 @"image":imageSourceArray,
										 @"video":@[],
										 @"audio":@[],
										 @"icon":HTPlaceholderString([HTUserManager currentUser].photo, @""),
										 @"publisher":HTPlaceholderString([HTUserManager currentUser].nickname, @""),
										 @"belong":@"1"} complete:complete];
	}];
}

+ (void)requestSendLiveWithNetworkModel:(HTNetworkModel *)networkModel  titleString:(NSString *)titleString detailString:(NSString *)detailString imageSourceArray:(NSArray <NSString *> *)imageSourceArray complete:(HTUserTaskCompleteBlock)complete{
	[HTUserManager surePermissionHighOrEqual:HTUserPermissionExerciseAbleUser passCompareBlock:^(HTUser *user) {
		[HTNetworkManager requestModel:networkModel
								method:HTNetworkRequestMethodPost
								   url:@"http://bbs.viplgw.cn/cn/app-api/add-live"
							 parameter:@{@"title":HTPlaceholderString(titleString, @""),
										 @"content":HTPlaceholderString(detailString, @""),
										 @"image":imageSourceArray,
										 @"video":@[],
										 @"audio":@[],
										 @"icon":HTPlaceholderString([HTUserManager currentUser].photo, @""),
										 @"publisher":HTPlaceholderString([HTUserManager currentUser].nickname, @""),
										 @"belong":@"1"} complete:complete];
	}];
}

+ (void)requestGossipMessageWithNetworkModel:(HTNetworkModel *)networkModel complete:(HTUserTaskCompleteBlock)complete {
	[HTNetworkManager requestModel:networkModel method:HTNetworkRequestMethodGet url:@"http://bbs.viplgw.cn/cn/app-api/reply-list" parameter:@{@"uid":HTPlaceholderString([HTUserManager currentUser].uid, @"0"), @"belong":@"1"} complete:complete];
}

+ (void)requestLiveMessageWithNetworkModel:(HTNetworkModel *)networkModel complete:(HTUserTaskCompleteBlock)complete {
	[HTNetworkManager requestModel:networkModel method:HTNetworkRequestMethodGet url:@"http://bbs.viplgw.cn/cn/app-api/live-reply-list" parameter:@{@"uid":HTPlaceholderString([HTUserManager currentUser].uid, @"0"), @"belong":@"1"} complete:complete];
}

+ (void)requestDiscoverGmatExamAttentionWithNetworkModel:(HTNetworkModel *)networkModel attentionId:(NSString *)attentionId complete:(HTUserTaskCompleteBlock)complete {
	[HTNetworkManager requestModel:networkModel method:HTNetworkRequestMethodPost url:@"http://www.gmatonline.cn/index.php?web/appapi/beiKaoDetail" parameter:@{@"id":HTPlaceholderString(attentionId, @"")} complete:complete];
}

+ (void)requestDiscoverInformationWithNetworkModel:(HTNetworkModel *)networkModel pageSize:(NSString *)pageSize currentPage:(NSString *)currentPage complete:(HTUserTaskCompleteBlock)complete {
	[HTNetworkManager requestModel:networkModel method:HTNetworkRequestMethodPost url:@"http://www.gmatonline.cn/index.php?web/appapi/beiKaoInformation" parameter:@{@"page":HTPlaceholderString(currentPage, @"1"), @"pageSize":HTPlaceholderString(pageSize, @"10")} complete:complete];
}

+ (void)requestDiscoverInformationDetailWithNetworkModel:(HTNetworkModel *)networkModel informationId:(NSString *)informationId complete:(HTUserTaskCompleteBlock)complete {
	[HTNetworkManager requestModel:networkModel method:HTNetworkRequestMethodPost url:@"http://www.gmatonline.cn/index.php?web/appapi/informationDetail" parameter:@{@"contentid":HTPlaceholderString(informationId, @"0")} complete:complete];
}

+ (void)requestDiscoverListWithNetworkModel:(HTNetworkModel *)networkModel discoverType:(HTDiscoverType)discoverType pageSize:(NSString *)pageSize currentPage:(NSString *)currentPage complete:(HTUserTaskCompleteBlock)complete {
	NSString *selectedString = @"1";
	switch (discoverType) {
		case HTDiscoverTypeInformation:
			selectedString = @"6";
			break;
		case HTDiscoverTypeKeyking:
			selectedString = @"8";
			break;
		case HTDiscoverTypeDatum:
			selectedString = @"3";
			break;
	}
    [HTNetworkManager requestModel:networkModel method:HTNetworkRequestMethodPost url:@"http://bbs.viplgw.cn/cn/app-api/post-list" parameter:@{@"selectId":HTPlaceholderString(selectedString, @"1"), @"page":HTPlaceholderString(currentPage, @"1"), @"pageSize":HTPlaceholderString(pageSize, @"10")} complete:complete];
}


+ (void)requestDiscoverItemDetailWithNetworkModel:(HTNetworkModel *)networkModel discoverId:(NSString *)discoverId complete:(HTUserTaskCompleteBlock)complete {
    [HTNetworkManager requestModel:networkModel method:HTNetworkRequestMethodPost url:@"http://bbs.viplgw.cn/cn/app-api/post-details" parameter:@{@"postId":HTPlaceholderString(discoverId, @"")} complete:complete];
}


+ (void)requestDiscoverIssueWithNetworkModel:(HTNetworkModel *)networkModel titleString:(NSString *)titleString contentString:(NSString *)contentString complete:(HTUserTaskCompleteBlock)complete {
    [HTNetworkManager requestModel:networkModel method:HTNetworkRequestMethodPost url:@"http://bbs.viplgw.cn/cn/app-api/add-post" parameter:@{@"catId":@"1", @"title":HTPlaceholderString(titleString, @""), @"content":HTPlaceholderString(contentString, @"'")} complete:complete];
}

+ (void)requestDiscoverReplyWithNetworkModel:(HTNetworkModel *)networkModel discoverId:(NSString *)discoverId contentString:(NSString *)contentString complete:(HTUserTaskCompleteBlock)complete {
	[HTNetworkManager requestModel:networkModel method:HTNetworkRequestMethodPost url:@"http://bbs.viplgw.cn/cn/app-api/post-reply" parameter:@{@"postId":HTPlaceholderString(discoverId, @""), @"content":HTPlaceholderString(contentString, @"")} complete:complete];
}

+ (void)requestHotCourseAndBannerWithNetworkModel:(HTNetworkModel *)networkModel complete:(HTUserTaskCompleteBlock)complete {
	[HTNetworkManager requestModel:networkModel method:HTNetworkRequestMethodPost url:GmatApi(@"/hotClass1") parameter:nil complete:complete];
}

+ (void)requestOpenCourseWithNetworkModel:(HTNetworkModel *)networkModel complete:(HTUserTaskCompleteBlock)complete {
	[HTNetworkManager requestModel:networkModel method:HTNetworkRequestMethodPost url:@"http://open.viplgw.cn/cn/api/gmat-open-class" parameter:nil complete:complete];
}

+ (void)requestTeacherListWithNetworkModel:(HTNetworkModel *)networkModel complete:(HTUserTaskCompleteBlock)complete {
	[HTNetworkManager requestModel:networkModel method:HTNetworkRequestMethodPost url:GmatApi(@"/teacherDetailsList") parameter:@{} complete:complete];
}

+ (void)requestLiveCourseWithNetworkModel:(HTNetworkModel *)networkModel complete:(HTUserTaskCompleteBlock)complete {
	[HTNetworkManager requestModel:networkModel method:HTNetworkRequestMethodPost url:GmatApi(@"/newLiveLesson1") parameter:@{} complete:complete];
}

+ (void)requestVideoCourseWithNetworkModel:(HTNetworkModel *)networkModel complete:(HTUserTaskCompleteBlock)complete {
	[HTNetworkManager requestModel:networkModel method:HTNetworkRequestMethodPost url:GmatApi(@"/newVideoLessons1") parameter:@{} complete:complete];
}

+ (void)requestMianShouLessonWithNetworkModel:(HTNetworkModel *)networkModel complete:(HTUserTaskCompleteBlock)complete {
	
	[HTNetworkManager requestModel:networkModel method:HTNetworkRequestMethodPost url:GmatApi(@"/gmatMianShouLesson") parameter:@{} complete:complete];
}

+ (void)requestCoursePayOrderWithNetworkModel:(HTNetworkModel *)networkModel orderCourseModel:(HTCourseOnlineVideoModel *)orderCourseModel complete:(HTUserTaskCompleteBlock)complete {
	[HTNetworkManager requestModel:networkModel
							method:HTNetworkRequestMethodPost
							   url:GmatApi(@"/pay_order")
						 parameter:@{@"num":@"1",
									 @"id":HTPlaceholderString(orderCourseModel.contentid, @"0"),
									 @"title":HTPlaceholderString(orderCourseModel.contenttitle, @""),
									 @"price":HTPlaceholderString(orderCourseModel.price, @"0"),
									 @"commodity_type":@"1",
									 @"integral":@"0"} complete:complete];
}

+ (void)requestResetPasswordWithNetworkModel:(HTNetworkModel *)networkModel phoneOrEmailString:(NSString *)phoneOrEmailString resetPassword:(NSString *)resetPassword messageCode:(NSString *)messageCode complete:(HTUserTaskCompleteBlock)complete {
	NSString *forgetType = @"1";
	if ([HTValidateManager ht_validateMobile:phoneOrEmailString]) {
		forgetType = @"1";
	} else if ([HTValidateManager ht_validateEmail:phoneOrEmailString]) {
		forgetType = @"2";
	}
	[HTNetworkManager requestModel:networkModel
							method:HTNetworkRequestMethodPost
							   url:@"http://login.gmatonline.cn/cn/app-api/find-pass"
						 parameter:@{@"type":forgetType,
									 @"registerStr":HTPlaceholderString(phoneOrEmailString, @"0"),
									 @"pass":HTPlaceholderString(resetPassword, @""),
									 @"code":HTPlaceholderString(messageCode, @"")}
						  complete:complete];
}

+ (void)requestKnowledgeListWithNetworkModel:(HTNetworkModel *)networkModel complete:(HTUserTaskCompleteBlock)complete {
	[HTNetworkManager requestModel:networkModel method:HTNetworkRequestMethodPost url:@"http://www.gmatonline.cn/index.php?web/appapi/knowledgeBase" parameter:nil complete:complete];
}

+ (void)requestKnowledgeDetailWithNetworkModel:(HTNetworkModel *)networkModel knowledgeContentId:(NSString *)knowledgeContentId complete:(HTUserTaskCompleteBlock)complete {
	[HTNetworkManager requestModel:networkModel method:HTNetworkRequestMethodPost url:GmatApi(@"/knowledgeDetails") parameter:@{@"contentid":HTPlaceholderString(knowledgeContentId, @"0")} complete:complete];
}

+ (void)requestMessageCodeSurePersonWithNetworkModel:(HTNetworkModel *)networkModel complete:(HTUserTaskCompleteBlock)complete {
	[HTNetworkManager requestModel:networkModel method:HTNetworkRequestMethodPost url:@"http://login.gmatonline.cn/cn/app-api/phone-request" parameter:nil complete:complete];
}

+ (void)requestRegisterOrForgetPasswordOrUpdataUserMessageCodeWithNetworkModel:(HTNetworkModel *)networkModel phoneOrEmailString:(NSString *)phoneOrEmailString requestMessageCodeStyle:(HTLoginTextFieldGroupType)requestMessageCodeStyle complete:(HTUserTaskCompleteBlock)complete {
	NSString *requestUrl;
	NSMutableDictionary *requestDictionary = [@{@"type":[NSString stringWithFormat:@"%ld", requestMessageCodeStyle + 1]} mutableCopy];
	if ([HTValidateManager ht_validateMobile:phoneOrEmailString]) {
		requestUrl = @"http://login.gmatonline.cn/cn/app-api/phone-code";
		[requestDictionary setValue:HTPlaceholderString(phoneOrEmailString, @"") forKey:@"phoneNum"];
	} else if ([HTValidateManager ht_validateEmail:phoneOrEmailString]) {
		requestUrl = @"http://login.gmatonline.cn/cn/app-api/send-mail";
		[requestDictionary setValue:HTPlaceholderString(phoneOrEmailString, @"") forKey:@"email"];
	}
	[HTNetworkManager requestModel:networkModel method:HTNetworkRequestMethodPost url:requestUrl parameter:requestDictionary complete:complete];
}

+ (void)requestAppStoreMaxVersionWithNetworkModel:(HTNetworkModel *)networkModel complete:(HTUserTaskCompleteBlock)complete {
	NSString *applicationIdString = kHTApplicationIdString;
	NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
	NSString *clearCacheKey = @"t";
	NSString *clearCacheValue = [NSString stringWithFormat:@"%.0lf", timeInterval];
	NSString *applicationVersionUrlString = [NSString stringWithFormat:@"https://itunes.apple.com/lookup/cn?id=%@&%@=%@", applicationIdString, clearCacheKey, clearCacheValue];
	[HTNetworkManager requestModel:networkModel method:HTNetworkRequestMethodGet url:applicationVersionUrlString parameter:nil complete:complete];
}

+ (void)requestOpenAppStore {
	NSString *applicationIdString = kHTApplicationIdString;
	NSString *applicationDetailURLString = [NSString stringWithFormat:@"https://itunes.apple.com/us/app/lei-gegmat/id%@?l=zh&ls=1&mt=8", applicationIdString];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:applicationDetailURLString]];
}

+ (void)requestMineMessageWithNetworkModel:(HTNetworkModel *)networkModel pageSize:(NSString *)pageSize currentPage:(NSString *)currentPage complete:(HTUserTaskCompleteBlock)complete {
	[HTNetworkManager requestModel:networkModel
							method:HTNetworkRequestMethodPost
							   url:GmatApi(@"/messages")
						 parameter:@{@"pageNumber":HTPlaceholderString(currentPage, @"1"),
									 @"pageSize":HTPlaceholderString(pageSize, @"10")} complete:complete];
}

+ (void)requestMockListWithNetworkModel:(HTNetworkModel *)networkModel mockStyle:(HTMockStyle)mockStyle typeClass:(HTTypeClass)typeClass complete:(HTUserTaskCompleteBlock)complete {
	NSString *typeClassString = @"";
	switch (typeClass) {
		case HTTypeClassPrep:
			typeClassString = @"p";
			break;
		case HTTypeClassGwd:
			typeClassString = @"g";
			break;
		case HTTypeClassChosen:
			typeClassString = @"j";
			break;
	}
	[HTNetworkManager requestModel:networkModel
							method:HTNetworkRequestMethodPost
							   url:GmatApi(@"/getMokaoList")
						 parameter:@{@"type":[NSString stringWithFormat:@"%ld", mockStyle + 1],
									 @"typeClass":typeClassString} complete:complete];
}

+ (void)requestMockRecordWithNetworkModel:(HTNetworkModel *)networkModel mockStyle:(HTMockStyle)mockStyle pageSize:(NSString *)pageSize currentPage:(NSString *)currentPage complete:(HTUserTaskCompleteBlock)complete {
	[HTNetworkManager requestModel:networkModel
							method:HTNetworkRequestMethodPost
							   url:GmatApi(@"/NewModelRecord")
						 parameter:@{@"type":@[@"verbal", @"quant", @"all"][mockStyle],
									 @"pageNumber":HTPlaceholderString(currentPage, @"1"),
									 @"pageSize":HTPlaceholderString(pageSize, @"10")} complete:complete];
}

+ (void)requestCourseRecordWithNetworkModel:(HTNetworkModel *)networkModel courseRecordStyle:(HTCourseRecordStyle)courseRecordStyle pageSize:(NSString *)pageSize currentPage:(NSString *)currentPage complete:(HTUserTaskCompleteBlock)complete {
	NSString *catIdString = @"0";
	switch (courseRecordStyle) {
		case HTCourseRecordStyleOpen:
			catIdString = @"2";
			break;
		case HTCourseRecordStylePay:
			catIdString = @"79";
			break;
	}
	[HTNetworkManager requestModel:networkModel
							method:HTNetworkRequestMethodPost
							   url:GmatApi(@"/MyCourse")
						 parameter:@{@"catid":catIdString,
									 @"pageSize":HTPlaceholderString(pageSize, @"10"),
									 @"pageNumber":HTPlaceholderString(currentPage, @"1")} complete:complete];
}

+ (void)requestMockWillSendMockIdWithNetworkModel:(HTNetworkModel *)networkModel mockIdString:(NSString *)mockIdString complete:(HTUserTaskCompleteBlock)complete {
	[HTNetworkManager requestModel:networkModel
							method:HTNetworkRequestMethodPost
							   url:@"http://www.gmatonline.cn/index.php?web/appapi/mokao"
						 parameter:@{@"id":HTPlaceholderString(mockIdString, @"0")}
						  complete:complete];
}

+ (void)requestMockStartMessageWithNetworkModel:(HTNetworkModel *)networkModel complete:(HTUserTaskCompleteBlock)complete {
	[HTNetworkManager requestModel:networkModel
							method:HTNetworkRequestMethodPost
							   url:@"http://www.gmatonline.cn/index.php?web/appapi/tishi"
						 parameter:nil complete:complete];
}

+ (void)requestMockQuestionWithNetworkModel:(HTNetworkModel *)networkModel signString:(NSString *)signString complete:(HTUserTaskCompleteBlock)complete {
	NSString *signUrlString = HTPlaceholderString(signString, @"");
	NSString *urlString = @"http://www.gmatonline.cn/index.php?web/appapi/";
	urlString = [NSString stringWithFormat:@"%@%@", urlString, signUrlString];
	[HTNetworkManager requestModel:networkModel
							method:HTNetworkRequestMethodPost
							   url:urlString
						 parameter:nil
						  complete:complete];
}

+ (void)requestMockSaveAnswerWithNetworkModel:(HTNetworkModel *)networkModel questionIdString:(NSString *)questionIdString answerString:(NSString *)answerString durationString:(NSString *)durationString complete:(HTUserTaskCompleteBlock)complete {
	[HTNetworkManager requestModel:networkModel
							method:HTNetworkRequestMethodPost
							   url:@"http://www.gmatonline.cn/index.php?web/appapi/checkmkanswer"
						 parameter:@{@"questionid":HTPlaceholderString(questionIdString, @"0"),
									 @"answer":answerString,
									 @"duration":durationString} complete:complete];
}

+ (void)requestMockSleepBeginWithNetworkModel:(HTNetworkModel *)networkModel complete:(HTUserTaskCompleteBlock)complete {
	[HTNetworkManager requestModel:networkModel
							method:HTNetworkRequestMethodPost
							   url:@"http://www.gmatonline.cn/index.php?web/appapi/mokaobreak"
						 parameter:nil complete:complete];
}

+ (void)requestMockSleepEndWithNetworkModel:(HTNetworkModel *)networkModel complete:(HTUserTaskCompleteBlock)complete {
	[HTNetworkManager requestModel:networkModel
							method:HTNetworkRequestMethodPost
							   url:@"http://www.gmatonline.cn/index.php?web/appapi/levelbreak"
						 parameter:nil complete:complete];
}

+ (void)requestMockScoreWithNetworkModel:(HTNetworkModel *)networkModel mockIdString:(NSString *)mockIdString mockScoreIdString:(NSString *)mockScoreIdString complete:(HTUserTaskCompleteBlock)complete {
	[HTNetworkManager requestModel:networkModel
							method:HTNetworkRequestMethodPost
							   url:@"http://www.gmatonline.cn/index.php?web/appapi/result"
						 parameter:@{@"mkid":HTPlaceholderString(mockIdString, @"0"),
									 @"mkscoreid":HTPlaceholderString(mockScoreIdString, @"0")} complete:complete];
}

+ (void)requestMockReloadRecordWithNetworkModel:(HTNetworkModel *)networkModel mockIdString:(NSString *)mockIdString complete:(HTUserTaskCompleteBlock)complete {
	[HTNetworkManager requestModel:networkModel
							method:HTNetworkRequestMethodPost
							   url:@"http://www.gmatonline.cn/index.php?web/appapi/mokaoredo"
						 parameter:@{@"mkid":HTPlaceholderString(mockIdString, @"")} complete:complete];
}

+ (void)requestOfflineRecordUploadWithNetworkModel:(HTNetworkModel *)networkModel complete:(HTUserTaskCompleteBlock)complete {
	[HTNetworkManager requestModel:networkModel method:HTNetworkRequestMethodUpload url:GmatApi(@"/fileRecord1") parameter:nil complete:complete];
}

+ (void)requestOfflineRecordDownloadWithNetworkModel:(HTNetworkModel *)networkModel downloadUrlString:(NSString *)downloadUrlString complete:(HTUserTaskCompleteBlock)complete {
	[HTNetworkManager requestModel:networkModel method:HTNetworkRequestMethodDownload url:downloadUrlString parameter:nil complete:complete];
}

+ (void)requestRegisterWithNetworkModel:(HTNetworkModel *)networkModel phoneOrEmailString:(NSString *)phoneOrEmailString registerPassword:(NSString *)registerPassword messageCode:(NSString *)messageCode usernameString:(NSString *)usernameString complete:(HTUserTaskCompleteBlock)complete {
	NSString *registerTypeString = @"1";
	if ([HTValidateManager ht_validateMobile:phoneOrEmailString]) {
		registerTypeString = @"1";
	} else if ([HTValidateManager ht_validateEmail:phoneOrEmailString]) {
		registerTypeString = @"2";
	}
	[HTNetworkManager requestModel:networkModel
							method:HTNetworkRequestMethodPost
							   url:@"http://login.gmatonline.cn/cn/app-api/register"
						 parameter:@{@"type":registerTypeString,
									 @"registerStr":HTPlaceholderString(phoneOrEmailString, @"0"),
									 @"pass":HTPlaceholderString(registerPassword, @""),
									 @"code":HTPlaceholderString(messageCode, @""),
									 @"userName":HTPlaceholderString(usernameString, @""),
									 @"source":@"1",
									 @"belong":@"1"}
						  complete:complete];
}

+ (void)requestStudyReportWithNetworkModel:(HTNetworkModel *)networkModel complete:(HTUserTaskCompleteBlock)complete {
	[HTNetworkManager requestModel:networkModel method:HTNetworkRequestMethodPost url:GmatApi(@"/proFormaData") parameter:nil complete:complete];
}

+ (void)requestInvideTeacherWithNetworkModel:(HTNetworkModel *)networkModel teacherIdString:(NSString *)teacherIdString usernameString:(NSString *)usernameString phoneNumberString:(NSString *)phoneNumberString courseTitleString:(NSString *)courseTitleString complete:(HTUserTaskCompleteBlock)complete {
	[HTNetworkManager requestModel:networkModel method:HTNetworkRequestMethodPost url:@"http://www.smartapply.cn/cn/api/add-content" parameter:@{@"catId":@"236", @"name":HTPlaceholderString(usernameString, @""), @"extend":@[HTPlaceholderString(teacherIdString, @"0"), HTPlaceholderString(phoneNumberString, @""), HTPlaceholderString(courseTitleString, @""), @"iOS gmat"]} complete:complete];
}

+ (void)requestNormalLoginWithNetworkModel:(HTNetworkModel *)networkModel usernameString:(NSString *)usernameString passwordString:(NSString *)passwordString complete:(HTUserTaskCompleteBlock)complete {
	[HTNetworkManager requestModel:networkModel
							method:HTNetworkRequestMethodPost
							   url:@"http://login.gmatonline.cn/cn/app-api/check-login"
						 parameter:@{@"userName":HTPlaceholderString(usernameString, @""),
									 @"userPass":HTPlaceholderString(passwordString, @"")} complete:complete];
}

+ (void)requestThirdLoginWithNetworkModel:(HTNetworkModel *)networkModel openIdString:(NSString *)openIdString nicknameString:(NSString *)nicknameString thirdIconSource:(NSString *)thirdIconSource complete:(HTUserTaskCompleteBlock)complete {
	[HTNetworkManager requestModel:networkModel
							method:HTNetworkRequestMethodPost
							   url:GmatApi(@"/qqLoginForAppTest")
						 parameter:@{@"openid":HTPlaceholderString(openIdString, @"0"),
									 @"nickname":HTPlaceholderString(nicknameString, @""),
									 @"figureurl_qq_2":HTPlaceholderString(thirdIconSource, @""),
									 @"source":@"1"} complete:complete];
}

+ (void)requestResetLoginSessionWithNetworkModel:(HTNetworkModel *)networkModel requestParameterDictionary:(NSDictionary *)requestParameterDictionary responseParameterDictionary:(NSDictionary *)responseParameterDictionary complete:(HTUserTaskCompleteBlock)complete {
	NSArray *sessionUrlArray = @[@"http://www.toeflonline.cn/cn/app-api/unify-login",
								 @"http://www.smartapply.cn/cn/app-api/unify-login",
								 @"http://www.gmatonline.cn/index.php?web/appapi/unifyLogin",
								 @"http://bbs.viplgw.cn/cn/app-api/unify-login"];
	NSString *uidString = HTPlaceholderString(responseParameterDictionary[@"uid"], @"");
	NSString *nicknameString = HTPlaceholderString(responseParameterDictionary[@"nickname"], @"");
	NSString *usernameString = HTPlaceholderString(responseParameterDictionary[@"username"], @"");
	NSString *passwordString = HTPlaceholderString(responseParameterDictionary[@"password"], @"123456");
	NSString *emailString = HTPlaceholderString(responseParameterDictionary[@"email"], @"");
	NSString *phoneString = HTPlaceholderString(responseParameterDictionary[@"phone"], @"");
	
	NSDictionary *parameter = @{@"uid":uidString, @"nickname":nicknameString, @"username":usernameString, @"password":passwordString, @"email":emailString, @"phone":phoneString};
	
	__block HTUserTaskCompleteBlock resetComplete = complete;
	
	__block NSInteger receiveCount = 0;
	[sessionUrlArray enumerateObjectsUsingBlock:^(NSString *url, NSUInteger idx, BOOL * _Nonnull stop) {
		[HTNetworkManager requestModel:networkModel method:HTNetworkRequestMethodGet url:url parameter:parameter complete:^(id response, HTError *errorModel) {
			if (errorModel.existError && errorModel.errorType != HTErrorTypeUnknown) {
				if (resetComplete) {
					errorModel.errorType = HTErrorTypeUnknown;
					errorModel.errorString = [NSString stringWithFormat:@"重置 session %@ 失败", url];
					resetComplete(nil, errorModel);
					resetComplete = nil;
				}
				return;
			}
			receiveCount ++;
			if (receiveCount == sessionUrlArray.count) {
				if (resetComplete) {
					resetComplete(response, nil);
				}
			}
		}];
	}];
}

+ (void)requestUserModelWithNetworkModel:(HTNetworkModel *)networkModel complete:(HTUserTaskCompleteBlock)complete {
	[HTNetworkManager requestModel:networkModel method:HTNetworkRequestMethodPost url:GmatApi(@"/personalCenter") parameter:nil complete:complete];
}

+ (void)requestLastExerciseIdWithNetworkModel:(HTNetworkModel *)networkModel complete:(HTUserTaskCompleteBlock)complete {
	[HTNetworkManager requestModel:networkModel method:HTNetworkRequestMethodPost url:GmatApi(@"/userRecord") parameter:nil complete:complete];
}

+ (void)requestUploadUserHeadImageWithNetworkModel:(HTNetworkModel *)networkModel complete:(HTUserTaskCompleteBlock)complete {
	[HTNetworkManager requestModel:networkModel method:HTNetworkRequestMethodUpload url:GmatApi(@"/fileimg") parameter:nil complete:complete];
}

+ (void)requestUpdateUserNicknameWithNetworkModel:(HTNetworkModel *)networkModel changeNickname:(NSString *)changeNickname complete:(HTUserTaskCompleteBlock)complete {
	[HTNetworkManager requestModel:networkModel method:HTNetworkRequestMethodPost url:@"http://login.gmatonline.cn/cn/app-api/change-nickname" parameter:@{@"nickname":HTPlaceholderString(changeNickname, @"")} complete:complete];
}

+ (void)requestUpdateUserPhoneWithNetworkModel:(HTNetworkModel *)networkModel changePhone:(NSString *)changePhone messageCode:(NSString *)messageCode complete:(HTUserTaskCompleteBlock)complete {
	[HTNetworkManager requestModel:networkModel
							method:HTNetworkRequestMethodPost
							   url:@"http://login.gmatonline.cn/cn/app-api/update-user"
						 parameter:@{@"uid":HTPlaceholderString([HTUserManager currentUser].uid, @"0"),
									 @"phone":HTPlaceholderString(changePhone, @""),
									 @"code":messageCode} complete:complete];
}

+ (void)requestUpdateUserEmailWithNetworkModel:(HTNetworkModel *)networkModel changeEmail:(NSString *)changeEmail messageCode:(NSString *)messageCode complete:(HTUserTaskCompleteBlock)complete {
	[HTNetworkManager requestModel:networkModel
							method:HTNetworkRequestMethodPost
							   url:@"http://login.gmatonline.cn/cn/app-api/update-user"
						 parameter:@{@"uid":HTPlaceholderString([HTUserManager currentUser].uid, @"0"),
									 @"email":HTPlaceholderString(changeEmail, @""),
									 @"code":messageCode} complete:complete];
}

+ (void)requestUpdateUserPasswordWithNetworkModel:(HTNetworkModel *)networkModel originPassword:(NSString *)originPassword changePassword:(NSString *)changePassword complete:(HTUserTaskCompleteBlock)complete {
	[HTNetworkManager requestModel:networkModel
							method:HTNetworkRequestMethodPost
							   url:@"http://login.gmatonline.cn/cn/app-api/update-user"
						 parameter:@{@"uid":HTPlaceholderString([HTUserManager currentUser].uid, @"0"),
									 @"oldPass":HTPlaceholderString(originPassword, @""),
									 @"newPass":HTPlaceholderString(changePassword, @"")} complete:complete];
}


+ (void)requestSendApplicationIssueWithNetworkModel:(HTNetworkModel *)networkModel suggestionMessage:(NSString *)suggestionMessage userContactWay:(NSString *)userContactWay complete:(HTUserTaskCompleteBlock)complete {
	[HTNetworkManager requestModel:networkModel
							method:HTNetworkRequestMethodPost
							   url:GmatApi(@"/opinion")
						 parameter:@{@"phone":HTPlaceholderString(userContactWay, @""),
									 @"opinion":HTPlaceholderString(suggestionMessage, @"")}
						  complete:complete];
	[HTNetworkSaveToBmob saveUserSuggestionWithUserContactWay:userContactWay suggestionMessage:suggestionMessage complete:^{
	} failure:^(NSString * _Nonnull description) {
	}];
}

+ (void)requestExerciseQuestionCountWithNetworkModel:(HTNetworkModel *)networkModel complete:(HTUserTaskCompleteBlock)complete {
	[HTNetworkManager requestModel:networkModel method:HTNetworkRequestMethodPost url:GmatApi(@"/getSubjectTotal") parameter:nil complete:complete];
}

+ (void)requestQuestionErrorReportWithNetworkModel:(HTNetworkModel *)networkModel questionIdString:(NSString *)questionIdString errorSelectedModel:(HTQuestionErrorModel *)errorSelectedModel errorContentString:(NSString *)errorContentString complete:(HTUserTaskCompleteBlock)complete {
	[HTNetworkManager requestModel:networkModel
							method:HTNetworkRequestMethodPost
							   url:@"http://www.gmatonline.cn/index.php?web/appapi/problemBug"
						 parameter:@{@"questionid":HTPlaceholderString(questionIdString, @""),
									 @"type":HTPlaceholderString(errorSelectedModel.titleName, @""),
									 @"describe":HTPlaceholderString(errorContentString, @"")} complete:complete];
}

+ (void)requestQuestionDiscussListWithNetworkModel:(HTNetworkModel *)networkModel questionIdString:(NSString *)questionIdString pageSize:(NSString *)pageSize currentPage:(NSString *)currentPage complete:(HTUserTaskCompleteBlock)complete {
	[HTNetworkManager requestModel:networkModel
							method:HTNetworkRequestMethodPost
							   url:@"http://www.gmatonline.cn/index.php?web/appapi/comment"
						 parameter:@{@"questionId":HTPlaceholderString(questionIdString, @""),
									 @"page":HTPlaceholderString(currentPage, @"1"),
									 @"pageSize":HTPlaceholderString(pageSize, @"20")} complete:complete];
}

+ (void)requestQuestionDiscussCreateWithNetworkModel:(HTNetworkModel *)networkModel questionIdString:(NSString *)questionIdString discussContentString:(NSString *)discussContentString willReplyIdString:(NSString *)willReplyIdString complete:(HTUserTaskCompleteBlock)complete {
	[HTNetworkManager requestModel:networkModel
							method:HTNetworkRequestMethodPost
							   url:@"http://www.gmatonline.cn/index.php?web/appapi/addComment"
						 parameter:@{@"questionid":HTPlaceholderString(questionIdString, @""),
									 @"commentid":HTPlaceholderString(willReplyIdString, @"0"),
									 @"content":HTPlaceholderString(discussContentString, @"")} complete:complete];
}

+ (void)requestStoryListWithNetworkModel:(HTNetworkModel *)networkModel pageSize:(NSString *)pageSize currentPage:(NSString *)currentPage complete:(HTUserTaskCompleteBlock)complete {
	[HTNetworkManager requestModel:networkModel
							method:HTNetworkRequestMethodPost
							   url:@"http://www.gmatonline.cn/index.php?web/appapi/caselist"
						 parameter:@{@"pageNumber":HTPlaceholderString(currentPage, @"1"),
									 @"pageSize":HTPlaceholderString(pageSize, @"")} complete:complete];
}

+ (void)requestStoryDetailWithNetworkModel:(HTNetworkModel *)networkModel storyIdString:(NSString *)storyIdString complete:(HTUserTaskCompleteBlock)complete {
	[HTNetworkManager requestModel:networkModel
							method:HTNetworkRequestMethodPost
							   url:@"http://www.gmatonline.cn/index.php?web/appapi/casedetails"
						 parameter:@{@"contentid":HTPlaceholderString(storyIdString, @"0")} complete:complete];
}

+ (void)requestTryListenCourseListWithNetworkModel:(HTNetworkModel *)networkModel complete:(HTUserTaskCompleteBlock)complete {
	[HTNetworkManager requestModel:networkModel
							method:HTNetworkRequestMethodPost
							   url:@"http://www.gmatonline.cn//index.php?web/appapi/freeAudition"
						 parameter:nil complete:complete];
}

+ (void)requestBeginCourseListWithNetworkModel:(HTNetworkModel *)networkModel complete:(HTUserTaskCompleteBlock)complete {
	[HTNetworkManager requestModel:networkModel
							method:HTNetworkRequestMethodPost
							   url:@"http://www.gmatonline.cn/index.php?web/appapi/introductionAudition"
						 parameter:nil complete:complete];
}










@end
