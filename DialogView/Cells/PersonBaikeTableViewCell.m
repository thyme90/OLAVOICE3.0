//
//  PersonBaikeTableViewCell.m
//  DialogDemo
//
//  Created by yanminli on 2016/10/31.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import "PersonBaikeTableViewCell.h"
#import "commonHeader.h"

@interface PersonBaikeItemView()
@property (nonatomic,strong) UILabel        *numLabel;
//@property (nonatomic,strong) UIImageView    *imgView;
@property (nonatomic,strong) UILabel        *upLabel;
@property (nonatomic,strong) UILabel        *downLabel;

@end

@implementation PersonBaikeItemView
-(id)init{
    if (self = [super init]) {
        [self setupView];
        [self setLayout];
    }
    
    return self;
}

-(void)setupView{
    _numLabel  = [[UILabel alloc] init];
    _numLabel.textAlignment = NSTextAlignmentCenter;
    _numLabel.textColor = COLOR(255, 255, 255, 1);
    _numLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:_numLabel];
    
    
//    _imgView = [[UIImageView alloc] init];
//    [self addSubview:_imgView];
    
    _upLabel  = [[UILabel alloc] init];
    _upLabel.textAlignment = NSTextAlignmentLeft;
    _upLabel.textColor = COLOR(255, 255, 255, 1);
    _upLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:_upLabel];
    
    _downLabel  = [[UILabel alloc] init];
    _downLabel.textAlignment = NSTextAlignmentLeft;
    _downLabel.textColor = COLOR(255, 255, 255, 1);
    _downLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:_downLabel];
}

-(void)setLayout{
    _numLabel.sd_layout
    .leftSpaceToView(self,25)
    .topSpaceToView(self,33)
    .autoHeightRatio(0);
    [_numLabel setSingleLineAutoResizeWithMaxWidth:20];
    
//    _imgView.sd_layout
//    .leftSpaceToView(_numLabel,26)
//    .topSpaceToView(self,12.5)
//    .widthIs(55)
//    .heightIs(55);
    
    _upLabel.sd_layout
    .leftSpaceToView(_numLabel,30)
    .topSpaceToView(self,20)
    .autoHeightRatio(0);
    [_upLabel setSingleLineAutoResizeWithMaxWidth:self.frame.size.width];
    
    _downLabel.sd_layout
    .leftEqualToView(_upLabel)
    .topSpaceToView(_upLabel,5)
    .rightEqualToView(_upLabel)
    .autoHeightRatio(0);
}

-(void)setDatas:(PersonBaikeData*) personData num:(NSString*)num{
    _numLabel.text = num;
//    [_imgView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"icnPicGrey"] options:SDWebImageProgressiveDownload];
    NSString    *upStr = [[NSString alloc] initWithFormat:@"%@ %@ - %@",personData.personName,personData.startTime,personData.endTime];
    _upLabel.text = upStr;
    
    NSString    *downStr = [[NSString alloc] initWithFormat:@"%@ %@ %@",personData.nation,personData.postOfTimes,personData.post];
    _downLabel.text = downStr;
    _viewNum = [num intValue];
}
@end

//###########################################################//

@interface PersonBaikeTableViewCell()
@property (nonatomic,strong) UILabel                *ttsLabel;
@property (nonatomic,strong) UIView                 *backView;
@property (nonatomic,strong) NSMutableArray         *itemLabelArray;
@property (nonatomic,strong) UIView                 *lastBottomLine;
@property (nonatomic,strong) PersonBaikeItemView    *itemView;
@property (nonatomic,strong) UIButton               *showButton;//按钮
@property (nonatomic,strong) PersonBaikeItemView    *shortItemView;
@end




@implementation PersonBaikeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupView];
    }
    
    return self;
}

-(void)setupView{
    self.selectionStyle = UITableViewCellSelectionStyleNone;//不可选择
    self.backgroundColor = [UIColor clearColor];
    
    //整个Cell标题
    _ttsLabel = [[UILabel alloc] init];
    _ttsLabel.textAlignment = NSTextAlignmentLeft;
    _ttsLabel.font = [UIFont systemFontOfSize:16];
    _ttsLabel.textColor = COLOR(255, 255, 255, 1);
    [self.contentView addSubview:_ttsLabel];
    
    //内容
    _backView = [[UIView alloc] init];
    _backView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"透明白背板"]];
    //_backView.backgroundColor = [UIColor blueColor];
    [self.contentView addSubview:_backView];
}


-(void)setModel:(PersonBaikeModel *)model{
    _model = model;
    _ttsLabel.text = model.ttsStr;
    if (!model.buttonIsShow) {
        [_backView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        _itemLabelArray = [[NSMutableArray alloc] init];
        for (int i=0; i<_model.personBaikeArray.count; i++) {
            PersonBaikeData    *data =  [_model.personBaikeArray objectAtIndex:i];
            PersonBaikeItemView *tmpView = [[PersonBaikeItemView alloc] init];
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickItem:)];
            [tmpView addGestureRecognizer:tapGesture];
            
            NSString *num = [[NSString alloc] initWithFormat:@"%d",i+1];
            [tmpView setDatas:data num:num];
            [_itemLabelArray addObject:tmpView];
            [_backView addSubview:tmpView];
        }
        
        [self setupLayout];
    }else{
        [_backView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        PersonBaikeData    *data =  [_model.personBaikeArray objectAtIndex:0];
        _shortItemView = [[PersonBaikeItemView alloc] init];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickItem:)];
        [_shortItemView addGestureRecognizer:tapGesture];
        
        NSString *num = [[NSString alloc] initWithFormat:@"%d",1];
        [_shortItemView setDatas:data num:num];
        [_backView addSubview:_shortItemView];

        
        _showButton = [[UIButton alloc] init];
        [_showButton setImage:[UIImage imageNamed:@"icnRightArrow"] forState:UIControlStateNormal];
        [_showButton setImage:[UIImage imageNamed:@"icnRightArrow"] forState:UIControlStateSelected];
        UIImage *bgImage = [UIImage imageNamed:@"buttonbak"];
        _showButton.backgroundColor = [UIColor colorWithPatternImage:bgImage];
        _showButton.imageView.contentMode = UIViewContentModeCenter;
        [_backView addSubview:_showButton];
        [_showButton addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        [self setShortLayout];
    }
    

    
}

-(void)setupLayout{
    _ttsLabel.sd_layout
    .leftSpaceToView(self.contentView,15)
    .topSpaceToView(self.contentView,0)
    .rightSpaceToView(self.contentView,0)
    .autoHeightRatio(0);
    
    _itemView = [_itemLabelArray objectAtIndex:0];
    _itemView.sd_layout
    .leftSpaceToView(_backView,0)
    .topSpaceToView(_backView,0)
    .rightSpaceToView(_backView,0)
    .heightIs(80);
    
    _lastBottomLine = [self addSeparatorLineBellowView:_itemView margin:1];
    
    for (int i=1; i<_itemLabelArray.count; i++) {
        _itemView = [_itemLabelArray objectAtIndex:i];
        _itemView.sd_layout
        .leftSpaceToView(_backView,0)
        .topSpaceToView(_lastBottomLine,0)
        .rightSpaceToView(_backView,0)
        .heightIs(80);
        
        _lastBottomLine = [self addSeparatorLineBellowView:_itemView margin:0];
    }
    
    
    _backView.sd_layout
    .leftSpaceToView(self.contentView,0)
    .topSpaceToView(_ttsLabel,12)
    .rightSpaceToView(self.contentView,0);
    
    
    [_backView setupAutoHeightWithBottomView:_lastBottomLine bottomMargin:0];
    [self setupAutoHeightWithBottomView:_backView bottomMargin:0];


}

-(void)setShortLayout{
    _ttsLabel.sd_layout
    .leftSpaceToView(self.contentView,15)
    .topSpaceToView(self.contentView,0)
    .rightSpaceToView(self.contentView,0)
    .autoHeightRatio(0);
    
    
    _shortItemView.sd_layout
    .leftSpaceToView(_backView,0)
    .topSpaceToView(_backView,0)
    .rightSpaceToView(_backView,0)
    .heightIs(80);
    
    _showButton.sd_layout
    .leftSpaceToView(_backView,0)
    .topSpaceToView(_shortItemView,0)
    .rightSpaceToView(_backView,0)
    .heightIs(20);
    
    _backView.sd_layout
    .leftSpaceToView(self.contentView,0)
    .topSpaceToView(_ttsLabel,12)
    .rightSpaceToView(self.contentView,0);
    
    
    [_backView setupAutoHeightWithBottomView:_showButton bottomMargin:0];
    [self setupAutoHeightWithBottomView:_backView bottomMargin:0];
}

//生成间隔线
- (UIView *)addSeparatorLineBellowView:(UIView *)view margin:(CGFloat)margin
{
    UIView *line = [UIView new];
    line.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"line1"]];
    [self.backView addSubview:line];
    
    line.sd_layout
    .leftSpaceToView(self.backView, 5)
    .rightSpaceToView(self.backView, 5)
    .heightIs(1)
    .topSpaceToView(view, margin);
    
    return line;
}


-(void)clickItem:(UITapGestureRecognizer*)tap{
    
    PersonBaikeItemView *tmpView = (PersonBaikeItemView*)tap.view;
    int num = tmpView.viewNum;
    
    if (self.didSelectBlock) {
        self.didSelectBlock(num);
    }
}

-(void)buttonClick{
    if ([self.delegate respondsToSelector:@selector(UnfoldCellDidClickUnfoldBtn:)]) {
        [self.delegate UnfoldCellDidClickUnfoldBtn:self.model];
    }
    
}

@end
    

