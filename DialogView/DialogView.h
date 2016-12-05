//
//  DialogView.h
//  DialogDemo
//
//  Created by yanminli on 2016/10/20.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DialogViewDelegate <NSObject>

-(void)sendMessageToServer:(NSString*)message;//手动向服务器发送消息

@end


@interface DialogView : UIView
-(id)init;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;//保存生成的所有mode数据
@property (nonatomic,strong) NSMutableArray *modeTypeArray;//保存生成的所有mode的类型
@property (nonatomic,strong) NSString       *modeType;
@property (nonatomic,strong) NSMutableDictionary    *dataDic;//保存生成的所有mode数据
@property (nonatomic,weak)   id<DialogViewDelegate> delegate;

@end
