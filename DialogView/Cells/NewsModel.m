//
//  NewsModel.m
//  testSDLayout
//
//  Created by yanminli on 2016/10/24.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import "NewsModel.h"


@implementation NewsData

@end

//############################################################

@interface NewsModel()
@property (nonatomic,strong) NSDictionary   *dicData;
@end

@implementation NewsModel
-(id)initWithData:(NSDictionary *)dic{
    if (self = [super init]) {
        _dicData = dic;
        [self setDatas];
    }
    
    return self;
}

-(void)setDatas{
    NSDictionary    *descDic = [_dicData objectForKey:@"desc_obj"];
    self.ttsStr = [descDic objectForKey:@"result"];
    
    NSArray *arry = [_dicData objectForKey:@"data_obj"];
    _dataArry = [[NSMutableArray alloc] init];
    for (int i=0; i<arry.count; i++) {
        NewsData *data = [[NewsData alloc] init];
        NSDictionary    *dataDic = [arry objectAtIndex:i];
        data.image_url = [dataDic objectForKey:@"image_url"];
        data.ref_url      = [dataDic objectForKey:@"ref_url"];
        data.time    = [dataDic objectForKey:@"time"];
        data.detail   = [dataDic objectForKey:@"detail"];
        data.title = [dataDic objectForKey:@"title"];
        
        [_dataArry addObject:data];
    }
}

@end




