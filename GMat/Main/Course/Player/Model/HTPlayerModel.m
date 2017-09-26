//
//  HTPlayerModel.m
//  GMat
//
//  Created by hublot on 2017/9/25.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTPlayerModel.h"

@implementation HTPlayerModel

- (instancetype)initWithXMLDictionary:(NSDictionary *)dictionary xmlURLString:(NSString *)xmlURLString {
	if (self = [super init]) {
		NSString *prefixFloder = [xmlURLString stringByDeletingLastPathComponent];
		NSDictionary *confDictionary = [dictionary valueForKey:@"conf"];
		NSString *m3u8URLString = [confDictionary valueForKey:@"hls"];
		m3u8URLString = [prefixFloder stringByAppendingPathComponent:m3u8URLString];
		
		NSMutableArray <HTPlayerDocumentModel *> *documentModelArray = [@[] mutableCopy];
		NSArray *moduleArray = [confDictionary valueForKey:@"module"];
		
		NSMutableArray *documentDictionaryArray = [@[] mutableCopy];
		
		[moduleArray enumerateObjectsUsingBlock:^(NSDictionary *dictionary, NSUInteger index, BOOL * _Nonnull stop) {
			
			if ([[dictionary valueForKey:@"name"] isEqualToString:@"document"]) {
				NSArray *documentArray = [dictionary valueForKey:@"document"];
				NSArray *pageModelArray = [documentArray valueForKey:@"page"];
				[pageModelArray enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL * _Nonnull stop) {
					if ([object isKindOfClass:[NSDictionary class]]) {
						[documentDictionaryArray addObject:object];
					} else if ([object isKindOfClass:[NSArray class]]) {
						[documentDictionaryArray addObjectsFromArray:object];
					}
				}];
			}
		}];
		[documentDictionaryArray enumerateObjectsUsingBlock:^(NSDictionary *dictionary, NSUInteger index, BOOL * _Nonnull stop) {
			CGFloat starttimestamp = [[dictionary valueForKey:@"starttimestamp"] floatValue];
			NSString *documentURLString = [dictionary valueForKey:@"hls"];
			documentURLString = [prefixFloder stringByAppendingPathComponent:documentURLString];
			HTPlayerDocumentModel *model = [[HTPlayerDocumentModel alloc] init];
			model.starttimestamp = starttimestamp;
			model.resourceURLString = documentURLString;
			[documentModelArray addObject:model];
		}];
		_m3u8URLString = m3u8URLString;
		_documentModelArray = documentModelArray;
	}
	return self;
}

- (void)setCurrentTime:(CGFloat)currentTime {
	_currentTime = currentTime;
	[self.documentModelArray enumerateObjectsUsingBlock:^(HTPlayerDocumentModel *model, NSUInteger index, BOOL * _Nonnull stop) {
		if (model.starttimestamp > currentTime) {
			if (model != self.currentDocumentModel) {
				self.currentDocumentModel = model;
			}
			*stop = true;
		}
	}];
}

@end
