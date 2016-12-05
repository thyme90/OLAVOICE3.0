//
//  WeatherModel.m
//  NoScreenAudio
//
//  Created by yanminli on 2016/10/20.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import "WeatherModel.h"


@implementation WeatherData

@end


@interface WeatherModel()
@property (nonatomic,strong) NSDictionary   *dicData;
@property (nonatomic,assign) long long  real_date;
@property (nonatomic,assign) int        is_today;
@property (nonatomic,strong) NSString   *weather_start_desc;//文字描述
@property (nonatomic,strong) NSString   *weather_end_desc;
@property (nonatomic,assign) int        weather_start;//数字
@property (nonatomic,strong) NSString   *wind;
@property (nonatomic,strong) NSString   *temperature_high;
@property (nonatomic,strong) NSString   *temperature_low;
@property (nonatomic,strong) NSArray    *exponent_type;
@property (nonatomic,strong) NSArray    *exponent_value;
@property (nonatomic,assign) int        is_querying;
@property (nonatomic,assign) int        pm25;
@property (nonatomic,strong) NSString   *detailDesc;
@property (nonatomic,strong) NSString   *current_temperature;
@end

@implementation WeatherModel
-(id)initWithData:(NSDictionary *)dic{
    if (self = [super init]) {
        _dicData = dic;
        _weatherDataArry = [[NSMutableArray alloc] init];
        [self setDatas];
    }
    
    return self;
}


-(void)setDatas{
    NSDictionary    *descDic = [_dicData objectForKey:@"desc_obj"];
    self.ttsStr = [descDic objectForKey:@"result"];
    
    NSArray *arry = [_dicData objectForKey:@"data_obj"];
    for (int i=0; i<arry.count; i++) {
        NSDictionary    *dataDic = [arry objectAtIndex:i];
        _is_today = [[dataDic objectForKey:@"date"] intValue];
        _cityStr = [dataDic objectForKey:@"city"];
        _weather_start_desc = [dataDic objectForKey:@"weather_start_desc"];
        _weather_end_desc = [dataDic objectForKey:@"weather_end_desc"];
        _weather_start = [[dataDic objectForKey:@"weather_start"] intValue];
        _is_querying = [[dataDic objectForKey:@"is_querying"] intValue];
        _real_date = [[dataDic objectForKey:@"real_date"] longLongValue];
        _pm25 = [[dataDic objectForKey:@"pm25"] intValue];
        _temperature_high = [dataDic objectForKey:@"temperature_high"];
        _temperature_low = [dataDic objectForKey:@"temperature_low"];
        _detailDesc = [dataDic objectForKey:@"description"];
        _current_temperature = [dataDic objectForKey:@"temp"];
        
    
        
        WeatherData *data = [self creatWeatherData];
        [_weatherDataArry addObject:data];
        
        
    }
    
}

-(WeatherData*)creatWeatherData{
    WeatherData *data = [[WeatherData alloc] init];
    data.weekDay = [self getWeekDayFordate:_real_date];
    data.yearDay = [self getYearMonthDayFordate:_real_date];
    data.pm = [self pmToString];
    data.temperature_high_low = [self temperatureRange];
    data.weatherdesc = [self weatherDesc];
    data.weatherIcon = [self iconName];
    data.is_query = _is_querying;
    data.current_temperature = _current_temperature;
    data.weatherdesc = [self weatherDesc];
    data.is_today = _is_today;
    
    return data;
}

//毫秒数转换为星期几
-(NSString *)getWeekDayFordate:(long long)data
{
    NSArray *weekday = [NSArray arrayWithObjects: [NSNull null], @"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    
    NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:data/1000];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekday fromDate:newDate];
    
    NSString *weekStr = [weekday objectAtIndex:components.weekday];
    return weekStr;
}

//毫秒数转换为年月日
-(NSString*)getYearMonthDayFordate:(long long)date{
    NSString *yearDay = nil;
    NSDate *tmpDate = [[NSDate alloc] initWithTimeIntervalSince1970:date/1000];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"YYYY/MM/dd";
    
    yearDay = [dateFormatter stringFromDate:tmpDate];
    
    return yearDay;
}

-(NSString*)pmToString{
    NSString *pmStr = nil;
    if (_pm25 <= 35) {
        pmStr = @"优";
    }else if(_pm25> 35 && _pm25 <=75){
        pmStr = @"良";
    }else if(_pm25 >75 && _pm25 <=115){
        pmStr = @"轻度污染";
    }else if(_pm25>115 && _pm25 <=150){
        pmStr = @"中度污染";
    }else if(_pm25 > 150 && _pm25 <=250){
        pmStr = @"重度污染";
    }else if(_pm25 > 250){
        pmStr = @"严重污染";
    }
        
    return pmStr;
}

//温度的范围，例如22~23
-(NSString*)temperatureRange{
    NSString *str = [[NSString alloc] initWithFormat:@"%@ ~ %@",_temperature_low,_temperature_high];
    return str;
}

//天气的描述 例如 阵雨转多云
-(NSString*)weatherDesc{
    NSString *str = nil;
    if ([_weather_start_desc isEqualToString:_weather_end_desc]) {
        str = [[NSString alloc] initWithFormat:@"%@",_weather_start_desc];
    }else{
        str = [[NSString alloc] initWithFormat:@"%@%@%@",_weather_start_desc,@"转",_weather_end_desc];

    }
    return str;
}

//天气图片的名称
-(NSString*)iconName{
    NSString *str = @"icnHeavyRain";
    switch (_weather_start) {
        case 0:
            str = @"icnHeavyRain";
            break;
        case 1:
            str = @"icnHeavyRain";
            break;
        case 2:
            str = @"icnHeavyRain";
            break;
        case 3:
            str = @"icnHeavyRain";
            break;
        case 4:
            str = @"icnHeavyRain";
            break;
        case 5:
            str = @"雷阵雨";
            break;
        case 6:
            str = @"小雨";
            break;
        case 7:
            str = @"小到中雨";
            break;
        case 8:
            str = @"中雨";
            break;
        case 9:
            str = @"中到大雨";
            break;
        case 10:
            str = @"大雨";
            break;
        case 11:
            str = @"大到暴雨";
            break;
        case 12:
            str = @"暴雨";
            break;
        case 13:
            str = @"暴雨到大暴雨";
            break;
        case 14:
            str = @"大暴雨";
            break;
        case 15:
            str = @"大暴雨到特大暴雨";
            break;
        case 16:
            str = @"特大暴雨";
            break;
        case 17:
            str = @"雷阵雨伴有冰雹";
            break;
        case 18:
            str = @"雨夹雪";
            break;
        case 19:
            str = @"冻雨";
            break;
        case 20:
            str = @"晴";
            break;
        case 21:
            str = @"晴";
            break;
        case 22:
            str = @"晴";
            break;
        case 23:
            str = @"晴";
            break;
        case 24:
            str = @"晴";
            break;
        case 25:
            str = @"晴";
            break;
        case 26:
            str = @"晴";
            break;
        case 27:
            str = @"晴";
            break;
        case 28:
            str = @"晴";
            break;
        case 29:
            str = @"晴";
            break;
        case 30:
            str = @"晴";
            break;
        case 31:
            str = @"晴";
            break;
        case 32:
            str = @"晴";
            break;
        default:
            str = @"icnHeavyRain";
            break;
    }
    
    return str;
}

@end
