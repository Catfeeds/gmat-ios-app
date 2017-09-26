//
//  HTBaiduOcrManager.m
//  GMat
//
//  Created by hublot on 2017/4/5.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTBaiduOcrManager.h"
#import <HTEncodeDecodeManager.h>

static NSString *kHTBaiduOcrKey = @"kHTBaiduOcrKey";

static NSString *kHTBaiduOcrApiKey = @"bXYKXZ0KhpdrZsAbsq2MRPte";

static NSString *kHTBaiduOcrSecretKey = @"amZ3IMbbAjH2qStVvYGYstrrUfKfqrgu";

@implementation HTBaiduOcrManager

+ (void)requestWithImage:(UIImage *)image complete:(void(^)(NSString *recognizeString))complete {
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSString *requestToken = [userDefaults stringForKey:kHTBaiduOcrKey];
	if (requestToken.length) {
		[self requestWithImage:image requestToken:requestToken complete:complete];
	} else {
		NSString *requestString = [NSString stringWithFormat:@"https://aip.baidubce.com/oauth/2.0/token?grant_type=client_credentials&client_id=%@&client_secret=%@", kHTBaiduOcrApiKey, kHTBaiduOcrSecretKey];
		NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:requestString]];
		[[[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
			if (data) {
				NSString *responseJsonString = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
				if ([responseJsonString isKindOfClass:[NSDictionary class]]) {
					NSString *accessTokenString = [responseJsonString valueForKey:@"access_token"];
					if (accessTokenString.length) {
						[userDefaults setValue:accessTokenString forKey:kHTBaiduOcrKey];
						[self requestWithImage:image requestToken:accessTokenString complete:complete];
					} else {
						!complete ? : complete(@"");
					}
				} else {
					!complete ? : complete(@"");
				}
			} else {
				!complete ? : complete(@"");
			}
		}] resume];
	}
}

+ (void)requestWithImage:(UIImage *)image requestToken:(NSString *)requestToken complete:(void(^)(NSString *recognizeString))complete {
	NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://aip.baidubce.com/rest/2.0/ocr/v1/general_basic?access_token=%@", requestToken]]];
	[urlRequest setHTTPMethod:@"POST"];
	[urlRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	NSData *imageData = UIImageJPEGRepresentation(image, 1);
	NSString *imageBase64String = [HTEncodeDecodeManager ht_encodeWithBase64:imageData];
	
	[urlRequest setHTTPBody:[[NSString stringWithFormat:@"language_type=ENG&image=%@", imageBase64String] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[[[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		if (data) {
			NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
			if ([responseDictionary isKindOfClass:[NSDictionary class]]) {
				if ([[responseDictionary valueForKey:@"error_code"] integerValue]) {
					NSInteger errorCode = [[responseDictionary valueForKey:@"error_code"] integerValue];
					if (errorCode == 110) {
						[[NSUserDefaults standardUserDefaults] setValue:@"" forKey:kHTBaiduOcrKey];
						[self requestWithImage:image complete:complete];
					} else {
						!complete ? : complete(@"");
					}
				} else if ([[responseDictionary valueForKey:@"words_result"] isKindOfClass:[NSArray class]]) {
					NSArray *wordsArray = [responseDictionary valueForKey:@"words_result"];
					NSMutableString *recognizeString = [@"" mutableCopy];
					[wordsArray enumerateObjectsUsingBlock:^(NSDictionary *wordsDictionary, NSUInteger idx, BOOL * _Nonnull stop) {
						[recognizeString appendString:wordsDictionary[@"words"]];
						if (idx != wordsArray.count - 1) {
							[recognizeString appendString:@"\n"];
						}
					}];
					!complete ? : complete(recognizeString);
				} else {
					!complete ? : complete(@"");
				}
			} else {
				!complete ? : complete(@"");
			}
		} else {
			!complete ? : complete(@"");
		}
	}] resume];
}

@end
