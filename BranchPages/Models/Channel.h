//
//  Channel.h
//  NoScreenAudio
//
//  Created by S3Graphic on 16/1/18.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Channel : NSObject
@property(nonatomic,strong)NSString *name;
@property(nonatomic,assign)NSInteger id;
@property(nonatomic,strong)NSString *category;
@property(nonatomic,strong)NSString*domain;
@property(nonatomic,strong)NSString *type;
@property(nonatomic,strong)NSString *freq;
-  (id)initWithKeyId:(NSInteger )id
                name:(NSString *)name
              category:(NSString *)category
                 domain:(NSString *)domain
            type:(NSString *)type
               freq:(NSString *)freq;

+ (id)channelWithKeyId:(NSInteger )id name:(NSString *)name category:(NSString *)category domain:(NSString *)domain type:(NSString *)type freq:(NSString *)freq;

-(instancetype)initWithDictionary:(NSDictionary *)Dictionary;
@end
