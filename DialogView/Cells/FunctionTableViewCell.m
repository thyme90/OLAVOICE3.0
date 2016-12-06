//
//  FunctionTableViewCell.m
//  DialogDemo
//
//  Created by yanminli on 2016/12/1.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import "FunctionTableViewCell.h"
 

@implementation FunctionItemView
-(id)init{
    if (self = [super init]) {
        [self setupView];
        [self setLayout];
    }
    
    return self;
}


-(void)setupView{
    _editButton = [[UIButton alloc] init];
    [_editButton setImage:[UIImage imageNamed:@"icnUnchoose1"] forState:UIControlStateNormal];
    [_editButton setImage:[UIImage imageNamed:@"35"] forState:UIControlStateSelected];
    [_editButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    //_editButton.backgroundColor = [UIColor redColor];
    [self addSubview:_editButton];
    
    _imgView = [[UIImageView alloc] init];
    [self addSubview:_imgView];
    //_imgView.backgroundColor = [UIColor yellowColor];
    
    
    _upLabel = [[UILabel alloc] init];
    _upLabel.textAlignment = NSTextAlignmentLeft;
    _upLabel.textColor = COLOR(255, 255, 255, 1);
    _upLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:_upLabel];
    
    
    _downLabel = [[UILabel alloc] init];
    _downLabel.textAlignment = NSTextAlignmentLeft;
    _downLabel.textColor = COLOR(255, 255, 255, 1);
    _downLabel.font = [UIFont systemFontOfSize:13];
    _downLabel.alpha = 0.6;
    [self addSubview:_downLabel];

    
    _showButton = [[UIButton alloc] init];
    [_showButton setImage:[UIImage imageNamed:@"icnRightArrow1"] forState:UIControlStateNormal];
    [_showButton addTarget:self action:@selector(showButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_showButton];
}

-(void)setLayout{
    _imgView.sd_layout
    .leftSpaceToView(self,15)
    .topSpaceToView(self,12.7)
    .widthIs(36)
    .heightIs(36);
    
    _upLabel.sd_layout
    .leftSpaceToView(_imgView,15)
    .topSpaceToView(self,12.7)
    .autoHeightRatio(0);
    [_upLabel setSingleLineAutoResizeWithMaxWidth:400];
    
    _downLabel.sd_layout
    .leftEqualToView(_upLabel)
    .topSpaceToView(_upLabel,7)
    .autoHeightRatio(0);
    [_downLabel setSingleLineAutoResizeWithMaxWidth:400];
    
    _showButton.sd_layout
    .leftSpaceToView(self,325)
    .topSpaceToView(self,0)
    .widthIs(60)
    .heightIs(60);
    
    _editButton.sd_layout
    .leftSpaceToView(self,-40)
    .topSpaceToView(self,0)
    .widthIs(60)
    .heightIs(60);
    
}

-(void)buttonClick:(UIButton*)button{
    NSLog(@"editbutton click");
    button.selected = !button.selected;
}

-(void)showButtonClick:(UIButton*)button{
    NSLog(@"showbutton click");
    //创建一个消息对象
    NSNotification * notice = [NSNotification notificationWithName:@"functionshowbuttonclick" object:_downLabel.text userInfo:nil];
    //发送消息
    [[NSNotificationCenter defaultCenter] postNotification:notice];
}

-(void)setDatas:(NSDictionary*)dic index:(int)num{
    _upLabel.text = [dic objectForKey:@"upText"];
    _downLabel.text = [dic objectForKey:@"downText"];
    _viewNum = num;
    [_imgView setImage:[UIImage imageNamed:[dic objectForKey:@"imgName"]]];

}

@end

//////////////////////////////////////////////////////////

@interface FunctionTableViewCell()
@property (nonatomic,strong) UIView                 *backView;
@property (nonatomic,strong) UILabel                *ttsLabel;
@property (nonatomic,strong) UIView                 *lastBottomLine;
@property (nonatomic,strong) UILabel                *titleLabel;
@property (nonatomic,strong) UIButton               *finishButton;
@property (nonatomic,strong) NSMutableArray         *arry;
@property (nonatomic,strong) NSMutableArray         *arryItem;
@property (nonatomic,strong) FunctionItemView       *itemView;




@end

@implementation FunctionTableViewCell

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
        [self initData];
        [self setupView];
    }
    
    return self;
}


-(void)initData{
    _arry = [[NSMutableArray alloc] init];
    NSDictionary *dic1 = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"icn_smarthome",@"imgName",
                          @"智能家居",@"upText",
                          @"“打开音响设备”",@"downText",nil];
    [_arry addObject:dic1];
    
    NSDictionary *dic2 = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"icn_weather",@"imgName",
                          @"天气",@"upText",
                          @"“今天天气怎么样”",@"downText",nil];
    [_arry addObject:dic2];
    
    
    NSDictionary *dic3 = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"icn_news",@"imgName",
                          @"新闻",@"upText",
                          @"“今天有什么新闻”",@"downText",nil];
    [_arry addObject:dic3];
    
    NSDictionary *dic4 = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"icn_share",@"imgName",
                          @"百科",@"upText",
                          @"“我要查百科”",@"downText",nil];
    [_arry addObject:dic4];
    
    NSDictionary *dic5 = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"circularBlue4",@"imgName",
                          @"翻译",@"upText",
                          @"“把rehoice翻译成中文”",@"downText",nil];
    [_arry addObject:dic5];

    
    
    _arryItem = [[NSMutableArray alloc] init];
}


-(void)setupView{
    self.selectionStyle = UITableViewCellSelectionStyleNone;//不可选择
    self.backgroundColor = [UIColor clearColor];
    
    _ttsLabel = [[UILabel alloc] init];
    _ttsLabel.textAlignment = NSTextAlignmentCenter;
    _ttsLabel.font = [UIFont systemFontOfSize:18];
    _ttsLabel.textColor = COLOR(255, 255, 255, 1);
    _ttsLabel.text = @"你可以这样问我:";
    [self.contentView addSubview:_ttsLabel];
    
    //设置背景图片的view
    _backView = [[UIView alloc] init];
    _backView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"透明白背板"]];
    //_backView.backgroundColor = [UIColor blueColor];
    [self.contentView addSubview:_backView];

}

-(void)setAllShow{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor grayColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.textColor = COLOR(119, 299, 255, 1);
        _titleLabel.text = @"   选择功能模块置于首页";
        _titleLabel.userInteractionEnabled = YES;
        [_backView addSubview:_titleLabel];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleClick)];
        [_titleLabel addGestureRecognizer:tapGesture];

    }
    
    for (int i=0; i<_arry.count; i++) {
        NSDictionary *dic = [_arry objectAtIndex:i];
        FunctionItemView *item = [[FunctionItemView alloc] init];
        [item setDatas:dic index:i];
        [_arryItem addObject:item];
        [_backView addSubview:item];

        
    }
    
    if (!_finishButton) {
        _finishButton = [[UIButton alloc] init];
        _finishButton.layer.masksToBounds = YES;
        _finishButton.layer.cornerRadius = 10;
        _finishButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_finishButton setTitle:@"完成" forState:UIControlStateNormal];
        _finishButton.backgroundColor = [UIColor grayColor];
        _finishButton.hidden = YES;
        [_finishButton addTarget:self action:@selector(finishButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_backView addSubview:_finishButton];
    }

    
        
    
    //进行布局
    _titleLabel.sd_layout
    .leftSpaceToView(_backView,0)
    .topSpaceToView(_backView,0)
    .rightSpaceToView(_backView,0)
    .heightIs(30);
    
    _finishButton.sd_layout
    .leftSpaceToView(_backView,265)
    .topSpaceToView(_backView,15)
    .widthIs(80)
    .heightIs(25);
    
    _itemView = [_arryItem objectAtIndex:0];
    _itemView.sd_layout
    .leftSpaceToView(_backView,0)
    .rightSpaceToView(_backView,0)
    .topSpaceToView(_titleLabel,0)
    .heightIs(60.2);
    
    
    _lastBottomLine = [self addSeparatorLineBellowView:_itemView margin:0];
    
    
    for (int i=1; i<_arryItem.count; i++) {
        _itemView = [_arryItem objectAtIndex:i];
        _itemView.sd_layout
        .leftSpaceToView(_backView,0)
        .rightSpaceToView(_backView,0)
        .topSpaceToView(_lastBottomLine,0)
        .heightIs(60.2);
        
        _lastBottomLine = [self addSeparatorLineBellowView:_itemView margin:0];

    }
    
    _backView.sd_layout
    .leftSpaceToView(self.contentView,0)
    .topSpaceToView(_ttsLabel,23)
    .rightSpaceToView(self.contentView,0);

    [_backView setupAutoHeightWithBottomView:_lastBottomLine bottomMargin:0];
    [self setupAutoHeightWithBottomView:_backView bottomMargin:5];
}

-(void)setShortShow{
    UIButton *showButton = [[UIButton alloc] init];
    [showButton setImage:[UIImage imageNamed:@"icnDownArrow"] forState:UIControlStateNormal];
    [showButton setImage:[UIImage imageNamed:@"icnDownArrow"] forState:UIControlStateSelected];
    UIImage *bgImage = [UIImage imageNamed:@"buttonbak"];
    showButton.backgroundColor = [UIColor colorWithPatternImage:bgImage];
    showButton.imageView.contentMode = UIViewContentModeCenter;
    [_backView addSubview:showButton];
    [showButton addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:13];
    titleLabel.textColor = COLOR(119, 299, 255, 1);
    titleLabel.text = @"选择功能模块置于首页";
    [_backView addSubview:titleLabel];
    
    

    
    //开始布局
    
    titleLabel.sd_layout
    .leftSpaceToView(_backView,0)
    .topSpaceToView(_backView,0)
    .rightSpaceToView(_backView,0)
    .autoHeightRatio(0);
    
    showButton.sd_layout
    .leftSpaceToView(_backView,0)
    .topSpaceToView(titleLabel,0)
    .rightSpaceToView(_backView,0)
    .heightIs(20);
    
    _backView.sd_layout
    .leftSpaceToView(self.contentView,0)
    .topSpaceToView(_ttsLabel,23)
    .rightSpaceToView(self.contentView,0);
    
    [_backView setupAutoHeightWithBottomView:showButton bottomMargin:0];
    
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

-(void)setModel:(FunctionModel *)model{
    _ttsLabel.sd_layout
    .leftSpaceToView(self.contentView,0)
    .topSpaceToView(self.contentView,32)
    .rightSpaceToView(self.contentView,0)
    .autoHeightRatio(0);
    
    [_backView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (!model.buttonIsShow) {
        [self setAllShow];
    }else{
        [self setShortShow];
        
    }
    
}


-(void)buttonClick{
    if ([self.delegate respondsToSelector:@selector(UnfoldCellDidClickUnfoldBtn:)]) {
        [self.delegate UnfoldCellDidClickUnfoldBtn:self.model];
    }
    
}

//点击标题栏，出现完成按钮和选择按钮
-(void)titleClick{
    _finishButton.hidden = !_finishButton.hidden;
    _titleLabel.hidden = !_titleLabel.hidden;
    [self showAniamtion];
}

//每一项进行选择的时候的动画
-(void)showAniamtion{
    [UIView animateWithDuration:0.5 animations:^{
        for (int i=0; i<_arryItem.count; i++) {
            FunctionItemView *itemView = [_arryItem objectAtIndex:i];
            CGFloat x = itemView.origin.x;
            CGFloat y = itemView.origin.y;
            CGFloat w = itemView.frame.size.width;
            CGFloat h = itemView.frame.size.height;
            itemView.frame = CGRectMake(x+50, y, w, h);
        }
    }];
}

-(void)hideAniamtion{
    [UIView animateWithDuration:0.5 animations:^{
        for (int i=0; i<_arryItem.count; i++) {
            FunctionItemView *itemView = [_arryItem objectAtIndex:i];
            CGFloat x = itemView.origin.x;
            CGFloat y = itemView.origin.y;
            CGFloat w = itemView.frame.size.width;
            CGFloat h = itemView.frame.size.height;
            itemView.frame = CGRectMake(x-50, y, w, h);
        }
    }];
}


//点击完成按钮是发出的消息
-(void)finishButtonClick{
    //查询有那几个选项被选中了。
    NSMutableArray *arry = [[NSMutableArray alloc] init];
    for (int i=0; i<_arryItem.count; i++) {
        FunctionItemView *itemView = [_arryItem objectAtIndex:i];
        if (itemView.editButton.isSelected) {
            int num = itemView.viewNum;
            [arry addObject:[NSNumber numberWithInt:num]];
        }
    }
    
    //如果选择的数目小于6 则不进行隐藏。
    if (arry.count < 6) {
        _finishButton.hidden = !_finishButton.hidden;
        _titleLabel.hidden = !_titleLabel.hidden;
        [self hideAniamtion];
    }
    
    //创建一个消息对象
    NSNotification * notice = [NSNotification notificationWithName:@"functioneditbuttonclick" object:arry userInfo:nil];
    //发送消息
    [[NSNotificationCenter defaultCenter] postNotification:notice];
    
}


@end
