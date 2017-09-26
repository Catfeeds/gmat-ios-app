//
//  HTSiriRecognitionManager.m
//  GMat
//
//  Created by hublot on 2017/4/12.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTSiriRecognitionManager.h"
#import <Speech/Speech.h>

@interface HTSiriRecognitionManager ()

@property (nonatomic, strong) void(^recognitionReplyBlock)(NSString *totalRecognitionString, BOOL isFinally);

@property (nonatomic, strong) SFSpeechRecognizer *speechRecognizer;

@property (nonatomic, strong) SFSpeechAudioBufferRecognitionRequest *recognitionRequest;

@property (nonatomic, strong) SFSpeechRecognitionTask *recognitionTask;

@property (nonatomic, strong) NSTimer *shouldFinallyTimer;

@end

@implementation HTSiriRecognitionManager

- (instancetype)initWithLocaleIdentifier:(NSString *)localeIdentifier recognitionReplyBlock:(void (^)(NSString *totalRecognitionString, BOOL isFinally))recognitionReplyBlock {
	if (self = [super init]) {
		self.recognitionReplyBlock = recognitionReplyBlock;
		NSLocale *locale = [NSLocale localeWithLocaleIdentifier:localeIdentifier];
		self.speechRecognizer = [[SFSpeechRecognizer alloc] initWithLocale:locale];
	}
	return self;
}

- (void)startRecognition {
	__weak HTSiriRecognitionManager *weakSelf = self;
	[self reloadFinallyTimer];
    self.recognitionTask = [self.speechRecognizer recognitionTaskWithRequest:self.recognitionRequest resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
		BOOL recognizerShouldStop = false;
		NSString *recognitionString = @"";
		if (error) {
			recognizerShouldStop = true;
		} else {
			if (result) {
				recognizerShouldStop = result.final;
				recognitionString = result.bestTranscription.formattedString;
			}
		}
		if (weakSelf.recognitionReplyBlock) {
			weakSelf.recognitionReplyBlock(recognitionString, recognizerShouldStop);
		}
        if (!recognizerShouldStop) {
			[weakSelf reloadFinallyTimer];
        }
	}];
}

- (void)appendBufferFromAudioBuffer:(AVAudioPCMBuffer *)audioBuffer audioData:(NSData *)audioData audioWhen:(AVAudioTime *)audioWhen volumeDecibel:(CGFloat)volumeDecibel {
	[self.recognitionRequest appendAudioPCMBuffer:audioBuffer];
}

- (void)stopRecognition {
    [self.shouldFinallyTimer invalidate];
	[self.recognitionRequest endAudio];
	self.recognitionRequest = nil;
	self.recognitionTask = nil;
}

- (void)reloadFinallyTimer {
	__weak HTSiriRecognitionManager *weakSelf = self;
	[weakSelf.shouldFinallyTimer invalidate];
	weakSelf.shouldFinallyTimer = [NSTimer bk_scheduledTimerWithTimeInterval:2 block:^(NSTimer *timer) {
		[weakSelf.recognitionTask finish];
	} repeats:false];
	[[NSRunLoop currentRunLoop] addTimer:weakSelf.shouldFinallyTimer forMode:NSRunLoopCommonModes];
}

- (SFSpeechAudioBufferRecognitionRequest *)recognitionRequest {
	if (!_recognitionRequest) {
		_recognitionRequest = [[SFSpeechAudioBufferRecognitionRequest alloc] init];
	}
	return _recognitionRequest;
}

@end
