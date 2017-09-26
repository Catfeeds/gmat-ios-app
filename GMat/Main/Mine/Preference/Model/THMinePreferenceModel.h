//
//  THMinePreferenceModel.h
//  TingApp
//
//  Created by hublot on 16/8/29.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, THMinePreferenceModelStyle) {
	THMinePreferenceModelStyleTitleDetail,
	THMinePreferenceModelStyleSectionTitle,
	THMinePreferenceModelStyleRightImage
};

typedef NS_ENUM(NSInteger, THMinePreferenceModelEveryOne) {
	THMinePreferenceModelEveryOneMineDetail,
	THMinePreferenceModelEveryOneHeadImage,
//	THMinePreferenceModelEveryOneUsername,
	THMinePreferenceModelEveryOneNickname,
	THMinePreferenceModelEveryOnePhoneCode,
	THMinePreferenceModelEveryOneEmailCode,
	THMinePreferenceModelEveryOnePassword,
	THMinePreferenceModelEveryOneAboutUs,
	THMinePreferenceModelEveryOneWebSite,
	THMinePreferenceModelEveryOneWeChat,
	THMinePreferenceModelEveryOneTencent,
	THMinePreferenceModelEveryOneComplaint,
	THMinePreferenceModelEveryOneStar,
	THMinePreferenceModelEveryOneFontSize,
	THMinePreferenceModelEveryOneClearCache
};

@interface THMinePreferenceModel : NSObject

@property (nonatomic, strong) NSString *titleName;

@property (nonatomic, strong) NSString *detailName;

@property (nonatomic, strong) NSString *headImageName;


@property (nonatomic, strong) NSNumber *accessoryAble;

@property (nonatomic, assign) THMinePreferenceModelStyle modelStyle;

@property (nonatomic, assign) THMinePreferenceModelEveryOne everyOneStyle;

+ (NSArray <THMinePreferenceModel *> *)packPrimaryModelArray;

+ (NSArray <THMinePreferenceModel *> *)packSecondModelArray;

+ (NSArray <THMinePreferenceModel *> *)packThirdModelArray;

@end
