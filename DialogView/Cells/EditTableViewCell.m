//
//  EditTableViewCell.m
//  testSDLayout
//
//  Created by yanminli on 2016/10/24.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import "EditTableViewCell.h"
#import "SDAutoLayout.h"
#import "macro.h"

@interface EditTableViewCell()<UITextViewDelegate>
@property (nonatomic,strong) UILabel    *label;
@property (nonatomic,strong) UITextView *textView;
@property (nonatomic, strong) UIView *container;
@property (nonatomic,copy) NSString *txtStr;
@end

@implementation EditTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    NSLog(@"editTableCell awakeFromNib");

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        NSLog(@"editTableCell init");
        [self setupView];
    }
    
    return self;
}

-(void)setupView{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
   
    _container = [UIView new];
    [self.contentView addSubview:_container];
    _container.backgroundColor = [UIColor whiteColor];
    _container.alpha = 0.3f;
    
    _textView = [[UITextView alloc] init];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.delegate = self;
    _textView.textColor = [UIColor whiteColor];//设置textview里面的字体颜色
    _textView.textAlignment = NSTextAlignmentRight;
    _textView.font = [UIFont systemFontOfSize:16];
    _textView.returnKeyType = UIReturnKeyDone;//return键的类型
    _textView.keyboardType = UIKeyboardTypeDefault;//键盘类型
    [_textView becomeFirstResponder];
    [self.contentView addSubview:_textView];
    
    _label = [[UILabel alloc] init];
    _label.text = @"点击进行编辑";
    _label.textAlignment = NSTextAlignmentRight;
    _label.font = [UIFont systemFontOfSize:12];
    _label.textColor = COLOR(155, 183, 199, 1);
    //    _label.userInteractionEnabled = YES;//能否与用户进行交互
    //    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickUILable)];
    //    [_label addGestureRecognizer:tapGesture];
    //_label.hidden = YES;
    _label.alpha = 0.0f;
    //_label.backgroundColor = [UIColor yellowColor];
    [self.contentView addSubview:_label];
    
    
    
    
}

-(void)setModel:(EditModel*)model{
    _model = model;
    _modelType = model.modelType;
    [self setLayout];
    
    
}

-(void)setLayout{
    _container.sd_resetLayout.rightSpaceToView(self.contentView,0)
    .topSpaceToView(self.contentView,0)
    .leftSpaceToView(self.contentView,0)
    .heightIs(40);
    
 
    _textView.sd_resetLayout
    .leftEqualToView(_container)
    .topEqualToView(_container)
    .rightSpaceToView(self.contentView,15)
    .heightRatioToView(_container,1);
   
    
    _label.sd_resetLayout
    .leftSpaceToView(self.contentView,0)
    .topSpaceToView(self.contentView,30)
    .rightSpaceToView(self.contentView,15)
    .autoHeightRatio(0);
    [_label setSingleLineAutoResizeWithMaxWidth:100];
    
    
    [self setupAutoHeightWithBottomView:_label bottomMargin:0];
}



//结束编辑
- (void)textViewDidEndEditing:(UITextView *)textView{
    _txtStr = textView.text;
    [self.delegate setAnimation];
}

//退出键盘
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        [self.delegate sendMessageToTableView:_textView.text];
        
        return NO;
        
    }
    
    return YES;
    
}

-(void)animationEditCell{
    _textView.editable = NO;
    _textView.selectable = NO;
    _textView.userInteractionEnabled = NO;
    [UIView animateWithDuration:1.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        _container.backgroundColor = [UIColor clearColor];
    }completion:^(BOOL finished){
        
    }];
    
    [UIView animateWithDuration:0.5 delay:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
        _label.alpha = 1.0f;
    }completion:^(BOOL finished){
        
    }];

}

@end
