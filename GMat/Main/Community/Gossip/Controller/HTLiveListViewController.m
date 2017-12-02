//
//  HTLiveListViewController.m
//  GMat
//
//  Created by Charles Cao on 2017/11/9.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTLiveListViewController.h"
#import "HTCommunityModel.h"
#import "HTLiveListCell.h"
#import "MJRefresh.h"
#import "HTRewardAlertView.h"
#import "IQKeyboardManager.h"
#import "HTLiveDetailViewController.h"
#import "HTCommunityIssueController.h"
#import "HTCommunityReplyKeyBoardView.h"
#import "HTCommunityRingHeaderView.h"
#import "HTCommunityMessageController.h"
#import "HTNoLiveAlert.h"

@interface HTLiveListViewController ()<UITableViewDelegate, UITableViewDataSource,HTLiveReplyCellDelegate,HTLiveListCellDelegate, HTCommunityIssueControllerDelete,HTCommunityDetailHeaderViewDelegate>

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSMutableArray *communityLayoutModelArray;
@property (nonatomic, assign) NSInteger integral; //雷豆数量
@property (nonatomic, strong) HTCommunityRingHeaderView *communityHeaderView;
@property (nonatomic, strong) HTNoLiveAlert *noLiveAlert;

@end

@implementation HTLiveListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	self.currentPage = 1;
	self.communityLayoutModelArray = [NSMutableArray array];
	self.liveListTableView.sectionFooterHeight = CommunityCellMargin;
	
	[self configInterface];
	[self loadLiveList:YES];
	
}

- (void)configInterface{
	
	
	self.liveListTableView.contentOffset = CGPointZero;
	
	MJRefreshNormalHeader *headerHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
		self.currentPage = 1;
		[self loadLiveList:NO];
	}];
	
	headerHeader.stateLabel.hidden = YES;
	[headerHeader setTitle:@"" forState:MJRefreshStateIdle];
	headerHeader.lastUpdatedTimeLabel.hidden = YES;
	self.liveListTableView.mj_header = headerHeader;
	
	MJRefreshAutoNormalFooter *footerHeader = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
		self.currentPage++;
		[self loadLiveList:NO];
	}];
	footerHeader.refreshingTitleHidden = YES;
    [footerHeader setTitle:@"" forState:MJRefreshStateIdle];
	self.liveListTableView.mj_footer = footerHeader;
	
	UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"bi"]  style:UIBarButtonItemStylePlain target:self action:@selector(sendLive)];
	self.navigationItem.rightBarButtonItem = rightItem;
	
}


- (void)setLiveNumber:(NSString *)number{
	
	if (number.length == 0 || number== nil) number = @"0";
	NSString *title = [NSString stringWithFormat:@"直播(%@人在线)",number];
	NSMutableAttributedString *attributeTitle = [[NSMutableAttributedString alloc]initWithString:title];
	[attributeTitle addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, 2)];
	
	NSTextAttachment* textAttachment = [[NSTextAttachment alloc] init];
	textAttachment.image = [UIImage imageNamed:@"people"];
	textAttachment.bounds = CGRectMake(0, 0, 18, 14);
	NSAttributedString *imageAttirubte = [NSAttributedString attributedStringWithAttachment:textAttachment];
	[attributeTitle insertAttributedString:imageAttirubte atIndex:3];
	
	[attributeTitle addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(2, attributeTitle.length-2)];
	[attributeTitle addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, attributeTitle.length)];
	[attributeTitle addAttribute:NSForegroundColorAttributeName value:[UIColor ht_colorString:@"01BAFF"] range:NSMakeRange(3+imageAttirubte.length, number.length)];

	UILabel *titleLabel = [[UILabel alloc]init];
	titleLabel.attributedText = attributeTitle;
	[titleLabel sizeToFit];
	
	self.navigationItem.titleView = titleLabel;
	
}

- (HTCommunityRingHeaderView *)communityHeaderView {
	if (!_communityHeaderView) {
		_communityHeaderView = [[HTCommunityRingHeaderView alloc] init];
		[_communityHeaderView.communityRingView ht_whenTap:^(UIView *view) {
			HTCommunityMessageController *messageController = [[HTCommunityMessageController alloc] initWithtype:HTLiveMessage];
			[self.navigationController pushViewController:messageController animated:true];
		}];
	}
	return _communityHeaderView;
}

- (void)loadLiveList:(BOOL) isShowLoading{
	__weak HTLiveListViewController *weakSelf = self;
	
	HTNetworkModel *networkModel = [[HTNetworkModel alloc] init];
	if (isShowLoading) {
		networkModel.autoAlertString = @"点赞中";
		networkModel.offlineCacheStyle = HTCacheStyleNone;
		networkModel.autoShowError = true;
	}
	
	if (self.noLiveAlert) {
		[self.noLiveAlert removeFromSuperview];
		self.noLiveAlert = nil;
	}
	
	[HTRequestManager  requestLiveListWithNetworkModel:networkModel pageSize:@"20" currentPage:@(self.currentPage).stringValue complete:^(id response, HTError *errorModel) {
		
		NSInteger ringCount  = [response[@"num"] integerValue];
		[self setLiveNumber:response[@"userNumber"]];
		if (ringCount > 0) {
			[weakSelf.communityHeaderView setRingCount:ringCount completeBlock:^{
				weakSelf.liveListTableView.tableHeaderView = weakSelf.communityHeaderView;
				weakSelf.liveListTableView.tableHeaderView.frame = CGRectMake(0, 0, HTSCREENWIDTH, weakSelf.communityHeaderView.ht_h);
			}];
		}else{
			weakSelf.liveListTableView.tableHeaderView =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0.01, 0.01)];
			
		}
		
		weakSelf.integral = [NSString stringWithFormat:@"%@",response[@"integral"]].integerValue;
		NSArray *tempArray = [HTCommunityModel mj_objectArrayWithKeyValuesArray:response[@"data"][@"data"]];
		NSMutableArray *tempLayoutModelArray = [NSMutableArray array];
		[tempArray enumerateObjectsUsingBlock:^(HTCommunityModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
			HTCommunityLayoutModel *communityLayoutModel = [HTCommunityLayoutModel layoutModelWithOriginModel:obj isDetail:false];
			[tempLayoutModelArray addObject:communityLayoutModel];
		}];
		if (weakSelf.currentPage == 1){
			[weakSelf.communityLayoutModelArray setArray:tempLayoutModelArray];
			[weakSelf.liveListTableView reloadData];
		}else{
			NSMutableArray *indexPathArray = [NSMutableArray array];
            NSMutableIndexSet *sectionIndexSex = [NSMutableIndexSet indexSet];
            
            for (NSInteger i = 0; i<tempLayoutModelArray.count; i++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:weakSelf.communityLayoutModelArray.count + i];
                [indexPathArray addObject:indexPath];
                [sectionIndexSex addIndex:weakSelf.communityLayoutModelArray.count + i ];
            }
            
			[weakSelf.communityLayoutModelArray addObjectsFromArray:tempLayoutModelArray];
            [weakSelf.liveListTableView beginUpdates];
            [weakSelf.liveListTableView insertSections:sectionIndexSex withRowAnimation:UITableViewRowAnimationNone];
            [weakSelf.liveListTableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
            [weakSelf.liveListTableView endUpdates];			
		}
		
		if (weakSelf.currentPage == 1 && tempArray.count == 0) {
			self.noLiveAlert = (HTNoLiveAlert *)[[[NSBundle mainBundle] loadNibNamed:@"HTNoLiveAlert" owner:nil options:nil] firstObject];
			self.noLiveAlert.frame = weakSelf.liveListTableView.frame;
			[weakSelf.view addSubview:self.noLiveAlert];
		}
		[weakSelf.liveListTableView.mj_footer endRefreshing];
		[weakSelf.liveListTableView.mj_header endRefreshing];
	}];
}

#pragma mark -UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return self.communityLayoutModelArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	HTLiveListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTLiveListCell"];
	cell.clickButtonDelegate = self;
    cell.delegate = self;
	cell.headerViewDelegate = self;
	cell.layoutModel = self.communityLayoutModelArray[indexPath.section];
	return cell;
}

#pragma mark -UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	HTCommunityLayoutModel *layoutModel = self.communityLayoutModelArray[indexPath.section];
	NSInteger moreLabelHeight = layoutModel.originModel.reply.count > 5 ? 40 : 0;
	return layoutModel.totalHeightForLive + layoutModel.totalHeightForLiveReply + moreLabelHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self performSegueWithIdentifier:@"liveListToLiveDetail" sender:self.communityLayoutModelArray[indexPath.section]];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - HTLiveReplyCellDelegate
- (void)clickButton:(UIButton *)btn reply:(CommunityReply *)reply communityLayoutModel:(HTCommunityLayoutModel *)communityLayoutModel
{
    
    __weak HTLiveListViewController *weakSelf = self;
	NSInteger tag = btn.tag;
	//点赞
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
                NSInteger index = [weakSelf.communityLayoutModelArray indexOfObject:communityLayoutModel];
                [weakSelf.liveListTableView beginUpdates];
                [weakSelf.liveListTableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationNone];
                [weakSelf.liveListTableView endUpdates];
            }
        }];
        
	}else if (tag == 101) //打赏
	{
        HTRewardAlertView *rewardAlertView = (HTRewardAlertView *)[[[NSBundle mainBundle] loadNibNamed:@"HTRewardAlertView" owner:nil options:nil] firstObject];
        rewardAlertView.integral = self.integral;
        rewardAlertView.frame = self.liveListTableView.frame;
        rewardAlertView.rewardBlock = ^(NSInteger num) {
            [HTRequestManager requestRewardWithNetworkModel:nil replyID:reply.Id number:num complete:^(id response, HTError *errorModel) {
                if (errorModel.errorType == HTErrorTypeNoError) {
                    HTRewardSuccessView *rewardAlertView = (HTRewardSuccessView *)[[[NSBundle mainBundle] loadNibNamed:@"HTRewardAlertView" owner:nil options:nil] lastObject];
                    rewardAlertView.frame = weakSelf.liveListTableView.frame;
                    [weakSelf.view addSubview:rewardAlertView];
                    
                    NSInteger code = [NSString stringWithFormat:@"%@",response[@"code"]].integerValue;
                    if (code == 1) {
						weakSelf.integral -= num;
                        reply.reward ++;
                        NSInteger index = [weakSelf.communityLayoutModelArray indexOfObject:communityLayoutModel];
                        [weakSelf.liveListTableView beginUpdates];
                        [weakSelf.liveListTableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationNone];
                        [weakSelf.liveListTableView endUpdates];
                    }
                }else{
                    [HTAlert title:errorModel.errorString];
                }
            }];
        };
        [self.view addSubview:rewardAlertView];
	
	}else if (tag == 102) //追问
	{
        [self performSegueWithIdentifier:@"liveListToLiveDetail" sender:communityLayoutModel];
	}
}

#pragma mark - HTCommunityDetailHeaderViewDelegate

- (void)replyPostSuccessWithModel:(HTCommunityLayoutModel *)model reply:(CommunityReply *)newReply{
	
	NSMutableArray *tempReplyArray = [[NSMutableArray alloc]initWithArray:model.originModel.reply];
	[tempReplyArray addObject:newReply];
	model.originModel.reply = tempReplyArray;
	HTCommunityLayoutModel *newCommunityLayoutModel = [HTCommunityLayoutModel layoutModelWithOriginModel:model.originModel isDetail:false];
	NSInteger index = [self.communityLayoutModelArray indexOfObject:model];
	[self.communityLayoutModelArray replaceObjectAtIndex:index withObject:newCommunityLayoutModel];
	[self.liveListTableView beginUpdates];
	[self.liveListTableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationNone];
	[self.liveListTableView endUpdates];
}

#pragma mark - HTLiveListCellDelegate

- (void)replyToReply:(CommunityReply *)reply communityLayoutModel:(HTCommunityLayoutModel *)communityLayoutModel
{
    __weak HTLiveListViewController *weakSelf = self;
    [HTCommunityReplyKeyBoardView showReplyKeyBoardViewPlaceHodler:[NSString stringWithFormat:@" @%@", reply.uName] keyBoardAppearance:UIKeyboardAppearanceDark completeBlock:^(NSString *replyText) {
        HTNetworkModel *networkModel = [[HTNetworkModel alloc] init];
        networkModel.autoAlertString = @"回复中";
        networkModel.offlineCacheStyle = HTCacheStyleNone;
        networkModel.autoShowError = true;
        
        [HTRequestManager requestReplyLiveReplyWithNetworkModel:networkModel replyContent:replyText communityModel:communityLayoutModel.originModel beingReplyModel:reply complete:^(id response, HTError *errorModel) {
            if (!errorModel.existError) {
            	[HTAlert title:@"回复成功"];
				
				reply.askNum ++;
				NSInteger index = [weakSelf.communityLayoutModelArray indexOfObject:communityLayoutModel];
				[weakSelf.liveListTableView beginUpdates];
				[weakSelf.liveListTableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationNone];
				[weakSelf.liveListTableView endUpdates];
            }
        }];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - 发帖
- (void)sendLive {
	HTCommunityIssueController *issueController = [[HTCommunityIssueController alloc] init];
	issueController.type = HTIssueContentLive;
	issueController.delegate = self;
	[self.navigationController pushViewController:issueController animated:true];
}

#pragma mark - HTCommunityIssueControllerDelete
- (void)sendPostSuccess{
	[self.liveListTableView.mj_header beginRefreshing];
//	[self loadLiveList];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	
	if ([segue.identifier isEqualToString:@"liveListToLiveDetail"])
		{
		HTCommunityLayoutModel *model = (HTCommunityLayoutModel *)sender;
		HTLiveDetailViewController *detail = [segue destinationViewController];
		detail.liveID = model.originModel.Id;
		
	}
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
