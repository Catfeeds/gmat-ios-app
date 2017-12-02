//
//  HTExerciseSearchView.m
//  GMat
//
//  Created by hublot on 2017/5/17.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTExerciseSearchView.h"
#import "HTExerciseSearchModel.h"
#import <UIButton+HTButtonCategory.h>
#import "HTPhotoSearchController.h"
#import "HTVoiceRecordController.h"
#import "HTSearchController.h"
#import "HTSearchListController.h"

@interface HTExerciseSearchView ()

@property (nonatomic, strong) UIView *buttonContentView;

@property (nonatomic, strong) NSMutableArray *buttonCornerArray;

@end

@implementation HTExerciseSearchView

- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
	UIBezierPath *bezierPath = [UIBezierPath bezierPath];
	__block CGFloat startPoint = 0;
	CGFloat lineHeight = 1 / [UIScreen mainScreen].scale;
	[self.buttonCornerArray enumerateObjectsUsingBlock:^(UIView *cornerView, NSUInteger index, BOOL * _Nonnull stop) {
		CGRect cornerFrame = [cornerView convertRect:cornerView.bounds toView:self];
		CGFloat pointY = cornerFrame.origin.y + cornerFrame.size.height / 2 - lineHeight / 2;
		[bezierPath moveToPoint:CGPointMake(startPoint, pointY)];
		[bezierPath addLineToPoint:CGPointMake(cornerFrame.origin.x, pointY)];
		startPoint = cornerFrame.origin.x + cornerFrame.size.width;
		if (index == self.buttonCornerArray.count - 1) {
			[bezierPath moveToPoint:CGPointMake(startPoint, pointY)];
			[bezierPath addLineToPoint:CGPointMake(self.buttonContentView.bounds.size.width, pointY)];
		}
	}];
	[[UIColor whiteColor] setStroke];
	[bezierPath setLineWidth:lineHeight];
	[bezierPath stroke];
}

- (void)didMoveToSuperview {
	self.backgroundColor = [UIColor clearColor];
	self.translatesAutoresizingMaskIntoConstraints = false;
	[self addSubview:self.buttonContentView];
	[self.buttonContentView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.mas_equalTo(UIEdgeInsetsMake(10, 0, 0, 0));
	}];
	NSArray *modelArray = [HTExerciseSearchModel packModelArray];
	NSMutableArray *buttonArray = [@[] mutableCopy];
	self.buttonCornerArray = [@[] mutableCopy];
	[modelArray enumerateObjectsUsingBlock:^(HTExerciseSearchModel *model, NSUInteger index, BOOL * _Nonnull stop) {
		UIButton *button = [[UIButton alloc] init];
		[self.buttonContentView addSubview:button];
		[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		button.titleLabel.font = [UIFont systemFontOfSize:15];
		[button setTitle:model.titleName forState:UIControlStateNormal];
		
		UIImage *image = [UIImage imageNamed:model.imageName];
		CGFloat maxImageHeight = 20;
		CGFloat maxImageWidth = 20;
		CGFloat imageHeightZoomNumber = maxImageHeight / image.size.height;
		CGFloat imageWidthZoomNumber = maxImageWidth / image.size.width;
		CGFloat imageZoomNumber = MIN(imageHeightZoomNumber, imageWidthZoomNumber);
		
		image = [image ht_resetSizeZoomNumber:imageZoomNumber];
		[button setImage:image forState:UIControlStateNormal];
		
		UIView *buttonCornerView = [[UIView alloc] init];
		[self.buttonCornerArray addObject:buttonCornerView];
		[self.buttonContentView addSubview:buttonCornerView];
		CGFloat corner = 40;
		[buttonCornerView mas_updateConstraints:^(MASConstraintMaker *make) {
			make.center.mas_equalTo(button.imageView);
			make.width.height.mas_equalTo(corner);
		}];
		buttonCornerView.layer.cornerRadius = corner / 2;
		buttonCornerView.layer.masksToBounds = true;
		buttonCornerView.layer.borderWidth = 1;
		buttonCornerView.layer.borderColor = [UIColor whiteColor].CGColor;
		
		[button ht_makeEdgeWithDirection:HTButtonEdgeDirectionVertical imageViewToTitleLabelSpeceOffset:20];
		[buttonArray addObject:button];
		
		buttonCornerView.userInteractionEnabled = false;
		[button ht_whenTap:^(UIView *view) {
			switch (model.searchType) {
				case HTExerciseSearchModelTypeTakePhoto: {
					HTPhotoSearchController *photoSearchController = [[HTPhotoSearchController alloc] init];
					[self.ht_controller.navigationController pushViewController:photoSearchController animated:true];
				}
				break;
				case HTExerciseSearchModelTypeVoice: {
					HTVoiceRecordController *voiceRecordController = [[HTVoiceRecordController alloc] init];
					[self.ht_controller.navigationController pushViewController:voiceRecordController animated:true];
				}
				break;
				case HTExerciseSearchModelTypeSearch: {
					HTSearchListController *searchListController = [[HTSearchListController alloc] init];
					HTSearchController *searchController = [[HTSearchController alloc] initWithSearchResultsController:searchListController];
					searchController.searchResultsUpdater = searchListController;
					[self.ht_controller presentViewController:searchController animated:true completion:nil];
				}
				break;
			}
		}];
	}];
	[self.buttonContentView ht_addStackDistanceWithSubViews:buttonArray foreSpaceDistance:HTADAPT568(30) backSpaceDistance:HTADAPT568(30) stackDistanceDirection:HTStackDistanceDirectionHorizontal];
}

- (void)setModel:(id)model row:(NSInteger)row {
	
}

- (UIView *)buttonContentView {
	if (!_buttonContentView) {
		_buttonContentView = [[UIView alloc] init];
	}
	return _buttonContentView;
}

@end
