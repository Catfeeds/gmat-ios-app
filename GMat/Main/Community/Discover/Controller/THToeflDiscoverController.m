//
//  THToeflDiscoverController.m
//  TingApp
//
//  Created by hublot on 16/8/22.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "THToeflDiscoverController.h"
#import "HTDiscoverAttentionController.h"
#import "HTDiscoverInformationController.h"
#import "THToeflDiscoverModel.h"
#import "HTDiscoverItemModel.h"
#import "HTDiscoverAttentionModel.h"
#import "HTDiscoverItemCell.h"
#import "HTDiscoverItemDetailController.h"
#import "HTGmatController.h"
#import <UICollectionView+HTSeparate.h>
#import <UIScrollView+HTRefresh.h>

@interface THToeflDiscoverController ()

@property (nonatomic, strong) NSMutableArray *modelArray;

@property (nonatomic, strong) UICollectionView *headerCollectionView;

@end

@implementation THToeflDiscoverController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initializeDataSource];
	[self initializeUserInterface];
}

- (void)initializeDataSource {
	
	__weak typeof(self) weakSelf = self;
	[self.magicView bk_addObserverForKeyPath:@"contentView.contentOffset" task:^(id target) {
		UIScrollView *scrollView = (UIScrollView *)[self.magicView valueForKey:@"contentView"];
		weakSelf.discoverContentOffX = scrollView.contentOffset.x;
	}];
}

- (void)ht_startRefreshHeader {
	HTDiscoverInformationController *selectedController = [self viewControllerAtPage:0];
	[selectedController.tableView ht_startRefreshHeader];
}

- (UIButton *)magicView:(VTMagicView *)magicView menuItemAtIndex:(NSUInteger)itemIndex {
	UIButton *button = [super magicView:magicView menuItemAtIndex:itemIndex];
	NSString *imageName = [NSString stringWithFormat:@"CommunityDiscoverSelected%ld", itemIndex + 1];
	UIImage *image = [UIImage imageNamed:imageName];
	[button setBackgroundImage:image forState:UIControlStateNormal];
	[button setBackgroundImage:image forState:UIControlStateHighlighted];
	[button setBackgroundImage:image forState:UIControlStateSelected];
	[button setTitleColor:[UIColor ht_colorString:@"282b3a"] forState:UIControlStateNormal];
	[button setTitleColor:[UIColor ht_colorString:@"005dcb"] forState:UIControlStateSelected];
	button.titleLabel.font = [UIFont systemFontOfSize:14];
	return button;
}

- (void)magicView:(VTMagicView *)magicView viewDidAppear:(__kindof HTReuseController *)viewController atPage:(NSUInteger)pageIndex {
	UITableView *tableView = viewController.tableView;
	
	__weak typeof(self) weakSelf = self;
	[tableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
		[sectionMaker willEndDraggingBlock:^(UIScrollView *scrollView, CGPoint contentOffSet, UIEdgeInsets contentInSet, CGPoint velocity, CGPoint targetContentOffSet) {
			if (velocity.y > 0.3) {
				if (!weakSelf.magicView.headerHidden) {
					[weakSelf.magicView setHeaderHidden:true duration:0.4];
				}
			} else if (targetContentOffSet.y < 0 || velocity.y < - 1) {
				if (weakSelf.magicView.headerHidden) {
					[weakSelf.magicView setHeaderHidden:false duration:0.4];
				}
			}
		}];
	}];
	
	[super magicView:magicView viewDidAppear:viewController atPage:pageIndex];

}

- (void)initializeUserInterface {
	self.magicView.headerHeight = self.headerCollectionView.ht_h;
	[self.magicView.headerView addSubview:self.headerCollectionView];
	self.magicView.headerHidden = false;
	
	
	NSArray *titleArray = @[@"考试资讯", @"鸡精更新", @"资料下载"];
	NSArray *controllerArray = @[NSStringFromClass([HTDiscoverAttentionController class]), NSStringFromClass([HTDiscoverInformationController class]), NSStringFromClass([HTDiscoverInformationController class])];
	NSMutableArray *pageModelArray = [@[] mutableCopy];
	[titleArray enumerateObjectsUsingBlock:^(NSString *title, NSUInteger index, BOOL * _Nonnull stop) {
		HTPageModel *pageModel = [[HTPageModel alloc] init];
		pageModel.selectedTitle = title;
		NSString *controllerString = controllerArray[index];
		pageModel.reuseControllerClass = NSClassFromString(controllerString);
		[pageModelArray addObject:pageModel];
	}];
	self.pageModelArray = pageModelArray;
	[self setModelArrayBlock:^(NSString *pageIndex, NSString *pageCount, NSString *currentPage, void (^modelArrayStatus)(NSArray <id> *, HTError *)) {
		HTNetworkModel *networkModel = [HTNetworkModel modelForOnlyCacheNoInterfaceForScrollViewWithCacheStyle:HTCacheStyleAllUser];
		
		if (pageIndex.integerValue == 0) {
			[HTRequestManager requestDiscoverInformationWithNetworkModel:networkModel pageSize:pageCount currentPage:currentPage complete:^(id response, HTError *errorModel) {
				if (errorModel.existError) {
					modelArrayStatus(nil, errorModel);
					return;
				}
				NSMutableArray <HTDiscoverAttentionModel *> *modelArray = [HTDiscoverAttentionModel mj_objectArrayWithKeyValuesArray:response];
				modelArrayStatus(modelArray, errorModel);
			}];
		} else {
			[HTRequestManager requestDiscoverListWithNetworkModel:networkModel discoverType:pageIndex.integerValue pageSize:pageCount currentPage:currentPage complete:^(id response, HTError *errorModel) {
				if (errorModel.existError) {
					modelArrayStatus(nil, errorModel);
					return;
				}
				[[[NSOperationQueue alloc] init] addOperationWithBlock:^{
					NSMutableArray <THToeflDiscoverModel *> *modelArray = [THToeflDiscoverModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
					for (THToeflDiscoverModel *model in modelArray) {
						[model creatDetailAttributedString];
					}
					[[NSOperationQueue mainQueue] addOperationWithBlock:^{
						modelArrayStatus(modelArray, nil);
					}];
				}];
			}];
		}
	}];
	self.magicView.sliderColor = [UIColor clearColor];
	self.magicView.layoutStyle = VTLayoutStyleDivide;
	self.magicView.navigationColor = [UIColor ht_colorString:@"fff5e1"];
	self.magicView.navigationHeight = 44;
	self.magicView.navigationInset = UIEdgeInsetsMake(6, 0, 6, 0);
	[self.magicView reloadData];
}

- (UICollectionView *)headerCollectionView {
	if (!_headerCollectionView) {
		UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
		CGSize collectionSize = CGSizeMake(HTSCREENWIDTH, 150);
		_headerCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, collectionSize.width, collectionSize.height) collectionViewLayout:flowLayout];
		_headerCollectionView.scrollEnabled = false;
		NSArray *modelArray = [HTDiscoverItemModel packModelArray];
		CGFloat itemCountForSingelRow = 5;
		CGFloat itemCountForSingelCol = ceil(modelArray.count / itemCountForSingelRow);
		UIEdgeInsets sectionEdge = UIEdgeInsetsMake(10, 10, 10, 10);
		CGFloat itemWidth = (collectionSize.width - sectionEdge.left - sectionEdge.right) / itemCountForSingelRow;
		CGFloat itemHeight = (collectionSize.height - sectionEdge.top - sectionEdge.bottom) / itemCountForSingelCol;
		CGSize itemSize = CGSizeMake(itemWidth, itemHeight);
		[_headerCollectionView ht_updateSection:0 sectionMakerBlock:^(HTCollectionViewSectionMaker *sectionMaker) {
			[sectionMaker
			.itemSize(itemSize)
			.sectionInset(sectionEdge)
			.itemHorizontalSpacing(0)
			.itemVerticalSpacing(0)
			.cellClass([HTDiscoverItemCell class])
			.modelArray(modelArray) didSelectedCellBlock:^(UICollectionView *collectionView, NSInteger item, __kindof UICollectionViewCell *cell, __kindof NSObject *model) {
				HTDiscoverItemDetailController *detailController = [[HTDiscoverItemDetailController alloc] init];
				detailController.attentionModel = model;
				[self.navigationController pushViewController:detailController animated:true];
			}];
		}];
		
		UIImage *image = [UIImage imageNamed:@"CommunityDiscoverHeader"];
		UIColor *darkColor = [UIColor colorWithWhite:0 alpha:0.5];
		UIImage *darkImage = [UIImage ht_pureColor:darkColor];
		darkImage = [darkImage ht_resetSize:image.size];
		image = [image ht_appendImage:darkImage atRect:CGRectMake(0, 0, darkImage.size.width, darkImage.size.height)];
		UIImageView *imageView = [[UIImageView alloc] init];
		imageView.image = image;
		_headerCollectionView.backgroundView = imageView;
	}
	return _headerCollectionView;
}

@end
