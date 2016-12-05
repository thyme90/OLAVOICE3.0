//
//  NewsModel.h
//  testSDLayout
//
//  Created by yanminli on 2016/10/24.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CellModel.h"


@interface NewsData : NSObject
@property (nonatomic,strong) NSString       *image_url;
@property (nonatomic,strong) NSString       *time;
@property (nonatomic,strong) NSString       *title;
@property (nonatomic,strong) NSString       *detail;
@property (nonatomic,strong) NSString       *ref_url;
@end
 
@interface NewsModel : CellModel
-(id)initWithData:(NSDictionary *)dic;
@property (nonatomic,strong) NSMutableArray         *dataArry;

@end
