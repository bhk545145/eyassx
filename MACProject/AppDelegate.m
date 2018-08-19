//
//  AppDelegate.m
//  MACProject
//
//  Created by MacKun on 16/7/28.
//  Copyright © 2016年 com.mackun. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabBarController.h"
#import "BaseService.h"
#import "BookWebViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <UMCommon/UMCommon.h>
#import <UMPush/UMessage.h>

#define CFBundleShortVersionString [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleShortVersionString"]

@interface AppDelegate ()<UNUserNotificationCenterDelegate,NSURLConnectionDataDelegate>

@end

@implementation AppDelegate




- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //fackbook统计
    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    //友盟统计
    [UMConfigure setLogEnabled:NO];
    [UMConfigure initWithAppkey:@"5b08e20bf29d98469d00052e" channel:@"App Store"];
    
    // Push组件基本功能配置
    UMessageRegisterEntity * entity = [[UMessageRegisterEntity alloc] init];
    //type是对推送的几个参数的选择，可以选择一个或者多个。默认是三个全部打开，即：声音，弹窗，角标
    entity.types = UMessageAuthorizationOptionBadge|UMessageAuthorizationOptionSound|UMessageAuthorizationOptionAlert;
    [UNUserNotificationCenter currentNotificationCenter].delegate=self;
    [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:entity     completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
        }else{
        }
    }];
    

    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [NSThread sleepForTimeInterval:0.5];
    BOOL checkopen = [[self checkopenapi] boolValue];
    //true是显示h5，false显示原生
    if (checkopen) {
        BookWebViewController *bookWebVC = [[BookWebViewController alloc]init];
        bookWebVC.webUrl = eyassxH5;
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:bookWebVC];
        self.window.rootViewController = nav;
        [FBSDKAppEvents logEvent:@"My custom event"];
    }else{
        MainTabBarController *nav = [[MainTabBarController alloc]init];
        self.window.rootViewController = nav;
        //检测新版本
        [self judgeAppVersion];
    }
    
    self.window.backgroundColor    = [UIColor whiteColor];
    [self appConfig];
    [self.window makeKeyAndVisible];
    
    
    
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                  openURL:url
                                                        sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                               annotation:options[UIApplicationOpenURLOptionsAnnotationKey]
                    ];
    
    // Add any custom logic here.
    return handled;
}


-(void)appConfig{
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithWhite:0.0f alpha:1.0f];
    shadow.shadowOffset = CGSizeMake(0, 0);
    [[UIApplication sharedApplication]registerNotifications];
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           NSForegroundColorAttributeName: [UIColor whiteColor],
                                                           NSShadowAttributeName: shadow,
                                                           NSFontAttributeName: [UIFont fontWithName:@"Arial-BoldMT" size:17.0f]
                                                           }];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor appNavigationBarColor]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
       [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}


- (void)statusBarOrientationChange:(NSNotification *)notification
{
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];

    if (orientation == UIInterfaceOrientationLandscapeRight) // home键靠右
    {
        //
    }
    
    if (
        orientation ==UIInterfaceOrientationLandscapeLeft) // home键靠左
    {
        //
    }
    
    if (orientation == UIInterfaceOrientationPortrait)
    {
        //
    }
    
    if (orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        //
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//H5开关  http://novel.eyassx.com/openapi/system/checkopenapi?key=ios
- (NSString *)checkopenapi {
    NSString *URLString = [NSString stringWithFormat:@"%@/openapi/system/checkopenapi?key=ios",eyassxURL];
    NSURL *url = [NSURL URLWithString:URLString];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *checkopen = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];

    return checkopen;
}

//AppStore访问地址（重点）
-(void)judgeAppVersion{
    NSString *urlStr = @"https://itunes.apple.com//lookup?id=1381221109";
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:req delegate:self];
}

#pragma mark - NSURLConnectionDataDelegate
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    //解析
    NSError *error;
    NSDictionary *appInfo = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    NSArray *infoContent = [appInfo objectForKey:@"results"];
    //最新版本号
//    NSString *version = [[infoContent objectAtIndex:0] objectForKey:@"version"];
    NSString *version = @"2.6";
    //应用程序介绍网址（用户升级跳转URL）
    NSString *trackViewUrl = [[infoContent objectAtIndex:0] objectForKey:@"trackViewUrl"];
    
    NSString *currentVersion = CFBundleShortVersionString;
    
    if ([version compare:currentVersion options:NSNumericSearch] == NSOrderedDescending) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"检查到更新" message:[NSString stringWithFormat:@"发现新版本(%@),是否升级",version] preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:trackViewUrl]];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
    } else if ([version compare:currentVersion options:NSNumericSearch] == NSOrderedSame) {
        BookWebViewController *bookWebVC = [[BookWebViewController alloc]init];
        bookWebVC.webUrl = eyassxH5;
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:bookWebVC];
        self.window.rootViewController = nav;
    }
    
}
@end
