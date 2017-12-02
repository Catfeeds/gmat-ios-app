//
//  HTSchoolRoomDetailController.h
//  GMat
//
//  Created by Charles Cao on 2017/11/20.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTKnowledgeModel.h"

@interface HTSchoolRoomDetailController : UIViewController

@property (nonatomic, strong) KnowledgeCategorycontent *detailModel;
@property (weak, nonatomic) IBOutlet UITableView *detailTable;

@end
