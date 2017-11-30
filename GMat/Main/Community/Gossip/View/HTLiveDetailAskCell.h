//
//  HTLiveDetailAskCell.h
//  GMat
//
//  Created by Charles Cao on 2017/11/14.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTCommunityModel.h"

@interface HTLiveDetailAskCell : UITableViewCell

@property (nonatomic, strong) CommunityReply *ask;
@property (weak, nonatomic) IBOutlet UILabel *askLabelView;


@end
