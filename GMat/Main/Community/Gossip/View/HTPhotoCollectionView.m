//
//  HTPhotoCollectionView.m
//  GMat
//
//  Created by hublot on 2016/11/21.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTPhotoCollectionView.h"
#import "UICollectionView+HTSeparate.h"
#import "HTPhotoCollectionCell.h"
#import "TZImagePickerController.h"
#import "HTManagerController.h"
#import "TZImageManager.h"

@interface HTPhotoCollectionView ()

@property (nonatomic, strong) NSMutableArray *imageAssetArray;

@property (nonatomic, assign) BOOL isSelectedOriginalPhoto;

@end

@implementation HTPhotoCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
	if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
		self.alwaysBounceHorizontal = true;
		self.showsHorizontalScrollIndicator = false;
		self.isSelectedOriginalPhoto = true;
        __weak HTPhotoCollectionView *weakSelf = self;
        [self ht_updateSection:0 sectionMakerBlock:^(HTCollectionViewSectionMaker *sectionMaker) {
            [[sectionMaker.cellClass([HTPhotoCollectionCell class])
			  .modelArray(@[[UIImage imageNamed:@"Community8"]])
			  .itemSize(CGSizeMake(HTADAPT568(70), HTADAPT568(70)))
			  .sectionInset(UIEdgeInsetsMake(HTADAPT568(5), HTADAPT568(5), HTADAPT568(5), HTADAPT568(5)))
			  .itemVerticalSpacing(HTADAPT568(5))
			  .itemHorizontalSpacing(HTADAPT568(5)) didSelectedCellBlock:^(UICollectionView *collectionView, NSInteger item, __kindof UICollectionViewCell *cell, __kindof NSObject *model) {
                TZImagePickerController *imagePickerController;
                if (item == weakSelf.imageAssetArray.count) {
                    imagePickerController = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:nil];
                    imagePickerController.selectedAssets = weakSelf.imageAssetArray;
                    imagePickerController.isSelectOriginalPhoto = weakSelf.isSelectedOriginalPhoto;
                } else {
                    imagePickerController = [[TZImagePickerController alloc] initWithSelectedAssets:weakSelf.imageAssetArray selectedPhotos:weakSelf.imageModelArray index:item];
                    imagePickerController.isSelectOriginalPhoto = weakSelf.isSelectedOriginalPhoto;
                }
                imagePickerController.allowPickingVideo = false;
                [imagePickerController setDidFinishPickingPhotosHandle:^(NSArray <UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                    weakSelf.imageModelArray = nil;
                    weakSelf.imageModelArray = [photos mutableCopy];
                    NSMutableArray *displayModelArray = [weakSelf.imageModelArray mutableCopy];
                    [displayModelArray addObject:[UIImage imageNamed:@"Community8"]];
                    weakSelf.imageAssetArray = [assets mutableCopy];
                    weakSelf.isSelectedOriginalPhoto = isSelectOriginalPhoto;
                    [weakSelf ht_updateSection:0 sectionMakerBlock:^(HTCollectionViewSectionMaker *sectionMaker) {
                        sectionMaker.modelArray(displayModelArray);
                    }];
                }];
                [[HTManagerController defaultManagerController] presentViewController:imagePickerController animated:YES completion:nil];
            }] customCellBlock:^(UICollectionView *collectionView, NSInteger item, __kindof HTPhotoCollectionCell *cell, __kindof NSObject *model) {
                cell.deleteButton.hidden = item == weakSelf.imageModelArray.count;
                [cell.deleteButton ht_whenTap:^(UIView *view) {
                    [weakSelf.imageModelArray removeObjectAtIndex:item];
                    [weakSelf.imageAssetArray removeObjectAtIndex:item];
                    NSMutableArray *displayModelArray = [weakSelf.imageModelArray mutableCopy];
                    [displayModelArray addObject:[UIImage imageNamed:@"Community8"]];
                    [weakSelf ht_updateSection:0 sectionMakerBlock:^(HTCollectionViewSectionMaker *sectionMaker) {
                        sectionMaker.modelArray(displayModelArray);
                    }];
                }];
            }];
        }];
	}
	return self;
}

- (NSMutableArray<UIImage *> *)imageModelArray {
	if (!_imageModelArray) {
		_imageModelArray = [@[] mutableCopy];
	}
	return _imageModelArray;
}

@end
