//
//  HTRecordManager.m
//  GMat
//
//  Created by hublot on 2017/4/12.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTRecordManager.h"

@interface HTRecordManager ()

@property (nonatomic, strong) AVAudioEngine *audioEngine;

@end

static NSInteger kRecordManagerOutputBusNumber = 0;

@implementation HTRecordManager

- (void)startRecord {
	__weak HTRecordManager *weakSelf = self;
	[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryRecord error:nil];
	[[AVAudioSession sharedInstance] setMode:AVAudioSessionModeMeasurement error:nil];
	[[AVAudioSession sharedInstance] setActive:true withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
	
	
	AVAudioFormat *recordFormat = [self.audioEngine.inputNode outputFormatForBus:kRecordManagerOutputBusNumber];
	[self.audioEngine.inputNode installTapOnBus:kRecordManagerOutputBusNumber bufferSize:1024 format:recordFormat block:^(AVAudioPCMBuffer * _Nonnull buffer, AVAudioTime * _Nonnull when) {
		if (weakSelf.recordObserveBlock) {
			NSData *audioData = [self convertToNSDataFromAudioPCMBuffer:buffer];
			CGFloat volumeDecibel = [self calculateVolumeDecibelFromAudioData:audioData];
			weakSelf.recordObserveBlock(buffer, audioData, when, volumeDecibel);
		}
	}];
	[self.audioEngine prepare];
	[self.audioEngine startAndReturnError:nil];
}

- (NSData *)convertToNSDataFromAudioPCMBuffer:(AVAudioPCMBuffer *)audioBuffer {
	NSData *audioData = nil;
	const void *channels[1] = {audioBuffer.floatChannelData};
	audioData = [[NSData alloc] initWithBytes:channels[0] length:audioBuffer.frameCapacity * audioBuffer.format.streamDescription->mBytesPerFrame];
	return audioData;
}

- (CGFloat)calculateVolumeDecibelFromAudioData:(NSData *)audioData {
	if (!audioData) {
		return 0;
	}
	
	long long pcmAllLenght = 0;
	
	short butterByte[audioData.length / 2];
	memcpy(butterByte, audioData.bytes, audioData.length);
	
	for (int i = 0; i < audioData.length / 2; i ++) {
		pcmAllLenght += butterByte[i] * butterByte[i];
	}
	
	double mean = pcmAllLenght / (double)audioData.length;
	double volume = 10 * log10(mean);
	return volume;
}

- (void)stopRecord {
	[self.audioEngine stop];
	[self.audioEngine.inputNode removeTapOnBus:kRecordManagerOutputBusNumber];
}

- (AVAudioEngine *)audioEngine {
	if (!_audioEngine) {
		_audioEngine = [[AVAudioEngine alloc] init];
	}
	return _audioEngine;
}

@end
