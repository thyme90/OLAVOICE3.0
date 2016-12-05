//
//  BaikeiModel.m
//  DialogDemo
//
//  Created by yanminli on 2016/10/28.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import "BaikeiModel.h"

@interface BaikeiModel()
@property (nonatomic,strong) NSDictionary   *dicData;

@end

@implementation BaikeiModel
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
    if (arry) {
        for (int i=0; i<arry.count; i++) {
            NSDictionary    *dataDic = [arry objectAtIndex:i];
            _photo_url = [dataDic objectForKey:@"photo_url"];
            _descr = [dataDic objectForKey:@"description"];
            _field_name = [dataDic objectForKey:@"field_name"];
            _field_value = [dataDic objectForKey:@"field_value"];
            _type = [dataDic objectForKey:@"type"];
        }

    }
}

@end
