//
//  SmartHomeVC.m
//  NoScreenAudio
//
//  Created by S3Graphic on 16/11/7.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import "SmartHomeVC.h"
#import "macro.h"
@interface SmartHomeVC ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation SmartHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading
//    [self.tableView registerClass:[SmartHomeCell class] forCellReuseIdentifier:@"smartHomeVCCell"];
}
- (IBAction)addDevice:(UITapGestureRecognizer *)sender {
    NSLog(@"开始跳转");
    [self performSegueWithIdentifier:@"toAddDevicePage" sender:self];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55*nKheight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        SmartHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"smartHomeVCCell" forIndexPath:indexPath];
        return cell;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
