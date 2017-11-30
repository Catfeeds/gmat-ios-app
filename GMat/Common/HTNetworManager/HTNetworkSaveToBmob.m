//
//  THThirdData.m
//  TingApp
//
//  Created by hublot on 16/9/30.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTNetworkSaveToBmob.h"
#import <BmobSDK/Bmob.h>

@implementation HTNetworkSaveToBmob

+ (void)saveUserSuggestionWithUserContactWay:(NSString *)userContactWay suggestionMessage:(NSString *)suggestionMessage complete:(void(^)(void))complete failure:(void(^_Nullable)(NSString *description))failure {
	BmobObject *suggestion = [BmobObject objectWithClassName:@"Suggestion"];
	[suggestion setObject:userContactWay forKey:@"contactWay"];
	[suggestion setObject:suggestionMessage forKey:@"suggestionMessage"];
	[suggestion saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
		if (isSuccessful) {
			complete();
		} else if (failure) {
			failure(error.description);
		}
	}];
}

+ (void)requestUserSuggestionModelArrayComplete:(void(^)(NSArray *))complete {
    BmobQuery *suggestionQuery = [BmobQuery queryWithClassName:@"Suggestion"];
    [suggestionQuery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (complete) {
            complete(array);
        }
    }];
}

@end
