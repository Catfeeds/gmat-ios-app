//
//  HTLiveDetailAskCell.m
//  GMat
//
//  Created by Charles Cao on 2017/11/14.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTLiveDetailAskCell.h"

@implementation HTLiveDetailAskCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setAsk:(CommunityReply *)ask
{
	_ask = ask;
	
	NSString *str = [NSString stringWithFormat:@"%@回复%@: %@",ask.uName, ask.replyUserName, ask.content];
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:str];
	
	//uName
	[attributedString addAttributes:@{NSForegroundColorAttributeName:[UIColor ht_colorStyle:HTColorStylePrimaryTheme]} range:NSMakeRange(0, ask.uName.length)];
	
	//@"回复"
	[attributedString addAttributes:@{NSForegroundColorAttributeName:[UIColor ht_colorString:@"A4A4A4"]} range:NSMakeRange(ask.uName.length, 2)];

	//replyUserName
	[attributedString addAttributes:@{NSForegroundColorAttributeName:[UIColor ht_colorStyle:HTColorStylePrimaryTheme]} range:NSMakeRange(ask.uName.length + 2,ask.replyUserName.length)];

	//content "+2 冒号,空格"
	[attributedString addAttributes:@{NSForegroundColorAttributeName:[UIColor ht_colorStyle:HTColorStyleSecondaryTitle]} range:NSMakeRange(ask.uName.length + 2 + ask.replyUserName.length + 2 ,ask.content.length)];
	[self.askLabelView setAttributedText:attributedString];
	
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
