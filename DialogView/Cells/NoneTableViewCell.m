//
//  NoneTableViewCell.m
//  DialogDemo
//
//  Created by yanminli on 2016/12/1.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import "NoneTableViewCell.h"
 


@interface NoneTableViewCell()
@property (nonatomic,strong) UILabel                *label;
@property (nonatomic,strong) UIView                 *backView;
@end

@implementation NoneTableViewCell

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
    
    _label = [[UILabel alloc] init];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.font = [UIFont systemFontOfSize:19];
    _label.textColor = COLOR(255, 255, 255, 1);
    _label.text = @"你可以这样问我:";
    [self.contentView addSubview:_label];
    
    _backView = [[UIView alloc] init];
    [self.contentView addSubview:_backView];

}


-(void)setModel:(NoneModel *)model{
    _label.sd_layout
    .leftSpaceToView(self.contentView,0)
    .topSpaceToView(self.contentView,96)
    .rightSpaceToView(self.contentView,0)
    .autoHeightRatio(0);
    
    [_backView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (!model.buttonIsShow) {
        [self setAllShow];
    }else{
        [self setShortShow];
        
    }
}

-(void)setAllShow{
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = COLOR(255, 255, 255, 0.8);
    label.text = @"安排九点钟开会";
    [_backView addSubview:label];
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.font = [UIFont systemFontOfSize:16];
    label1.textColor = COLOR(255, 255, 255, 0.8);
    label1.text = @"附件的咖啡馆";
    [_backView addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.font = [UIFont systemFontOfSize:16];
    label2.textColor = COLOR(255, 255, 255, 0.8);
    label2.text = @"朗读我的新信息";
    [_backView addSubview:label2];
    
    UILabel *label3 = [[UILabel alloc] init];
    label3.textAlignment = NSTextAlignmentCenter;
    label3.font = [UIFont systemFontOfSize:16];
    label3.textColor = COLOR(255, 255, 255, 0.8);
    label3.text = @"打开微信";
    [_backView addSubview:label3];
    
    UILabel *label4 = [[UILabel alloc] init];
    label4.textAlignment = NSTextAlignmentCenter;
    label4.font = [UIFont systemFontOfSize:16];
    label4.textColor = COLOR(255, 255, 255, 0.8);
    label4.text = @"拨打张晨的电话";
    [_backView addSubview:label4];
    
    UILabel *label5 = [[UILabel alloc] init];
    label5.textAlignment = NSTextAlignmentCenter;
    label5.font = [UIFont systemFontOfSize:16];
    label5.textColor = COLOR(255, 255, 255, 0.8);
    label5.text = @"附近的美甲店";
    [_backView addSubview:label5];
    
    //开始布局
    _backView.sd_layout
    .leftSpaceToView(self.contentView,0)
    .topSpaceToView(_label,0)
    .rightSpaceToView(self.contentView,0);
    
    label1.sd_layout
    .leftSpaceToView(_backView,0)
    .topSpaceToView(_backView,72)
    .rightSpaceToView(_backView,0)
    .autoHeightRatio(0);
    
    label2.sd_layout
    .leftSpaceToView(_backView,0)
    .topSpaceToView(label1,24.5)
    .rightSpaceToView(_backView,0)
    .autoHeightRatio(0);
    
    label3.sd_layout
    .leftSpaceToView(_backView,0)
    .topSpaceToView(label2,24.5)
    .rightSpaceToView(_backView,0)
    .autoHeightRatio(0);
    
    label4.sd_layout
    .leftSpaceToView(_backView,0)
    .topSpaceToView(label3,24.5)
    .rightSpaceToView(_backView,0)
    .autoHeightRatio(0);
    
    label5.sd_layout
    .leftSpaceToView(_backView,0)
    .topSpaceToView(label4,24.5)
    .rightSpaceToView(_backView,0)
    .autoHeightRatio(0);
    
    
    [_backView setupAutoHeightWithBottomView:label5 bottomMargin:150];
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
    
    //开始布局
     showButton.sd_layout
    .leftSpaceToView(_backView,0)
    .topSpaceToView(_backView,0)
    .rightSpaceToView(_backView,0)
    .heightIs(20);
    
    _backView.sd_layout
    .leftSpaceToView(self.contentView,0)
    .topSpaceToView(_label,5)
    .rightSpaceToView(self.contentView,0);
    
    [_backView setupAutoHeightWithBottomView:showButton bottomMargin:0];
     [self setupAutoHeightWithBottomView:_backView bottomMargin:5];
    

}


-(void)buttonClick{
    if ([self.delegate respondsToSelector:@selector(UnfoldCellDidClickUnfoldBtn:)]) {
        [self.delegate UnfoldCellDidClickUnfoldBtn:self.model];
    }
    
}




@end
