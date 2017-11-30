//
//  HTIFlyRecogintionManager.m
//  GMat
//
//  Created by hublot on 2017/4/12.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTIFlyRecogintionManager.h"
#import <iflyMSC/iflyMSC.h>

@interface HTIFlyRecogintionManager () <IFlySpeechRecognizerDelegate>

@property (nonatomic, strong) NSMutableString *totalRecognitionString;

@property (nonatomic, strong) void(^recognitionReplyBlock)(NSString *totalRecognitionString, BOOL isFinally);

@property (nonatomic, strong) IFlySpeechRecognizer *speechRecognizer;

@end

@implementation HTIFlyRecogintionManager

- (instancetype)initWithLocaleIdentifier:(NSString *)localeIdentifier recognitionReplyBlock:(void (^)(NSString *totalRecognitionString, BOOL isFinally))recognitionReplyBlock {
	if (self = [super init]) {
        self.recognitionReplyBlock = recognitionReplyBlock;
	}
	return self;
}

- (void)startRecognition {
    self.totalRecognitionString = [@"" mutableCopy];
    [self.speechRecognizer startListening];
}

- (void)appendBufferFromAudioBuffer:(AVAudioPCMBuffer *)audioBuffer audioData:(NSData *)audioData audioWhen:(AVAudioTime *)audioWhen volumeDecibel:(CGFloat)volumeDecibel {
    [self.speechRecognizer writeAudio:audioData];
}

- (void)stopRecognition {
    if (self.speechRecognizer.isListening) {
        [self.speechRecognizer stopListening];
    }
    self.totalRecognitionString = [@"" mutableCopy];
}


- (void)onError:(IFlySpeechError *)errorCode {
    [self stopRecognition];
}

- (void)onVolumeChanged:(int)volume {
    
}

- (void)onResults:(NSArray *)results isLast:(BOOL)isLast {
    NSMutableString *resultString = [[NSMutableString alloc] init];
    NSDictionary *dictionary = results.firstObject;
    for (NSString *key in dictionary) {
        [resultString appendFormat:@"%@", key];
    }
    [self.totalRecognitionString appendString:resultString];
    
    if (self.recognitionReplyBlock) {
        self.recognitionReplyBlock(self.totalRecognitionString, isLast);
    }
    
}

- (IFlySpeechRecognizer *)speechRecognizer {
    if (!_speechRecognizer) {
        _speechRecognizer = [IFlySpeechRecognizer sharedInstance];
        
        [_speechRecognizer setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
        
        //设置听写模式
        [_speechRecognizer setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
        _speechRecognizer.delegate = self;
        
        //设置最长录音时间
        [_speechRecognizer setParameter:@"30000" forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
        //设置后端点
        [_speechRecognizer setParameter:@"3000" forKey:[IFlySpeechConstant VAD_EOS]];
        //设置前端点
        [_speechRecognizer setParameter:@"3000" forKey:[IFlySpeechConstant VAD_BOS]];
        //网络等待时间
        [_speechRecognizer setParameter:@"20000" forKey:[IFlySpeechConstant NET_TIMEOUT]];
        
        //设置采样率，推荐使用16K
        [_speechRecognizer setParameter:@"16000" forKey:[IFlySpeechConstant SAMPLE_RATE]];
        
        [_speechRecognizer setParameter:@"en_us" forKey:[IFlySpeechConstant LANGUAGE]];
        
        //设置是否返回标点符号
        [_speechRecognizer setParameter:@"0" forKey:[IFlySpeechConstant ASR_PTT]];
        
        [_speechRecognizer setParameter:@"plain" forKey:[IFlySpeechConstant RESULT_TYPE]];
        
    }
    return _speechRecognizer;
}

@end
