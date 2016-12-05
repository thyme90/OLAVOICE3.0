//
//  AppDelegate.m
//  NoScreenAudio
//
//  Created by yanminli on 15/10/8.
//  Copyright © 2015年 s3graphics. All rights reserved.
//

#import "AppDelegate.h"
#import "UserManager.h"
#import "RootViewController.h"
#import <PgyUpdate/PgyUpdateManager.h>


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [NSThread sleepForTimeInterval:1.0];//设置启动页面时间
    //启动更新检查SDK
//    [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:@"a4ec94c7d0f80ce83c92ac9452a891f9"];
//    [[PgyUpdateManager sharedPgyManager] checkUpdate];
    
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    self.window.backgroundColor = [UIColor whiteColor];
//    [self.window makeKeyAndVisible];
    
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"EnterPage" bundle:nil];
    UIViewController* mainVC =[mainStoryBoard instantiateViewControllerWithIdentifier:@"enterpagestoryboard"];
    self.window.rootViewController = mainVC;
    
    //根据存储的用户的状态，进入不同的界面。如果用户没有登出或者删除程序，就直接进入主页，否则进入初始页面
    /*
    UserManager* userManager = [UserManager getUserManagerInstance];
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
   
    BOOL isLog = [userDefaultes integerForKey:@"isLog"];
    if (!isLog) {
        [userManager initUserManager];
        userManager.logStatus = FirstLog;
        
        UIStoryboard *enterStoryBoard = [UIStoryboard storyboardWithName:@"EnterPage" bundle:nil];
        UIViewController* rootViewController = [enterStoryBoard instantiateViewControllerWithIdentifier:@"rootViewController"];
        //[self.navigationController pushViewController:clockVC animated:YES];
        
        //RootViewController* rootView = [[RootViewController alloc] init];
        UIViewController* vc = [[UINavigationController alloc] initWithRootViewController:rootViewController];
        self.window.rootViewController = vc;
    }else{
        [userManager reflectDataFromOtherObject];
     */
        /*
//        userManager.isLog = YES;
//        userManager.logStatus = MainPageLog;
//        userManager.userName = [userDefaultes valueForKey:@"userName"];
//        userManager.nickName = [userDefaultes valueForKey:@"nickName"];
//        userManager.verified = [userDefaultes integerForKey:@"verified"];
//        userManager.passwd = [userDefaultes valueForKey:@"passwd"];
//        userManager.passwdMD5 = [userDefaultes valueForKey:@"passwdMD5"];
//        userManager.phoneVcode = [userDefaultes valueForKey:@"phoneVcode"];
//        userManager.accountType = [userDefaultes integerForKey:@"accountType"];
//        userManager.headImage = [userDefaultes valueForKey:@"headImage"];
//        userManager.currentBoxName = [userDefaultes valueForKey:@"currentBoxName"];
//        userManager.nickNameSetting = [userDefaultes valueForKey:@"nickNameSetting"];
//        userManager.olaPhoneNum = [userDefaultes valueForKey:@"olaPhoneNum"];
        
        self.window.rootViewController = self.m_leftSlideVC;
    }
     */
    return YES;
        
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
//    NSLog(@"applicationWillTerminate");
//    UserManager* userManager = [UserManager getUserManagerInstance];
//    [userManager saveDataFromObject];
    
//    [userDefaultes setObject:userManager.userName forKey:@"userName"];
//    [userDefaultes setInteger:userManager.verified forKey:@"verified"];
//    [userDefaultes setObject:userManager.headImage forKey:@"headImage"];
//    [userDefaultes setObject:userManager.passwd forKey:@"passwd"];
//    [userDefaultes setObject:userManager.passwdMD5 forKey:@"passwdMD5"];
//    [userDefaultes setInteger:userManager.isLog forKey:@"isLog"];
//    [userDefaultes setObject:userManager.olaPhoneNum forKey:@"olaPhoneNum"];
//    [userDefaultes setObject:userManager.nickName forKey:@"nickName"];
//    [userDefaultes setObject:userManager.phoneVcode forKey:@"phoneVcode"];
//    [userDefaultes setInteger:userManager.accountType forKey:@"accountType"];
//    [userDefaultes setObject:userManager.currentBoxName forKey:@"currentBoxName"];
//    [userDefaultes setObject:userManager.nickNameSetting forKey:@"nickNameSetting"];
}


//保存log日志
- (void)redirectNSlogToDocumentFolder{
    NSLog(@"logfile");
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDirectory = [paths objectAtIndex:0];
    
    NSString *fileName = [NSString stringWithFormat:@"noscreenaudio.log"];// 注意不是NSData!
    
    NSString *logFilePath = [documentDirectory stringByAppendingPathComponent:fileName];
    
    // 先删除已经存在的文件
    
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    
    [defaultManager removeItemAtPath:logFilePath error:nil];
    
    
    // 将log输入到文件
    
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stdout);
    
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
    
}

@end
