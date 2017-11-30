//
//  HTCommunityController.m
//  GMat
//
//  Created by hublot on 2016/10/26.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTCommunityController.h"
#import "HTCommunityIssueController.h"
#import "HTLoginManager.h"
#import "HTCommunityLayoutModel.h"
#import "HTCommunityCell.h"
#import <UITableView+HTSeparate.h>
#import "UIScrollView+HTRefresh.h"
#import "HTCommunityDetailController.h"
#import "HTCommunityMessageController.h"
#import <UITableViewCell_HTSeparate.h>
#import <NSObject+HTTableRowHeight.h>
#import "HTMineFontSizeController.h"
#import "HTLiveImageView.h"
#import "HTIsPayAlertView.h"
#import "HTComplaintModel.h"
#import "HTCommunityWebPayViewController.h"
#import "HTLiveListViewController.h"
#import <TencentOpenAPI/QQApiInterface.h>

@interface HTCommunityController () <HTCommunityWebPayViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray <HTCommunityLayoutModel *> *communityLayoutModelArray;
@property (nonatomic, strong) HTTableViewSectionMaker *tempLiveSectionMaker;


@end

@implementation HTCommunityController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initializeDataSource];
	[self initializeUserInterface];
	[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deleteGossip:) name:DELETE object:nil];
	[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginSuccess) name:LOGINSUCCESS object:nil];
	
}

- (void)initializeDataSource {
	self.tableView.ht_pageSize = 20;
	__weak HTCommunityController *weakSelf = self;
	[self.tableView ht_setRefreshBlock:^(NSString *pageSize, NSString *currentPage) {
		HTNetworkModel *networkModel = [HTNetworkModel modelForOnlyCacheNoInterfaceForScrollViewWithCacheStyle:HTCacheStyleAllUser];
		[HTRequestManager requestGossipListWithNetworkModel:networkModel pageSize:pageSize currentPage:currentPage complete:^(id response, HTError *errorModel) {
			if (errorModel.existError) {
				[weakSelf.tableView ht_endRefreshWithModelArrayCount:errorModel.errorType];
				return;
			}
			dispatch_async(dispatch_get_global_queue(0, 0), ^{
				NSMutableArray <HTCommunityLayoutModel *> *communityLayoutModelArray = [@[] mutableCopy];
				if (response && response[@"data"] && response[@"data"][@"data"]) {
					NSMutableArray <HTCommunityModel *> *communityModelArray = [HTCommunityModel mj_objectArrayWithKeyValuesArray:response[@"data"][@"data"]];
					[communityModelArray enumerateObjectsUsingBlock:^(HTCommunityModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
						HTCommunityLayoutModel *communityLayoutModel = [HTCommunityLayoutModel layoutModelWithOriginModel:obj isDetail:false];
						[communityLayoutModelArray addObject:communityLayoutModel];
					}];
					NSInteger ringCount = [response[@"num"] integerValue];
					
					dispatch_async(dispatch_get_main_queue(), ^{
						if (ringCount > 0) {
							[weakSelf.communityHeaderView setRingCount:ringCount completeBlock:^{
								weakSelf.tableView.tableHeaderView = weakSelf.communityHeaderView;
							}];
						}else{
							weakSelf.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0.01, 0.01)];
						}
						
					});
				}
				if (currentPage.integerValue == 1) {
					weakSelf.communityLayoutModelArray = communityLayoutModelArray;
				} else {
					[weakSelf.communityLayoutModelArray addObjectsFromArray:communityLayoutModelArray];
				}
				dispatch_async(dispatch_get_main_queue(), ^{
					[weakSelf.tableView ht_endRefreshWithModelArrayCount:communityLayoutModelArray.count];
					
					//自己
					[communityLayoutModelArray enumerateObjectsUsingBlock:^(HTCommunityLayoutModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
						[weakSelf.tableView ht_updateSection:idx sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
							if (idx == 0) {
								self.tempLiveSectionMaker = sectionMaker;
								HTComplaintModel *complaint = [HTComplaintModel mj_objectWithKeyValues:response];
								UIView *headerView = [self liveSectionHeaderView:complaint];
								if (headerView) {
//									sectionMaker.headerView(headerView).headerHeight(HTSCREENWIDTH/(526.0/230.0) + 7);
									sectionMaker.headerView(headerView);
								}else {
									sectionMaker.headerView(nil).headerHeight(0);
								}
							}
							[sectionMaker.cellClass([HTCommunityCell class]) didSelectedCellBlock:^(UITableView *tableView, NSInteger row, __kindof UITableViewCell *cell, __kindof HTCommunityLayoutModel *model) {
								HTCommunityDetailController *detailController = [[HTCommunityDetailController alloc] init];
								[detailController setDetailDidDismissBlock:^(HTCommunityModel *communityModel) {
									HTCommunityLayoutModel *communityLayoutModel = [HTCommunityLayoutModel layoutModelWithOriginModel:communityModel isDetail:false];
									[self.communityLayoutModelArray replaceObjectAtIndex:row withObject:communityLayoutModel];
									dispatch_async(dispatch_get_global_queue(0, 0), ^{
										dispatch_async(dispatch_get_main_queue(), ^{
											[cell setModel:communityLayoutModel row:row];
											[self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:row]] withRowAnimation:UITableViewRowAnimationNone];
										});
									});
								}];
								detailController.communityIdString = model.originModel.Id;
								[self.navigationController pushViewController:detailController animated:true];
							}];
							//
							sectionMaker.modelArray(@[obj]);
						}];
					}];
					
					/*** 原来
					 [weakSelf.tableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
					 sectionMaker.modelArray(weakSelf.communityLayoutModelArray);
					 }];
					 ***/
				});
			});
		}];
	}];
	[self.tableView ht_startRefreshHeader];
	
	[[NSNotificationCenter defaultCenter] addObserver:self.tableView selector:@selector(ht_startRefreshHeader) name:kHTFontChangeNotification object:nil];
	
}

- (void)initializeUserInterface {
	[self.view addSubview:self.tableView];
	[self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.edges.mas_equalTo(UIEdgeInsetsZero);
	}];
}

- (void)loginSuccess{
	[self.tableView ht_startRefreshHeader];
}

- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
		
		//        _tableView = [[UITableView alloc] init];
		_tableView.backgroundColor = [UIColor ht_colorStyle:HTColorStyleCompareBackground];
		_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		
		//        [_tableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
		//            [sectionMaker.cellClass([HTCommunityCell class]) didSelectedCellBlock:^(UITableView *tableView, NSInteger row, __kindof UITableViewCell *cell, __kindof HTCommunityLayoutModel *model) {
		//
		//                HTCommunityDetailController *detailController = [[HTCommunityDetailController alloc] init];
		//                [detailController setDetailDidDismissBlock:^(HTCommunityModel *communityModel) {
		//                    HTCommunityLayoutModel *communityLayoutModel = [HTCommunityLayoutModel layoutModelWithOriginModel:communityModel isDetail:false];
		//                    [self.communityLayoutModelArray replaceObjectAtIndex:row withObject:communityLayoutModel];
		//                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
		//                        dispatch_async(dispatch_get_main_queue(), ^{
		//                            [cell setModel:communityLayoutModel row:row];
		//                            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
		//                        });
		//                    });
		//                }];
		//                detailController.communityIdString = model.originModel.Id;
		//                [self.navigationController pushViewController:detailController animated:true];
		//            }];
		//        }];
	}
	return _tableView;
}

- (HTCommunityRingHeaderView *)communityHeaderView {
	if (!_communityHeaderView) {
		_communityHeaderView = [[HTCommunityRingHeaderView alloc] init];
        
		[_communityHeaderView.communityRingView ht_whenTap:^(UIView *view) {
			HTCommunityMessageController *messageController = [[HTCommunityMessageController alloc] initWithtype:HTCommunityMessage];
			
			[self.navigationController pushViewController:messageController animated:true];
		}];
	}
	return _communityHeaderView;
}

//获取直播 sectionHeaderView
- (UIView *)liveSectionHeaderView:(HTComplaintModel *)plaint{
	HTLiveImageView *view = nil;
	__weak HTCommunityController *weakSelf = self;
	if (plaint.live != 0){
		view = (HTLiveImageView *)[[[NSBundle mainBundle] loadNibNamed:@"HTLiveImageView" owner:nil options:nil] firstObject];
		NSString *imageUrl = nil;
		if (plaint.live == 1) {
			imageUrl = plaint.signLive.psvImage;
		}else if (plaint.live == 2){
			imageUrl = plaint.signLive.image;
		}else{
			imageUrl = plaint.signLive.backImage;
		}
		NSString *imageUrlStr = [NSString stringWithFormat:@"http://bbs.viplgw.cn%@",imageUrl];
		[view.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrlStr] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
			
			CGFloat heigth 	= image ?  image.size.height/image.size.width*HTSCREENWIDTH + 7 : 0;
			self.tempLiveSectionMaker.headerHeight(heigth);
			[self.tableView beginUpdates];
			[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
			[self.tableView endUpdates];
		}];
		view.tap = ^{
			if (plaint.live == 1) {
				//拉起 qq
				if ([QQApiInterface isQQInstalled]) {
					QQApiWPAObject *wpaObj = [QQApiWPAObject objectWithUin:plaint.QQ];
					SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:wpaObj];
					QQApiSendResultCode sent = [QQApiInterface sendReq:req];
					if (sent == EQQAPIVERSIONNEEDUPDATE) [HTAlert title:@"当前QQ版本太低"];
				}
			}else if (plaint.live == 2 || plaint.live == 3){
				if ([HTUserManager currentUser].permission < HTUserPermissionExerciseAbleUser) {
					[HTLoginManager presentAndLoginSuccess:^{
					//	[weakSelf.tableView ht_startRefreshHeader];
					}];
					return ;
				}
				
				//*****************测试******************
			     //   plaint.isPay = 1;
				//*****************测试******************
				
				if (plaint.isPay == 0){
					HTIsPayAlertView *alertView = (HTIsPayAlertView *)[[[NSBundle mainBundle] loadNibNamed:@"HTIsPayAlertView" owner:nil options:nil] firstObject];
					alertView.frame = CGRectMake(0, 0, HTSCREENWIDTH, weakSelf.view.bounds.size.height);
					alertView.currentIntegral.text = [[NSString alloc]initWithFormat:@"您当前的雷豆数:%ld",(long)plaint.integral];
					
					alertView.titleLabel.text = [[NSString alloc]initWithFormat:@"是否花费%ld雷豆进入直播间?",(long)plaint.needNum];
					NSString *str = plaint.integral < plaint.needNum ? @"雷豆不足,点击[确定]进入支付页面": [NSString stringWithFormat:@"点击[确定],花费%ld雷豆进入直播间",(long)plaint.needNum];
					alertView.describeLabel.text = str;
					[weakSelf.view addSubview:alertView];
					alertView.confirmAction = ^{
						
						if (plaint.integral < plaint.needNum) {
							//跳h5支付
							HTCommunityWebPayViewController *payController = [HTCommunityWebPayViewController new];
							payController.delegate = weakSelf;
							[weakSelf.navigationController pushViewController:payController animated:YES];
						}else{
							//请求服务器确认
							[HTRequestManager requestToPay:nil complete:^(id response, HTError *errorModel) {
								NSInteger code = [NSString stringWithFormat:@"%@",response[@"code"]].integerValue  ;
								
								if (code == 0) {
									//0直播已关闭
									[HTAlert title:@"直播已关闭"];
								}else if (code == 1){
									//1支付并进入直播间
									plaint.isPay = 1;
									HTLiveListViewController *liveList = STORYBOARD_VIEWCONTROLLER(@"Community",@"HTLiveListViewController");;
									[weakSelf.navigationController pushViewController:liveList animated:YES];
								}else if (code == 2){
									//2跳 H5
									HTCommunityWebPayViewController *payController = [HTCommunityWebPayViewController new];
									payController.delegate = weakSelf;
									[weakSelf.navigationController pushViewController:payController animated:YES];
								}
							}];
						}
					};
				}else{
					HTLiveListViewController *liveList = STORYBOARD_VIEWCONTROLLER(@"Community",@"HTLiveListViewController");;
					[weakSelf.navigationController pushViewController:liveList animated:YES];
				}
			}
			
		};
		view.backgroundColor = [UIColor ht_colorStyle:HTColorStyleCompareBackground];
	}
	return view;
}

#pragma mark - deleteGossip
- (void)deleteGossip:(NSNotification *)notification{
	[HTAlert title:@"" message:@"确定删除?" sureAction:^{
		__weak HTCommunityController *weakSelf = self;
		HTCommunityModel *model = notification.userInfo[@"model"];
		[HTRequestManager deleteGossipWithNetworkModel:nil gossipIdString:model.Id complete:^(id response, HTError *errorModel) {
			if (!errorModel.existError) {
				[weakSelf.tableView ht_startRefreshHeader];
			}
		}] ;
	} cancelAction:^{
		
	} animated:YES completion:nil];
	
}

#pragma mark - HTCommunityWebPayViewControllerDelegate
- (void)paySuccess{
	[self.tableView ht_startRefreshHeader];
}


@end
