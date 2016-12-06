//
//  NewsTableViewCell.m
//  testSDLayout
//
//  Created by yanminli on 2016/10/24.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import "NewsTableViewCell.h"
#import "commonHeader.h"
 
@interface NewsTitleView()
@property (nonatomic,strong) UIImageView        *imageView;
@property (nonatomic,strong) UILabel            *label;
@property (nonatomic,strong) UILabel            *numLabel;
@end

@implementation NewsTitleView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 [self setupView];
 }*/

-(id)init{
    if (self = [super init]) {
        [self setupView];
    }
    
    return self;
}

-(void)setupView{
    //self.backgroundColor = [UIColor clearColor];
    _numLabel = [[UILabel alloc] init];
    _numLabel.textAlignment = NSTextAlignmentCenter;
    _numLabel.textColor = COLOR(255, 255, 255, 1);
    _numLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:_numLabel];
    
    _imageView = [[UIImageView alloc] init];
    [self addSubview:_imageView];
    
    _label = [[UILabel alloc] init];
    _label.textAlignment = NSTextAlignmentLeft;
    _label.textColor = COLOR(255, 255, 255, 1);
    _label.font = [UIFont systemFontOfSize:15];
    [self addSubview:_label];
    
    [self setLayout];
    
    
    
    
}

-(void)setLayout{
    _numLabel.sd_layout
    .leftSpaceToView(self,15)
    .topSpaceToView(self,33)
    .autoHeightRatio(0);
    [_numLabel setSingleLineAutoResizeWithMaxWidth:20];
    
    _imageView.sd_layout
    .leftSpaceToView(_numLabel,26)
    .topSpaceToView(self,12.5)
    .widthIs(55)
    .heightIs(55);
    
    _label.sd_layout
    .leftSpaceToView(_imageView,18)
    .topSpaceToView(self,20)
    .rightSpaceToView(self,17)
    .autoHeightRatio(0);
    //[_label setSingleLineAutoResizeWithMaxWidth:self.frame.size.width];
}

-(void)setNewsData:(NewsData*)data num:(int)num{
    NSString *numStr = [[NSString alloc] initWithFormat:@"%d",num+1];
    _numLabel.text = numStr;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:data.image_url] placeholderImage:[UIImage imageNamed:@"icnPicGrey"] options:SDWebImageProgressiveDownload];
    NSString *str = [data.title stringByReplacingOccurrencesOfString:@" " withString:@""];
    _label.text = str;
    _viewNum = num+1;
}

@end


//################################################################

@interface NewsTableViewCell()
@property (nonatomic,strong) UILabel                *ttsLabel;
@property (nonatomic,strong) UIView                 *backView;
@property (nonatomic,strong) NewsTitleView          *titleView;
@property (nonatomic,strong) NewsTitleView          *shortTitleView;
@property (nonatomic,strong) UIView                 *lastBottomLine;
@property (nonatomic,strong) NSMutableArray         *titleViewArray;
@property (nonatomic,strong) UIButton               *showButton;//按钮
@end

@implementation NewsTableViewCell

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
    
    _ttsLabel = [[UILabel alloc] init];
    _ttsLabel.textAlignment = NSTextAlignmentLeft;
    _ttsLabel.font = [UIFont systemFontOfSize:16];
    _ttsLabel.textColor = COLOR(255, 255, 255, 1);
    [self.contentView addSubview:_ttsLabel];

    //设置背景图片的view
    _backView = [[UIView alloc] init];
    _backView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"透明白背板"]];
    //_backView.backgroundColor = [UIColor blueColor];
    [self.contentView addSubview:_backView];
    
}

-(void)setModel:(NewsModel *)model{
    _model = model;
    _ttsLabel.text = model.ttsStr;
    NSArray *arry = model.dataArry;
    if (!model.buttonIsShow) {
        [_backView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        _titleViewArray = [[NSMutableArray alloc] init];
        for (int i=0; i<arry.count; i++) {
            NewsData *data = [arry objectAtIndex:i];
            NewsTitleView *newsView = [[NewsTitleView alloc] init];
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickItem:)];
            [newsView addGestureRecognizer:tapGesture];
            [newsView setNewsData:data num:i];
            [_titleViewArray addObject:newsView];
            [_backView addSubview:newsView];
            
        }
        
        [self setLayout];
    }else{
        [_backView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        NewsData *data = [arry objectAtIndex:0];
        _shortTitleView = [[NewsTitleView alloc] init];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickItem:)];
        [_shortTitleView addGestureRecognizer:tapGesture];
        [_shortTitleView setNewsData:data num:0];
        [_backView addSubview:_shortTitleView];
            
        
        _showButton = [[UIButton alloc] init];
        [_showButton setImage:[UIImage imageNamed:@"icnDownArrow"] forState:UIControlStateNormal];
        [_showButton setImage:[UIImage imageNamed:@"icnDownArrow"] forState:UIControlStateSelected];
        UIImage *bgImage = [UIImage imageNamed:@"buttonbak"];
        _showButton.backgroundColor = [UIColor colorWithPatternImage:bgImage];
        _showButton.imageView.contentMode = UIViewContentModeCenter;
        [_backView addSubview:_showButton];
        [_showButton addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        [self setShortLayout];
    }
    
}



-(void)setLayout{
    _ttsLabel.sd_layout
    .leftSpaceToView(self.contentView,15)
    .topSpaceToView(self.contentView,0)
    .rightSpaceToView(self.contentView,0)
    .autoHeightRatio(0);
    
    
    //背景图片的布局
    _titleView = [_titleViewArray objectAtIndex:0];
    _titleView.sd_layout
    .leftSpaceToView(_backView,0)
    .topSpaceToView(_backView,0)
    .rightSpaceToView(_backView,0)
    .heightIs(80);
    _lastBottomLine = [self addSeparatorLineBellowView:_titleView margin:1];
    
    
    
    for (int i=1; i<_titleViewArray.count; i++) {
        _titleView = [_titleViewArray objectAtIndex:i];
        
        _titleView.sd_layout
        .leftSpaceToView(_backView,0)
        .topSpaceToView(_lastBottomLine,0)
        .rightSpaceToView(_backView,0)
        .heightIs(80);
        
//        if (i != _titleViewArray.count-1) {
//            _lastBottomLine = [self addSeparatorLineBellowView:_titleView margin:0];
//        }
        _lastBottomLine = [self addSeparatorLineBellowView:_titleView margin:0];
    }
    
    _backView.sd_layout
    .leftSpaceToView(self.contentView,0)
    .topSpaceToView(_ttsLabel,5)
    .rightSpaceToView(self.contentView,0);
    
    [_backView setupAutoHeightWithBottomView:_lastBottomLine bottomMargin:0];
    [self setupAutoHeightWithBottomView:_backView bottomMargin:5];
}

-(void)setShortLayout{
    _ttsLabel.sd_layout
    .leftSpaceToView(self.contentView,15)
    .topSpaceToView(self.contentView,0)
    .rightSpaceToView(self.contentView,0)
    .autoHeightRatio(0);
    
    //新闻条目进行布局
    _shortTitleView.sd_layout
    .leftSpaceToView(_backView,0)
    .topSpaceToView(_backView,0)
    .rightSpaceToView(_backView,0)
    .heightIs(80);
    //_lastBottomLine = [self addSeparatorLineBellowView:titleView0 margin:0];
    
    _showButton.sd_layout
    .leftSpaceToView(_backView,0)
    .topSpaceToView(_shortTitleView,0)
    .rightSpaceToView(_backView,0)
    .heightIs(20);
    
    _backView.sd_layout
    .leftSpaceToView(self.contentView,0)
    .topSpaceToView(_ttsLabel,5)
    .rightSpaceToView(self.contentView,0);
    [_backView setupAutoHeightWithBottomView:_showButton bottomMargin:0];
    
    [self setupAutoHeightWithBottomView:_backView bottomMargin:5];
}

//生成间隔线
- (UIView *)addSeparatorLineBellowView:(UIView *)view margin:(CGFloat)margin{
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

//点击条目中的一项是，调用的函数
-(void)clickItem:(UITapGestureRecognizer*)tap{
   
    NewsTitleView *newsView = (NewsTitleView*)tap.view;
    //NSSLog(@"cell num is %d",5);
    int num = newsView.viewNum;
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
