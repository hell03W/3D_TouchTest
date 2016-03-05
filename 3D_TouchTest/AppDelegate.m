//
//  AppDelegate.m
//  3D_TouchTest
//
//  Created by Walden on 16/3/2.
//  Copyright © 2016年 Walden. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self createShortCutItems];
    
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:[[ViewController alloc] init]];
    self.window.rootViewController = navi;
    [self.window makeKeyAndVisible];
    
    
    return YES;
}

/*
 创建动态的菜单:
 动态菜单和静态菜单的区别, 静态菜单是写死在plist中的菜单, 在app中是不能改变的, 当程序第一次安装到手机上时候就是可用的, 动态菜单, 是可以在程序运行期间动态的改变的, 例如iPhone自带的通讯录的3dTouch, 动态菜单, 在程序第一次打开之前, 是不可用的, 当程序第一次打开之后, 以后这个都是可用的.
 动态菜单和静态菜单点击事件都是在 application: performActionForShortcutItem: completionHandler: 这个方法中监听并实现事件处理和跳转的. 
 
 如果动态菜单和静态菜单同时存在时候, 静态菜单会出现在更靠近icon的位置.
 */
- (void)createShortCutItems
{
    UIApplicationShortcutIcon *icon1 = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeAlarm];
    UIApplicationShortcutIcon *icon2 = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeAudio];
    UIApplicationShortcutIcon *icon3 = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeBookmark];
    
    UIApplicationShortcutItem *item1 = [[UIApplicationShortcutItem alloc] initWithType:@"first" localizedTitle:@"first item" localizedSubtitle:@"第一个" icon:icon1 userInfo:nil];
    UIApplicationShortcutItem *item2 = [[UIApplicationShortcutItem alloc] initWithType:@"second" localizedTitle:@"second item" localizedSubtitle:@"第二个" icon:icon2 userInfo:nil];
    UIApplicationShortcutItem *item3 = [[UIApplicationShortcutItem alloc] initWithType:@"third" localizedTitle:@"third item" localizedSubtitle:@"第三个" icon:icon3 userInfo:nil];
    
//    NSArray *newArray = [@[item1, item2, item3] arrayByAddingObjectsFromArray:[UIApplication sharedApplication].shortcutItems];
    NSArray *newArray = @[item1, item2, item3];
    
    [UIApplication sharedApplication].shortcutItems = newArray;
    
}
/*
 当点击 Home Screen Quick Actions 进入应用的时候, 会走这个方法, 不管应用是否在杀死状态, 都会走这个方法(已测试)
 在这个方法里面应该处理点击事件的处理. 跳转到指定的页面.
 */
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler
{
    NSString *itemType = shortcutItem.type;
    if ([itemType isEqualToString:@"first"]) {
        NSLog(@"点击了第一个");
    }
    else if ([itemType isEqualToString:@"second"]) {
        NSLog(@"点击了第二个");
    }
    else if ([itemType isEqualToString:@"third"]) {
        NSLog(@"点击了第三个");
    }
    else if ([itemType isEqualToString:@"forth"]) {
        NSLog(@"点击了第四个");
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:itemType delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}

@end
