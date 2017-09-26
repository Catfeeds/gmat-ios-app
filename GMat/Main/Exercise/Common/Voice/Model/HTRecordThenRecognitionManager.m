//
//  HTRecordThenRecognitionManager.m
//  GMat
//
//  Created by hublot on 2017/4/12.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTRecordThenRecognitionManager.h"
#import "HTRecordManager.h"
#import "HTRecognitionManager.h"

@interface HTRecordThenRecognitionManager ()

@property (nonatomic, strong) HTRecordManager *recordManager;

@property (nonatomic, strong) HTRecognitionManager *recognitionManager;

@end

@implementation HTRecordThenRecognitionManager

- (void)setIsRecordAndRecognition:(BOOL)isRecordAndRecognition {
	_isRecordAndRecognition = isRecordAndRecognition;
	if (isRecordAndRecognition) {
		[self.recordManager startRecord];
		[self.recognitionManager startRecognition];
	} else {
		[self.recognitionManager stopRecognition];
        [self.recordManager stopRecord];
	}
}

- (HTRecordManager *)recordManager {
	if (!_recordManager) {
		_recordManager = [[HTRecordManager alloc] init];
		
		__weak HTRecordThenRecognitionManager *weakSelf = self;
		[_recordManager setRecordObserveBlock:^(AVAudioPCMBuffer *audioBuffer, NSData *audioData, AVAudioTime *audioWhen, CGFloat volumeDecibel) {
			[weakSelf.recognitionManager appendBufferFromAudioBuffer:audioBuffer audioData:audioData audioWhen:audioWhen volumeDecibel:volumeDecibel];
		}];
	}
	return _recordManager;
}

- (HTRecognitionManager *)recognitionManager {
	if (!_recognitionManager) {
		
		__weak HTRecordThenRecognitionManager *weakSelf = self;
		_recognitionManager = [[HTRecognitionManager alloc] initWithLocaleIdentifier:@"en" recognitionReplyBlock:^(NSString *totalRecognitionString, BOOL isFinally) {
			if (isFinally) {
				weakSelf.isRecordAndRecognition = false;
			}
			if (weakSelf.recognitionReplyBlock) {
				weakSelf.recognitionReplyBlock(totalRecognitionString, isFinally);
			}
		}];
	}
	return _recognitionManager;
}

@end
