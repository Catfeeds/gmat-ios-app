//
//  THMinePreferenceModel.m
//  TingApp
//
//  Created by hublot on 16/8/29.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "THMinePreferenceModel.h"
#import "HTLoginManager.h"
#import "HTVideoWiFIManager.h"
#import <HTCacheManager.h>

@implementation THMinePreferenceModel

+ (NSArray <THMinePreferenceModel *> *)packPrimaryModelArray {
	__block NSMutableArray *modelArray = [@[] mutableCopy];
	NSArray *titleNameArray = @[@"个人信息", @"头像", @"昵称", @"电话", @"邮箱", @"密码", @"关于我们", @"官方网站", @"微信公众号", @"雷哥GMAT QQ备考群"];
	NSArray *everyOneStyleArray = @[@(THMinePreferenceModelEveryOneMineDetail), @(THMinePreferenceModelEveryOneHeadImage), @(THMinePreferenceModelEveryOneNickname), @(THMinePreferenceModelEveryOnePhoneCode), @(THMinePreferenceModelEveryOneEmailCode), @(THMinePreferenceModelEveryOnePassword), @(THMinePreferenceModelEveryOneAboutUs), @(THMinePreferenceModelEveryOneWebSite), @(THMinePreferenceModelEveryOneWeChat), @(THMinePreferenceModelEveryOneTencent)];
	
	NSArray *modelStyleArray = @[@(THMinePreferenceModelStyleSectionTitle), @(THMinePreferenceModelStyleRightImage), @(THMinePreferenceModelStyleTitleDetail), @(THMinePreferenceModelStyleTitleDetail), @(THMinePreferenceModelStyleTitleDetail), @(THMinePreferenceModelStyleTitleDetail), @(THMinePreferenceModelStyleSectionTitle), @(THMinePreferenceModelStyleTitleDetail), @(THMinePreferenceModelStyleTitleDetail), @(THMinePreferenceModelStyleTitleDetail)];
	NSArray *detailNameArray = @[@"", [HTUserManager currentUser].photo, [HTUserManager currentUser].nickname, [HTUserManager currentUser].phone, [HTUserManager currentUser].useremail, @"*******", @"", @"www.gmatonline.cn", @"LGclub", @"439324846"];
	NSArray *headImageNameArray = @[@"0", [HTUserManager currentUser].photo, @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0"];
	NSArray *accessoryAbleArray = @[@0, @0, @1, @1, @1, @1, @0, @1, @0, @0];
    HTUser *user = [HTUserManager currentUser];
	[everyOneStyleArray enumerateObjectsUsingBlock:^(NSNumber *oneStyle, NSUInteger index, BOOL * _Nonnull stop) {
		THMinePreferenceModel *model = [[THMinePreferenceModel alloc] init];
		model.everyOneStyle = oneStyle.integerValue;
		model.modelStyle = [modelStyleArray[index] integerValue];
		model.accessoryAble = accessoryAbleArray[index];
		model.titleName = titleNameArray[index];
		model.detailName = detailNameArray[index];
		model.headImageName = headImageNameArray[index];
		
//		if (user.permission < HTUserPermissionExerciseNotFullThreeUser) {
		if (user.permission < HTUserPermissionExerciseAbleUser) {
			if (model.everyOneStyle < THMinePreferenceModelEveryOneAboutUs) {
				return;
			}
		} else if (user.permission < HTUserPermissionExerciseAbleUser) {
			if (model.everyOneStyle == THMinePreferenceModelEveryOnePassword) {
				return;
			}
		}
		[modelArray addObject:model];
	}];
	return modelArray;
}

+ (NSArray <THMinePreferenceModel *> *)packSecondModelArray {
	__block NSMutableArray *modelArray = [@[] mutableCopy];
	NSArray *titleNameArray = @[@"意见反馈", @"激励雷哥GMAT"];
	NSArray *everyOneStyleArray = @[@(THMinePreferenceModelEveryOneComplaint), @(THMinePreferenceModelEveryOneStar)];
	NSArray *modelStyleArray = @[@(THMinePreferenceModelStyleTitleDetail), @(THMinePreferenceModelStyleTitleDetail)];
	NSArray *detailNameArray = @[[NSString stringWithFormat:@"%@_%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"], [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]], @"五星好评来一个"];
	NSArray *headImageNameArray = @[@"0", @"0"];
	NSArray *accessoryAbleArray = @[@1, @1];
	[everyOneStyleArray enumerateObjectsUsingBlock:^(NSNumber *oneStyle, NSUInteger index, BOOL * _Nonnull stop) {
		THMinePreferenceModel *model = [[THMinePreferenceModel alloc] init];
		model.everyOneStyle = oneStyle.integerValue;
		model.modelStyle = [modelStyleArray[index] integerValue];
		model.titleName = titleNameArray[index];
		model.detailName = detailNameArray[index];
		model.headImageName = headImageNameArray[index];
		model.accessoryAble = accessoryAbleArray[index];
		[modelArray addObject:model];
	}];
	return modelArray;
}

+ (NSArray <THMinePreferenceModel *> *)packThirdModelArray {
	__block NSMutableArray *modelArray = [@[] mutableCopy];
	NSArray *titleNameArray = @[@"字体大小", @"允许非 WIFI 播放", @"清除缓存"];
	NSArray *everyOneStyleArray = @[@(THMinePreferenceModelEveryOneFontSize), @(THMinePreferenceModelEveryOneVideoNotWiFI), @(THMinePreferenceModelEveryOneClearCache)];
	NSArray *modelStyleArray = @[@(THMinePreferenceModelStyleTitleDetail), @(THMinePreferenceModelStyleRightSwitch), @(THMinePreferenceModelStyleTitleDetail)];
	NSArray *detailNameArray = @[@"", [HTVideoWiFIManager allowNotWiFiPlayVideo] ? @"1" : @"0", [NSString stringWithFormat:@"%.1lfM", [HTCacheManager ht_size]]];
	NSArray *headImageNameArray = @[@"0", @"0", @"0"];
	NSArray *accessoryAbleArray = @[@1, @0, @0];
	[everyOneStyleArray enumerateObjectsUsingBlock:^(NSNumber *oneStyle, NSUInteger index, BOOL * _Nonnull stop) {
		THMinePreferenceModel *model = [[THMinePreferenceModel alloc] init];
		model.everyOneStyle = oneStyle.integerValue;
		model.modelStyle = [modelStyleArray[index] integerValue];
		model.titleName = titleNameArray[index];
		model.detailName = detailNameArray[index];
		model.headImageName = headImageNameArray[index];
		model.accessoryAble = accessoryAbleArray[index];
		[modelArray addObject:model];
	}];
	return modelArray;
}

@end
