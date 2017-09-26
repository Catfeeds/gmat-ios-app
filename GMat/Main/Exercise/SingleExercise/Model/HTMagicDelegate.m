//
//  HTMagicDelegate.m
//  GMat
//
//  Created by hublot on 2016/10/31.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTMagicDelegate.h"

@interface HTMagicDelegate ()

@property (nonatomic, copy) UIButton *(^menuItemBlock)(VTMagicView *magicView, NSUInteger itemIndex);

@property (nonatomic, copy) void(^didSelectedBlock)(VTMagicView *magicView, NSUInteger itemIndex);

@end

@implementation HTMagicDelegate

- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex {
	return nil;
}

- (instancetype)initWithTitleArray:(NSArray *)titleArray menuItemBlock:(UIButton *(^)(VTMagicView *magicView, NSUInteger itemIndex))menuItemBlock  didSelectedBlock:(void(^)(VTMagicView *magicView, NSUInteger itemIndex))didSelectedBlock {
	if (self = [super init]) {
		self.titleArray = titleArray;
		self.menuItemBlock = menuItemBlock;
		self.didSelectedBlock = didSelectedBlock;
	}
	return self;
}

- (NSArray<__kindof NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView {
	return self.titleArray;
}

- (UIButton *)magicView:(VTMagicView *)magicView menuItemAtIndex:(NSUInteger)itemIndex {
	return self.menuItemBlock(magicView, itemIndex);
}

- (void)magicView:(VTMagicView *)magicView didSelectItemAtIndex:(NSUInteger)itemIndex {
	self.selectedIndex = itemIndex;
	return self.didSelectedBlock(magicView, itemIndex);
}


@end
