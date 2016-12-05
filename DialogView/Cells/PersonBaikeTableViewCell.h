//
//  PersonBaikeTableViewCell.h
//  DialogDemo
//
//  Created by yanminli on 2016/10/31.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonBaikeModel.h"
#import "CellTableViewCell.h"


/****
 当询问“历届国家主席是谁的时候”,调用这个类，是一个选择界面
 */


@interface PersonBaikeItemView : UIView
-(id)init;
-(void)setDatas:(PersonBaikeData*) personData num:(NSString*)num;
@property (nonatomic,assign) int    viewNum;//保存点击的cell的索引;
@end

@interface PersonBaikeTableViewCell : CellTableViewCell
@property (nonatomic,strong) PersonBaikeModel   *model;
@property (nonatomic, copy)  void       (^didSelectBlock)(int num);
@end
