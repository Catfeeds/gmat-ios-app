//
//  HTPlayerManager.m
//  GMat
//
//  Created by hublot on 2017/9/25.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTPlayerManager.h"
#import "XMLReader.h"

@implementation HTPlayerManager

+ (void)findPlayerXMLURLFromCourseURLString:(NSString *)courseURLString complete:(void(^)(NSString *playerXMLString))complete {
	NSURL *URL = [NSURL URLWithString:courseURLString];
	NSMutableURLRequest *request = [[NSURLRequest requestWithURL:URL] mutableCopy];
	[request setValue:@"Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.30 (KHTML, like Gecko) Mobile/14E8301" forHTTPHeaderField:@"User-Agent"];
	NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		NSRange startRange = NSMakeRange(0, 0);
		NSString *playerXMLURL;
		while (!playerXMLURL.length && startRange.location + startRange.length < responseString.length) {
			NSInteger limitLocation = startRange.location + startRange.length;
			NSInteger limitLength = responseString.length - limitLocation;
			NSRange limitRange = NSMakeRange(limitLocation, limitLength);
			NSRange prefixRange = [responseString rangeOfString:@"http://cache.gensee.com" options:NSCaseInsensitiveSearch range:limitRange];
			if (prefixRange.location == NSNotFound) {
				startRange.length = responseString.length;
			} else {
				NSInteger limitLocation = prefixRange.location + prefixRange.length;
				NSInteger limitLength = responseString.length - limitLocation;
				NSRange limitRange = NSMakeRange(limitLocation, limitLength);
				NSRange suffixRange = [responseString rangeOfString:@"'" options:NSCaseInsensitiveSearch range:limitRange];
				if (suffixRange.location != NSNotFound) {
					NSString *playerString = [responseString substringWithRange:NSMakeRange(prefixRange.location, suffixRange.location + suffixRange.length - 1 - prefixRange.location)];
					if ([playerString containsString:@"xml?"]) {
						playerXMLURL = playerString;
					}
				}
			}
		}
		if (complete) {
			complete(playerXMLURL);
		}
	}];
	[task resume];
}

+ (void)findM3U8URLFromXMLURLString:(NSString *)XMLURLString complete:(void(^)(HTPlayerModel *model))complete {
	NSURL *URL = [NSURL URLWithString:XMLURLString];
	NSMutableURLRequest *request = [[NSURLRequest requestWithURL:URL] mutableCopy];
	[request setValue:@"Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.30 (KHTML, like Gecko) Mobile/14E8301" forHTTPHeaderField:@"User-Agent"];
	NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		NSError *readerError;
		NSDictionary *dictionary = [XMLReader dictionaryForXMLData:data error:&readerError];
		HTPlayerModel *model = [[HTPlayerModel alloc] initWithXMLDictionary:dictionary xmlURLString:XMLURLString];
		if (complete) {
			complete(model);
		}
	}];
	[task resume];
}

@end
