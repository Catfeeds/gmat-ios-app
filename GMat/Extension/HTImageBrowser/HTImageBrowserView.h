//
//  HTImageBrowserView.h
//  HTImageBrowserView
//
//  Created by hublot on 17/1/7.
//  Copyright © 2017年 hublot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTImageBrowserModel : NSObject

// 每个 Model 对应的缩略图 View

@property (nonatomic, strong) UIImageView *thubnailImageView;

@property (nonatomic, strong) NSURL *browserModelImageURL;

@end

@interface HTImageBrowserView : UIView

+ (instancetype)presentModelArray:(NSArray <HTImageBrowserModel *> *)modelArray fromIndex:(NSInteger)fromIndex setImageAndProgressBlock:(void(^)(HTImageBrowserModel *model, NSInteger index, UIImageView *imageView, NSURL *browserModelImageURL, void(^progressBlock)(HTImageBrowserModel *model, CGFloat progress), void(^setImageBlock)(HTImageBrowserModel *model, NSData *imageData, UIImage *image)))imageAndProgressBlock longPressBlock:(void(^)(NSData *imageData, HTImageBrowserModel *model, NSInteger pressIndex))longPressBlock;

@end
