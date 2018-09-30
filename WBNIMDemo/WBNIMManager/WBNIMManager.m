//
//  WBNIMManager.m
//  WBNIMDemo
//
//  Created by Mr_Lucky on 2018/9/30.
//  Copyright © 2018 wenbo. All rights reserved.
//

#import "WBNIMManager.h"

@implementation WBNIMManager

+ (instancetype)shareManager {
    static WBNIMManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc]init];
    });
    return _instance;
}

// MARK:注册SDK
- (void)wb_registerNIMSDKWithConfiguration:(WBNIMConfiguration *)config {
    //配置额外配置信息 （需要在注册 appkey 前完成
    [NIMSDKConfig sharedConfig].shouldSyncUnreadCount = config.shouldSyncUnreadCount;
    [NIMSDKConfig sharedConfig].maxAutoLoginRetryTimes = config.maxAutoLoginRetryTimes ? 10 : config.maxAutoLoginRetryTimes;
    [NIMSDKConfig sharedConfig].enabledHttpsForInfo = config.enabledHttpsForInfo;
    [NIMSDKConfig sharedConfig].enabledHttpsForMessage = config.enabledHttpsForMessage;
    [NIMSDKConfig sharedConfig].fetchAttachmentAutomaticallyAfterReceiving = config.fetchAttachmentAutomaticallyAfterReceiving;
    
    NIMSDKOption *opiton = [[NIMSDKOption alloc]init];
    opiton.appKey = config.appKey;
    opiton.apnsCername = config.apnsCername;
    opiton.pkCername = config.pkCername;
    [[NIMSDK sharedSDK] registerWithOption:opiton];
}

// MARK:登录相关
- (void)wb_login:(NSString *)account
           token:(NSString *)token
      completion:(NIMLoginHandler)completion {
    if (!account || !token) {
        DDLogError(@"账号信息不能为空");
        return;
    }
    [[[NIMSDK sharedSDK] loginManager] login:account
                                       token:token
                                  completion:completion];
}

- (void)wb_autoLogin:(NIMAutoLoginData *)loginData {
    [[[NIMSDK sharedSDK] loginManager] autoLogin:loginData];
}

- (void)wb_autoLogin:(NSString *)account
               token:(NSString *)token {
    NIMAutoLoginData *loginData = [[NIMAutoLoginData alloc]init];
    loginData.account = account;
    loginData.token = token;
    [self wb_autoLogin:loginData];
}

- (void)wb_logout:(nullable NIMLoginHandler)completion {
    [[[NIMSDK sharedSDK] loginManager] logout:completion];
}

@end


@implementation WBNIMConfiguration


@end
