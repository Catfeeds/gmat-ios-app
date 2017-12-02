//
//  HTPageModel.h
//  GMat
//
//  Created by hublot on 2017/4/28.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTPageModel : NSObject


@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, assign) BOOL noMoreDataSource;

@property (nonatomic, assign) CGPoint contentOffset;

@property (nonatomic, strong) NSMutableArray *modelArray;


@property (nonatomic, strong) NSString *selectedTitle;

@property (nonatomic, assign) Class reuseControllerClass;

@property (nonatomic, assign) NSInteger controllerIndex;

@property (nonatomic, strong) NSString *lastSelectedRowString;

@end
