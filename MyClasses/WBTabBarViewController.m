//
//  WBTabBarViewController.m
//  WBNIMDemo
//
//  Created by Mr_Lucky on 2018/9/30.
//  Copyright © 2018 wenbo. All rights reserved.
//

#import "WBTabBarViewController.h"
#import "NTESSessionListViewController.h"

@interface WBTabBarViewController ()

@end

@implementation WBTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NTESSessionListViewController *vc = [NTESSessionListViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    vc.title = @"云信";
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [self addChildViewController:nav];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
