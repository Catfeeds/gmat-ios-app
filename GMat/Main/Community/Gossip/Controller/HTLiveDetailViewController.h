//
//  HTLiveDetailViewController.h
//  GMat
//
//  Created by Charles Cao on 2017/11/14.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import <UIKit/UIKit.h>

 @interface HTLiveDetailViewController : UIViewController

@property (nonatomic, strong) NSString *liveID;
@property (weak, nonatomic) IBOutlet UITableView *detailTableView;

@end
