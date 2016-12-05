//
//  AppDelegate.h
//  NoScreenAudio
//
//  Created by yanminli on 15/10/8.
//  Copyright © 2015年 s3graphics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "macro.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (assign, nonatomic) AccountStatus accountStatus;
@property (strong, nonatomic) NSString* accountName;//保存用户的名称
@property (assign, nonatomic) AccountType accountType;//用户类型



@end

