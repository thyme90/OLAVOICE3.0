//
//  BaikeTableViewCell.m
//  DialogDemo
//
//  Created by yanminli on 2016/10/28.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import "BaikeTableViewCell.h"
#import "commonHeader.h"

@interface itemLabel()<UITextViewDelegate>
@property (nonatomic,strong) UILabel    *leftLabel;
@property (nonatomic,strong) UILabel    *rightLabel;

@end

@implementation itemLabel
-(id)init{
    if (self = [super init]) {
        [self setupView];
        [self setLayout];
    }
    
    return self;
}


-(void)setupView{
    _leftLabel = [[UILabel alloc] init];
    _leftLabel.textAlignment = NSTextAlignmentLeft;
    _leftLabel.textColor = COLOR(255, 255, 255, 1);
    _leftLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:_leftLabel];
    
    _rightLabel = [[UILabel alloc] init];
    _rightLabel.textAlignment = NSTextAlignmentRight;
    _rightLabel.textColor = COLOR(255, 255, 255, 1);
    _rightLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:_rightLabel];
}

-(void)setLayout{
    _leftLabel.sd_layout
    .leftSpaceToView(self,0)
    .topSpaceToView(self,0)
    .widthRatioToView(self,0.2)
    .autoHeightRatio(0);
    
    _rightLabel.sd_layout
    .rightSpaceToView(self,0)
    .topSpaceToView(self,0)
    .widthRatioToView(self,0.8)
    .autoHeightRatio(0);
    
    [self setupAutoHeightWithBottomView:_rightLabel bottomMargin:0];
    
}

-(void)setData:(NSString*)leftValue rightValue:(NSString*)rightVal{
    _leftLabel.text = leftValue;
    _rightLabel.text = rightVal;
}


@end


//////#######################################################################
@interface BaikeTableViewCell()
@property (nonatomic,strong) UILabel                *ttsLabel;
//@property (nonatomic,strong) UILabel                *contentLabel;
@property (nonatomic,strong) UIView                 *backView;
@property (nonatomic,strong) UIView                 *lastBottomLine;
@property (nonatomic,strong) NSMutableArray         *itemLabelArray;
@property (nonatomic,strong) UITextView             *textView;
@property (nonatomic,strong) UIImageView            *imgView;
@property (nonatomic,strong) UIButton               *showButton;//按钮

@end


@implementation BaikeTableViewCell

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
    _ttsLabel.textAlignment = NSTextAlignmentLeft;
    _ttsLabel.font = [UIFont systemFontOfSize:16];
    _ttsLabel.textColor = COLOR(255, 255, 255, 1);
    //_ttsLabel.text = @"周杰伦的资料如下";
    [self.contentView addSubview:_ttsLabel];
    
    //内容
    _backView = [[UIView alloc] init];
    _backView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"透明白背板"]];
    [self.contentView addSubview:_backView];
    
}

-(void)setModel:(BaikeiModel *)model{
    _model = model;
    _ttsLabel.text = model.ttsStr;
    
    if (!model.buttonIsShow) {
        //清除_backView的所有子控件，然后重新生成
        [_backView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        _textView = [[UITextView alloc] init];
        _textView.font = [UIFont systemFontOfSize:15];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.textColor = COLOR(255, 255, 255, 1);
        _textView.editable = NO;
        _textView.scrollEnabled = NO;
        [_backView addSubview:_textView];
        
        if (![_model.photo_url isEmpty]) {
            _imgView = [[UIImageView alloc] init];
            [_backView addSubview:_imgView];
            CGRect rect = CGRectMake(0, 0, 90, 90);
            //设置环绕的路径
            UIBezierPath * path = [UIBezierPath bezierPathWithRect:rect];
            _textView.textContainer.exclusionPaths = @[path];
            
            [_imgView sd_setImageWithURL:[NSURL URLWithString:_model.photo_url] placeholderImage:[UIImage imageNamed:@"icnPicGrey"] options:SDWebImageProgressiveDownload];
        }
        
        _itemLabelArray = [[NSMutableArray alloc] init];
        for (int i=0; i<_model.field_name.count; i++) {
            itemLabel *label = [[itemLabel alloc] init];
            NSString    *leftVal  = [_model.field_name objectAtIndex:i];
            NSString    *rightVal = [_model.field_value objectAtIndex:i];
            [label setData:leftVal rightValue:rightVal];
            [_backView addSubview:label];
            [_itemLabelArray addObject:label];
            
        }
        
        _textView.text = _model.descr;
        [self setAllLayout];
    }else{
        [_backView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        _textView = [[UITextView alloc] init];
        _textView.font = [UIFont systemFontOfSize:15];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.textColor = COLOR(255, 255, 255, 1);
        _textView.editable = NO;
        _textView.scrollEnabled = NO;
        [_backView addSubview:_textView];
        
        //如果没有图片，就不需要进行图片环绕
        if (![_model.photo_url isEmpty]) {
            _imgView = [[UIImageView alloc] init];
            [_backView addSubview:_imgView];
            CGRect rect = CGRectMake(0, 0, 90, 90);
            //设置环绕的路径
            UIBezierPath * path = [UIBezierPath bezierPathWithRect:rect];
            _textView.textContainer.exclusionPaths = @[path];
            
            [_imgView sd_setImageWithURL:[NSURL URLWithString:_model.photo_url] placeholderImage:[UIImage imageNamed:@"icnPicGrey"] options:SDWebImageProgressiveDownload];
        }

        
        _showButton = [[UIButton alloc] init];
        [_showButton setImage:[UIImage imageNamed:@"icnDownArrow"] forState:UIControlStateNormal];
        [_showButton setImage:[UIImage imageNamed:@"icnDownArrow"] forState:UIControlStateSelected];
        UIImage *bgImage = [UIImage imageNamed:@"buttonbak"];
        _showButton.backgroundColor = [UIColor colorWithPatternImage:bgImage];

        _showButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _showButton.imageView.contentMode = UIViewContentModeCenter;
        
        [self.backView addSubview:_showButton];
        [_showButton addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        [self setShortLayout];
    }
}

-(void)setAllLayout{
    _ttsLabel.sd_layout
    .leftSpaceToView(self.contentView,15)
    .topSpaceToView(self.contentView,0)
    .rightSpaceToView(self.contentView,0)
    .autoHeightRatio(0);
    
    //float textHeight = [self heightForString:_model.descr fontSize:14 andWidth:self.contentView.frame.size.width];
   float textHeight = [self heightForString:_textView andWidth:self.contentView.frame.size.width];
    //字符的高度最小为90
    if (textHeight < 100) {
        textHeight = 100.0f;
    }
    if (_itemLabelArray.count != 0) {
        
        if (![_model.photo_url isEmpty]){
            _imgView.sd_layout
            .leftSpaceToView(_backView,15)
            .topSpaceToView(_backView,25)
            .widthIs(85)
            .heightIs(85);
        }
        
        _textView.sd_layout
        .leftSpaceToView(_backView,15)
        .topSpaceToView(_backView,15)
        .rightSpaceToView(_backView,15)
        .heightIs(textHeight);
        
        
        itemLabel   *label1 = [_itemLabelArray objectAtIndex:0];
        label1.sd_layout
        .leftSpaceToView(_backView,15)
        .topSpaceToView(_textView,0)
        .rightSpaceToView(_backView,15)
        .autoHeightRatio(0);
        
        _lastBottomLine = [self addSeparatorLineBellowView:label1 margin:10];
        
        for (int i=1; i<_itemLabelArray.count; i++) {
            itemLabel   *tmp = [_itemLabelArray objectAtIndex:i];
            tmp.sd_layout
            .leftSpaceToView(_backView,15)
            .topSpaceToView(_lastBottomLine,10)
            .rightSpaceToView(_backView,15)
            .autoHeightRatio(0);
            
            _lastBottomLine = [self addSeparatorLineBellowView:tmp margin:10];
        }
        
        _backView.sd_layout
        .leftSpaceToView(self.contentView,0)
        .topSpaceToView(_ttsLabel,12)
        .rightSpaceToView(self.contentView,0);
        
        
        [_backView setupAutoHeightWithBottomView:_lastBottomLine bottomMargin:1];
        [self setupAutoHeightWithBottomView:_backView bottomMargin:5];
    }else{
        [self setupAutoHeightWithBottomView:_ttsLabel bottomMargin:0];
    }
}


-(void)setShortLayout{
    _ttsLabel.sd_layout
    .leftSpaceToView(self.contentView,15)
    .topSpaceToView(self.contentView,0)
    .rightSpaceToView(self.contentView,0)
    .autoHeightRatio(0);
    
    if (_textView.text.length > 100) {
        _textView.text = [_model.descr substringWithRange:NSMakeRange(0, 100)];
    }else{
        _textView.text = _model.descr;
    }
    
    float textHeight = [self heightForString:_textView andWidth:self.contentView.frame.size.width];
    //字符的高度最小为90
    if (textHeight < 100) {
        textHeight = 100.0f;
    }
    
    
    if (![_model.photo_url isEmpty]){
        _imgView.sd_layout
        .leftSpaceToView(_backView,15)
        .topSpaceToView(_backView,25)
        .widthIs(85)
        .heightIs(85);
    }

    _textView.sd_layout
    .leftSpaceToView(_backView,15)
    .topSpaceToView(_backView,15)
    .rightSpaceToView(_backView,15)
    .heightIs(textHeight);
    
    _showButton.sd_layout
    .leftSpaceToView(_backView,0)
    .topSpaceToView(_textView,0)
    .rightSpaceToView(_backView,0)
    .heightIs(20);
    
    _backView.sd_layout
    .leftSpaceToView(self.contentView,0)
    .topSpaceToView(_ttsLabel,12)
    .rightSpaceToView(self.contentView,0);

    
    [_backView setupAutoHeightWithBottomView:_showButton bottomMargin:0];
    [self setupAutoHeightWithBottomView:_backView bottomMargin:5];
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



//根据文字计算textView的高度
- (float) heightForString:(UITextView *)textView andWidth:(float)width{
    CGSize sizeToFit = [textView sizeThatFits:CGSizeMake(width-16, MAXFLOAT)];
    return sizeToFit.height-16;
}


-(void)buttonClick{
    if ([self.delegate respondsToSelector:@selector(UnfoldCellDidClickUnfoldBtn:)]) {
        [self.delegate UnfoldCellDidClickUnfoldBtn:self.model];
    }

}

@end
