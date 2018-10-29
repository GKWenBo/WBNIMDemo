//
//  WBNIMManager.m
//  WBNIMDemo
//
//  Created by Mr_Lucky on 2018/9/30.
//  Copyright © 2018 wenbo. All rights reserved.
//

#import "WBNIMManager.h"

@interface WBNIMManager () <NIMLoginManagerDelegate>

@property (nonatomic,copy)  NSString *filepath;

@end

@implementation WBNIMManager

- (void)dealloc {
    
}

+ (instancetype)shareManager {
    static WBNIMManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"nim_sdk_ntes_login_data"];
        _instance = [[self alloc]initWithPath:filePath];
    });
    return _instance;
}

- (instancetype)initWithPath:(NSString *)filePath
{
    self = [super init];
    if (self) {
        _filepath = filePath;
        [self readData];
    }
    return self;
}

- (void)addLoginNoti {
    [[NIMSDK sharedSDK].loginManager addDelegate:self];
}

//从文件中读取和保存用户名密码,建议上层开发对这个地方做加密,DEMO只为了做示范,所以没加密
- (void)readData
{
    NSString *filepath = [self filepath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filepath])
    {
        id object = [NSKeyedUnarchiver unarchiveObjectWithFile:filepath];
        _currentLoginData = [object isKindOfClass:[WBNIMAutoLoginData class]] ? object : nil;
    }
}

- (void)setCurrentLoginData:(WBNIMAutoLoginData *)currentLoginData
{
    _currentLoginData = currentLoginData;
    [self saveData];
}

- (void)saveData
{
    NSData *data = [NSData data];
    if (_currentLoginData)
    {
        data = [NSKeyedArchiver archivedDataWithRootObject:_currentLoginData];
        [data writeToFile:[self filepath] atomically:YES];
    }else {
        [[NSFileManager defaultManager] removeItemAtPath:[self filepath]
                                                   error:nil];
    }
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
    
    [[NIMSDK sharedSDK].loginManager login:account
                                     token:token
                                completion:^(NSError * _Nullable error) {
                                    if (!error) {
                                        /*  < 保存登录数据 > */
                                        WBNIMAutoLoginData *loginData = [WBNIMAutoLoginData new];
                                        loginData.account = account;
                                        loginData.token = token;
                                        self.currentLoginData = loginData;
                                    }
                                    
                                    if (completion) {
                                        completion(error);
                                    }
                                }];
}

- (void)wb_autoLogin:(NSString *)account
               token:(NSString *)token {
    NIMAutoLoginData *loginData = [[NIMAutoLoginData alloc]init];
    loginData.account = account;
    loginData.token = token;
    [[NIMSDK sharedSDK].loginManager autoLogin:loginData];
}

- (void)wb_logout:(nullable NIMLoginHandler)completion {
    [[[NIMSDK sharedSDK] loginManager] logout:completion];
    self.currentLoginData = nil;
}

// MARK:NIMLoginManagerDelegate
- (void)onLogin:(NIMLoginStep)step {
    DDLogDebug(@"%ld",step);
}

- (void)onAutoLoginFailed:(NSError *)error {
    DDLogDebug(@"%@",error.description);
}

@end


@implementation WBNIMConfiguration


@end

@implementation WBNIMAutoLoginData

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        _account = [aDecoder decodeObjectForKey:@"account"];
        _token = [aDecoder decodeObjectForKey:@"token"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    if ([_account length]) {
        [encoder encodeObject:_account forKey:@"account"];
    }
    if ([_token length]) {
        [encoder encodeObject:_token forKey:@"token"];
    }
}

@end
