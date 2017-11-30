//
//  HTDiscoverAttentionModel.m
//  GMat
//
//  Created by hublot on 2017/7/5.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTDiscoverAttentionModel.h"
#import <NSString+HTString.h>

@implementation HTDiscoverAttentionModel

- (void)mj_keyValuesDidFinishConvertingToObject {
	self.contenttitle = [self.contenttitle ht_htmlDecodeString];
	self.contenttext = [self.contenttext ht_htmlDecodeString];
}

@end
