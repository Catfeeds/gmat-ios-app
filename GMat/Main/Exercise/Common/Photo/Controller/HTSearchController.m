//
//  HTSearchController.m
//  GMat
//
//  Created by hublot on 2017/3/31.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTSearchController.h"

@interface HTSearchController ()

@end

@implementation HTSearchController

- (BOOL)willDealloc {
	return false;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initializeDataSource];
	[self initializeUserInterface];
}

- (void)initializeDataSource {
	
}

- (void)initializeUserInterface {
	self.searchBar.tintColor = [UIColor orangeColor];
}


@end
