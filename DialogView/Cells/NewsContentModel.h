//
//  NewsContentModel.h
//  testSDLayout
//
//  Created by yanminli on 2016/10/26.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CellModel.h"

@interface NewsContentModel : CellModel
-(id)initWithData:(NSDictionary *)dic;
@property (nonatomic,strong) NSString       *image_url;
@property (nonatomic,strong) NSString       *time;
@property (nonatomic,strong) NSString       *title;
@property (nonatomic,strong) NSString       *detail;
@property (nonatomic,strong) NSString       *ref_url;
@property (nonatomic,strong) NSString       *source;
@property (nonatomic,strong) NSString       *indexNum;//说明当前是第几条新闻
@property (nonatomic,assign) BOOL           isNull;//如果没有新闻，这个值为YES
@end
