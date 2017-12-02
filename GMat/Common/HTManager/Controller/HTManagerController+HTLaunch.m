//
//  HTManagerController+HTLaunch.m
//  GMat
//
//  Created by hublot on 2017/7/14.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTManagerController+HTLaunch.h"
#import "HTLoginManager.h"
#import "THFirstIntroduceController.h"
#import "THBroadCastController.h"
#import "HTUpdateVersionView.h"
#import "HTGuideView.h"

@implementation HTManagerController (HTLaunch)

- (void)launchChildController {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    NSString *infoPlistVersionString = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *firstLaunchFlag = @"First";
    NSString *firstLaunchValue = HTPlaceholderString([userDefault stringForKey:firstLaunchFlag], @"");
    if (!firstLaunchValue.length) {
		[HTLoginManager exitLoginWithComplete:nil];
        THFirstIntroduceController *firstIntroduceController = [[THFirstIntroduceController alloc] init];
		[self addChildViewController:firstIntroduceController];
		[firstIntroduceController setLoadViewBlock:^(UIView *view){
			[self.view addSubview:view];
		}];
		
		firstIntroduceController.view = firstIntroduceController.view;
        [firstIntroduceController didMoveToParentViewController:self];
        [userDefault setObject:infoPlistVersionString forKey:firstLaunchFlag];
		self.managerModel.isDownloadFirstLaunch = true;
		
		[self loadGuideVivew];
		
    } else {
        THBroadCastController *bootAdvertController = [[THBroadCastController alloc] init];
		[self addChildViewController:bootAdvertController];
		[bootAdvertController setLoadViewBlock:^(UIView *view) {
			[self.view addSubview:view];
		}];
		bootAdvertController.view = bootAdvertController.view;
		[bootAdvertController didMoveToParentViewController:self];
    }
        
    HTNetworkModel *networkModel = [[HTNetworkModel alloc] init];
    networkModel.autoAlertString = nil;
    networkModel.offlineCacheStyle = HTCacheStyleAllUser;
    networkModel.autoShowError = false;
    [HTRequestManager requestAppStoreMaxVersionWithNetworkModel:networkModel complete:^(id response, HTError *errorModel) {
        if (errorModel.existError) {
            return;
        }
        self.managerModel.updateModel = [HTUpdateModel mj_objectWithKeyValues:response];
        if (self.managerModel.updateModel.resultCount == 1 && self.managerModel.updateModel.results.count == 1) {
            UpdateResults *results = self.managerModel.updateModel.results.firstObject;
            NSComparisonResult comparisonResult = [infoPlistVersionString compare:results.version options:NSNumericSearch];
            if (comparisonResult == NSOrderedAscending) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self showUpdateVersionView];
                });
            }
            if (comparisonResult == NSOrderedDescending) {
                self.managerModel.isAppStoreOnReviewingVersion = true;
            }
        }
    }];
    [HTLoginManager autoLoginWithComplete:nil];
}

- (void)loadGuideVivew{
	
	HTGuideView *guideView = (HTGuideView *)[[[NSBundle mainBundle] loadNibNamed:@"Guide" owner:nil options:nil] firstObject];
	guideView.frame = self.view.bounds;
	[self.view addSubview:guideView];
}

- (void)showUpdateVersionView {
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"每一次都带给你实质性的体验升级"
                                                                           attributes:@{NSForegroundColorAttributeName:[UIColor ht_colorStyle:HTColorStylePrimaryTitle],
                                                                                        NSFontAttributeName:[UIFont systemFontOfSize:16],
                                                                                        NSParagraphStyleAttributeName:paragraphStyle}];
    [HTUpdateVersionView showWithSureBlock:^{
        [HTRequestManager requestOpenAppStore];
    } attributedString:attributedString animate:true superView:self.drawerController.view];
}
@end
