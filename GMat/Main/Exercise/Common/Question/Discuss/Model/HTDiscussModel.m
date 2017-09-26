//
//  HTDiscussModel.m
//  GMat
//
//  Created by hublot on 2017/8/23.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTDiscussModel.h"

@implementation HTDiscussModel


+ (NSDictionary *)objectClassInArray{
    return @{@"son" : [HTDiscussReplyModel class]};
}

- (void)mj_keyValuesDidFinishConvertingToObject {
//	NSMutableArray *modelArray = [self.son mutableCopy];
//	[self.son enumerateObjectsUsingBlock:^(HTDiscussReplyModel *firstReplyModel, NSUInteger idx, BOOL * _Nonnull stop) {
//		NSMutableArray *childModelArray = [@[] mutableCopy];
//		[firstReplyModel.son enumerateObjectsUsingBlock:^(HTDiscussReplyModel *secondReplyModel, NSUInteger idx, BOOL * _Nonnull stop) {
//			[self.class findChildReplyModelWithSuperModel:secondReplyModel modelArray:childModelArray];
//			[childModelArray enumerateObjectsUsingBlock:^(HTDiscussReplyModel *childReplyModel, NSUInteger idx, BOOL * _Nonnull stop) {
//				childReplyModel.replyNickname = HTPlaceholderString(secondReplyModel.nickname, secondReplyModel.username);
//				childReplyModel.replyCommentid = self.commentid;
//				[modelArray addObject:childReplyModel];
//			}];
//		}];
//		
//		
//	}];
//	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//	formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//	[modelArray sortUsingComparator:^NSComparisonResult(HTDiscussReplyModel *oneModel, HTDiscussReplyModel *otherModel) {
//		return oneModel.commentid.integerValue > otherModel.commentid.integerValue;
//	}];
//	self.son = modelArray;
	[self.son enumerateObjectsUsingBlock:^(HTDiscussReplyModel *replyModel, NSUInteger idx, BOOL * _Nonnull stop) {
		replyModel.replyCommentid = self.commentid;
		replyModel.replyNickname = HTPlaceholderString(self.nickname, self.username);
	}];
}

+ (void)findChildReplyModelWithSuperModel:(HTDiscussReplyModel *)superReplyModel modelArray:(NSMutableArray *)modelArray {
	[modelArray addObject:superReplyModel];
	if (superReplyModel.son.count) {
		[superReplyModel.son enumerateObjectsUsingBlock:^(HTDiscussReplyModel *childReplyModel, NSUInteger idx, BOOL * _Nonnull stop) {
			[self findChildReplyModelWithSuperModel:childReplyModel modelArray:modelArray];
		}];
	}
}

@end


@implementation HTDiscussReplyModel

+ (NSDictionary *)objectClassInArray{
	return @{@"son" : [HTDiscussReplyModel class]};
}

@end


