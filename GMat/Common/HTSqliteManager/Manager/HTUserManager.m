//
//  HTUserManager.m
//  GMat
//
//  Created by hublot on 2017/5/25.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTUserManager.h"
#import "HTLoginManager.h"
#import "FMDB.h"
#import "HTQuestionManager.h"
#import "THMinePreferenceController.h"
#import "HTManagerController.h"
#import "HTRootNavigationController.h"
#import "HTQuestionController.h"

NSString *const kuserTableName = @"kuserTableName";

NSString *const kuserExerciseRecordTableName = @"kuserExerciseRecordTableName";

NSString *const kuserExerciseStoryTableName = @"kuserExerciseStoryTableName";


@interface HTUserManager ()

@property (nonatomic, strong) HTUser *sqliteLockUser;

@end

@implementation HTUserManager

static HTUserManager *userManager;

+ (instancetype)defaultUserManager {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		userManager = [[HTUserManager alloc] init];
	});
	return userManager;
}

+ (NSString *)userManagerSqlitePath {
	NSString *diretionPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true) lastObject];
	NSString *fileName = @"user_4.sqlite";
	NSString *filePath = [diretionPath stringByAppendingPathComponent:fileName];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if (![fileManager fileExistsAtPath:filePath]) {
		NSString *defaultUserDataPath = [[NSBundle mainBundle] pathForAuxiliaryExecutable:@"user.sqlite"];
		if ([fileManager fileExistsAtPath:defaultUserDataPath]) {
			[fileManager copyItemAtPath:defaultUserDataPath toPath:filePath error:nil];
		}
		
		[self findOldFileHistoryWithNewVersionName:fileName oldVersionName:@"user_1.sqlite"];
		[self findOldFileHistoryWithNewVersionName:fileName oldVersionName:@"user_3.sqlite"];
		[HTLoginManager exitLoginWithComplete:nil];
	}
	return filePath;
}

+ (void)findOldFileHistoryWithNewVersionName:(NSString *)newVersionName oldVersionName:(NSString *)oldVersionName {
	NSString *diretionPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true) lastObject];
	NSString *newVersionPath = [diretionPath stringByAppendingPathComponent:newVersionName];
	NSString *oldVersionPath = [diretionPath stringByAppendingPathComponent:oldVersionName];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if (![fileManager fileExistsAtPath:oldVersionPath] || ![fileManager fileExistsAtPath:newVersionPath]) {
		return;
	}
	FMDatabase *oldDataBase = [FMDatabase databaseWithPath:oldVersionPath];
	if (![oldDataBase open]) {
		return;
	}
	NSString *selectedOldString = [NSString stringWithFormat:@"select * from %@", kuserExerciseStoryTableName];
	FMResultSet *oldSelectedSet = [oldDataBase executeQuery:selectedOldString];
	
	NSMutableArray *insertDictionaryArray = [@[] mutableCopy];
	NSArray *sqliteKeyArray = @[@"questionId", @"userid", @"storeTime", @"sectionId", @"twoId"];
	while (oldSelectedSet.next) {
		NSMutableDictionary *insertDictionary = [@{} mutableCopy];
		[sqliteKeyArray enumerateObjectsUsingBlock:^(NSString *sqliteKey, NSUInteger index, BOOL * _Nonnull stop) {
			id value = [oldSelectedSet stringForColumn:sqliteKey];
			[insertDictionary setValue:value forKey:sqliteKey];
		}];
		[insertDictionary setValue:@"0" forKey:@"storeState"];
		[insertDictionaryArray addObject:insertDictionary];
	}
	[oldDataBase close];
	FMDatabase *newDataBase = [FMDatabase databaseWithPath:newVersionPath];
	if (![newDataBase open]) {
		return;
	}
	[newDataBase beginTransaction];
	@try {
		[insertDictionaryArray enumerateObjectsUsingBlock:^(NSDictionary *dictionary, NSUInteger index, BOOL * _Nonnull stop) {
			[HTQuestionManager updateSqliteTableName:kuserExerciseStoryTableName dataBase:newDataBase dictionary:dictionary primaryKey:@"userid, questionId"];
		}];
		[newDataBase commit];
		[fileManager removeItemAtPath:oldVersionPath error:nil];
	} @catch (NSException *exception) {
		[newDataBase rollback];
	} @finally {
		[newDataBase close];
	}
}

+ (void)saveToUserTableWithUser:(HTUser *)user {
	FMDatabase *dataBase = [FMDatabase databaseWithPath:[self userManagerSqlitePath]];
	if (![dataBase open]) {
		return;
	}
	
	if (user) {
		[dataBase executeUpdate:[NSString stringWithFormat:@"update %@ set isCurrentUser = ? where uid <> ?", kuserTableName], @0, user.uid];
		
		FMResultSet *resultSet = [dataBase executeQuery:[NSString stringWithFormat:@"select * from %@ where uid = ?", kuserTableName], user.uid];
		if (resultSet.next) {
			[dataBase executeUpdate:[NSString stringWithFormat:@"update %@ set isCurrentUser = ?, userData = ? where uid = ?", kuserTableName], @1, user.mj_JSONData, user.uid];
		} else {
			[dataBase executeUpdate:[NSString stringWithFormat:@"insert into %@ (uid, isCurrentUser, userData) values (?, ?, ?)", kuserTableName], user.uid, @1, user.mj_JSONData];
		}
	} else {
		[dataBase executeUpdate:[NSString stringWithFormat:@"update %@ set isCurrentUser = ?", kuserTableName], @0];
		[dataBase executeUpdate:[NSString stringWithFormat:@"update %@ set isCurrentUser = ? where uid = 0", kuserTableName], @1];
	}
	
	[dataBase close];
}

+ (HTUser *)currentUser {
	FMDatabase *dataBase = [FMDatabase databaseWithPath:[self userManagerSqlitePath]];
	if (![dataBase open]) {
		return nil;
	}
	NSData *userData = [dataBase dataForQuery:[NSString stringWithFormat:@"select userData from %@ where isCurrentUser = ?", kuserTableName], @1];
	[dataBase close];
	if (!userData) {
		HTUser *sqliteLockUser = [HTUserManager defaultUserManager].sqliteLockUser;
		return sqliteLockUser ? sqliteLockUser : nil;
	}
	NSDictionary *userDictionary = [NSJSONSerialization JSONObjectWithData:userData options:kNilOptions error:nil];
	NSMutableDictionary *noneNullDictionary = [@{} mutableCopy];
	[userDictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
		if (!obj || [obj isKindOfClass:[NSNull class]] || ([obj isKindOfClass:[NSString class]] && [obj isEqualToString:@""])) {
			obj = @"";
		}
		[noneNullDictionary setObject:obj forKey:key];
	}];
	HTUser *user = [HTUser mj_objectWithKeyValues:noneNullDictionary];
	[HTUserManager defaultUserManager].sqliteLockUser = user;
	return user;
}






+ (void)updateUserDetailComplete:(void(^)(BOOL success))complete {
	[self updateUserDetailComplete:complete userLoginDictionary:nil];
}

+ (void)updateUserDetailComplete:(void(^)(BOOL success))complete userLoginDictionary:(NSDictionary *)userLoginDictionary {
	HTNetworkModel *networkModel = [[HTNetworkModel alloc] init];
	networkModel.autoAlertString = nil;
	networkModel.offlineCacheStyle = HTCacheStyleNone;
	networkModel.autoShowError = false;
	networkModel.maxRepeatCountString = @"0";
	[HTRequestManager requestUserModelWithNetworkModel:networkModel complete:^(id response, HTError *errorModel) {
		if (errorModel.existError) {
			[[NSNotificationCenter defaultCenter] postNotificationName:kHTLoginNotification object:nil];
			complete(true);
			return;
		}
		__block NSMutableDictionary *userData = [@{} mutableCopy];
		NSDictionary *dataDictionary = response[@"data"];
		[dataDictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
			if (!obj || [obj isKindOfClass:[NSNull class]] || ([obj isKindOfClass:[NSString class]] && [obj isEqualToString:@""])) {
				obj = @"";
			}
			[userData setObject:obj forKey:key];
		}];
		HTUser *user = [[HTUser alloc] init];
		NSString *originUidString;
		NSString *receiveUidString = [userData valueForKey:@"uid"];
		NSDictionary *originUserKeyValues;
		if (userLoginDictionary.count) {
			originUidString = [userLoginDictionary valueForKey:@"uid"];
			originUserKeyValues = userLoginDictionary;
		} else {
			HTUser *currentUser = [HTUserManager currentUser];
			originUidString = currentUser.uid;
			originUserKeyValues = currentUser.mj_keyValues;
		}
		if ([originUidString isEqualToString:receiveUidString]) {
			[user mj_setKeyValues:originUserKeyValues];
		}
		[user mj_setKeyValues:userData];
		[HTUserManager saveToUserTableWithUser:user];
		
//		if ([HTUserManager currentUser].permission >= HTUserPermissionExerciseNotFullThreeUser) {
		if ([HTUserManager currentUser].permission >= HTUserPermissionExerciseAbleUser) {
			HTNetworkModel *networkModel = [[HTNetworkModel alloc] init];
			networkModel.autoAlertString = nil;
			networkModel.offlineCacheStyle = HTCacheStyleNone;
			networkModel.autoShowError = false;
			[HTRequestManager requestLastExerciseIdWithNetworkModel:networkModel complete:^(id response, HTError *errorModel) {
				if (!errorModel.existError && response[@"data"][@"record"] && [response[@"data"][@"record"] isKindOfClass:[NSDictionary class]]) {
					HTUser *user = [HTUser mj_objectWithKeyValues:[HTUserManager currentUser].mj_keyValues];
					user.user_tikuname = response[@"data"][@"user_tikuname"];
					user.nearExerciseStid = [NSString stringWithFormat:@"%@", response[@"data"][@"record"][@"stid"]];
					[HTUserManager saveToUserTableWithUser:user];
				}
				[[NSNotificationCenter defaultCenter] postNotificationName:kHTLoginNotification object:nil];
				complete(true);
			}];
		} else {
			[[NSNotificationCenter defaultCenter] postNotificationName:kHTLoginNotification object:nil];
			complete(true);
		}
	}];
}

+ (void)surePermissionHighOrEqual:(HTUserPermission)permission passCompareBlock:(void(^)(HTUser *user))passCompareBlock {
	
	HTUser *user = [HTUserManager currentUser];
	void(^presentLoginSuccessBlock)(void) = ^() {
		passCompareBlock(user);
	};
	
	if ([HTUserManager currentUser].permission >= permission) {
		presentLoginSuccessBlock();
//	} else if ([HTUserManager currentUser].permission == HTUserPermissionExerciseNotFullThreeUser) {
//		HTRootNavigationController *navigationController = (HTRootNavigationController *)[HTManagerController defaultManagerController].drawerController.tabBarController.selectedViewController;
//		if ([navigationController.rt_visibleViewController isKindOfClass:[HTQuestionController class]]) {
//			[navigationController popViewControllerAnimated:true];
//		}
//		[HTAlert title:@"需要先点击头像完善手机号或者邮箱才能继续哦😲" sureAction:^{
//			THMinePreferenceController *preferenceController = [[THMinePreferenceController alloc] init];
//			[navigationController pushViewController:preferenceController animated:true];
//		}];
	} else if ([HTUserManager currentUser].permission == HTUserPermissionExerciseAbleVisitor) {
		[HTAlert title:@"需要登录才能继续哦😲" sureAction:^{
			[HTLoginManager presentAndLoginSuccess:presentLoginSuccessBlock];
		}];
	} else if ([HTUserManager currentUser].permission == HTUserPermissionExerciseUnAbleVisitor) {
		[HTAlert title:@"做题数量到了上限啦, 需要登录才能获得更多哦😲" sureAction:^{
			[HTLoginManager presentAndLoginSuccess:presentLoginSuccessBlock];
		}];
	}
}






- (void)startSynchronousExerciseRecordCompleteHandleBlock:(void(^)(NSString *errorString))completeHandleBlock {
	if (self.synchronousExerciseRecord) {
		return;
	}
	[HTQuestionManager synchronousStartHandleBlock:^{
		self.synchronousExerciseRecord = true;
	} completeHandleBlock:^(NSString *errorString) {
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			self.synchronousExerciseRecord = false;
			if (!errorString.length) {
				[[NSNotificationCenter defaultCenter] postNotificationName:kHTLoginNotification object:nil];
			}
			if (completeHandleBlock) {
				NSString *resetErrorString = errorString.length ? errorString : @"同步做题记录成功 !";
				completeHandleBlock(resetErrorString);
			}
		});
	}];
}

@end
