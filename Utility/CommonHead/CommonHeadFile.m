//
//  CommonHeadFile.m
//  NoScreenAudio
//
//  Created by yanminli on 15/12/14.
//  Copyright © 2015年 s3graphics. All rights reserved.
//

#import "CommonHeadFile.h"
#import <CommonCrypto/CommonDigest.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <UIKit/UIKit.h>

@implementation CommonHeadFile

static CommonHeadFile* commonHeadFileInstance = nil;

+ (CommonHeadFile *)getCommonHeadFileInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        commonHeadFileInstance = [[CommonHeadFile alloc]init];
    });
    return commonHeadFileInstance;
}

#pragma mark --密码md5加密
- (NSString *)md5HexDigest:(NSString*)input
{
    const char* str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02X",result[i]];
    }
    NSString* retStr = [[NSString stringWithString:ret] lowercaseString];
    return retStr;
}

#pragma mark --生成6位的随机数
- (NSString *)random6Code{
    NSString* strRandom = [[NSString alloc] init];
    for (int i=0; i<6; i++) {
        strRandom = [ strRandom stringByAppendingFormat:@"%i",(arc4random() % 9)];
    }
    return strRandom;
}

//- (NetworkStatus)getNetWorkStates{
//    UIApplication *app = [UIApplication sharedApplication];
//    NSArray *children = [[[app valueForKeyPath:@"statusBar"]valueForKeyPath:@"foregroundView"]subviews];
//    NetworkStatus state=NONETWORK;
//    int netType = 0;
//    //获取到网络返回码
//    for (id child in children) {
//        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
//            //获取到状态栏
//            netType = [[child valueForKeyPath:@"dataNetworkType"]intValue];
//            switch (netType) {
//                case 0:
//                    state = NONETWORK;
//                    //无网模式
//                    break;
//                case 1:
//                    state = IS2G;
//                    break;
//                case 2:
//                    state = IS3G;
//                    break;
//                case 3:
//                    state = IS4G;
//                    break;
//                case 5:
//                 state = ISWIFI;
//                 break;
//                default:
//                    break;
//            }
//        }
//    }
//    //根据状态选择
//    return state;
//}

- (NetworkStatus)getNetWorkStates{
    NetworkStatus state=NotReachable;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.sina.com.cn"];
    switch ([reach currentReachabilityStatus]) {
        case ReachableViaWiFi:
            state = ReachableViaWiFi;//使用WIFI
            //NSLog(@"Reachable");
            break;
        case ReachableViaWWAN://使用3G
            state = ReachableViaWWAN;
            break;
        default:
            break;
    }
    return state;
}

@end
