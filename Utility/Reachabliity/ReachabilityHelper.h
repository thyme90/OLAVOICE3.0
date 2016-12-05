//
//  ReachabilityHelper.h
//  NoScreenAudio
//
//  Created by S3Graphic on 16/4/26.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReachabilityHelper : NSObject
+(id)connectWithHostName:(NSString *)hostName;
+(id)connectWithHostAddress:(NSString *)hostAddress;
@end
