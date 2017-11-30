//
//  HTLiveDetailViewController.m
//  GMat
//
//  Created by Charles Cao on 2017/11/14.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTLiveDetailViewController.h"
#import "HTLiveReplyCell.h"
#import "HTCommunityDetailHeaderView.h"
#import "HTRewardAlertView.h"
#import "IQKeyboardManager.h"
#import "HTCommunityReplyKeyBoardView.h"

@interface HTLiveDetailViewController () <UITableViewDelegate, UITableViewDataSource,HTCommunityDetailHeaderViewDelegate,HTLiveReplyCellDelegate>

@property (nonatomic, strong) HTCommunityDetailHeaderView *postView;
@property (nonatomic, strong) HTCommunityModel *model;
@property (nonatomic, strong) HTCommunityLayoutModel *layoutModel;
@property (nonatomic, strong) NSMutableArray *totalHeightForAskArray; //每条回复下的追问总高度

@end

@implementation HTLiveDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	[self loadData:YES];
}

- (void)loadPostView:(HTCommunityLayoutModel *) layoutModel {
	if (self.postView) {
		[self.postView removeFromSuperview];
	}else{
	 	self.postView = [[HTCommunityDetailHeaderView alloc]initWithFrame:CGRectZero];
     	self.postView.delegate = self;
	}
	[self.postView setModel:layoutModel row:0 type:HTCommunityTypelLive isShowDelete:NO];
	
	CGRect rect = CGRectMake(0, 0, HTSCREENWIDTH, self.postView.heightForLive);
	self.postView.frame = rect;
	self.detailTableView.tableHeaderView.frame = rect;
	[self.detailTableView.tableHeaderView addSubview:self.postView];
	[self.detailTableView reloadData];
}

- (void)loadData:(BOOL)isShowLoading{
	
	HTNetworkModel *networkModel = [[HTNetworkModel alloc] init];
	if (isShowLoading) {
		networkModel.autoAlertString = @"点赞中";
		networkModel.offlineCacheStyle = HTCacheStyleNone;
		networkModel.autoShowError = true;
	}
	
	__weak HTLiveDetailViewController* weakSelf = self;
	[HTRequestManager requestLiveDetailWithNetworkModel:networkModel liveId:self.liveID complete:^(id response, HTError *errorModel) {
		weakSelf.totalHeightForAskArray = [NSMutableArray array];
		weakSelf.model = [HTCommunityModel mj_objectWithKeyValues:response];
		[weakSelf.model.reply enumerateObjectsUsingBlock:^(CommunityReply * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
			obj.askNum = obj.asked.count;
			[self calculateAskHeight:obj.asked];
		}];
		
		weakSelf.layoutModel = [HTCommunityLayoutModel layoutModelWithOriginModel:weakSelf.model isDetail:false];
		[weakSelf loadPostView:weakSelf.layoutModel];
	}];
}

#pragma mark - HTCommunityDetailHeaderViewDelegate
//评论帖子成功
- (void)replyPostSuccessWithModel:(HTCommunityLayoutModel *)model reply:(CommunityReply *)newReply
{
	[self loadData:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return self.model.reply.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	HTLiveReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTLiveReplyCell"];
	cell.type = HTliveReplyCellTypeDetail;
	cell.reply = self.model.reply[indexPath.section];
    cell.delegate = self;
	cell.layoutModel = self.layoutModel;
	return cell;
}

#pragma mark -UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *liveReplyHeight = self.layoutModel.singleLiveReplyHeightArray[indexPath.section];
	CommunityReply *tempReply = self.model.reply[indexPath.section];
	if (tempReply.asked && tempReply.asked.count > 0)
	{
		CGFloat heightForAsk = ((NSNumber *)self.totalHeightForAskArray[indexPath.section]).floatValue;
		return liveReplyHeight.floatValue + heightForAsk + 5 + 10 + 7; // 三角形icon 顶部间距 + 三角形高度  + 追问 table 底部间距
	}else{
		return liveReplyHeight.floatValue;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommunityReply *tempReply = self.model.reply[indexPath.section];
    [self replyToReply:tempReply communityModel:self.model];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//追问高度
#pragma mark - 记录高度
- (void)calculateAskHeight:(NSArray *) askArray
{
	__weak HTLiveDetailViewController* weakSelf = self;
		__block CGFloat totalHeight = 0;
		[askArray enumerateObjectsUsingBlock:^(CommunityReply * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
			NSString *str = [NSString stringWithFormat:@"%@回复%@: %@",obj.uName, obj.replyUserName, obj.content];
			CGRect rec = [str boundingRectWithSize:CGSizeMake(HTSCREENWIDTH - 20 - 10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil]; //-20外层左右间距  -10 label 左右间距
			CGFloat askHeight = ceil(10 + rec.size.height); //追问回复:顶部距离 + 文字高度
			totalHeight += askHeight;
		}];
		[weakSelf.totalHeightForAskArray addObject:@(totalHeight)];
}

#pragma mark - HTLiveReplyCellDelegate
//点击点赞(tag:100) 打赏(tag:101) 追问(tag:102)    reply 评论
- (void)clickButton:(UIButton *)btn reply:(CommunityReply *)reply communityLayoutModel:(HTCommunityLayoutModel *)communityLayoutModel{
    NSInteger tag = btn.tag;
    __weak HTLiveDetailViewController* weakSelf = self;
    if (tag == 100)
    {
        [HTRequestManager requestRewardLikeWithNetworkModel:nil replyID:reply.Id complete:^(id response, HTError *errorModel) {
            if (errorModel.errorType == HTErrorTypeNoError) {
                NSInteger code = [NSString stringWithFormat:@"%@",response[@"code"]].integerValue;  //code 1：点赞  2：取消点赞
                if (code == 1){
                    reply.likeSign = 1;
                    reply.likeNum++;
                }else if (code == 2){
                    reply.likeSign = 0;
                    reply.likeNum--;
                }
                NSInteger index = [weakSelf.model.reply indexOfObject:reply];
                [weakSelf.detailTableView beginUpdates];
                [weakSelf.detailTableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationNone];
                [weakSelf.detailTableView endUpdates];
            }
            
        }];
    }else if (tag == 101) //打赏
    {
        HTRewardAlertView *rewardAlertView = (HTRewardAlertView *)[[[NSBundle mainBundle] loadNibNamed:@"HTRewardAlertView" owner:nil options:nil] firstObject];
        rewardAlertView.integral = self.model.integral;
        rewardAlertView.frame = self.detailTableView.frame;
	__weak HTLiveDetailViewController *weakSelf = self;
        rewardAlertView.rewardBlock = ^(NSInteger num) {
            [HTRequestManager requestRewardWithNetworkModel:nil replyID:reply.Id number:num complete:^(id response, HTError *errorModel) {
				
                if (errorModel.errorType == HTErrorTypeNoError) {
					
                    HTRewardSuccessView *rewardAlertView = (HTRewardSuccessView *)[[[NSBundle mainBundle] loadNibNamed:@"HTRewardAlertView" owner:nil options:nil] lastObject];
                    rewardAlertView.frame = weakSelf.detailTableView.frame;
                    [weakSelf.view addSubview:rewardAlertView];
                    NSInteger code = [NSString stringWithFormat:@"%@",response[@"code"]].integerValue;
                    if (code == 1) {
						self.model.integral -= num;
                        reply.reward ++;
                        NSInteger index = [weakSelf.model.reply indexOfObject:reply];
                        [weakSelf.detailTableView beginUpdates];
                        [weakSelf.detailTableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationNone];
                        [weakSelf.detailTableView endUpdates];
                    }
                }else{
                    [HTAlert title:errorModel.errorString];
                }
            }];
        };
        [self.view addSubview:rewardAlertView];
        
        
        
    }else if (tag == 102) //追问
    {
        [self replyToReply:reply communityModel:self.model];
        
    }
}

- (void)replyToReply:(CommunityReply *)reply communityModel:(HTCommunityModel *)communityModel{
    [HTCommunityReplyKeyBoardView showReplyKeyBoardViewPlaceHodler:[NSString stringWithFormat:@" @%@", reply.uName] keyBoardAppearance:UIKeyboardAppearanceDark completeBlock:^(NSString *replyText) {
        HTNetworkModel *networkModel = [[HTNetworkModel alloc] init];
        networkModel.autoAlertString = @"回复中";
        networkModel.offlineCacheStyle = HTCacheStyleNone;
        networkModel.autoShowError = true;
        
        [HTRequestManager requestReplyLiveReplyWithNetworkModel:networkModel replyContent:replyText communityModel:communityModel beingReplyModel:reply complete:^(id response, HTError *errorModel) {
            if (errorModel.existError) {
                return;
            }
			
            [HTAlert title:@"回复成功"];
			[self loadData:NO];
        }];
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
