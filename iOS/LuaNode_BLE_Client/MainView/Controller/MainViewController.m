//
//  MainViewController.m
//  LuaNode_BLE_Client
//
//  Created by apple on 2017/4/10.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "MainViewController.h"
#import "TheMainView.h"
#import "ScanViewController.h"
#import "BLEViewController.h"
#import "SettingViewController.h"
#import "Config.h"

static MainViewController *instance;

@interface MainViewController ()

@end

@implementation MainViewController {
    // private
    TheMainView *mainView;
    NSInteger currTab;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self layout];
    
    currTab = 0;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setup view layout
- (void)layout {
    /*mainView = [TheMainView instanceView];
    // stretch to fill the screen
    mainView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:mainView];*/
    
    self.title = NSLocalizedString(@"main.view", "Main View");
    
    // init all tab view
    ScanViewController *scanVC = [[ScanViewController alloc]init];
    UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:scanVC];
    nav1.title = NSLocalizedString(@"main.scan", "Main Scan View");
    
    BLEViewController *bleVC = [[BLEViewController alloc] initWithRoot:[BLEViewController createTable]];
    UINavigationController *nav2 = [[UINavigationController alloc]initWithRootViewController:bleVC];
    nav2.title = NSLocalizedString(@"main.ble", "Main BLE View");
    
    SettingViewController *settingVC = [[SettingViewController alloc] initWithRoot:[SettingViewController createTable]];
    UINavigationController *nav3 = [[UINavigationController alloc]initWithRootViewController:settingVC];
    nav3.title = NSLocalizedString(@"main.settings", "Main Settings View");
    
    NSArray *vcArray = [NSArray arrayWithObjects:nav1, nav2, nav3, nil];
    self.viewControllers = vcArray;
    
    // set tab item image
    UITabBarItem *tabItem1 = [self.tabBar.items objectAtIndex:0];
    tabItem1.image = [[UIImage imageNamed:@"tabbar_chats"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabItem1.selectedImage = [[UIImage imageNamed:@"tabbar_chatsHL"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabItem1.tag = 0;
    
    UITabBarItem *tabItem2 = [self.tabBar.items objectAtIndex:1];
    tabItem2.image = [[UIImage imageNamed:@"tabbar_cloud"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabItem2.selectedImage = [[UIImage imageNamed:@"tabbar_cloudHL"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabItem2.tag = 1;
    
    UITabBarItem *tabItem3 = [self.tabBar.items objectAtIndex:2];
    tabItem3.image = [[UIImage imageNamed:@"tabbar_setting"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabItem3.selectedImage = [[UIImage imageNamed:@"tabbar_settingHL"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabItem3.tag = 2;
}

#pragma mark - singleton
+ (MainViewController *)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MainViewController alloc]init];
    });
    return instance;
}

#pragma mark - tabbar delegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSLog(@"item name = %d", item.tag);
    
    if (item.tag == 0) {
        // start BLE scanning
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIF_TAB2_DISCONNECT object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIF_TAB1_SCAN_START object:nil userInfo:nil];
    } else if (item.tag == 1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIF_TAB1_SCAN_STOP object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIF_TAB2_CONNECT object:nil userInfo:nil];
    } else {
        
    }
    currTab = item.tag;
}

@end
