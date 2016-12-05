//
//  QuestionModelTableViewCell.m
//  DialogDemo
//
//  Created by yanminli on 2016/10/20.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import "QuestionTableViewCell.h"
#import "SDAutoLayout.h"
#import "commonHeader.h"


@interface QuestionTableViewCell()
@property (nonatomic,strong) UILabel    *messageLabel;
@property (nonatomic,strong) UILabel    *editLabel;
@property (nonatomic,strong) UIView     *container;
@property (nonatomic,strong) NSString   *tmpText;

@end

@implementation QuestionTableViewCell

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
    
    _container = [UIView new];
    [self.contentView addSubview:_container];
    //_container.backgroundColor = [UIColor redColor];
    //_container.backgroundColor = COLOR(255, 255, 255, 1);
    //_container.hidden = YES;
    
    
    _messageLabel = [[UILabel alloc] init];
    _messageLabel.textAlignment = NSTextAlignmentRight;
    _messageLabel.font = [UIFont systemFontOfSize:16];
    _messageLabel.textColor = COLOR(255, 255, 255, 1);
    [self.contentView addSubview:_messageLabel];
   
    
    _editLabel = [[UILabel alloc] init];
    _editLabel.textColor = COLOR(155, 183, 199, 1);
    _editLabel.text =@"点击进行编辑";
    _editLabel.textAlignment = NSTextAlignmentRight;
    _editLabel.font = [UIFont systemFontOfSize:12];
    //_editLabel.alpha = 0.0f;
    
//    _label.userInteractionEnabled = YES;//能否与用户进行交互
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickUILable)];
//    [_label addGestureRecognizer:tapGesture];
    [self.contentView addSubview:_editLabel];
    
}

-(void)setModel:(QuestionModel*)model{
    _model = model;
    _messageLabel.text = _model.sendText;
    [self setLayout];
    
    

}

-(void)setLayout{
    _container.sd_resetLayout.rightSpaceToView(self.contentView,0)
    .topSpaceToView(self.contentView,0)
    .leftSpaceToView(self.contentView,0)
    .rightSpaceToView(self.contentView,0)
    .heightIs(40);
    
    _messageLabel.sd_resetLayout
    .topEqualToView(_container)
    .rightSpaceToView(self.contentView,15)
    .autoHeightRatio(0); // 设置label纵向自适应
    [_messageLabel setSingleLineAutoResizeWithMaxWidth:_container.frame.size.width];
    
    
    _editLabel.sd_resetLayout
    .topSpaceToView(_messageLabel,0)
    .rightSpaceToView(self.contentView,15)
    .widthIs(100)
    .autoHeightRatio(0);
    
    // 设置label横向自适应
    [self setupAutoHeightWithBottomView:_editLabel bottomMargin:1];
    
}


-(void)animationAction{
    [UIView animateWithDuration:1 animations:^{
        _container.alpha = 0.0f;
    }completion:^(BOOL finished){
       [self labelShowAnimation];
        //创建一个消息对象
        NSNotification * notice = [NSNotification notificationWithName:@"sendMessageDone" object:nil userInfo:nil];
        //发送消息
        [[NSNotificationCenter defaultCenter] postNotification:notice];
    }];
    
    
}

-(void)labelShowAnimation{
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        _editLabel.alpha = 1.0f;
    }completion:nil];
}

-(void)showText{
//    NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(animationLabel) object:nil];
//    [thread start];
}

//- (void)animationLabel{
//    for (NSInteger i = 0; i < _model.sendText.length; i++){
//        [self performSelectorOnMainThread:@selector(refreshUIWithContentStr:) withObject:[_model.sendText substringWithRange:NSMakeRange(0, i+1)] waitUntilDone:YES];
//        [NSThread sleepForTimeInterval:0.3];
//    }
//}
//
////模拟打字功能
//- (void)refreshUIWithContentStr:(NSString *)contentStr{
//    _messageLabel.text = contentStr;
//    if (_messageLabel.text.length == _model.sendText.length) {
//        [self animationAction];
//        
//    }
//}

@end
