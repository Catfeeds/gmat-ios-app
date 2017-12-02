//
//  HTTakePhotoManager.h
//  photographDemo
//
//  Created by hublot on 2017/3/17.
//  Copyright © 2017年 Renford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface HTTakePhotoManager : NSObject

@property (nonatomic, strong, readonly) AVCaptureVideoPreviewLayer *previewLayer;

@property (nonatomic, assign) AVCaptureDevicePosition devicePosition;

@property (nonatomic, assign, getter=flashLightIsOpening) BOOL openFlashLight;

- (void)reload;

- (void)cutCameraImageDataComplete:(void(^)(NSData *imageData))complete;

@end
