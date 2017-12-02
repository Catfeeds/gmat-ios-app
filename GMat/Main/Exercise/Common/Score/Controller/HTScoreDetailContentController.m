//
//  HTScoreDetailContentController.m
//  GMat
//
//  Created by hublot on 16/11/27.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTScoreDetailContentController.h"
#import "THExerciseExamListenAnswerNavigationButton.h"
#import "HTScoreDetailController.h"
#import "HTQuestionViewGroup.h"
#import "HTQuestionManager.h"
#import "HTMineFontSizeController.h"
#import "HTQuestionErrorController.h"

@interface HTScoreDetailContentController ()

@property (nonatomic, strong) HTQuestionViewGroup *questionViewGroup;

@end

@implementation HTScoreDetailContentController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initializeDataSource];
	[self initializeUserInterface];
}

- (void)initializeDataSource {
	
}

- (void)initializeUserInterface {
	self.navigationItem.title = @"雷哥GMAT-查看详情";
	self.magicView.layoutStyle = VTLayoutStyleCustom;
	self.magicView.itemWidth = 50;
	self.magicView.sliderHidden = true;
	self.magicView.navigationInset = UIEdgeInsetsMake(10, 0, 0, 0);
	self.magicView.navigationHeight = 54;
	[self.magicView reloadData];
	
	UIBarButtonItem *spaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	spaceBarButtonItem.width = HTADAPT568(10);
	self.navigationItem.rightBarButtonItems = @[self.questionViewGroup.moreBarButtonItem, spaceBarButtonItem, self.questionViewGroup.storeBarButtonItem];
}

- (NSArray<NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView {
	NSMutableArray *titleArray = [@[] mutableCopy];
	for (NSInteger index = 1; index <= self.questionModelArray.count; index ++) {
		[titleArray addObject:[NSString stringWithFormat:@"%ld", index]];
	}
	return titleArray;
}

- (UIButton *)magicView:(VTMagicView *)magicView menuItemAtIndex:(NSUInteger)itemIndex {
    static NSString *itemIdentifier = @"itemIdentifier";
	THExerciseExamListenAnswerNavigationButton *menuItem = [magicView dequeueReusableItemWithIdentifier:itemIdentifier];
	if (!menuItem) {
		menuItem = [THExerciseExamListenAnswerNavigationButton buttonWithType:UIButtonTypeCustom];
		menuItem.titleNameLabel.font = [UIFont systemFontOfSize:15];
	}
	[menuItem setModel:self.questionModelArray[itemIndex]];
	return menuItem;
}

- (void)magicView:(VTMagicView *)magicView viewDidAppear:(__kindof HTScoreDetailController *)viewController atPage:(NSUInteger)pageIndex {
    HTQuestionModel *questionModel = self.questionModelArray[pageIndex];
	viewController.headerQuestionView.showUserAnswerParse = self.questionViewGroup.questionParseSelected;
	
	viewController.headerQuestionView.showUserExerciseDuration = true;
	[viewController.headerQuestionView setModel:questionModel tableView:viewController.tableView];
	self.questionViewGroup.storeBarButton.selected = questionModel.storeQuestion;
	
    __weak HTScoreDetailContentController *weakSelf = self;
	[self.questionViewGroup.storeBarButton ht_whenTap:^(UIView *view) {
		if (questionModel) {
            [HTQuestionManager switchStoreStateWithQuestionId:questionModel.questionId];
            weakSelf.questionViewGroup.storeBarButton.selected = !weakSelf.questionViewGroup.storeBarButton.selected;
            questionModel.storeQuestion = !questionModel.storeQuestion;
        } else {
            [HTAlert title:@"没有题目可以收藏喔"];
        }
	}];
	
	[self.questionViewGroup setMoreItemDidSelected:^(HTQuestionMoreMenuModel *model) {
		switch (model.type) {
			case HTQuestionMoreItemTypeParse: {
				if (questionModel) {
					weakSelf.questionViewGroup.questionParseSelected = !weakSelf.questionViewGroup.questionParseSelected;
					viewController.headerQuestionView.showUserAnswerParse = weakSelf.questionViewGroup.questionParseSelected;
					viewController.headerQuestionView.showUserExerciseDuration = true;
					[viewController.headerQuestionView computeQuestionViewHeight];
				}
				if (weakSelf.questionViewGroup.questionParseSelected ) {
					CGPoint contentOffset = viewController.tableView.contentOffset;
					contentOffset.y = MIN(viewController.headerQuestionView.bottomRightAnswerLabel.ht_y - 10, viewController.tableView.contentSize.height - viewController.tableView.bounds.size.height);
					[viewController.tableView setContentOffset:contentOffset animated:true];
				}
				break;
			}
			case HTQuestionMoreItemTypeFont: {
				HTMineFontSizeController *fontController = [[HTMineFontSizeController alloc] init];
				[weakSelf.navigationController pushViewController:fontController animated:true];
				break;
			}
			case HTQuestionMoreItemTypeError: {
				HTQuestionErrorController *errorController = [[HTQuestionErrorController alloc] init];
				errorController.questionModel = questionModel;
				[weakSelf.navigationController pushViewController:errorController animated:true];
				break;
			}
		}
	}];
}

- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageInde {
	static NSString *controllerIdentifier = @"controllerIdentifier";
	HTScoreDetailController *viewController = [magicView dequeueReusablePageWithIdentifier:controllerIdentifier];
	if (!viewController) {
		viewController = [[HTScoreDetailController alloc] init];
	}
	return viewController;
}

- (HTQuestionViewGroup *)questionViewGroup {
	if (!_questionViewGroup) {
		_questionViewGroup = [[HTQuestionViewGroup alloc] init];
		_questionViewGroup.questionParseSelected = true;
		_questionViewGroup.isHiddenAnalysis = NO;
		
	}
	return _questionViewGroup;
}


@end
