//
//  HTRecordManager.h
//  GMat
//
//  Created by hublot on 2017/4/12.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface HTRecordManager : NSObject

- (void)startRecord;

@property (nonatomic, strong) void(^recordObserveBlock)(AVAudioPCMBuffer *audioBuffer, NSData *audioData, AVAudioTime *audioWhen, CGFloat volumeDecibel);

- (void)stopRecord;

@end
