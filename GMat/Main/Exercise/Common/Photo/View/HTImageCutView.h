//
//  HTImageCutView.h
//  GMat
//
//  Created by hublot on 2017/3/20.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTImageCutView : UIImageView

@property (nonatomic, strong) UIButton *sureButton;

@property (nonatomic, strong) UIButton *exitButton;

- (void)setInputImage:(UIImage *)inputImage outPutImageBlock:(void(^)(UIImage *outPutImage))outPutImageBlock;

@end
