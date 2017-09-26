//
//  HTRecognitionManager.m
//  GMat
//
//  Created by hublot on 2017/4/12.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTRecognitionManager.h"
#import "HTRecognitionProtocol.h"
#import "HTSiriRecognitionManager.h"
#import "HTIFlyRecogintionManager.h"

@interface HTRecognitionManager ()

@property (nonatomic, strong) id <HTRecognitionProtocol> recognitionManager;

@end

@implementation HTRecognitionManager

- (instancetype)initWithLocaleIdentifier:(NSString *)localeIdentifier recognitionReplyBlock:(void(^)(NSString *totalRecognitionString, BOOL isFinally))recognitionReplyBlock {
	if (self = [super init]) {
		#ifdef __IPHONE_10_0
			self.recognitionManager = [[HTSiriRecognitionManager alloc] initWithLocaleIdentifier:localeIdentifier recognitionReplyBlock:recognitionReplyBlock];
		#else
			self.recognitionManager = [[HTIFlyRecogintionManager alloc] initWithLocaleIdentifier:localeIdentifier recognitionReplyBlock:recognitionReplyBlock];
		#endif
	}
	return self;
}

- (void)startRecognition {
	if ([self.recognitionManager respondsToSelector:@selector(startRecognition)]) {
		[self.recognitionManager startRecognition];
	}
}

- (void)appendBufferFromAudioBuffer:(AVAudioPCMBuffer *)audioBuffer audioData:(NSData *)audioData audioWhen:(AVAudioTime *)audioWhen volumeDecibel:(CGFloat)volumeDecibel {
	if ([self.recognitionManager respondsToSelector:@selector(appendBufferFromAudioBuffer:audioData:audioWhen:volumeDecibel:)]) {
		[self.recognitionManager appendBufferFromAudioBuffer:audioBuffer audioData:audioData audioWhen:audioWhen volumeDecibel:volumeDecibel];
	}
}

- (void)stopRecognition {
	if ([self.recognitionManager respondsToSelector:@selector(stopRecognition)]) {
		[self.recognitionManager stopRecognition];
	}
}

@end
