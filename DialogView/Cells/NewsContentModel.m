//
//  NewsContentModel.m
//  testSDLayout
//
//  Created by yanminli on 2016/10/26.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import "NewsContentModel.h"

@interface NewsContentModel()
@property (nonatomic,strong) NSDictionary   *dicData;

@end

@implementation NewsContentModel
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
            _image_url = [dataDic objectForKey:@"image_url"];
            _ref_url = [dataDic objectForKey:@"ref_url"];
            _time = [dataDic objectForKey:@"time"];
            _detail = [dataDic objectForKey:@"detail"];
            _source = [dataDic objectForKey:@"source"];
            _title = [dataDic objectForKey:@"title"];
            _indexNum = [[NSString alloc] initWithFormat:@"%d",i+1];
        }

    }else{
        _isNull = YES;
    }
    
}
@end
