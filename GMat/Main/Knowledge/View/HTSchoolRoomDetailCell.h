//
//  HTSchoolRoomDetailCell.h
//  GMat
//
//  Created by Charles Cao on 2017/11/20.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTSchoolRoomDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *content;
@property (weak, nonatomic) IBOutlet UILabel *pageLabel;
@property (nonatomic, strong) NSTextContainer *container;


@end
