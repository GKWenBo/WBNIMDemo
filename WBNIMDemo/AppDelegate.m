//
//  AppDelegate.m
//  WBNIMDemo
//
//  Created by Mr_Lucky on 2018/9/30.
//  Copyright © 2018 wenbo. All rights reserved.
//

#import "AppDelegate.h"

#import "WBTabBarViewController.h"
#import "NTESLoginViewController.h"

#import "NTESLoginManager.h"
#import "NTESService.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    _window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _window.backgroundColor = [UIColor whiteColor];
    [_window makeKeyAndVisible];
    
    [self configNIMSDK];
    [self setupMainViewController];
    
    return YES;
}

- (void)configNIMSDK {
    NIMSDKOption *option = [[NIMSDKOption alloc]init];
    option.appKey = @"826a6d64f6990f2ce5198a9ae81ff10e";
    [[NIMSDK sharedSDK] registerWithOption:option];
}

- (void)setupMainViewController {
//    [[NTESLoginManager sharedManager] setCurrentLoginData:nil];
    
    NTESLoginData *data = [[NTESLoginManager sharedManager] currentLoginData];
    NSString *account = [data account];
    NSString *token = [data token];
    
    
    
    //如果有缓存用户名密码推荐使用自动登录
    if ([account length] && [token length])
    {
        NIMAutoLoginData *loginData = [[NIMAutoLoginData alloc] init];
        loginData.account = account;
        loginData.token = token;
        
        [[[NIMSDK sharedSDK] loginManager] autoLogin:loginData];
        [[NTESServiceManager sharedManager] start];
        WBTabBarViewController *mainTab = [[WBTabBarViewController alloc] initWithNibName:nil bundle:nil];
        self.window.rootViewController = mainTab;
    }
    else
    {
        [self setupLoginViewController];
    }
}

- (void)setupLoginViewController {
    NTESLoginViewController *loginController = [[NTESLoginViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginController];
    self.window.rootViewController = nav;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
