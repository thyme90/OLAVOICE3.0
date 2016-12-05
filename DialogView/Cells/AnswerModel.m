//
//  AnswerModel.m
//  DialogDemo
//
//  Created by yanminli on 2016/11/1.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import "AnswerModel.h"

@interface AnswerModel()
@property (nonatomic,strong) NSDictionary   *dicData;

@end

@implementation AnswerModel
-(id)initWithData:(NSDictionary *)dic{
    if (self = [super init]) {
        _dicData = dic;
        [self setDatas];
    }
    
    return self;
}

-(id)init{
    if (self = [super init]) {
        _result = @"目前只支持百科，新闻和天气，请换个话题";
    }
    
    return self;
}

-(void)setDatas{
    NSDictionary    *descDic = [_dicData objectForKey:@"desc_obj"];
    NSArray         *dataArray = [_dicData objectForKey:@"data_obj"];
    if (descDic != nil) {
        _content = [descDic objectForKey:@"content"];
        _result  = [descDic objectForKey:@"result"];
    }
    
    if (dataArray != nil) {
        NSDictionary    *conDic = [dataArray objectAtIndex:0];
        _content = [conDic objectForKey:@"content"];
    }
    
    
     
}

@end
