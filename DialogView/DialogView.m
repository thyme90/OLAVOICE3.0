//
//  DialogView.m
//  DialogDemo
//
//  Created by yanminli on 2016/10/20.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import "DialogView.h"
//#import "ViaVoice.h"
#import "SDAutoLayout.h"
#import "QuestionTableViewCell.h"
#import "EditTableViewCell.h"
#import "commonHeader.h"
#import "NewsTableViewCell.h"
#import "NewsModel.h"
#import "NewsContentModel.h"
#import "NewsContentTableViewCell.h"
#import "WeatherModel.h"
#import "WeatherTableViewCell.h"
#import "BaikeiModel.h"
#import "BaikeTableViewCell.h"
#import "PersonBaikeTableViewCell.h"
#import "AnswerTableViewCell.h"
#import "NSString+Extension.h"
#import "SelectionBaikeTableViewCell.h"


static NSString   *QuestionCellId               =  @"QuestionTableViewCellId";
static NSString   *EditCellId                   =  @"EditTableViewCellId";
static NSString   *NewsCellId                   =  @"NewsTableViewCellId";
static NSString   *NewsContentCellId            =  @"NewsContentTableViewCellId";
static NSString   *WeatherCellId                =  @"WeatherTableViewCellId";
static NSString   *BaikeCellId                  =  @"BaikeTableViewCellId";
static NSString   *PersonBaikeCellId            =  @"PersonBaikeTableViewCellId";
static NSString   *AnswerCellId                 =  @"AnswerTableViewCellId";//回到
static NSString   *SelectionBaikeCellId         =  @"SelectionBaikeTableViewCellId";//百科选择

@interface DialogView()<UITableViewDelegate,UITableViewDataSource,EditTableViewCellDelegate,CellTableViewCellDelegate>
@property (nonatomic,strong) EditTableViewCell  *tmpCell;//处于编辑状态的tmpCell
@property (nonatomic,strong) NSIndexPath        *editCellIndexPath;//保存目前生成的editcell的indexpath;
@property (nonatomic,assign) BOOL               isCreateEditCell;
@property (nonatomic,strong) NSIndexPath        *currentIndexPath;//保存当前的indexpath;
@end

@implementation DialogView

/*
 Only override drawRect: if you perform custom drawing.
 An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
   // [self setupView];
}*/

-(id)init{
    if (self = [super init]) {
        [self setupView];
        [self setupData];
        
        
    }
    
    return self;
}


-(void)setupView{
    _tableView = [[UITableView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.bounces = NO;

    [self addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _tableView.sd_layout.leftSpaceToView(self,0)
    .topSpaceToView(self,0)
    .rightSpaceToView(self,0)
    .heightRatioToView(self,1);
    
}

-(void)setupData{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    
    if (!_modeTypeArray) {
        _modeTypeArray = [[NSMutableArray alloc] init];
    }
    
    if (!_dataDic) {
        _dataDic = [[NSMutableDictionary alloc] init];
    }
    
    //监听键盘显示时的事件
    [[NSNotificationCenter
      defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
    //注册通知,监听键盘消失事件
    [[NSNotificationCenter
      defaultCenter] addObserver:self selector:@selector(keyboardDidHidden:) name:UIKeyboardDidHideNotification object:nil];
    
    
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //获得当前话筒点击事件的消息
    [center addObserver:self selector:@selector(receiveMessage:) name:@"voiceClick" object:nil];

    
    

    
    _isCreateEditCell = NO;
}


-(void)keyboardDidShow:(NSNotification*)notification{
    
    //获取键盘高度
    
    NSValue *keyboardObject = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect  keyboardRect;
    
    [keyboardObject getValue:&keyboardRect];
    
    //当前输入框在屏幕上的位置
    CGRect rectInTableView = [_tableView rectForRowAtIndexPath:_editCellIndexPath];
    
    
    CGRect rect = [_tableView convertRect:rectInTableView toView:[_tableView superview]];
    
    //NSSLog(@"rect.y is %f",rect.origin.y);
    
    //当键盘挡住了输入框的时候
    if (rect.origin.y > keyboardRect.origin.y) {
        _tableView.frame = CGRectMake(0, -keyboardRect.size.height, self.frame.size.width, self.frame.size.height);
    }
    
}

-(void)keyboardDidHidden:(NSNotification*)notification{
    //当tableView的y坐标小于0,说明当键盘显示的时候进行了移动。当键盘消失的时候进行回位
    if (_tableView.frame.origin.y < 0) {
        _tableView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    }
    
}



#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   return _dataArray.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *type = _modeTypeArray[indexPath.row];
    //NSSLog(@"cell type is %@",type);
    if ([type isEqualToString:@"question"]) {
        QuestionTableViewCell *cell = nil;
        cell = [_tableView dequeueReusableCellWithIdentifier:QuestionCellId];
        if (!cell) {
            cell = [[QuestionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:QuestionCellId];
            
        }
        cell.model = _dataArray[indexPath.row];
        return cell;
        
    }else if([type isEqualToString:@"edit"]){
        //EditTableViewCell *cell = nil;
        _editCellIndexPath = indexPath;
        _tmpCell = [_tableView dequeueReusableCellWithIdentifier:EditCellId];
        if (!_tmpCell) {
            _tmpCell = [[EditTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:EditCellId];
            _isCreateEditCell = NO;
        }
        
        if (_isCreateEditCell) {
            _tmpCell = [[EditTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:EditCellId];
            _isCreateEditCell = NO;
        }
    
        _tmpCell.model = _dataArray[indexPath.row];
        _tmpCell.delegate = self;
        
        return _tmpCell;
    }else if([type isEqualToString:@"news"]){
        NewsTableViewCell *cell = nil;
        cell = [_tableView dequeueReusableCellWithIdentifier:NewsCellId];
        NewsModel *oldModel = cell.model;
        NewsModel   *newModel = _dataArray[indexPath.row];
        //cell = [_tableView cellForRowAtIndexPath:indexPath];
        if (!cell || newModel != oldModel) {
            cell = [[NewsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NewsCellId];
        }
        
        cell.model = _dataArray[indexPath.row];
        cell.delegate = self;
        cell.didSelectBlock= ^(int num) {
            NSString *str = [[NSString alloc] initWithFormat:@"%d",num];;
            [self.delegate sendMessageToServer:str];

        };

        return cell;
    }else if([type isEqualToString:@"newscontent"]){
        NewsContentTableViewCell *cell = nil;
        cell = [_tableView dequeueReusableCellWithIdentifier:NewsContentCellId];
        NewsContentModel *oldModel = cell.model;
        NewsContentModel   *newModel = _dataArray[indexPath.row];

        if (!cell || newModel != oldModel) {
            cell = [[NewsContentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NewsContentCellId];
        }
        cell.model = _dataArray[indexPath.row];
        cell.delegate = self;
        return cell;
    }else if([type isEqualToString:@"weather"]){
        WeatherTableViewCell *cell = nil;
        cell = [_tableView dequeueReusableCellWithIdentifier:WeatherCellId];
        WeatherModel   *newModel = _dataArray[indexPath.row];
        WeatherModel   *oldModel = cell.model;
        if (!cell || newModel != oldModel) {
            cell = [[WeatherTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:WeatherCellId];
        }
        cell.model = _dataArray[indexPath.row];
        return cell;

    }else if([type isEqualToString:@"baike"]){
        BaikeTableViewCell *cell = nil;
        cell = [_tableView dequeueReusableCellWithIdentifier:BaikeCellId];
        BaikeiModel   *newModel = _dataArray[indexPath.row];
        BaikeiModel *oldModel = cell.model;
        //cell = [_tableView cellForRowAtIndexPath:indexPath];
        if (!cell || newModel != oldModel) {
            cell = [[BaikeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BaikeCellId];
        }
        cell.model = _dataArray[indexPath.row];
        cell.delegate = self;
        
        return cell;
        
    }else if([type isEqualToString:@"person_baike"]){
        PersonBaikeTableViewCell *cell = nil;
        cell = [_tableView dequeueReusableCellWithIdentifier:PersonBaikeCellId];
        PersonBaikeModel   *newModel = _dataArray[indexPath.row];
        PersonBaikeModel   *oldModel = cell.model;
        if (!cell || newModel != oldModel) {
            cell = [[PersonBaikeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PersonBaikeCellId];
        }
        
        cell.model = _dataArray[indexPath.row];
        cell.delegate = self;
        [cell setDidSelectBlock:^(int num){
            NSString *str = [[NSString alloc] initWithFormat:@"第%d个",num];;
            [self.delegate sendMessageToServer:str];
        }];

        return cell;
        
    }else if([type isEqualToString:@"answer"]){
        AnswerTableViewCell *cell = nil;
        cell = [_tableView dequeueReusableCellWithIdentifier:AnswerCellId];
        if (!cell) {
            cell = [[AnswerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AnswerCellId];
        }
        cell.model = _dataArray[indexPath.row];
        //[cell animationAction];
        return cell;
        
    }else if([type isEqualToString:@"selectionbaike"]){
        SelectionBaikeTableViewCell *cell = nil;
        cell = [_tableView dequeueReusableCellWithIdentifier:SelectionBaikeCellId];
        SelectionBaikeModel   *newModel = _dataArray[indexPath.row];
        SelectionBaikeModel   *oldModel = cell.model;

        if (!cell || newModel != oldModel) {
            cell = [[SelectionBaikeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SelectionBaikeCellId];
        }
        cell.model = _dataArray[indexPath.row];
        cell.didSelectBlock= ^(int num) {
            NSString *str = [[NSString alloc] initWithFormat:@"%d",num];;
            [self.delegate sendMessageToServer:str];
            
        };

        return cell;
        
    }
    

    return nil;

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Class currentClass = nil;
    
    NSString *type = _modeTypeArray[indexPath.row];
    if ([type isEqualToString:@"question"]) {
        currentClass = [QuestionTableViewCell class];
    }else if([type isEqualToString:@"edit"]){
        currentClass = [EditTableViewCell class];
    }else if([type isEqualToString:@"news"]){
        currentClass = [NewsTableViewCell class];
    }else if([type isEqualToString:@"newscontent"]){
        currentClass = [NewsContentTableViewCell class];
    }else if([type isEqualToString:@"weather"]){
        currentClass = [WeatherTableViewCell class];
    }else if([type isEqualToString:@"baike"]){
        currentClass = [BaikeTableViewCell class];
    }else if([type isEqualToString:@"person_baike"]){
        currentClass = [PersonBaikeTableViewCell class];
    }else if([type isEqualToString:@"answer"]){
        currentClass = [AnswerTableViewCell class];
    }else if([type isEqualToString:@"selectionbaike"]){
        currentClass = [SelectionBaikeTableViewCell class];
    }

    
    
    
    id model = self.dataArray[indexPath.row];
    CGFloat h = [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:currentClass contentViewWidth:[UIScreen mainScreen].bounds.size.width];
    
    //NSSLog(@"h is %f",h);
    return h+20;//11为cell和cell之间的间隔


}

-(void)sendMessageToTableView:(NSString *)message{
    [self.delegate sendMessageToServer:message];
    //NSSLog(@"edit message is %@",message);
    //如果发送了一个空消息，则把新建的edit给删除掉
    if ([message isEmpty]) {
        [_tableView beginUpdates];
        unsigned long num = _dataArray.count;
        [_dataArray removeObjectAtIndex:num-1];
        [_modeTypeArray removeObjectAtIndex:num-1];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:num-1  inSection:0];
        [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [_tableView endUpdates];

    }
}

-(void)setAnimation{
    [_tmpCell animationEditCell];
}


- (void)UnfoldCellDidClickUnfoldBtn:(CellModel *)model{
    NSInteger index = [self.dataArray indexOfObject:model];
    model.buttonIsShow = !model.buttonIsShow;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void)receiveMessage:(NSNotification*)notice{
    //如果没有cell生成，则直接返回
    if (_dataArray.count == 0) {
        return;
    }
    
    for (int i=0; i<[_tableView indexPathsForVisibleRows].count; i++) {
        NSIndexPath *indexPath = [[_tableView indexPathsForVisibleRows] objectAtIndex:i];
        UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
        CGFloat cellH = cell.height;
        //NSLog(@"cellH is %f",cellH);
        if (cellH > 400) {//只有高度大于400cell才可以进行折叠
            CellModel   *model = _dataArray[indexPath.row];
            if (model) {
                    if (!model.buttonIsShow) {
                        model.buttonIsShow = YES;
                        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                        
                    }
            }
        }
        
    }
}

#pragma mark--点击cell的时候添加一个新的cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *type = [_modeTypeArray objectAtIndex:indexPath.row];
    if ([type isEqualToString:@"question"] || [type isEqualToString:@"edit"]) {
        _isCreateEditCell = YES;
        EditModel  *model = [[EditModel alloc] init];
        model.modelType = @"edit";
        [_dataArray addObject:model];
        [_modeTypeArray addObject:model.modelType];
        unsigned long num = _dataArray.count;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:num-1  inSection:0];
        [_tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                      withRowAnimation:UITableViewRowAnimationFade];
        [_tableView scrollToRowAtIndexPath:indexPath
                                      atScrollPosition:UITableViewScrollPositionTop
                                              animated:YES];
        
        
        
    } 
}


//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
////    NSString *type = [_modeTypeArray objectAtIndex:indexPath.row];
////    NSLog(@"type is %@",type);
////    if ([type isEqualToString:@"question"]) {
////        QuestionTableViewCell *cell = (QuestionTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
////        [cell labelShowAnimation];
////        
////    }
//    
//    BOOL isQuestion = [cell isKindOfClass:[QuestionTableViewCell class]];
//    if (isQuestion) {
//        QuestionTableViewCell *tmpCell = (QuestionTableViewCell*)cell;
//        [tmpCell labelShowAnimation];
//    }
//   
//}


@end
