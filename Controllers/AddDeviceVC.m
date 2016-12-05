//
//  AddDeviceVC.m
//  NoScreenAudio
//
//  Created by S3Graphic on 16/11/18.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import "AddDeviceVC.h"

@interface AddDeviceVC ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation AddDeviceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"first reuse";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    return cell;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    //toLinkWifiPage
    //Eligible
}


@end
