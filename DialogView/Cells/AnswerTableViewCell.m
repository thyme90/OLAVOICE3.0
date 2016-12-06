//
//  AnswerTableViewCell.m
//  DialogDemo
//
//  Created by yanminli on 2016/11/1.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import "AnswerTableViewCell.h"
#import "SDAutoLayout.h"
#import "macro.h"
 


@interface AnswerTableViewCell()<CAAnimationDelegate>
@property (nonatomic,strong) UILabel    *label;

@end

@implementation AnswerTableViewCell

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

-(void)drawRect:(CGRect)rect{
    [self animationAction];
}

-(void)setupView{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;//不可选择
    self.backgroundColor = [UIColor clearColor];

    _label = [[UILabel alloc] init];
    _label.textAlignment = NSTextAlignmentLeft;
    _label.font = [UIFont systemFontOfSize:16];
    _label.textColor = COLOR(255, 255, 255, 1);
    //_label.hidden = YES;
    [self.contentView addSubview:_label];
}

-(void)setModel:(AnswerModel *)model{
    _model = model;
    if (model.content != nil) {
        _label.text = model.content;
    }else if(model.result != nil){
        _label.text = model.result;
    }
    
    
    _label.sd_layout
    .leftSpaceToView(self.contentView,15)
    .topSpaceToView(self.contentView,0)
    .rightSpaceToView(self.contentView,15)
    .autoHeightRatio(0);
    
    [self setupAutoHeightWithBottomView:_label bottomMargin:0];
}

-(void)animationAction{
    //_label.hidden = NO;
    //_label.alpha = 0.0f;
//    [UIView animateWithDuration:2.0 animations:^ {
//        _label.alpha = 1.0f;
//    } completion:^(BOOL finished) {
//        [_label.layer removeAllAnimations];
//        [_label setNeedsDisplay];
//        
//    }];
    
//    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"opacity"];
//    anim.fromValue = [NSNumber numberWithFloat:0.0f];
//    anim.toValue =[NSNumber numberWithFloat:1.0f];
//    anim.duration = 2;
//    anim.removedOnCompletion = NO;
//    anim.fillMode = kCAFillModeForwards;
//    anim.delegate = self;
//    
//    [_label.layer addAnimation:anim forKey:@"labelAlpha"];
    


}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if ([_label.layer animationForKey:@"labelAlpha"] == anim){
        [_label.layer removeAllAnimations];
    }
}



@end
