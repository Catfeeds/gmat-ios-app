//
//  HTPlayerModel.h
//  GMat
//
//  Created by hublot on 2017/9/25.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTPlayerDocumentModel.h"
#import "HTPlayerSpeedModel.h"

@interface HTPlayerModel : NSObject

@property (nonatomic, copy, readonly) NSString *m3u8URLString;

@property (nonatomic, copy, readonly) NSArray <HTPlayerDocumentModel *> *documentModelArray;

- (instancetype)initWithXMLDictionary:(NSDictionary *)dictionary xmlURLString:(NSString *)xmlURLString;


// 他人观察同步 player 的当前时间值, 对这个时间值进行同步更新
// 不要在其他地方更改, 要 seek 请更改 dragEndTime, 更改 dragEndTime 会影响 player 的 seektime
// 同步此值后自己内部会主动去更改 isLoading 和 currentDocumentModel
@property (nonatomic, assign) CGFloat currentTime;

@property (nonatomic, assign) CGFloat dragingTime;

@property (nonatomic, assign) CGFloat dragEndTime;


// 他人观察同步 player 的当前速度, 对这个速度进行同步更新,
// 不要在其他地方更改, 要 更改 请更改 willSeakRate, 更改 willSeakRate 会影响 player 的 rate
// 同步此值后自己内部会主动去更改 isPlaying
@property (nonatomic, assign) CGFloat currentRate;

@property (nonatomic, assign) CGFloat willSeekRate;




@property (nonatomic, strong) HTPlayerDocumentModel *currentDocumentModel;

@property (nonatomic, assign) BOOL isPlaying;

@property (nonatomic, assign) BOOL isLoading;

@property (nonatomic, assign) CGFloat totalTime;


// option

@property (nonatomic, copy) NSString *titleName;

// 这个会影响 willSeekRate, 进而影响 player 的播放与暂停
- (void)reloadWillSeekRateWillPlay:(BOOL)willPlay;

@property (nonatomic, strong) NSArray <HTPlayerSpeedModel *> *speedModelArray;

@end
