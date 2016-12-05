//
//  NewsContentTableViewCell.m
//  testSDLayout
//
//  Created by yanminli on 2016/10/26.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import "NewsContentTableViewCell.h"
#import "commonHeader.h"


@interface NewsContentTableViewCell()
@property (nonatomic,strong) UILabel        *ttsLabel;
@property (nonatomic,strong) UILabel        *labelTime;
@property (nonatomic,strong) UILabel        *labelSource;
@property (nonatomic,strong) UIView         *labelView;
@property (nonatomic,strong) UILabel        *titleLabel;
@property (nonatomic,strong) UILabel        *contentLabel;
@property (nonatomic,strong) UIView         *backView;
@property (nonatomic,strong) UIImageView    *imgView;
@property (nonatomic,strong) UIView         *bgView;
@property (nonatomic,strong) UIButton       *showButton;//按钮
@end

@implementation NewsContentTableViewCell

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
    self.selectionStyle = UITableViewCellSelectionStyleNone;//不可选择
    self.backgroundColor = [UIColor clearColor];
    
    //整个Cell标题
    _ttsLabel = [[UILabel alloc] init];
    _ttsLabel.font = [UIFont systemFontOfSize:16];
    _ttsLabel.textColor = COLOR(255, 255, 255, 1);
    [self.contentView addSubview:_ttsLabel];
    
    
    //内容
    _backView = [[UIView alloc] init];
    _backView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"透明白背板"]];
    [self.contentView addSubview:_backView];
    
    //图片
    _imgView = [[UIImageView alloc] init];
    _imgView.contentMode = UIViewContentModeScaleToFill;
    [_backView addSubview:_imgView];
    
    //渐变色的背景图片
    _bgView = [[UIView alloc] init];
    UIImage *bgImage = [UIImage imageNamed:@"newsbg"];
    _bgView.backgroundColor = [UIColor colorWithPatternImage:bgImage];
    [_backView addSubview:_bgView];

    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = NSTextAlignmentLeft;
    _titleLabel.font = [UIFont systemFontOfSize:15 weight:22.5];
    _titleLabel.textColor = COLOR(255, 255, 255, 1);
    [_backView addSubview:_titleLabel];

    
    _labelView = [[UIView alloc] init];
    _labelView.backgroundColor = [UIColor clearColor];
    [_backView addSubview:_labelView];
    
    _labelTime = [[UILabel alloc] init];
    _labelTime.textAlignment = NSTextAlignmentLeft;
    _labelTime.font = [UIFont systemFontOfSize:16 weight:22.5];
    _labelTime.textColor = COLOR(255, 255, 255, 0.5);
    [self.labelView addSubview:_labelTime];
    
    _labelSource = [[UILabel alloc] init];
    _labelSource.textAlignment = NSTextAlignmentRight;
    _labelSource.font = [UIFont systemFontOfSize:14];
    _labelSource.textColor = COLOR(119, 199, 255, 0.5);
    [self.labelView addSubview:_labelSource];
    
    
    

}



-(void)setModel:(NewsContentModel*)model{
    _model = model;
    _ttsLabel.text = model.ttsStr;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:model.image_url] placeholderImage:[UIImage imageNamed:@"icnPicGrey"] options:SDWebImageProgressiveDownload];
    //去掉前后的空格和换行
    _titleLabel.text = [model.title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    _labelTime.text = [model.time stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    _labelSource.text = [model.source stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if (!model.buttonIsShow) {
        [_showButton removeFromSuperview];
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont systemFontOfSize:15 weight:22.5];
        _contentLabel.textColor = COLOR(255, 255, 255, 1);
        _contentLabel.text = model.detail;
        [_backView addSubview:_contentLabel];
        
        [self setLayout];
    }else{
        [_contentLabel removeFromSuperview];
        _showButton = [[UIButton alloc] init];
        [_showButton setImage:[UIImage imageNamed:@"icnRightArrow"] forState:UIControlStateNormal];
        //[_showButton setImage:[UIImage imageNamed:@"icnRightArrow"] forState:UIControlStateSelected];
        UIImage *bgImage = [UIImage imageNamed:@"buttonbak"];
        _showButton.backgroundColor = [UIColor colorWithPatternImage:bgImage];
        _showButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _showButton.imageView.contentMode = UIViewContentModeCenter;
        
        [self.backView addSubview:_showButton];
        [_showButton addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];

        [self setShortLayout];
    }
    
}



-(void)setLayout{
    _ttsLabel.sd_layout
    .leftSpaceToView(self.contentView,15.5)
    .topSpaceToView(self.contentView,0)
    .autoHeightRatio(0);
    [_ttsLabel setSingleLineAutoResizeWithMaxWidth:self.contentView.frame.size.width];

    
 
    //背景色图片布局
    _backView.sd_layout
    .leftSpaceToView(self.contentView,0)
    .topSpaceToView(_ttsLabel,12)
    .rightSpaceToView(self.contentView,0);
    
    //新闻图片布局
    _imgView.sd_layout
    .leftSpaceToView(_backView,15)
    .topSpaceToView(_backView,15)
    .rightSpaceToView(_backView,15)
    .heightIs(194);
 
    //渐变色的背景图片布局
    _bgView.sd_layout
    .leftEqualToView(_imgView)
    .rightEqualToView(_imgView)
    .bottomEqualToView(_imgView)
    .heightIs(70);
    
    _titleLabel.sd_layout
    .leftSpaceToView(_backView,15)
    .topSpaceToView(_backView,145)
    .rightSpaceToView(_backView,15)
    .autoHeightRatio(0);
    
    
    _labelView.sd_layout
    .leftEqualToView(_titleLabel)
    .topSpaceToView(_titleLabel,12)
    .rightSpaceToView(_backView,15)
    .heightIs(20);
    
    
     _labelTime.sd_layout
    .leftSpaceToView(_labelView,0)
    .topSpaceToView(_labelView,0)
    .rightSpaceToView(_labelView,0)
    .autoHeightRatio(0);

    _labelSource.sd_layout
    .topEqualToView(_labelTime)
    .rightSpaceToView(_labelView,0)
    .autoHeightRatio(0);
    
    

    _contentLabel.sd_layout
    .leftEqualToView(_imgView)
    .topSpaceToView(_imgView,20)
    .rightEqualToView(_imgView)
    .autoHeightRatio(0);
    
    [_backView setupAutoHeightWithBottomView:_contentLabel bottomMargin:0];
    //[_scrollView setupAutoHeightWithBottomView:_backView bottomMargin:1];
    [self setupAutoHeightWithBottomView:_backView bottomMargin:0];
    
}

-(void)setShortLayout{
    _ttsLabel.sd_layout
    .leftSpaceToView(self.contentView,15.5)
    .topSpaceToView(self.contentView,0)
    .autoHeightRatio(0);
    [_ttsLabel setSingleLineAutoResizeWithMaxWidth:self.contentView.frame.size.width];
    
    //新闻图片布局
    _imgView.sd_layout
    .leftSpaceToView(_backView,15)
    .topSpaceToView(_backView,15)
    .rightSpaceToView(_backView,15)
    .heightIs(194);
    
    //渐变色的背景图片布局
    _bgView.sd_layout
    .leftEqualToView(_imgView)
    .rightEqualToView(_imgView)
    .bottomEqualToView(_imgView)
    .heightIs(70);
    
    _titleLabel.sd_layout
    .leftSpaceToView(_backView,15)
    .topSpaceToView(_backView,145)
    .rightSpaceToView(_backView,15)
    .autoHeightRatio(0);
    
    
    _labelView.sd_layout
    .leftEqualToView(_titleLabel)
    .topSpaceToView(_titleLabel,12)
    .rightSpaceToView(_backView,15)
    .heightIs(20);
    
    
    _labelTime.sd_layout
    .leftSpaceToView(_labelView,0)
    .topSpaceToView(_labelView,0)
    .rightSpaceToView(_labelView,0)
    .autoHeightRatio(0);
    
    _labelSource.sd_layout
    .topEqualToView(_labelTime)
    .rightSpaceToView(_labelView,0)
    .autoHeightRatio(0);
    
    _showButton.sd_layout
    .leftSpaceToView(_backView,0)
    .topSpaceToView(_imgView,0)
    .rightSpaceToView(_backView,0)
    .heightIs(20);
    
    //背景色图片布局
    _backView.sd_layout
    .leftSpaceToView(self.contentView,0)
    .topSpaceToView(_ttsLabel,12)
    .rightSpaceToView(self.contentView,0);
    
    
    [_backView setupAutoHeightWithBottomView:_showButton bottomMargin:0];
    [self setupAutoHeightWithBottomView:_backView bottomMargin:0];

}

-(void)buttonClick{
    if ([self.delegate respondsToSelector:@selector(UnfoldCellDidClickUnfoldBtn:)]) {
        [self.delegate UnfoldCellDidClickUnfoldBtn:self.model];
    }
    
}

@end
