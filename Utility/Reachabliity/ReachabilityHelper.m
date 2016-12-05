//
//  ReachabilityHelper.m
//  NoScreenAudio
//
//  Created by S3Graphic on 16/4/26.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import "ReachabilityHelper.h"
#import "Reachability.h"
static ReachabilityHelper *ReachHelper = nil;
static Reachability *reach = nil;
@implementation ReachabilityHelper

+ (ReachabilityHelper *)shareReachabilityHelper{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ReachHelper = [[ReachabilityHelper alloc]init];
    });
    return ReachHelper;
}
-(instancetype)init{
    if (self = [super init]) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            reach = [[Reachability alloc]init];
        });
    }
    return self;
}


+(id)connectWithHostName:(NSString *)hostName{
    //reach reach
    return 0;
}

+(id)connectWithHostAddress:(NSString *)hostAddress{
    return 0;
}




@end
