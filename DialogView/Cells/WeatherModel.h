//
//  WeatherModel.h
//  NoScreenAudio
//
//  Created by yanminli on 2016/10/20.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CellModel.h"

@interface WeatherData : NSObject
@property (nonatomic,strong) NSString   *current_temperature;//实时温度
@property (nonatomic,strong) NSString   *pm;//pm指数
@property (nonatomic,strong) NSString   *temperature_high_low;//温度范围
@property (nonatomic,strong) NSString   *weekDay;//星期几
@property (nonatomic,strong) NSString   *yearDay;//几月几号
@property (nonatomic,strong) NSString   *weatherIcon;//要显示的图片的名称
@property (nonatomic,strong) NSString   *weatherdesc;//天气的详细情况
@property (nonatomic,assign) int        is_query;//询问的要突出显示的哪一天，1为是，0为不是
@property (nonatomic,assign) int        is_today;//保存是否询问的是当天的天气，0表示当天，1表示明天

 


@end

@interface WeatherModel : CellModel
-(id)initWithData:(NSDictionary *)dic;
@property (nonatomic,strong) NSMutableArray         *weatherDataArry;
@property (nonatomic,strong) NSString               *modelType;
@property (nonatomic,strong) NSString               *cityStr;//当前的城市
@end
