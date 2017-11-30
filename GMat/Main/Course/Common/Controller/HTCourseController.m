//
//  HTCourseController.m
//  GMat
//
//  Created by hublot on 16/10/13.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTCourseController.h"
#import <UITableView+HTSeparate.h>
#import "HTNavigationBar.h"
#import "HTScrollPageView.h"
#import "HTCourseTryListenIndexCell.h"
#import "HTCourseOpenIndexCell.h"
#import "HTCourseBeginIndexCell.h"
#import "NSString+HTString.h"
#import "HTCourseTeacherIndexCell.h"
#import "HTCourseHotIndexCell.h"
#import "HTCourseOnlineVideoIndexCell.h"
#import "HTCourseOpenModel.h"
#import "THCourseTogetherTeacherModel.h"
#import "HTCourseCellHeaderView.h"
#import "HTCourseHotModel.h"
#import "HTCourseBannerModel.h"
#import "UIScrollView+HTRefresh.h"
#import "HTCourseOnlineVideoModel.h"
#import "HTWebController.h"
#import "THCourseTogetherController.h"
#import "HTTryListenModel.h"
#import "HTCourseBeginModel.h"

@interface HTCourseController ()

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) HTScrollPageView *scrollPageHeaderView;

@property (nonatomic, strong) NSArray <HTCourseBannerModel *> *bannerModelArray;

@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation HTCourseController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initializeDataSource];
	[self initializeUserInterface];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.bannerModelArray.count) {
        [self.tableView ht_startRefreshHeader];
    }
}

- (void)initializeDataSource {
	__weak HTCourseController *weakSelf = self;
	[self.tableView ht_setRefreshBlock:^(NSString *pageSize, NSString *currentPage) {
		HTNetworkModel *hotNetworkModel = [[HTNetworkModel alloc] init];
		hotNetworkModel.autoAlertString = nil;
		hotNetworkModel.offlineCacheStyle = HTCacheStyleAllUser;
		hotNetworkModel.autoShowError = false;
		[HTRequestManager requestHotCourseAndBannerWithNetworkModel:hotNetworkModel complete:^(id response, HTError *errorModel) {
			[weakSelf.tableView ht_endRefreshWithModelArrayCount:1];
			if (errorModel.existError) {
				return;
			}
			NSArray <HTCourseBannerModel *> *bannerModelArray = [HTCourseBannerModel mj_objectArrayWithKeyValuesArray:response[@"banner"]];
			weakSelf.pageControl.numberOfPages = bannerModelArray.count;
			
			weakSelf.bannerModelArray = bannerModelArray;
            weakSelf.scrollPageHeaderView.numberOfRows = bannerModelArray.count;
			[weakSelf.scrollPageHeaderView reloadData];
            [self.scrollPageHeaderView addSubview:self.pageControl];
			
			
			NSArray <HTCourseHotModel *> *hotModelArray = [HTCourseHotModel mj_objectArrayWithKeyValuesArray:response[@"hotClass"]];
			[hotModelArray enumerateObjectsUsingBlock:^(HTCourseHotModel * _Nonnull obj, NSUInteger index, BOOL * _Nonnull stop) {
				[obj resetJoinTimesWithIndex:index];
			}];
			[weakSelf.tableView ht_updateSection:3 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
				sectionMaker.cellClass([HTCourseHotIndexCell class])
				.modelArray(@[hotModelArray])
				.headerClass([HTCourseCellHeaderView class])
				.headerHeight(40)
				.footerHeight(10);
			}];
		}];
		
		HTNetworkModel *trylistenNetworkModel = [HTNetworkModel modelForOnlyCacheNoInterfaceForScrollViewWithCacheStyle:HTCacheStyleAllUser];
		[HTRequestManager requestTryListenCourseListWithNetworkModel:trylistenNetworkModel complete:^(id response, HTError *errorModel) {
			if (errorModel.existError) {
				return;
			}
			NSArray *modelArray = [HTTryListenModel mj_objectArrayWithKeyValuesArray:response];
			[modelArray enumerateObjectsUsingBlock:^(HTTryListenModel *model, NSUInteger index, BOOL * _Nonnull stop) {
				[model appendDataWithIndex:index];
			}];
			[weakSelf.tableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
				sectionMaker.cellClass([HTCourseTryListenIndexCell class])
				.modelArray(@[modelArray])
				.headerClass([HTCourseCellHeaderView class])
				.headerHeight(40)
				.footerHeight(10);
			}];
		}];
		
		HTNetworkModel *openNetworkModel = [[HTNetworkModel alloc] init];
		openNetworkModel.autoAlertString = nil;
		openNetworkModel.offlineCacheStyle = HTCacheStyleAllUser;
		openNetworkModel.autoShowError = false;
		[HTRequestManager requestOpenCourseWithNetworkModel:openNetworkModel complete:^(id response, HTError *errorModel) {
			if (errorModel.existError) {
				return;
			}
			NSMutableArray *modelArray = [HTCourseOpenModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
			[modelArray enumerateObjectsUsingBlock:^(HTCourseOpenModel *openModel, NSUInteger idx, BOOL * _Nonnull stop) {
				[openModel resetJoinTimes];
			}];
			[weakSelf.tableView ht_updateSection:1 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
				sectionMaker.cellClass([HTCourseOpenIndexCell class])
				.modelArray(@[modelArray])
				.footerHeight(10);
			}];
		}];
		
		/* 入门课程
		HTNetworkModel *beginNetworkModel = [HTNetworkModel modelForOnlyCacheNoInterfaceForScrollViewWithCacheStyle:HTCacheStyleAllUser];
		[HTRequestManager requestBeginCourseListWithNetworkModel:beginNetworkModel complete:^(id response, HTError *errorModel) {
			if (errorModel.existError) {
				return;
			}
			NSArray *modelArray = [HTCourseBeginModel mj_objectArrayWithKeyValuesArray:response];
			[modelArray enumerateObjectsUsingBlock:^(HTCourseBeginModel *model, NSUInteger index, BOOL * _Nonnull stop) {
				[model appendDataWithIndex:index];
			}];
			[weakSelf.tableView ht_updateSection:2 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
				sectionMaker.cellClass([HTCourseBeginIndexCell class])
				.modelArray(@[modelArray])
				.headerClass([HTCourseCellHeaderView class])
				.headerHeight(40)
				.footerHeight(10);
			}];
		}];
		*/
		HTNetworkModel *teacherNetworkModel = [[HTNetworkModel alloc] init];
		teacherNetworkModel.autoAlertString = nil;
		teacherNetworkModel.offlineCacheStyle = HTCacheStyleAllUser;
		teacherNetworkModel.autoShowError = false;
		[HTRequestManager requestTeacherListWithNetworkModel:teacherNetworkModel complete:^(id response, HTError *errorModel) {
			if (errorModel.existError) {
				return;
			}
			dispatch_async(dispatch_get_global_queue(0, 0), ^{
				NSMutableArray *modelArray = [THCourseTogetherTeacherModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
				[modelArray enumerateObjectsUsingBlock:^(THCourseTogetherTeacherModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
					obj.introduceAttributedString = [[obj.introduce ht_htmlDecodeString] ht_attributedStringNeedDispatcher:nil];
					[obj resetJoinTimes];
				}];
				dispatch_async(dispatch_get_main_queue(), ^{
					[weakSelf.tableView ht_updateSection:2 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
						[sectionMaker.cellClass([HTCourseTeacherIndexCell class])
						 .modelArray(@[modelArray])
						 .headerClass([HTCourseCellHeaderView class])
						 .headerHeight(40)
						 .footerHeight(10) customHeaderBlock:^(UITableView *tableView, NSInteger section, __kindof HTCourseCellHeaderView *reuseView, __kindof NSArray *modelArray) {
							[reuseView setHeaderRightDetailTapedBlock:^{
								THCourseTogetherController *teacherListController = [[THCourseTogetherController alloc] init];
								[weakSelf.navigationController pushViewController:teacherListController animated:true];
							}];
						}];
					}];
				});
			});
		}];
		
		HTNetworkModel *liveNetworkModel = [[HTNetworkModel alloc] init];
		liveNetworkModel.autoAlertString = nil;
		liveNetworkModel.offlineCacheStyle = HTCacheStyleAllUser;
		liveNetworkModel.autoShowError = false;
		
		[HTRequestManager requestLiveCourseWithNetworkModel:liveNetworkModel complete:^(id response, HTError *errorModel) {
			if (errorModel.existError) {
				return;
			}
			NSMutableArray *modelArray = [HTCourseOnlineVideoModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
			[weakSelf.tableView ht_updateSection:4 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
				sectionMaker.cellClass([HTCourseOnlineVideoIndexCell class])
				 .modelArray(@[modelArray])
				 .headerClass([HTCourseCellHeaderView class])
				 .headerHeight(40)
				 .footerHeight(10);
			}];
		}];
		
		HTNetworkModel *videoNetworkModel = [[HTNetworkModel alloc] init];
		videoNetworkModel.autoAlertString = nil;
		videoNetworkModel.offlineCacheStyle = HTCacheStyleAllUser;
		videoNetworkModel.autoShowError = false;
		
		[HTRequestManager requestVideoCourseWithNetworkModel:videoNetworkModel complete:^(id response, HTError *errorModel) {
			if (errorModel.existError) {
				return;
			}
			NSMutableArray *modelArray = [HTCourseOnlineVideoModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
			[weakSelf.tableView ht_updateSection:5 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
				sectionMaker.cellClass([HTCourseOnlineVideoIndexCell class])
				.modelArray(@[modelArray])
				.headerClass([HTCourseCellHeaderView class])
				.headerHeight(40)
				.footerHeight(10);
			}];
		}];
		
		//获取面授课程
		
		HTNetworkModel *mianShouLessonNetworkModel = [[HTNetworkModel alloc] init];
		mianShouLessonNetworkModel.autoAlertString = nil;
		mianShouLessonNetworkModel.offlineCacheStyle = HTCacheStyleAllUser;
		mianShouLessonNetworkModel.autoShowError = false;
		
		[HTRequestManager requestMianShouLessonWithNetworkModel:mianShouLessonNetworkModel complete:^(id response, HTError *errorModel) {
			if (errorModel.existError) {
				return;
			}
			NSMutableArray *modelArray = [HTCourseOnlineVideoModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
			[weakSelf.tableView ht_updateSection:6 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
				sectionMaker.cellClass([HTCourseOnlineVideoIndexCell class])
				.modelArray(@[modelArray])
				.headerClass([HTCourseCellHeaderView class])
				.headerHeight(40)
				.footerHeight(10);
			}];
		}];
}];

	[self.tableView ht_startRefreshHeader];
}

- (void)initializeUserInterface {
	[self.view addSubview:self.tableView];
	self.navigationItem.title = @"抢先学课";
	self.tableView.tableHeaderView = self.scrollPageHeaderView;
	self.automaticallyAdjustsScrollViewInsets = false;
	if (@available(iOS 11.0, *)) {
		self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
	}
}

- (NSInteger)numberOfRowInScrollPageView:(HTScrollPageView *)scrollPageView {
	return self.bannerModelArray.count;
}

- (void)scrollPageView:(HTScrollPageView *)scrollPageView updateCurrentRow:(NSInteger)row {
    self.pageControl.currentPage = row;
}

- (void)scrollPageView:(HTScrollPageView *)scrollPageView didSelectedRow:(NSInteger)row {
	HTCourseBannerModel *bannerModel = self.bannerModelArray[row];
	HTWebController *webController = [[HTWebController alloc] initWithAddress:bannerModel.contentlink];
	[self.navigationController pushViewController:webController animated:true];
}

- (void)scrollPageView:(HTScrollPageView *)scrollPageView configureButton:(UIButton *)button AtRow:(NSInteger)row {
	HTCourseBannerModel *bannerModel = self.bannerModelArray[row];
	[button sd_setBackgroundImageWithURL:[NSURL URLWithString:GmatResourse(bannerModel.contentthumb)] forState:UIControlStateNormal placeholderImage:HTPLACEHOLDERIMAGE];
}

- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
		_tableView.contentInset = UIEdgeInsetsMake(64, 0, 49, 0);
		_tableView.scrollIndicatorInsets = _tableView.contentInset;
		_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.allowsSelection = false;
        _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
	}
	return _tableView;
}

- (HTScrollPageView *)scrollPageHeaderView {
	if (!_scrollPageHeaderView) {
        
        __weak HTCourseController *weakSelf = self;
		_scrollPageHeaderView = [[HTScrollPageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 220)];
        [_scrollPageHeaderView setButtonForIndexPath:^(UIButton *button, NSInteger index) {
            HTCourseBannerModel *bannerModel = weakSelf.bannerModelArray[index];
            [button sd_setBackgroundImageWithURL:[NSURL URLWithString:GmatResourse(bannerModel.contentthumb)] forState:UIControlStateNormal placeholderImage:HTPLACEHOLDERIMAGE];
        }];
        [_scrollPageHeaderView setWillDisplayIndexPath:^(UIButton *button, NSInteger index) {
            weakSelf.pageControl.currentPage = index;
        }];
        [_scrollPageHeaderView setDidSelectedIndexPath:^(UIButton *button, NSInteger index) {
            HTCourseBannerModel *bannerModel = weakSelf.bannerModelArray[index];
            HTWebController *webController = [[HTWebController alloc] initWithAddress:bannerModel.contentlink];
            [weakSelf.navigationController pushViewController:webController animated:true];
        }];
	}
	return _scrollPageHeaderView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, self.scrollPageHeaderView.bounds.size.width, 20)];
        _pageControl.center = CGPointMake(self.scrollPageHeaderView.bounds.size.width / 2, self.scrollPageHeaderView.bounds.size.height - self.pageControl.bounds.size.height);
        _pageControl.currentPageIndicatorTintColor = [UIColor ht_colorString:@"fe9e4e"];
    }
    return _pageControl;
}

@end
