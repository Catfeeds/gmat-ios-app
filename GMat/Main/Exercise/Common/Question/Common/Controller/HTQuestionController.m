//
//  HTQuestionController.m
//  GMat
//
//  Created by hublot on 2016/11/9.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTQuestionController.h"
#import "HTLoginManager.h"
#import "THMinePreferenceController.h"
#import "HTQuestionMockSleepController.h"
#import "HTQuestionMockStartController.h"
#import "THDeveloperModelView.h"
#import "HTRootNavigationController.h"
#import "HTManagerController+HTRotate.h"
#import "NSTimer+HTBackground.h"
#import "HTMineFontSizeController.h"
#import "HTQuestionErrorController.h"

@interface HTQuestionController () <HTRotateEveryOne>

@property (nonatomic, strong) HTQuestionModel *questionModel;

@end

@implementation HTQuestionController

- (void)dealloc {
    self.questionViewGroup.tableView.tableHeaderView = nil;
	[self.questionViewGroup.timer invalidate];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initializeDataSource];
	[self initializeUserInterface];
}

- (void)initializeDataSource {
	self.questionViewGroup.enable = false;
	if (self.blockPackage.questionInitializeMockBlock) {
        __weak HTQuestionController *weakSelf = self;
		weakSelf.questionViewGroup.tableView.placeHolderState = HTPlaceholderStateFirstRefresh;
		void(^initializeMockStatus)(HTError *errorModel) = ^(HTError *errorModel) {
			if (errorModel.existError) {
				weakSelf.questionViewGroup.tableView.placeHolderState = (HTPlaceholderState)errorModel.errorType;
			} else {
				weakSelf.questionViewGroup.tableView.placeHolderState = HTPlaceholderStateNone;
				[weakSelf requestQuestionDetailModel];
			}
		};
		void(^permissionFailBlock)(void) = ^ {
			[weakSelf.rt_navigationController popViewControllerAnimated:false];
		};
		[weakSelf.questionViewGroup.tableView setReloadNetworkBlock:^{
			weakSelf.blockPackage.questionInitializeMockBlock(initializeMockStatus, permissionFailBlock);
		}];
		weakSelf.blockPackage.questionInitializeMockBlock(initializeMockStatus, permissionFailBlock);
	} else {
		[self requestQuestionDetailModel];
	}
}

- (void)requestQuestionDetailModel {
    __weak HTQuestionController *weakSelf = self;
	void(^permissionFailBlock)(void) = ^ {
		[weakSelf.navigationController popViewControllerAnimated:false];
	};
	void(^requestQuestionModelStatus)(HTQuestionModel *questionModel, id originResponse);
	requestQuestionModelStatus = ^(HTQuestionModel *questionModel, id originResponse) {
        if (!weakSelf || !questionModel) {
            return;
        }
		self.questionViewGroup.enable = true;
		weakSelf.questionModel = questionModel;
		weakSelf.navigationItem.title = weakSelf.blockPackage.questionNavigationItemTitle(weakSelf.questionModel);
		weakSelf.questionViewGroup.storeBarButton.selected = weakSelf.questionModel.storeQuestion;
		weakSelf.questionViewGroup.questionParseSelected = weakSelf.blockPackage.defaultDisplayParse;
		weakSelf.questionViewGroup.questionView.showUserExerciseDuration = false;
		weakSelf.questionViewGroup.questionView.showUserAnswerParse = weakSelf.questionViewGroup.questionParseSelected;
		[weakSelf.questionViewGroup.questionView setModel:weakSelf.questionModel tableView:weakSelf.questionViewGroup.tableView];

        if (weakSelf.blockPackage.questionInitializeMockBlock) {
            if ([originResponse isKindOfClass:[NSDictionary class]]) {
				weakSelf.questionViewGroup.lastTime = [[originResponse valueForKey:@"showtime"] integerValue];
            }
			weakSelf.questionModel.questionDuration = 0;
            [weakSelf.questionViewGroup.timer invalidate];
            weakSelf.questionViewGroup.timer = [NSTimer ht_scheduledTimerWithTimeInterval:1 block:^(NSTimer *timer) {
                weakSelf.questionViewGroup.lastTime --;
                if (weakSelf.questionViewGroup.lastTime >= 0) {
                    [weakSelf.questionViewGroup.timeBarButton setTitle:[NSString stringWithFormat:@"%.2ld:%.2ld:%.2ld", weakSelf.questionViewGroup.lastTime / 3600, (weakSelf.questionViewGroup.lastTime % 3600) / 60, weakSelf.questionViewGroup.lastTime % 60] forState:UIControlStateNormal];
					weakSelf.questionModel.questionDuration ++;
                } else {
                    weakSelf.blockPackage.requestQuestionModelBlock(requestQuestionModelStatus, permissionFailBlock);
                    [weakSelf.questionViewGroup.timer invalidate];
                }
            } repeats:true];
            [[NSRunLoop mainRunLoop] addTimer:weakSelf.questionViewGroup.timer forMode:NSRunLoopCommonModes];
            [weakSelf.questionViewGroup.timer fire];

        } else {
            weakSelf.questionModel.questionDuration = 0;
            [weakSelf.questionViewGroup.timer invalidate];
            weakSelf.questionViewGroup.timer = [NSTimer ht_scheduledTimerWithTimeInterval:1 block:^(NSTimer *timer) {
				[weakSelf.questionViewGroup.timeBarButton setTitle:[NSString stringWithFormat:@"%.2ld:%.2ld:%.2ld", weakSelf.questionModel.questionDuration / 3600, (weakSelf.questionModel.questionDuration % 3600) / 60, weakSelf.questionModel.questionDuration % 60] forState:UIControlStateNormal];
                weakSelf.questionModel.questionDuration ++;
            } repeats:true];
            [[NSRunLoop mainRunLoop] addTimer:weakSelf.questionViewGroup.timer forMode:NSRunLoopCommonModes];
            [weakSelf.questionViewGroup.timer fire];
        }
		
//		void(^autoExerciseRobot)(void) = ^() {
//			CGFloat autoExerciseTime = 1000;
//			autoExerciseTime = 0.5;
//			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(autoExerciseTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//				UITableView *answerSelectedTabelView = [weakSelf.questionViewGroup.questionView valueForKey:@"answerSelectedTableView"];
//				if (answerSelectedTabelView && weakSelf.blockPackage.questionSubmitBlock) {
//					NSInteger answerSelectedCount = answerSelectedTabelView.visibleCells.count;
//					NSInteger randomSelectedRow = arc4random_uniform((CGFloat)answerSelectedCount);
//					NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:randomSelectedRow inSection:0];
//					[answerSelectedTabelView.delegate tableView:answerSelectedTabelView didSelectRowAtIndexPath:selectedIndexPath];
//					[answerSelectedTabelView selectRowAtIndexPath:selectedIndexPath animated:false scrollPosition:UITableViewScrollPositionNone];
//					[weakSelf.questionViewGroup.bottomSureButton tap];
//				}
//			});
//		};
		
		#ifdef DEBUG
//			autoExerciseRobot();
		#else
//			if ([THDeveloperModelView isDeveloperModel]) {
//				autoExerciseRobot();
//			}
		#endif
		
	};
	self.blockPackage.requestQuestionModelBlock(requestQuestionModelStatus, permissionFailBlock);
}

- (void)initializeUserInterface {
	self.navigationController.hidesBarsOnSwipe = true;

    [self.view addSubview:self.questionViewGroup.tableView];
    [self.view addSubview:self.questionViewGroup.bottomSureButton];
    [self.questionViewGroup.bottomSureButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(self.blockPackage.questionSubmitBlock ? 49 : 0);
    }];
    self.questionViewGroup.bottomSureButton.hidden = self.blockPackage.questionSubmitBlock ? false : true;
    
    [self.questionViewGroup.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.questionViewGroup.bottomSureButton.mas_top);
    }];
	[self.view addSubview:self.questionViewGroup.statusEffectBar];
    [self.questionViewGroup.statusEffectBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.view);
        make.height.mas_equalTo(20);
    }];
	
    __weak HTQuestionController *weakSelf = self;
	[self.questionViewGroup.bottomSureButton ht_whenTap:^(UIView *view) {
		if (weakSelf.blockPackage.questionSubmitBlock) {
			void(^submitStatusBlock)(NSString *errorString) = ^(NSString *errorString) {
				if (!errorString.length) {
					[weakSelf requestQuestionDetailModel];
				} else {
					[HTAlert title:errorString];
				}
			};
			weakSelf.blockPackage.questionSubmitBlock(weakSelf.questionModel, [NSString stringWithFormat:@"%ld", weakSelf.questionModel.questionDuration], weakSelf.questionViewGroup.questionView.userSelectedAnswer, submitStatusBlock);
		}
	}];
	[self.questionViewGroup.storeBarButton ht_whenTap:^(UIView *view) {
		if (weakSelf.blockPackage.questionStoreButtonDidTapedBlock) {
			weakSelf.blockPackage.questionStoreButtonDidTapedBlock(weakSelf.questionModel);
			weakSelf.questionModel.storeQuestion = !weakSelf.questionModel.storeQuestion;
			weakSelf.questionViewGroup.storeBarButton.selected = !weakSelf.questionViewGroup.storeBarButton.selected;
		}
	}];
	[self.questionViewGroup setMoreItemDidSelected:^(HTQuestionMoreMenuModel *model) {
		switch (model.type) {
			case HTQuestionMoreItemTypeParse: {
				weakSelf.questionViewGroup.questionParseSelected = !weakSelf.questionViewGroup.questionParseSelected;
				weakSelf.questionViewGroup.questionView.showUserExerciseDuration = false;
				weakSelf.questionViewGroup.questionView.showUserAnswerParse = weakSelf.questionViewGroup.questionParseSelected;
				[weakSelf.questionViewGroup.questionView computeQuestionViewHeight];
				if (weakSelf.questionViewGroup.questionParseSelected) {
					CGPoint contentOffset = weakSelf.questionViewGroup.tableView.contentOffset;
					contentOffset.y = MIN(weakSelf.questionViewGroup.questionView.bottomRightAnswerLabel.ht_y - 80, weakSelf.questionViewGroup.tableView.contentSize.height - weakSelf.questionViewGroup.tableView.bounds.size.height);
					[weakSelf.questionViewGroup.tableView setContentOffset:contentOffset animated:true];
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
				errorController.questionModel = weakSelf.questionModel;
				[weakSelf.navigationController pushViewController:errorController animated:true];
				break;
			}
		}
	}];
    NSArray *rightBarButtonItemArray = self.blockPackage.questionNavigationItemArray(self.questionViewGroup.timeBarButtonItem, self.questionViewGroup.storeBarButtonItem, self.questionViewGroup.moreBarButtonItem);
	NSMutableArray *rightBarButtomAppendSpaceArray = [@[] mutableCopy];
	[rightBarButtonItemArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger index, BOOL * _Nonnull stop) {
		if (index == 0) {
			UIBarButtonItem *spaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
			spaceBarButtonItem.width = HTADAPT568(10);
			[rightBarButtomAppendSpaceArray addObject:spaceBarButtonItem];
		}
		[rightBarButtomAppendSpaceArray addObject:obj];
	}];
	self.questionViewGroup.closeBarButtonItem.target = self;
	self.questionViewGroup.closeBarButtonItem.action = @selector(closeQuestionController);
	self.navigationItem.leftBarButtonItem = self.questionViewGroup.closeBarButtonItem;
	self.navigationItem.rightBarButtonItems = rightBarButtomAppendSpaceArray;
}

- (void)closeQuestionController {
	[self.navigationController popViewControllerAnimated:true];
	[self.navigationController dismissViewControllerAnimated:true completion:nil];
}

- (UIBarButtonItem *)customBackItemWithTarget:(id)target action:(SEL)action {
	return nil;
}

- (HTQuestionViewGroup *)questionViewGroup {
	if (!_questionViewGroup) {
		_questionViewGroup = [[HTQuestionViewGroup alloc] init];
	}
	return _questionViewGroup;
}


@end
