//
//  WeatherTableViewCell.m
//  NoScreenAudio
//
//  Created by yanminli on 2016/10/20.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import "WeatherTableViewCell.h"
#import "SDAutoLayout.h"
#import "commonHeader.h"

#define KW [UIScreen mainScreen].bounds.size.width/375
#define KH [UIScreen mainScreen].bounds.size.height/667

#define LABELMAXWIDTH    200  //label的最大宽度

@interface WeatherItemView()
@property (nonatomic,strong) UILabel            *weekday;//显示星期几
@property (nonatomic,strong) UIImageView        *iconImg;//显示天气图标
@property (nonatomic,strong) UILabel            *temperature_high_low;//温度范围
@property (nonatomic,strong) UILabel            *descr;//天气状况
@property (nonatomic,strong) UIView             *tempIcon;//温度的标志，目前是个圆

@end

@implementation WeatherItemView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

-(id)init{
    if (self = [super init]) {
        [self setupView];
        [self setLayout];
    }
    return self;
}

-(void)setupView{
    _weekday = [[UILabel alloc] init];
    _weekday.textAlignment = NSTextAlignmentCenter;
    _weekday.textColor = COLOR(255, 255, 255, 1);
    _weekday.font = [UIFont systemFontOfSize:12];
    [self addSubview:_weekday];
    
    
    
    _iconImg = [[UIImageView alloc] init];
    //_iconImg.backgroundColor = [UIColor blueColor];
    [self addSubview:_iconImg];
    
    _temperature_high_low = [[UILabel alloc] init];
    _temperature_high_low.textAlignment = NSTextAlignmentCenter;
    _temperature_high_low.textColor = COLOR(255, 255, 255, 1);
    _temperature_high_low.font = [UIFont systemFontOfSize:13];
    [self addSubview:_temperature_high_low];
    
    _tempIcon = [[UIView alloc] init];
    [self addSubview:_tempIcon];
    
    _descr = [[UILabel alloc] init];
    _descr.textAlignment = NSTextAlignmentCenter;
    _descr.textColor = COLOR(255, 255, 255, 1);
    _descr.font = [UIFont systemFontOfSize:12];
    [self addSubview:_descr];
}

-(void)setLayout{
    
    _weekday.sd_layout
    .leftSpaceToView(self,0)
    .topSpaceToView(self,12.5*KH)
    .rightSpaceToView(self,0)
    .autoHeightRatio(0);
    
    
    
    _iconImg.sd_layout
    .leftSpaceToView(self,30.7*KW)
    .topSpaceToView(_weekday,5*KH)
    .widthIs(30*KW)
    .heightIs(25*KH);
    
    _temperature_high_low.sd_layout
    .leftSpaceToView(self,0)
    .topSpaceToView(_iconImg,5*KH)
    .rightSpaceToView(self,0)
    .autoHeightRatio(0);
    
    _tempIcon.sd_layout
    .leftSpaceToView(self,67*KW)
    .topEqualToView(_temperature_high_low)
    .widthIs(6)
    .heightIs(6);
    
    
    _descr.sd_layout
    .leftSpaceToView(self,0)
    .topSpaceToView(_temperature_high_low,5*KH)
    .rightSpaceToView(self,0)
    .autoHeightRatio(0);
    
    
    [self setupAutoHeightWithBottomView:_descr bottomMargin:0];
}

-(void)setWeatherData:(WeatherData *)data{
    _weekday.text = data.weekDay;
    [_iconImg setImage:[UIImage imageNamed:data.weatherIcon]];
    _temperature_high_low.text = data.temperature_high_low;
    _descr.text = data.weatherdesc;
    UIImage *bgImage = [UIImage imageNamed:@"weather2"];
    _tempIcon.backgroundColor = [UIColor colorWithPatternImage:bgImage];
}

@end

//####################################################################

@interface WeatherTableViewCell()

@property (nonatomic,strong) UILabel        *ttsLabel;
@property (nonatomic,strong) UILabel        *current_temp;//实时温度
@property (nonatomic,strong) UILabel        *pm25;
@property (nonatomic,strong) UILabel        *temperature_high_low;//温度范围
@property (nonatomic,strong) UIImageView    *todayIcon;//提问时间的天气图标
@property (nonatomic,strong) UILabel        *desc;
@property (nonatomic,strong) UILabel            *currentDay;//当前询问时间的日期
@property (nonatomic,strong) UIImageView    *horizLine;//横间隔线
@property (nonatomic,strong) NSMutableArray     *arryDays;//保存生成的星期几的天数的view
@property (nonatomic,strong) UIView         *backView;
@property (nonatomic,strong) WeatherItemView    *itemView1;
@property (nonatomic,strong) WeatherItemView    *itemView2;
@property (nonatomic,strong) WeatherItemView    *itemView3;
@property (nonatomic,strong) WeatherItemView    *itemView4;
@property (nonatomic,strong) UIView        *VertexLine;//竖间隔线
@property (nonatomic,strong) WeatherData        *curWeatherData;//要显示的天气。由于显示当天和不是当天（例如明天的天气）
                                                                //的布局不一样，所以要进行分别对待。
@property (nonatomic,strong) UIView             *weatherIcon0;
@property (nonatomic,strong) UIView             *weatherIcon1;


@end

@implementation WeatherTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupView];
    }
    
    return self;
}

-(void)setupView{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    
    _ttsLabel = [[UILabel alloc] init];
    _ttsLabel.textAlignment = NSTextAlignmentLeft;
    _ttsLabel.textColor = COLOR(255, 255, 255, 1);
    _ttsLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:_ttsLabel];
    
    
    _backView = [[UIView alloc] init];
    _backView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"透明白背板"]];
    [self.contentView addSubview:_backView];
    
    //显示实时温度或者明后天的温度区间值
    _current_temp = [[UILabel alloc] init];
    _current_temp.textAlignment = NSTextAlignmentCenter;
    _current_temp.textColor = COLOR(255, 255, 255, 1);
    _current_temp.font = [UIFont systemFontOfSize:70];
    [_backView addSubview:_current_temp];
    
    _weatherIcon0 = [[UIView alloc] init];
    UIImage *bgImage = [UIImage imageNamed:@"weather0"];
    _weatherIcon0.backgroundColor = [UIColor colorWithPatternImage:bgImage];
    [_backView addSubview:_weatherIcon0];

    
    _pm25 = [[UILabel alloc] init];
    _pm25.textAlignment = NSTextAlignmentCenter;
    _pm25.textColor = COLOR(255, 255, 255, 1);
    _pm25.font = [UIFont systemFontOfSize:14];
    bgImage = [UIImage imageNamed:@"透明黑底"];
    _pm25.backgroundColor = [UIColor colorWithPatternImage:bgImage];
    [_backView addSubview:_pm25];
    
    _temperature_high_low = [[UILabel alloc] init];
    _temperature_high_low.textAlignment = NSTextAlignmentCenter;
    _temperature_high_low.textColor = COLOR(255, 255, 255, 1);
    [_backView addSubview:_temperature_high_low];
    
    _weatherIcon1 = [[UIView alloc] init];
    [_backView addSubview:_weatherIcon1];

    
    _todayIcon = [[UIImageView alloc] init];
    [_backView addSubview:_todayIcon];
    
    _currentDay = [[UILabel alloc] init];
    _currentDay.textAlignment = NSTextAlignmentCenter;
    _currentDay.textColor = COLOR(255, 255, 255, 0.5);
    _currentDay.font = [UIFont systemFontOfSize:11];
    [_backView addSubview:_currentDay];
   
    
    _desc = [[UILabel alloc] init];
    _desc.textAlignment = NSTextAlignmentCenter;
    _desc.textColor = COLOR(255, 255, 255, 1);
    _desc.font = [UIFont systemFontOfSize:15];
    [_backView addSubview:_desc];
    
    _horizLine = [[UIImageView alloc] init];
    _horizLine.backgroundColor = [UIColor whiteColor];
    [_backView addSubview:_horizLine];
    
    _arryDays = [[NSMutableArray alloc] init];
    
    _itemView1 = [[WeatherItemView alloc] init];
    [_backView addSubview:_itemView1];
    [_arryDays addObject:_itemView1];
    
    _itemView2 = [[WeatherItemView alloc] init];
    [_backView addSubview:_itemView2];
    [_arryDays addObject:_itemView2];
    
    _itemView3 = [[WeatherItemView alloc] init];
    [_backView addSubview:_itemView3];
    [_arryDays addObject:_itemView3];
    
    _itemView4 = [[WeatherItemView alloc] init];
    [_backView addSubview:_itemView4];
    [_arryDays addObject:_itemView4];

}

-(void)setModel:(WeatherModel *)model{
    _model = model;
    [self setData:model];
    [self setLayout];
}


-(void)setData:(WeatherModel*)model{
    _ttsLabel.text = model.ttsStr;
    NSMutableArray *tmpData = [[NSMutableArray alloc] init];
    unsigned long num = 5;
    if (model.weatherDataArry.count <= num) {
        num = model.weatherDataArry.count;
    }
    
    for (int i=0; i<num; i++) {
        WeatherData *data = [model.weatherDataArry objectAtIndex:i];
        if (data.is_query == 1) {
            _curWeatherData = data;
            _current_temp.text = data.current_temperature;
            _temperature_high_low.text = data.temperature_high_low;
            [_todayIcon setImage:[UIImage imageNamed:data.weatherIcon]];
            if (data.pm != nil) {
                NSString *str = [[NSString alloc] initWithFormat:@" 今日: %@ ",data.pm];
                NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:str];
                [attriStr addAttribute:NSForegroundColorAttributeName value:COLOR(164, 246, 150, 1) range:NSMakeRange(5,data.pm.length)];
                _pm25.attributedText = attriStr;
                
            }
            _desc.text = data.weatherdesc;
            NSString *str = [[NSString alloc] initWithFormat:@"%@ %@",data.weekDay,data.yearDay];
            _currentDay.text = str;
            
        }else{
            [tmpData addObject:data];
        }
    }
    
    for (int i=0; i<tmpData.count; i++) {
        WeatherData *data = [tmpData objectAtIndex:i];
        WeatherItemView *itemView = [_arryDays objectAtIndex:i];
        [itemView setWeatherData:data];
        
    }
}

-(void)setLayout{
    _ttsLabel.sd_layout
    .leftSpaceToView(self.contentView,15*KW)
    .topSpaceToView(self.contentView,0)
    .rightSpaceToView(self.contentView,15*KW)
    .autoHeightRatio(0);
         
    _backView.sd_layout
    .leftSpaceToView(self.contentView,0)
    .topSpaceToView(_ttsLabel,12*KW)
    .rightSpaceToView(self.contentView,0);
    
    //如果is_today为0说明询问的是当天的天气，否则不是。
    if (_curWeatherData.is_today == 0) {
        _current_temp.sd_layout
        .leftSpaceToView(_backView,43*KW)
        .topSpaceToView(_backView,51*KH)
        .autoHeightRatio(0);
        [_current_temp setSingleLineAutoResizeWithMaxWidth:LABELMAXWIDTH];
        
        _weatherIcon0.sd_layout
        .leftSpaceToView(_current_temp,10*KW)
        .topSpaceToView(_backView,50*KH)
        .widthIs(20)
        .heightIs(20);
        
        _pm25.sd_layout
        .leftEqualToView(_current_temp)
        .topSpaceToView(_current_temp,5*KH)
        .autoHeightRatio(0);
        [_pm25 setSingleLineAutoResizeWithMaxWidth:200];
        
        _temperature_high_low.sd_layout
        .leftSpaceToView(_backView,225*KW)
        .topSpaceToView(_backView,60*KH)
        .heightIs(18*KH);
        [_temperature_high_low setSingleLineAutoResizeWithMaxWidth:LABELMAXWIDTH];
        _temperature_high_low.font = [UIFont systemFontOfSize:21];
        
        UIImage *bgImage = [UIImage imageNamed:@"weather1"];
        _weatherIcon1.backgroundColor = [UIColor colorWithPatternImage:bgImage];
        _weatherIcon1.sd_layout
        .leftSpaceToView(_temperature_high_low,0)
        .topSpaceToView(_backView,54.5*KH)
        .widthIs(7)
        .heightIs(7);

        
    }else{
        _temperature_high_low.sd_layout
        .leftSpaceToView(_backView,43*KW)
        .topSpaceToView(_backView,56*KH)
        .heightIs(43*KH);
        [_temperature_high_low setSingleLineAutoResizeWithMaxWidth:LABELMAXWIDTH];

        _temperature_high_low.font = [UIFont systemFontOfSize:50];
        
        UIImage *bgImage = [UIImage imageNamed:@"weather1"];
        _weatherIcon1.backgroundColor = [UIColor colorWithPatternImage:bgImage];
        _weatherIcon1.sd_layout
        .leftSpaceToView(_temperature_high_low,0)
        .topSpaceToView(_backView,54.5*KH)
        .widthIs(7)
        .heightIs(7);

    }
    
    _todayIcon.sd_layout
    .leftSpaceToView(_backView,318*KW)
    .topSpaceToView(_backView,54*KH)
    .widthIs(32*KW)
    .heightIs(30*KH);
    
    _desc.sd_layout
    .leftSpaceToView(_backView,256*KW)
    .topSpaceToView(_backView,92*KH)
    .heightIs(16*KH);
    [_desc setSingleLineAutoResizeWithMaxWidth:100];
    
    _currentDay.sd_layout
    .leftSpaceToView(_backView,250.5*KW)
    .topSpaceToView(_desc,4*KH)
    .heightIs(12*KH);
    [_currentDay setSingleLineAutoResizeWithMaxWidth:100];
    
    
    
    //横线，开始布局四天的天气
    _horizLine.sd_layout
    .leftSpaceToView(_backView,0)
    .topSpaceToView(_currentDay,68.5*KH)
    .rightSpaceToView(_backView,0)
    .heightIs(1*KH);
    
    
    _itemView1.sd_layout
    .leftSpaceToView(_backView,0)
    .topSpaceToView(_horizLine,0)
    .rightSpaceToView(_backView,282*KW)
    .heightIs(116.5*KH);
    
    _VertexLine = [self addSeparatorLineRightView:_itemView1];
    
    _itemView2.sd_layout
    .leftSpaceToView(_itemView1,1*KW)
    .topEqualToView(_itemView1)
    .bottomEqualToView(_itemView1)
    .widthRatioToView(_itemView1,1);
    
    _VertexLine = [self addSeparatorLineRightView:_itemView2];

    
    _itemView3.sd_layout
    .leftSpaceToView(_itemView2,1*KW)
    .topEqualToView(_itemView1)
    .bottomEqualToView(_itemView1)
    .widthRatioToView(_itemView1,1);
    
    _VertexLine = [self addSeparatorLineRightView:_itemView3];

    _itemView4.sd_layout
    .leftSpaceToView(_itemView3,1*KW)
    .topEqualToView(_itemView1)
    .bottomEqualToView(_itemView1)
    .widthRatioToView(_itemView1,1);
    
    [_backView setupAutoHeightWithBottomView:_itemView1 bottomMargin:10];
    [self setupAutoHeightWithBottomView:_backView bottomMargin:1];
    
}

//生成间隔线
- (UIView *)addSeparatorLineRightView:(UIView *)view
{
    UIView *line = [UIView new];
    line.backgroundColor = [UIColor whiteColor];
    [self.backView addSubview:line];
    
    line.sd_layout
    .leftSpaceToView(view, 0)
    .topSpaceToView(_horizLine, 12.5*KH)
    .widthIs(1)
    .heightIs(87*KH);
    
    
    return line;
}



@end
