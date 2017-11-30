//
//  HTCourseCellHeaderView.h
//  GMat
//
//  Created by hublot on 17/4/18.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTCourseCellHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) void(^headerRightDetailTapedBlock)(void);

@end
