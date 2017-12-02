//
//  HTComplaintModel.h
//  GMat
//
//  Created by Charles Cao on 2017/11/8.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTSignLive : NSObject

@property (nonatomic, assign) NSInteger createTime;
@property (nonatomic, assign) NSInteger endTime;
@property (nonatomic, copy) NSString *image;    //正在直播图片地址
@property (nonatomic, assign) NSInteger startTime;
@property (nonatomic, copy) NSString *title;    //标题
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, copy) NSString *psvImage;   // 直播宣传图片地址
@property (nonatomic, copy) NSString *backImage;  //回放图片地址


@end

//吐槽界面中直播 json
@interface HTComplaintModel : NSObject

@property (nonatomic, assign) NSInteger needNum;  // 需要雷豆数量
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger integral;  //雷豆数量
@property (nonatomic, assign) NSInteger isPay;     //是否已经支付过
@property (nonatomic, strong) NSString *QQ;  //宣传 QQ;
//0-没图片, 1-点击图片进入QQ ,2-正在直播 点击进入直播列表, 3-直播回放 点击进入直播列表
@property (nonatomic, assign) NSInteger live;
@property (nonatomic, assign) NSInteger num;   //消息条数
@property (nonatomic, strong) HTSignLive *signLive;

@end









