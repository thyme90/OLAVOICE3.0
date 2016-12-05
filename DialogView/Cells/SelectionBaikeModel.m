//
//  SelectionBaike.m
//  DialogDemo
//
//  Created by yanminli on 2016/11/23.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import "SelectionBaikeModel.h"

#import "commonHeader.h"

@implementation SelectionBaikeData



@end


@interface SelectionBaikeModel()
@property (nonatomic,strong) NSDictionary   *dicData;


@end

@implementation SelectionBaikeModel
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
    _dataArray = [[NSMutableArray alloc] init];
    for (int i=0; i<arry.count; i++) {
        SelectionBaikeData *data = [[SelectionBaikeData alloc] init];
        NSDictionary    *dataDic = [arry objectAtIndex:i];
        data.name = [dataDic objectForKey:@"name"];
        data.desc      = [dataDic objectForKey:@"desc"];
        [_dataArray addObject:data];
    }
}
@end

