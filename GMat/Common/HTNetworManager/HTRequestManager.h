//
//  HTRequestManager.h
//  GMat
//
//  Created by hublot on 2017/5/3.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTNetworkManager.h"
#import "HTRequestDomain.h"

#import "THBroadCastModel.h"

#import "HTCommunityLayoutModel.h"

#import "HTCourseOnlineVideoModel.h"

#import "HTLoginTextFieldGroupView.h"

#import "HTMockExerciseSectionController.h"

#import "HTPayLessonController.h"

#import "THToeflDiscoverController.h"

#import "HTQuestionErrorModel.h"


#define HTPlaceholderString(string, placeholder) string && [NSString stringWithFormat:@"%@", string].length ? [NSString stringWithFormat:@"%@", string] : [NSString stringWithFormat:@"%@", placeholder]

@interface HTRequestManager : NSObject


/**
 获取广告

 */
+ (void)requestBroadcastComplete:(HTUserTaskCompleteBlock)complete;


/**
 获取活动

 */
+ (void)requestActivityComplete:(HTUserTaskCompleteBlock)complete;



/**
 检查题库更新

 @param localSqliteLastUpdateTime 本地题库上次更新的时间
 */
+ (void)requestSqliteUpdateWithNetworkModel:(HTNetworkModel *)networkModel localSqliteLastUpdateTime:(NSString *)localSqliteLastUpdateTime complete:(HTUserTaskCompleteBlock)complete;


/**
 下载题库更新

 @param downloadSqliteUrl 下载的 url
 */
+ (void)requestSqliteUpdateFileDownloadWithNetworkModel:(HTNetworkModel *)networkModel downloadSqliteUrl:(NSString *)downloadSqliteUrl complete:(HTUserTaskCompleteBlock)complete;


/**
 获取备考八卦列表

 @param pageSize 每页返回个数
 @param currentPage 当前页
 */
+ (void)requestGossipListWithNetworkModel:(HTNetworkModel *)networkModel pageSize:(NSString *)pageSize currentPage:(NSString *)currentPage complete:(HTUserTaskCompleteBlock)complete;


/**
 获取某一个八卦的详情

 @param gossipIdString 要获取的八卦的 id
 */
+ (void)requestGossipDetailWithNetworkModel:(HTNetworkModel *)networkModel gossipIdString:(NSString *)gossipIdString complete:(HTUserTaskCompleteBlock)complete;


/**
 回复帖子

 @param replyContent 要回复的内容
 @param communityLayoutModel 打包的八卦的模型
 */
+ (void)requestGossipReplyGossipOwnerWithNetworkModel:(HTNetworkModel *)networkModel replyContent:(NSString *)replyContent communityLayoutModel:(HTCommunityLayoutModel *)communityLayoutModel complete:(HTUserTaskCompleteBlock)complete;


/**
 回复楼层

 @param replyContent 要回复的内容
 @param communityLayoutModel 打包的八卦的模型
 @param beingReplyModel 打包的要回复的楼层的模型
 */
+ (void)requestGossipReplyGossipLoopReplyWithNetworkModel:(HTNetworkModel *)networkModel replyContent:(NSString *)replyContent communityLayoutModel:(HTCommunityLayoutModel *)communityLayoutModel beingReplyModel:(HTCommunityReplyLayoutModel *)beingReplyModel complete:(HTUserTaskCompleteBlock)complete;


/**
 八卦点赞或取消点赞

 @param gossipIdString 要点赞或要取消点赞的八卦 id
 */
+ (void)requestGossipGoodGossipWithNetworkModel:(HTNetworkModel *)networkModel gossipIdString:(NSString *)gossipIdString complete:(HTUserTaskCompleteBlock)complete;


/**
 上传图片到服务器, 图片用来发表备考八卦, 图片数据放在 networkModel

 */
+ (void)requestGossipUploadGossipImageWithNetworkModel:(HTNetworkModel *)networkModel complete:(HTUserTaskCompleteBlock)complete;

/**
 发表一个新的备考八卦

 @param gossipTitleString 发表标题
 @param gossipDetailString 发表内容
 @param imageSourceArray 发表的图片地址数组
 */
+ (void)requestGossipSendGossipWithNetworkModel:(HTNetworkModel *)networkModel gossipTitleString:(NSString *)gossipTitleString gossipDetailString:(NSString *)gossipDetailString imageSourceArray:(NSArray <NSString *> *)imageSourceArray complete:(HTUserTaskCompleteBlock)complete;


/**
 获取自己的备考八卦的未读消息

 */
+ (void)requestGossipMessageWithNetworkModel:(HTNetworkModel *)networkModel complete:(HTUserTaskCompleteBlock)complete;


/**
 获取备考详情

 @param attentionId 要获取的注意点 id
 */
+ (void)requestDiscoverGmatExamAttentionWithNetworkModel:(HTNetworkModel *)networkModel attentionId:(NSString *)attentionId complete:(HTUserTaskCompleteBlock)complete;


/**
 获取备考资讯列表

 @param pageSize 每页返回个数
 @param currentPage 当前页
 */
+ (void)requestDiscoverInformationWithNetworkModel:(HTNetworkModel *)networkModel pageSize:(NSString *)pageSize currentPage:(NSString *)currentPage complete:(HTUserTaskCompleteBlock)complete;


/**
 获取备考详情
 @param 资讯详情

 */
+ (void)requestDiscoverInformationDetailWithNetworkModel:(HTNetworkModel *)networkModel informationId:(NSString *)informationId complete:(HTUserTaskCompleteBlock)complete;

/**
 获取发现的列表
 
 @param discoverType 发现的类型
 @param pageSize 每页返回个数
 @param currentPage 当前页
 */
+ (void)requestDiscoverListWithNetworkModel:(HTNetworkModel *)networkModel discoverType:(HTDiscoverType)discoverType pageSize:(NSString *)pageSize currentPage:(NSString *)currentPage complete:(HTUserTaskCompleteBlock)complete;


/**
 获取发现的单个 item 的详情
 
 @param discoverId 要获取详情的 item 的 id
 */
+ (void)requestDiscoverItemDetailWithNetworkModel:(HTNetworkModel *)networkModel discoverId:(NSString *)discoverId complete:(HTUserTaskCompleteBlock)complete;


/**
 发表一个新的发现
 
 @param titleString 发表的标题
 @param contentString 发表的详情
 */
+ (void)requestDiscoverIssueWithNetworkModel:(HTNetworkModel *)networkModel titleString:(NSString *)titleString contentString:(NSString *)contentString complete:(HTUserTaskCompleteBlock)complete;


/**
 回复一个发现的 item
 
 @param discoverId 要回复的 item 的 id
 @param contentString 要回复的内容
 */
+ (void)requestDiscoverReplyWithNetworkModel:(HTNetworkModel *)networkModel discoverId:(NSString *)discoverId contentString:(NSString *)contentString complete:(HTUserTaskCompleteBlock)complete;



/**
 获取热门课程和 banner

 */
+ (void)requestHotCourseAndBannerWithNetworkModel:(HTNetworkModel *)networkModel complete:(HTUserTaskCompleteBlock)complete;


/**
 获取公开课

 */
+ (void)requestOpenCourseWithNetworkModel:(HTNetworkModel *)networkModel complete:(HTUserTaskCompleteBlock)complete;


/**
 获取约课的老师列表

 */
+ (void)requestTeacherListWithNetworkModel:(HTNetworkModel *)networkModel complete:(HTUserTaskCompleteBlock)complete;

/**
 获取直播课

 */
+ (void)requestLiveCourseWithNetworkModel:(HTNetworkModel *)networkModel complete:(HTUserTaskCompleteBlock)complete;


/**
 获取视频课

 */
+ (void)requestVideoCourseWithNetworkModel:(HTNetworkModel *)networkModel complete:(HTUserTaskCompleteBlock)complete;


/**
 为课程下订单

 @param orderCourseModel 要下订单的课程的模型
 */
+ (void)requestCoursePayOrderWithNetworkModel:(HTNetworkModel *)networkModel orderCourseModel:(HTCourseOnlineVideoModel *)orderCourseModel complete:(HTUserTaskCompleteBlock)complete;


/**
 重置密码

 @param phoneOrEmailString 电话或者邮箱
 @param resetPassword 重新设置的密码
 @param messageCode 验证码
 */
+ (void)requestResetPasswordWithNetworkModel:(HTNetworkModel *)networkModel phoneOrEmailString:(NSString *)phoneOrEmailString resetPassword:(NSString *)resetPassword messageCode:(NSString *)messageCode complete:(HTUserTaskCompleteBlock)complete;


/**
 获取小讲堂列表

 */
+ (void)requestKnowledgeListWithNetworkModel:(HTNetworkModel *)networkModel complete:(HTUserTaskCompleteBlock)complete;


/**
 获取小讲堂内单个知识点详情

 @param knowledgeContentId 知识点的 id
 */
+ (void)requestKnowledgeDetailWithNetworkModel:(HTNetworkModel *)networkModel knowledgeContentId:(NSString *)knowledgeContentId complete:(HTUserTaskCompleteBlock)complete;


/**
 注册, 重置密码, 修改用户信息时发送验证码

 @param phoneOrEmailString 电话或者邮箱
 @param requestMessageCodeStyle 获取验证码用来做什么
 */
+ (void)requestRegisterOrForgetPasswordOrUpdataUserMessageCodeWithNetworkModel:(HTNetworkModel *)networkModel phoneOrEmailString:(NSString *)phoneOrEmailString requestMessageCodeStyle:(HTLoginTextFieldGroupType)requestMessageCodeStyle complete:(HTUserTaskCompleteBlock)complete;


/**
 获取中国区 appStore 最高版本

 */
+ (void)requestAppStoreMaxVersionWithNetworkModel:(HTNetworkModel *)networkModel complete:(HTUserTaskCompleteBlock)complete;


/**
 打开 appStore
 */
+ (void)requestOpenAppStore;


/**
 获取自己的消息列表

 @param pageSize 每页返回个数
 @param currentPage 当前页
 */
+ (void)requestMineMessageWithNetworkModel:(HTNetworkModel *)networkModel pageSize:(NSString *)pageSize currentPage:(NSString *)currentPage complete:(HTUserTaskCompleteBlock)complete;


/**
 获取模考列表

 @param mockStyle 模考的样式, 语文, 数学, 全套
 @param typeClass 模考的类型 prep | gwd | 精选题库
 */
+ (void)requestMockListWithNetworkModel:(HTNetworkModel *)networkModel mockStyle:(HTMockStyle)mockStyle typeClass:(HTTypeClass)typeClass complete:(HTUserTaskCompleteBlock)complete;


/**
 获取模考的记录

 @param mockStyle 模考的样式, 语文, 数学, 全套
 @param pageSize 每页返回个数
 @param currentPage 当前页
 */
+ (void)requestMockRecordWithNetworkModel:(HTNetworkModel *)networkModel mockStyle:(HTMockStyle)mockStyle pageSize:(NSString *)pageSize currentPage:(NSString *)currentPage complete:(HTUserTaskCompleteBlock)complete;


/**
 获取购课的记录

 @param courseRecordStyle 课程的样式, 公开课, 收费课
 @param pageSize 每页返回个数
 @param currentPage 当前页
 */
+ (void)requestCourseRecordWithNetworkModel:(HTNetworkModel *)networkModel courseRecordStyle:(HTCourseRecordStyle)courseRecordStyle pageSize:(NSString *)pageSize currentPage:(NSString *)currentPage complete:(HTUserTaskCompleteBlock)complete;

/**
 通知后台即将进入模考的 id

 */
+ (void)requestMockWillSendMockIdWithNetworkModel:(HTNetworkModel *)networkModel mockIdString:(NSString *)mockIdString complete:(HTUserTaskCompleteBlock)complete;

/**
 刷新前台即将进入模考的界面同时拿到 sign
 
 */
+ (void)requestMockStartMessageWithNetworkModel:(HTNetworkModel *)networkModel complete:(HTUserTaskCompleteBlock)complete;


/**
 获取模考的单个题目

 @param signString 模考是语文还是数学还是全套的 sign, 从模考提示返回里取到
 */
+ (void)requestMockQuestionWithNetworkModel:(HTNetworkModel *)networkModel signString:(NSString *)signString complete:(HTUserTaskCompleteBlock)complete;


/**
 提交模考答案

 @param questionIdString 问题 id
 @param answerString 答案
 @param duration 间隔
 */
+ (void)requestMockSaveAnswerWithNetworkModel:(HTNetworkModel *)networkModel questionIdString:(NSString *)questionIdString answerString:(NSString *)answerString durationString:(NSString *)durationString complete:(HTUserTaskCompleteBlock)complete;


/**
 模考中场休息

 */
+ (void)requestMockSleepBeginWithNetworkModel:(HTNetworkModel *)networkModel complete:(HTUserTaskCompleteBlock)complete;


/**
 
 模考休息完毕
 */
+ (void)requestMockSleepEndWithNetworkModel:(HTNetworkModel *)networkModel complete:(HTUserTaskCompleteBlock)complete;

/**
 获取模考的结果

 @param mockIdString 模考的 id
 @param mockScoreIdString 模考的结果 id
 */
+ (void)requestMockScoreWithNetworkModel:(HTNetworkModel *)networkModel mockIdString:(NSString *)mockIdString mockScoreIdString:(NSString *)mockScoreIdString complete:(HTUserTaskCompleteBlock)complete;

/**
 重置模考

 @param mockIdString mock 的 id
 */
+ (void)requestMockReloadRecordWithNetworkModel:(HTNetworkModel *)networkModel mockIdString:(NSString *)mockIdString complete:(HTUserTaskCompleteBlock)complete;


/**
 同步做题记录先上传本地的

 */
+ (void)requestOfflineRecordUploadWithNetworkModel:(HTNetworkModel *)networkModel complete:(HTUserTaskCompleteBlock)complete;


/**
 同步做题记录再下载服务器的

 @param downloadUrlString 上传时服务器给出的下载服务器的记录的地址
 */
+ (void)requestOfflineRecordDownloadWithNetworkModel:(HTNetworkModel *)networkModel downloadUrlString:(NSString *)downloadUrlString complete:(HTUserTaskCompleteBlock)complete;


/**
 注册

 @param phoneOrEmailString 电话或邮箱
 @param registerPassword 注册密码
 @param messageCode 注册的验证码
 @param usernameString 注册的用户名
 */
+ (void)requestRegisterWithNetworkModel:(HTNetworkModel *)networkModel phoneOrEmailString:(NSString *)phoneOrEmailString registerPassword:(NSString *)registerPassword messageCode:(NSString *)messageCode usernameString:(NSString *)usernameString complete:(HTUserTaskCompleteBlock)complete;


/**
 获取学习报告

 */
+ (void)requestStudyReportWithNetworkModel:(HTNetworkModel *)networkModel complete:(HTUserTaskCompleteBlock)complete;


/**
 预约老师 / 课程

 @param teacherIdString 老师的 id
 @param usernameString  预约的用户的名字
 @param phoneNumberString 预约的用户的电话
 @param courseTitleString 预约的课程名字
 */
+ (void)requestInvideTeacherWithNetworkModel:(HTNetworkModel *)networkModel teacherIdString:(NSString *)teacherIdString usernameString:(NSString *)usernameString phoneNumberString:(NSString *)phoneNumberString courseTitleString:(NSString *)courseTitleString complete:(HTUserTaskCompleteBlock)complete;


/**
 正常登陆

 @param usernameString 用户名, 电话, 邮箱
 @param passwordString 密码
 */
+ (void)requestNormalLoginWithNetworkModel:(HTNetworkModel *)networkModel usernameString:(NSString *)usernameString passwordString:(NSString *)passwordString complete:(HTUserTaskCompleteBlock)complete;


/**
 三方登录

 @param openIdString 三方授权拿到的 openid
 @param nicknameString 三方授权拿到的昵称
 @param thirdIconSource 三方授权拿到的头像
 */
+ (void)requestThirdLoginWithNetworkModel:(HTNetworkModel *)networkModel openIdString:(NSString *)openIdString nicknameString:(NSString *)nicknameString thirdIconSource:(NSString *)thirdIconSource complete:(HTUserTaskCompleteBlock)complete;


/**
 登录后要进行重置 session

 @param requestParameterDictionary 包含用户名和密码的字典
 @param responseParameterDictionary 包含 uid, 用户名, 密码, 邮箱, 电话的字典
 */
+ (void)requestResetLoginSessionWithNetworkModel:(HTNetworkModel *)networkModel requestParameterDictionary:(NSDictionary *)requestParameterDictionary responseParameterDictionary:(NSDictionary *)responseParameterDictionary complete:(HTUserTaskCompleteBlock)complete;


/**
 获取用户详细信息

 */
+ (void)requestUserModelWithNetworkModel:(HTNetworkModel *)networkModel complete:(HTUserTaskCompleteBlock)complete;


/**
 获取用户做题记录的最后一题

 */
+ (void)requestLastExerciseIdWithNetworkModel:(HTNetworkModel *)networkModel complete:(HTUserTaskCompleteBlock)complete;


/**
 修改用户头像

 */
+ (void)requestUploadUserHeadImageWithNetworkModel:(HTNetworkModel *)networkModel complete:(HTUserTaskCompleteBlock)complete;


/**
 修改用户昵称

 @param changeNickname 新昵称
 */
+ (void)requestUpdateUserNicknameWithNetworkModel:(HTNetworkModel *)networkModel changeNickname:(NSString *)changeNickname complete:(HTUserTaskCompleteBlock)complete;


/**
 修改用户电话

 @param changePhone 新电话
 */
+ (void)requestUpdateUserPhoneWithNetworkModel:(HTNetworkModel *)networkModel changePhone:(NSString *)changePhone messageCode:(NSString *)messageCode complete:(HTUserTaskCompleteBlock)complete;


/**
 修改用户邮箱

 @param changeEmail 新邮箱
 */
+ (void)requestUpdateUserEmailWithNetworkModel:(HTNetworkModel *)networkModel changeEmail:(NSString *)changeEmail messageCode:(NSString *)messageCode complete:(HTUserTaskCompleteBlock)complete;


/**
 修改用户密码

 @param originPassword 原密码
 @param changePassword 新密码
 */
+ (void)requestUpdateUserPasswordWithNetworkModel:(HTNetworkModel *)networkModel originPassword:(NSString *)originPassword changePassword:(NSString *)changePassword complete:(HTUserTaskCompleteBlock)complete;


/**
 用户反馈, 会同时传到 bmob

 @param suggestionMessage 用户建议
 @param userContactWay 联系方式
 */
+ (void)requestSendApplicationIssueWithNetworkModel:(HTNetworkModel *)networkModel suggestionMessage:(NSString *)suggestionMessage userContactWay:(NSString *)userContactWay complete:(HTUserTaskCompleteBlock)complete;


/**
 获取语文题目总数和数学做题总数

 */
+ (void)requestExerciseQuestionCountWithNetworkModel:(HTNetworkModel *)networkModel complete:(HTUserTaskCompleteBlock)complete;


/**
 上报题目错误

 @param questionIdString 问题的 id
 @param errorSelectedModel 错误的类型
 @param errorContentString 错误的详细说明
 */
+ (void)requestQuestionErrorReportWithNetworkModel:(HTNetworkModel *)networkModel questionIdString:(NSString *)questionIdString errorSelectedModel:(HTQuestionErrorModel *)errorSelectedModel errorContentString:(NSString *)errorContentString complete:(HTUserTaskCompleteBlock)complete;

/**
 获取题目讨论列表

 @param questionIdString 问题的 id
 @param pageSize 每页返回个数
 @param currentPage 当前页
 */
+ (void)requestQuestionDiscussListWithNetworkModel:(HTNetworkModel *)networkModel questionIdString:(NSString *)questionIdString pageSize:(NSString *)pageSize currentPage:(NSString *)currentPage complete:(HTUserTaskCompleteBlock)complete;


/**
 回复

 @param questionIdString 问题的 id
 @param discussContent 如果要回复的目标是另一个回复 B, 也可以称为楼中楼, 传 B 的 id, 如果不是楼中楼, 传 nil 0 都可以
 */
+ (void)requestQuestionDiscussCreateWithNetworkModel:(HTNetworkModel *)networkModel questionIdString:(NSString *)questionIdString discussContentString:(NSString *)discussContentString willReplyIdString:(NSString *)willReplyIdString complete:(HTUserTaskCompleteBlock)complete;



/**
 获取备考故事列表

 @param pageSize 每页返回个数
 @param currentPage 当前页
 */
+ (void)requestStoryListWithNetworkModel:(HTNetworkModel *)networkModel pageSize:(NSString *)pageSize currentPage:(NSString *)currentPage complete:(HTUserTaskCompleteBlock)complete;


/**
 获取备考故事详情

 @param storyIdString 备考故事详情
 */
+ (void)requestStoryDetailWithNetworkModel:(HTNetworkModel *)networkModel storyIdString:(NSString *)storyIdString complete:(HTUserTaskCompleteBlock)complete;




/**
 获取试听课列表

 */
+ (void)requestTryListenCourseListWithNetworkModel:(HTNetworkModel *)networkModel complete:(HTUserTaskCompleteBlock)complete;

/**
 获取入门列表

 */
+ (void)requestBeginCourseListWithNetworkModel:(HTNetworkModel *)networkModel complete:(HTUserTaskCompleteBlock)complete;


@end
