//
//  WBNIMManager.h
//  WBNIMDemo
//
//  Created by Mr_Lucky on 2018/9/30.
//  Copyright © 2018 wenbo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NIMSDK/NIMSDK.h>

@class WBNIMConfiguration;
@class WBNIMAutoLoginData;

NS_ASSUME_NONNULL_BEGIN

@interface WBNIMManager : NSObject


/**
 单例管理类

 @return WBNIMManager.
 */
+ (instancetype)shareManager;

@property (nonatomic, strong, nullable) WBNIMAutoLoginData *currentLoginData;


- (void)addLoginNoti;

// MARK:注册SDK
/**
 注册网易云信SDK

 @param config 相关配置
 */
- (void)wb_registerNIMSDKWithConfiguration:(WBNIMConfiguration *)config;

// MARK:登录相关
/**
 *  登录
 *
 *  @param account    帐号
 *  @param token      令牌 (在后台绑定的登录token)
 *  @param completion 完成回调
 */
- (void)wb_login:(NSString *)account
           token:(NSString *)token
      completion:(NIMLoginHandler)completion;

/**
 自动登录

 @param account 账户
 @param token n密码
 */
- (void)wb_autoLogin:(NSString *)account
               token:(NSString *)token;

/**
 *  登出
 *
 *  @param completion 完成回调
 *  @discussion 用户在登出是需要调用这个接口进行 SDK 相关数据的清理,回调 Block 中的 error 只是指明和服务器的交互流程中可能出现的错误,但不影响后续的流程。
 *              如用户登出时发生网络错误导致服务器没有收到登出请求，客户端仍可以登出(切换界面，清理数据等)，但会出现推送信息仍旧会发到当前手机的问题。
 */
- (void)wb_logout:(nullable NIMLoginHandler)completion;

@end

@interface WBNIMConfiguration : NSObject

/**
 网易注册AppKey
 */
@property (nonatomic, copy) NSString *appKey;
@property (nonatomic, copy, nullable) NSString *apnsCername;
@property (nonatomic, copy, nullable) NSString *pkCername;
/**
 *  是否需要多端同步未读数
 *  @discusssion 默认为 NO。设置成 YES 的情况下，同个账号多端（PC 和 移动端等）将同步未读计数。
 */
@property (nonatomic, assign) BOOL shouldSyncUnreadCount;
/**
 *  针对用户信息开启 https 支持
 *  @discusssion 默认为 YES。在默认情况下，我们认为用户头像，群头像，聊天室类用户头像等信息都是默认托管在云信上，所以 SDK 会针对他们自动开启 https 支持。
 *                          但如果你需要将这些信息都托管在自己的服务器上，需要设置这个接口为 NO，避免 SDK 自动将你的 http url 自动转换为 https url。
 */
@property (nonatomic, assign) BOOL enabledHttpsForInfo;

/**
 *  针对消息内容开启 https 支持
 *  @discusssion 默认为 YES。在默认情况下，我们认为消息，包括图片，视频，音频信息都是默认托管在云信上，所以 SDK 会针对他们自动开启 https 支持。
 *                         但如果你需要将这些信息都托管在自己的服务器上，需要设置这个接口为 NO，避免 SDK 自动将你的 http url 自动转换为 https url。 (强烈不建议)
 *                         需要注意的是即时设置了这个属性，通过 iOS SDK 发出去的消息 URL 仍是 https 的，设置这个值只影响接收到的消息 URL 格式转换
 */
@property (nonatomic, assign) BOOL enabledHttpsForMessage;

/**
 *  自动登录重试次数
 *  @discusssion 默认为 0。即默认情况下，自动登录将无限重试。设置成大于 0 的值后，在没有登录成功前，自动登录将重试最多 maxAutoLoginRetryTimes 次，如果失败，则抛出错误 (NIMLocalErrorCodeAutoLoginRetryLimit)。
 */
@property (nonatomic, assign) NSInteger maxAutoLoginRetryTimes;

/**
 *  是否在收到消息后自动下载附件 (群和个人)
 *  @discussion 默认为YES,SDK会在第一次收到消息是直接下载消息附件,上层开发可以根据自己的需要进行设置
 */

@property (nonatomic, assign) BOOL fetchAttachmentAutomaticallyAfterReceiving;

@end

@interface WBNIMAutoLoginData : NSObject <NSCoding>

@property (nonatomic,copy)  NSString *account;
@property (nonatomic,copy)  NSString *token;

@end

NS_ASSUME_NONNULL_END
