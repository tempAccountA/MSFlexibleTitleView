//
//  AppDelegate.m
//  FlexibleTitleViewDEMO
//
//  Created by JZJ on 2016/9/22.
//  Copyright © 2016年 JZJ. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [UIWindow new];
    self.window.frame = [UIScreen mainScreen].bounds;
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:ViewController.new];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
