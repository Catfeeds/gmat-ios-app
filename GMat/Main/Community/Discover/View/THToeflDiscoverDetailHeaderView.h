//
//  THToeflDiscoverDetailHeaderView.h
//  TingApp
//
//  Created by hublot on 16/9/7.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THToeflDiscoverDetailHeaderView : UIView

- (void)setModel:(id)model tableView:(UITableView *)tableView;

@property (nonatomic, copy) void(^callReplyKeyboard)(void);

@end
