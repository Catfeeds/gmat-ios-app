//
//  HTStoreCell.h
//  GMat
//
//  Created by hublot on 16/11/7.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTStoreModel.h"

@interface HTStoreCell : UITableViewCell

- (void)setModel:(HTStoreModel *)model row:(NSInteger)row;

@end
