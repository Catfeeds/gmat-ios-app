//
//  HTLiveListCell.m
//  GMat
//
//  Created by Charles Cao on 2017/11/10.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTLiveListCell.h"
#import "HTLiveReplyCell.h"
#import "HTCommunityReplyKeyBoardView.h"

@interface HTLiveListCell() <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)HTCommunityDetailHeaderView *postView;
@property (nonatomic, strong)NSArray *replyTableArray;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *postViewHeightLayoutConstraint;
@end

@implementation HTLiveListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
	
	self.replyTableArray = [NSArray array];
	self.postView = [[HTCommunityDetailHeaderView alloc]initWithFrame:CGRectZero];
	[self.postContentView addSubview:self.postView];
	
}

- (void)setHeaderViewDelegate:(id<HTCommunityDetailHeaderViewDelegate>)headerViewDelegate{
	_headerViewDelegate = headerViewDelegate;
	self.postView.delegate = headerViewDelegate;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setLayoutModel:(HTCommunityLayoutModel *)layoutModel
{
	_layoutModel = layoutModel;
	[self.postView setModel:layoutModel row:0 type:HTCommunityTypelLive isShowDelete:NO];
	self.postViewHeightLayoutConstraint.constant = self.postView.heightForLive;
	self.postView.frame = CGRectMake(0, 0, HTSCREENWIDTH, self.postView.heightForLive);
	self.replyTableArray = layoutModel.originModel.reply;
	
	if (layoutModel.originModel.reply.count > 5) {
		self.moreLabel.text = [NSString stringWithFormat:@"查看全部%ld条评论",layoutModel.originModel.reply.count];
		self.moreLabelHeight.constant = 40;
	}else{
		self.moreLabel.text = @"";
		self.moreLabelHeight.constant = 0;
	}
	
	[self.replyTable reloadData];
}

#pragma mark -UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.replyTableArray.count > 5 ? 5 : self.replyTableArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	HTLiveReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTLiveReplyCell"];
	cell.delegate = self.clickButtonDelegate;
	cell.reply = self.replyTableArray[indexPath.row];
    cell.layoutModel = self.layoutModel;

	return cell;
}

#pragma mark -UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *heightStr = self.layoutModel.singleLiveReplyHeightArray[indexPath.row];
	return  heightStr.floatValue;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     CommunityReply *tempReply = self.replyTableArray[indexPath.row];
    if (self.delegate) {
        [self.delegate replyToReply:tempReply communityLayoutModel:self.layoutModel];
    }
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
