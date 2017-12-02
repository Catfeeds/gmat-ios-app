//
//  THToeflDiscoverModel.m
//  TingApp
//
//  Created by hublot on 16/8/30.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "THToeflDiscoverModel.h"

@implementation THToeflDiscoverModel

+ (NSDictionary *)objectClassInArray{
    return @{@"Reply" : [THDiscoverReply class]};
}

- (void)creatDetailAttributedString {
	@try {
		NSDictionary *normalDictionary = @{NSForegroundColorAttributeName:[UIColor ht_colorStyle:HTColorStyleSecondaryTitle]};
		NSDictionary *selectedDictionary = @{NSForegroundColorAttributeName:[UIColor ht_colorString:@"2479da"]};
		NSMutableAttributedString *attributedString = [[[NSAttributedString alloc] initWithString:@"发布人: " attributes:normalDictionary] mutableCopy];
		NSAttributedString *appendAttributedString = [[NSAttributedString alloc] initWithString:HTPlaceholderString(self.nickname, self.username) attributes:selectedDictionary];
		[attributedString appendAttributedString:appendAttributedString];
		
		CGFloat leftEdge = 10;
		CGFloat rightEdge = 5;
		UIImage *viewCountImage = [[UIImage imageNamed:@"CommunityDiscoverViewCount"] ht_resetSizeZoomNumber:0.55];
		UIImage *viewCountBackgroundImage = [UIImage ht_pureColor:[UIColor clearColor]];
		viewCountBackgroundImage = [viewCountBackgroundImage ht_resetSize:CGSizeMake(viewCountImage.size.width + leftEdge + rightEdge, viewCountImage.size.height)];
		viewCountBackgroundImage = [viewCountBackgroundImage ht_appendImage:viewCountImage atRect:CGRectMake(leftEdge, 0, viewCountImage.size.width, viewCountImage.size.height)];
		NSTextAttachment *viewCountAttachment = [[NSTextAttachment alloc] init];
		viewCountAttachment.image = viewCountBackgroundImage;
		viewCountAttachment.bounds = CGRectMake(0, 0, viewCountBackgroundImage.size.width, viewCountBackgroundImage.size.height);
		appendAttributedString = [NSAttributedString attributedStringWithAttachment:viewCountAttachment];
		[attributedString appendAttributedString:appendAttributedString];
		
		appendAttributedString = [[NSAttributedString alloc] initWithString:self.viewCount attributes:normalDictionary];
		[attributedString appendAttributedString:appendAttributedString];
		
		UIImage *sendTimeImage = [[UIImage imageNamed:@"CommunityDiscoverTime"] ht_resetSizeZoomNumber:0.5];
		UIImage *sendTimeBackgroundImage = [UIImage ht_pureColor:[UIColor clearColor]];
		sendTimeBackgroundImage = [sendTimeBackgroundImage ht_resetSize:CGSizeMake(sendTimeImage.size.width + leftEdge + rightEdge, sendTimeImage.size.height)];
		sendTimeBackgroundImage = [sendTimeBackgroundImage ht_appendImage:sendTimeImage atRect:CGRectMake(leftEdge, 0, sendTimeImage.size.width, sendTimeImage.size.height)];
		NSTextAttachment *sendTimeAttachment = [[NSTextAttachment alloc] init];
		sendTimeAttachment.image = sendTimeBackgroundImage;
		sendTimeAttachment.bounds = CGRectMake(0, 0, sendTimeBackgroundImage.size.width, sendTimeBackgroundImage.size.height);
		appendAttributedString = [NSAttributedString attributedStringWithAttachment:sendTimeAttachment];
		[attributedString appendAttributedString:appendAttributedString];
		
		appendAttributedString = [[NSAttributedString alloc] initWithString:self.dateTime attributes:normalDictionary];
		[attributedString appendAttributedString:appendAttributedString];
		
		[attributedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} range:NSMakeRange(0, attributedString.length)];
		
		self.detailAttributedString = attributedString;
		
	} @catch (NSException *exception) {
		
	} @finally {
		
	}

}

@end

@implementation THDiscoverReply

@end


