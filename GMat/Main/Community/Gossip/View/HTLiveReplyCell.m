//
//  HTLiveReplyCell.m
//  GMat
//
//  Created by Charles Cao on 2017/11/10.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTLiveReplyCell.h"
#import "HTLiveDetailAskCell.h"

@implementation HTLiveReplyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setReply:(CommunityReply *)reply{
	_reply = reply;
	self.answerLabel.attributedText = [self replyAttributeString:reply.uName content:reply.content];
	[self.likeButton setTitle: [NSString stringWithFormat:@" 点赞(%ld)",reply.likeNum]  forState:UIControlStateNormal];
	[self.rewardButton setTitle:[NSString stringWithFormat:@" 打赏(%ld)",reply.reward] forState:UIControlStateNormal];
	[self.continueAskButton setTitle:[NSString stringWithFormat:@" 追问(%ld)",reply.askNum] forState:UIControlStateNormal];
    
    self.likeButton.selected = reply.likeSign;
	self.rewardButton.selected = reply.reward > 0;
	self.continueAskButton.selected = reply.askNum > 0;

	//直播详情页面追问
	if (self.type == HTliveReplyCellTypeDetail) {
		
		if (reply.asked && reply.asked.count > 0){
			self.askImageView.hidden = NO;
			self.askTableView.hidden = NO;
			self.askImageViewHeight.constant = 10;
			self.tableBottom.constant = 7;
		}else {
			self.askImageViewHeight.constant = 0;
			self.askImageView.hidden = YES;
			self.askTableView.hidden = YES;
			self.tableBottom.constant = 0;
			
		}
		[self.askTableView reloadData];
	}
	
}

//点赞(tag:100) 打赏(tag:101) 追问(tag:102)

- (IBAction)clickButton:(UIButton *)sender
{
	[self.delegate clickButton:sender reply:self.reply communityLayoutModel:self.layoutModel];
}

- (NSMutableAttributedString *)replyAttributeString:(NSString *)uName content:(NSString *)content{
	
	NSString *str = [NSString stringWithFormat:@"%@: %@",uName,content];
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:str];
	[attributedString addAttributes:@{NSForegroundColorAttributeName:[UIColor ht_colorStyle:HTColorStylePrimaryTheme]} range:NSMakeRange(0, uName.length)];
	[attributedString addAttributes:@{NSForegroundColorAttributeName:[UIColor ht_colorStyle:HTColorStyleSecondaryTitle]} range:NSMakeRange(uName.length, content.length + 2)];
	return attributedString;
}

#pragma 直播详情页 追问表格
#pragma mark -UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.reply.askNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	HTLiveDetailAskCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTLiveDetailAskCell"];
	cell.ask = self.reply.asked[indexPath.row];
	return cell;
}

#pragma mark -UITableViewDelegate

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//	NSString *askHeight = self.layoutModel.singleLiveAskHeightArray[indexPath.row];
//	return askHeight.floatValue;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommunityReply *tempReply = self.reply.asked[indexPath.row];
    if (self.delegate) {
        [self.delegate replyToReply:tempReply communityModel:self.layoutModel.originModel];
    }
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
