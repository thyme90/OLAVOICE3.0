//
//  WeatherTableViewCell.h
//  NoScreenAudio
//
//  Created by yanminli on 2016/10/20.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherModel.h"
#import "CellTableViewCell.h"

@interface WeatherItemView : UIView
-(id)init;
-(void)setWeatherData:(WeatherData*)data;

@end

@interface WeatherTableViewCell : CellTableViewCell
@property (nonatomic,strong) WeatherModel       *model;

@end
