//
//  PersonBaikeModel.m
//  DialogDemo
//
//  Created by yanminli on 2016/10/31.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import "PersonBaikeModel.h"
@implementation PersonBaikeData
@end


@interface PersonBaikeModel()
@property (nonatomic,strong) NSDictionary   *dicData;


@end

@implementation PersonBaikeModel
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
    _personBaikeArray = [[NSMutableArray alloc] init];
    for (int i=0; i<arry.count; i++) {
        PersonBaikeData *data = [[PersonBaikeData alloc] init];
        NSDictionary    *dataDic = [arry objectAtIndex:i];
        data.startTime = [dataDic objectForKey:@"start_time"];
        data.post      = [dataDic objectForKey:@"post"];
        data.nation    = [dataDic objectForKey:@"nation"];
        data.endTime   = [dataDic objectForKey:@"end_time"];
        data.personName = [dataDic objectForKey:@"person_name"];
        data.postOfTimes = [dataDic objectForKey:@"post_of_times"];
        [_personBaikeArray addObject:data];
    }
}
@end
