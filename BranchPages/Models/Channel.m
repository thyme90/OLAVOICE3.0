//
//  Channel.m
//  NoScreenAudio
//
//  Created by S3Graphic on 16/1/18.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import "Channel.h"

@implementation Channel

-  (id)initWithKeyId:(NSInteger)id name:(NSString *)name category:(NSString *)category domain:(NSString *)domain type:(NSString *)type freq:(NSString *)freq
{
    self = [super init];
    if (self) {
        self.id =id;
        self.name = name;
        self.category = category;
        self.domain = domain;
        self.type = type;
        self.freq = freq;
    }
    return self;
}

+ (id)channelWithKeyId:(NSInteger)id name:(NSString *)name category:(NSString *)category domain:(NSString *)domain type:(NSString *)type freq:(NSString *)freq{
    Channel *channel = [[Channel alloc]initWithKeyId:id name:name category:category domain:domain type:type freq:freq];
    return channel;
}

-(instancetype)initWithDictionary:(NSDictionary *)Dictionary{
    self = [super init];
    if (self) {
        self.name = [NSString stringWithFormat:@"%@",[Dictionary objectForKey:@"name"]];
        self.id = [[Dictionary objectForKey:@"id"] integerValue];
        self.category = [NSString stringWithFormat:@"%@", [Dictionary objectForKey:@"category"]];
        self.domain = [NSString stringWithFormat:@"%@", [Dictionary objectForKey:@"domain"]];
        self.type = [NSString stringWithFormat:@"%@", [Dictionary objectForKey:@"type"]];
        self.freq = [Dictionary objectForKey:@"freq"];
    }
    return self;
}
@end
