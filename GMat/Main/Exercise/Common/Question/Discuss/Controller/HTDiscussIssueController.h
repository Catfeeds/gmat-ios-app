//
//  HTDiscussIssueController.h
//  GMat
//
//  Created by hublot on 17/8/24.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTDiscussIssueController : UIViewController

@property (nonatomic, strong) NSString *questionIdString;

@property (nonatomic, copy) void(^issueSuccessBlock)(void);

@end
