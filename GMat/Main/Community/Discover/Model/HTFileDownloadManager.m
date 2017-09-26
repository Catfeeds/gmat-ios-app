//
//  HTFileDownloadManager.m
//  GMat
//
//  Created by hublot on 2017/6/28.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTFileDownloadManager.h"
#import <HTCacheManager.h>

@interface HTFileDownloadManager ()

@property (nonatomic, strong) NSMutableDictionary <NSString *, HTNetworkModel *> *networkModelDictionary;

@property (nonatomic, strong) NSMutableDictionary <NSString *, HTFileDownloadModel *> *fileModelDictionary;

@end

@implementation HTFileDownloadManager

static HTFileDownloadManager *downloadManager;

+ (HTFileDownloadManager *)defaultDownloadManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        downloadManager = [[HTFileDownloadManager alloc] init];
    });
    return downloadManager;
}

+ (NSString *)filePathWithSaveFileName:(NSString *)saveFileName {
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *downloadFloderCompletePath = [self downloadFloderCompletePath];
	NSString *downloadCompleteFilePath = [downloadFloderCompletePath stringByAppendingPathComponent:saveFileName];
	if ([fileManager fileExistsAtPath:downloadCompleteFilePath]) {
		return downloadCompleteFilePath;
	}
	return nil;
}

+ (void)startDownloadFileUrlString:(NSString *)url saveFileName:(NSString *)saveFileName {
	HTFileDownloadManager *manager = [self defaultDownloadManager];
	[self appendModelWithFileName:saveFileName downloadUrl:url];
	HTFileDownloadModel *fileModel = [manager.fileModelDictionary valueForKey:saveFileName];
	fileModel.selected = true;
}

+ (void)deleteDownloadFileUrlSaveFileName:(NSString *)saveFileName {
	NSError *error;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *downloadFloderCompletePath = [self downloadFloderCompletePath];
	NSString *downloadCompleteFilePath = [downloadFloderCompletePath stringByAppendingPathComponent:saveFileName];
	NSString *downloadFloderingPath = [self downloadFloderingPath];
	NSString *downloadingFilePath = [downloadFloderingPath stringByAppendingPathComponent:saveFileName];
	[fileManager removeItemAtPath:downloadingFilePath error:&error];
	[fileManager removeItemAtPath:downloadCompleteFilePath error:&error];
	[self removeModelWithFileName:saveFileName];
}

+ (void)appendModelWithFileName:(NSString *)fileName downloadUrl:(NSString *)downloadUrl {
	HTFileDownloadManager *manager = [self defaultDownloadManager];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *downloadFloderCompletePath = [self downloadFloderCompletePath];
	NSString *downloadCompleteFilePath = [downloadFloderCompletePath stringByAppendingPathComponent:fileName];
	NSString *downloadFloderingPath = [self downloadFloderingPath];
	NSString *downloadingFilePath = [downloadFloderingPath stringByAppendingPathComponent:fileName];
	
	if ([fileManager fileExistsAtPath:downloadCompleteFilePath isDirectory:false]) {
		[self removeModelWithFileName:fileName];
	} else {
		
		if (!downloadUrl.length && [fileManager fileExistsAtPath:downloadingFilePath isDirectory:false]) {
			NSData *fileUrlData = [NSData dataWithContentsOfFile:downloadingFilePath];
			downloadUrl = [[NSString alloc] initWithData:fileUrlData encoding:NSUTF8StringEncoding];
		}
		
		NSData *data = [downloadUrl dataUsingEncoding:NSUTF8StringEncoding];
		[fileManager createFileAtPath:downloadingFilePath contents:data attributes:nil];
		if (![manager.fileModelDictionary valueForKey:fileName]) {
			HTFileDownloadModel *fileModel = [[HTFileDownloadModel alloc] init];
			fileModel.fileTitleName = fileName;
			fileModel.totalMegaByte = - 1;
			fileModel.completedMegaByte = 0;
			[manager.fileModelDictionary setValue:fileModel forKey:fileName];
		}
		[self creatNetworkModelAndTaskWithFileName:fileName downloadUrl:downloadUrl];
	}

}

+ (void)creatNetworkModelAndTaskWithFileName:(NSString *)fileName downloadUrl:(NSString *)downloadUrl {
	HTFileDownloadManager *manager = [self defaultDownloadManager];
	NSString *downloadFloderCompletePath = [self downloadFloderCompletePath];
	NSString *downloadCompleteFilePath = [downloadFloderCompletePath stringByAppendingPathComponent:fileName];
	__block HTFileDownloadModel *fileModel = [manager.fileModelDictionary valueForKey:fileName];
	if (![manager.networkModelDictionary valueForKey:fileName]) {
		HTNetworkModel *networkModel = [[HTNetworkModel alloc] init];
		networkModel.autoAlertString = nil;
		networkModel.offlineCacheStyle = HTCacheStyleAllUser;
		networkModel.autoShowError = false;
		networkModel.downloadFilePath = downloadCompleteFilePath;
		[networkModel setTaskProgressBlock:^(float progress, float completedMegaByte, float totalMegaByte) {
			fileModel = [manager.fileModelDictionary valueForKey:fileName];
			if (fileModel.task.state == NSURLSessionTaskStateSuspended) {
				return;
			}
			fileModel.completedMegaByte = completedMegaByte;
			fileModel.totalMegaByte = totalMegaByte;
		}];
		[HTNetworkManager requestModel:networkModel method:HTNetworkRequestMethodDownload url:downloadUrl parameter:nil complete:^(id response, HTError *errorModel) {
			if (errorModel.existError) {
				[self deleteNetworkModelWithFileName:fileName];
				[self creatNetworkModelAndTaskWithFileName:fileName downloadUrl:downloadUrl];
			} else {
				fileModel = [manager.fileModelDictionary valueForKey:fileName];
				[self removeModelWithFileName:fileName];
				if (fileModel.downloadComplete) {
					fileModel.downloadComplete();
				}
			}
		}];
		fileModel.task = networkModel.task;
		fileModel.selected = false;
		[manager.networkModelDictionary setValue:networkModel forKey:fileName];
	}
}

+ (void)removeModelWithFileName:(NSString *)fileName {
	__block NSError *error;
	HTFileDownloadManager *manager = [self defaultDownloadManager];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *downloadFloderingPath = [self downloadFloderingPath];
	NSString *downloadingFilePath = [downloadFloderingPath stringByAppendingPathComponent:fileName];
	
	@try {
		[fileManager removeItemAtPath:downloadingFilePath error:&error];
		[manager.fileModelDictionary removeObjectForKey:fileName];
	} @catch (NSException *exception) {
	} @finally {
	}
	[self deleteNetworkModelWithFileName:fileName];
}

+ (void)deleteNetworkModelWithFileName:(NSString *)fileName {
	HTFileDownloadManager *manager = [self defaultDownloadManager];
	@try {
		HTFileDownloadModel *fileModel = [manager.fileModelDictionary valueForKey:fileName];
		fileModel.selected = false;
		[manager.networkModelDictionary removeObjectForKey:fileName];
	} @catch (NSException *exception) {
	} @finally {
	}
}

+ (NSString *)downloadFloderingPath {
    NSString *savePathFloder = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true) lastObject];
    savePathFloder = [savePathFloder stringByAppendingString:@"/downloading"];
    [HTCacheManager sureFloderExistsPath:savePathFloder];
    return savePathFloder;
}

+ (NSString *)downloadFloderCompletePath {
	NSString *savePathFloder = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true) lastObject];
	savePathFloder = [savePathFloder stringByAppendingString:@"/downloadComplete"];
    [HTCacheManager sureFloderExistsPath:savePathFloder];
	return savePathFloder;
}

+ (NSArray <HTFileDownloadModel *> *)packDownloadingModelArray {
    HTFileDownloadManager *manager = [self defaultDownloadManager];
	NSString *floderPath = [self.class downloadFloderingPath];
	NSMutableArray *fileModelArray = [[self.class packDownloadModelArrayWithFloderPath:floderPath] mutableCopy];
	NSMutableArray *fileNameArray = [@[] mutableCopy];
	for (HTFileDownloadModel *fileModel in fileModelArray) {
		[fileNameArray addObject:fileModel.fileTitleName];
		[self appendModelWithFileName:fileModel.fileTitleName downloadUrl:nil];
	}
	fileModelArray = [@[] mutableCopy];
	for (NSString *fileName in fileNameArray) {
		HTFileDownloadModel *fileModel = [manager.fileModelDictionary valueForKey:fileName];
		if (fileModel) {
			[fileModelArray addObject:fileModel];
		}
	}
	return fileModelArray;
}

- (NSMutableDictionary<NSString *,HTNetworkModel *> *)networkModelDictionary {
	if (!_networkModelDictionary) {
		_networkModelDictionary = [@{} mutableCopy];
	}
	return _networkModelDictionary;
}

- (NSMutableDictionary<NSString *,HTFileDownloadModel *> *)fileModelDictionary {
	if (!_fileModelDictionary) {
		_fileModelDictionary = [@{} mutableCopy];
	}
	return _fileModelDictionary;
}

+ (NSArray <HTFileDownloadModel *> *)packDownloadCompleteModelArray {
    NSString *floderPath = [self downloadFloderCompletePath];
	NSArray *modelArray = [self packDownloadModelArrayWithFloderPath:floderPath];
	return modelArray;
}

+ (NSArray <HTFileDownloadModel *> *)packDownloadModelArrayWithFloderPath:(NSString *)floderPath {
    NSMutableArray *modelArray = [@[] mutableCopy];
    NSArray *subpathArray = [[NSFileManager defaultManager] subpathsAtPath:floderPath];
    NSMutableArray *clearHiddenSubpathArray = [@[] mutableCopy];
    for (NSString *path in subpathArray) {
        if (![path hasPrefix:@"."]) {
            [clearHiddenSubpathArray addObject:path];
        }
    }
    NSArray *sortedPathArray = [clearHiddenSubpathArray sortedArrayUsingComparator:^(NSString *firstPath, NSString *secondPath) {
        NSString *firstUrl = [floderPath stringByAppendingPathComponent:firstPath];
        NSString *secondUrl = [floderPath stringByAppendingPathComponent:secondPath];
        NSDictionary *firstFileInfo = [[NSFileManager defaultManager] attributesOfItemAtPath:firstUrl error:nil];
        NSDictionary *secondFileInfo = [[NSFileManager defaultManager] attributesOfItemAtPath:secondUrl error:nil];
        id firstData = [firstFileInfo valueForKey:NSFileCreationDate];
        id secondData = [secondFileInfo valueForKey:NSFileCreationDate];
        return [secondData compare:firstData];
    }];
    for (NSString *filePath in sortedPathArray) {
        NSString *floderFilePath = [floderPath stringByAppendingPathComponent:filePath];
        NSData *fileData = [NSData dataWithContentsOfFile:floderFilePath];
        if (fileData.length) {
            HTFileDownloadModel *model = [[HTFileDownloadModel alloc] init];
            model.fileTitleName = filePath;
            model.completedMegaByte = model.totalMegaByte = fileData.length / 1024.0 / 1024.0;
            [modelArray addObject:model];
        }
    }
    return modelArray;
}

@end
