//
//  HTReportExcelCollectionCell.h
//  GMat
//
//  Created by hublot on 16/11/30.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CollectionExcelType) {
	collectionExcelTypeThreeColFourRow,
	collectionExcelTypeFiveColFourRow
};

@interface HTReportExcelCollectionCell : UITableViewCell

@property (nonatomic, assign) CollectionExcelType collectionExcelType;

@end
