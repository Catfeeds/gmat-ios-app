//
//  HTIssueManager.m
//  GMat
//
//  Created by hublot on 2017/10/12.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTIssueManager.h"
#import "THDeveloperModelView.h"
#import "HTUserIssueController.h"
#import "HTDeveloperIssueController.h"

@implementation HTIssueManager

+ (void)pushIssueControllerFromNavigationController:(UINavigationController *)navigationController {
	BOOL showDeveloper = false;
	#ifdef DEBUG
		showDeveloper = true;
	#else
		if ([THDeveloperModelView isDeveloperModel]) {
			showDeveloper = true;
		}
	#endif
	UIViewController *viewController;
	if (showDeveloper) {
		viewController = [[HTDeveloperIssueController alloc] init];
	} else {
		viewController = [[HTUserIssueController alloc] init];
	}
	[navigationController pushViewController:viewController animated:true];
}

@end
