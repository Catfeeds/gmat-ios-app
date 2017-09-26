//
//  HTUserActionManager.m
//  GMat
//
//  Created by hublot on 2017/8/4.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTUserActionManager.h"
#import <sqlite3.h>

NSString *const kHTUserActionAppendNotification = @"kHTUserActionAppendNotification";

static NSString *kHTUserActionTableName = @"action";

@implementation HTUserActionManager

+ (void)trackUserActionWithType:(HTUserActionType)type keyValue:(NSDictionary *)keyValue {
	NSString *keyValueString = @"";
	@try {
		if ([NSJSONSerialization isValidJSONObject:keyValue]) {
			NSError *error;
			NSData *keyValueData = [NSJSONSerialization dataWithJSONObject:keyValue options:NSJSONWritingPrettyPrinted error:&error];
			if (keyValueData) {
				keyValueString = [[NSString alloc] initWithData:keyValueData encoding:NSUTF8StringEncoding];
			}
		}
	} @catch (NSException *exception) {
		
	} @finally {
		
	}
	[self crateSqliteTable];
	NSInteger currentDate = [[NSDate date] timeIntervalSince1970];
	NSString *execSqliteString = [NSString stringWithFormat:@"insert into '%@' ('%@', '%@', '%@') values ('%ld', '%@', '%ld')", kHTUserActionTableName, @"type", @"keyValue", @"creatTime", type, keyValueString, currentDate];
	[self execSqliteString:execSqliteString];
	[[NSNotificationCenter defaultCenter] postNotificationName:kHTUserActionAppendNotification object:nil];
}

+ (NSInteger)trackCountForType:(HTUserActionType)type {
	[self crateSqliteTable];
	sqlite3 *sqlite;
	sqlite3_stmt *statement;
	NSString *selectedSqliteString = [NSString stringWithFormat:@"select * from '%@' where type = '%ld'", kHTUserActionTableName, type];
	NSInteger trackCount = 0;
	if ((sqlite = [self openSqlite])) {
		if (sqlite3_prepare_v2(sqlite, [selectedSqliteString UTF8String], - 1, &statement, nil) == SQLITE_OK) {
			while (sqlite3_step(statement) == SQLITE_ROW) {
				trackCount ++;
			}
		} else {
			trackCount = 0;
		}
		sqlite3_finalize(statement);
		[self closeSqlite:sqlite];
	} else {
		trackCount = 0;
	}
	return trackCount;
}

+ (NSArray <NSDictionary *> *)trackKeyValueForType:(HTUserActionType)type {
	[self crateSqliteTable];
	sqlite3 *sqlite;
	sqlite3_stmt *statement;
	NSString *selectedSqliteString = [NSString stringWithFormat:@"select * from '%@' where type = '%ld'", kHTUserActionTableName, type];
	NSMutableArray *keyValueArray = [@[] mutableCopy];
	if ((sqlite = [self openSqlite])) {
		if (sqlite3_prepare_v2(sqlite, [selectedSqliteString UTF8String], - 1, &statement, nil) == SQLITE_OK) {
			while (sqlite3_step(statement) == SQLITE_ROW) {
				const void *blob = sqlite3_column_blob(statement, 1);
				int length = sqlite3_column_bytes(statement, 1);
				NSData *data = [[NSData alloc] initWithBytes:blob length:length];
				NSDictionary *keyValue = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
				[keyValueArray addObject:keyValue];
			}
		}
		sqlite3_finalize(statement);
		[self closeSqlite:sqlite];
	}
	return keyValueArray;
}

+ (NSString *)userActionSqlitePath {
	NSString *diretionPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true) lastObject];
	NSString *fileName = @"action.sqlite";
	NSString *useractionPath = [diretionPath stringByAppendingPathComponent:fileName];
	return useractionPath;
}

+ (void)crateSqliteTable {
	NSString *creatTableSqliteString = [NSString stringWithFormat:@"create table if not exists '%@'(type integer, keyValue blob, creatTime integer)", kHTUserActionTableName];
	[self execSqliteString:creatTableSqliteString];
}

+ (sqlite3 *)openSqlite {
	sqlite3 *sqlite;
	BOOL isOpen = sqlite3_open([[self userActionSqlitePath] UTF8String], &sqlite) == SQLITE_OK;
	if (isOpen) {
		return sqlite;
	} else {
		return nil;
	}
}

+ (BOOL)execSqliteString:(NSString *)sqliteString {
	char *error;
	sqlite3 *sqlite;
	if ((sqlite = [self openSqlite])) {
		BOOL success = sqlite3_exec(sqlite, [sqliteString UTF8String], NULL, NULL, &error) == SQLITE_OK;
		[self closeSqlite:sqlite];
		return success;
	}
	return false;
}

+ (void)closeSqlite:(sqlite3 *)sqlite {
	sqlite3_close(sqlite);
}

@end
