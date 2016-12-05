//
//  FunctionTableViewCell.h
//  DialogDemo
//
//  Created by yanminli on 2016/12/1.
//  Copyright © 2016年 s3graphics. All rights reserved.
//


/************
 
 功能Cell，用来展示有多少功能
 
*/
#import <UIKit/UIKit.h>
#import "CellTableViewCell.h"
#import "FunctionModel.h"

@interface FunctionItemView : UIView
@property (nonatomic,strong) UIButton       *editButton;
@property (nonatomic,strong) UIImageView    *imgView;
@property (nonatomic,strong) UILabel        *upLabel;
@property (nonatomic,strong) UILabel        *downLabel;
@property (nonatomic,strong) UIButton       *showButton;
@property (nonatomic,assign) int            viewNum;//保存点击的cell的索引;
-(void)setDatas:(NSDictionary*)dic index:(int)num;
@end

@interface FunctionTableViewCell : CellTableViewCell
@property (nonatomic,strong) FunctionModel  *model;
@property (nonatomic, copy)  void       (^didSelectBlock)(int num);
@end
