//
//  HTRecognitionProtocol.h
//  GMat
//
//  Created by hublot on 2017/4/12.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol HTRecognitionProtocol <NSObject>

@required

- (instancetype)initWithLocaleIdentifier:(NSString *)localeIdentifier recognitionReplyBlock:(void(^)(NSString *totalRecognitionString, BOOL isFinally))recognitionReplyBlock;

- (void)startRecognition;

- (void)appendBufferFromAudioBuffer:(AVAudioPCMBuffer *)audioBuffer audioData:(NSData *)audioData audioWhen:(AVAudioTime *)audioWhen volumeDecibel:(CGFloat)volumeDecibel;

- (void)stopRecognition;

@end
