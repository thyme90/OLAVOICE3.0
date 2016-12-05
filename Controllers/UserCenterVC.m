//
//  UserCenterVC.m
//  NoScreenAudio
//
//  Created by S3Graphic on 16/11/2.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import "UserCenterVC.h"

@interface UserCenterVC ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@end

@implementation UserCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _changeUserPicView.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated{
    UserManager* userManger = [UserManager getUserManagerInstance];
    _userNameLabel.text = userManger.nickName;
    [_userPicButton setImage:[UIImage imageNamed:[UserManager getUserManagerInstance].headImage] forState:UIControlStateNormal];
    
    switch (self.accountType) {
        case PHONENUMSUCCESS:{
            if (userManger.olaPhoneNum != nil) {
                _m_phoneNumberLabel.text = userManger.olaPhoneNum;
            }
        }
            break;
        case MAILBOXSUCCESS:{
            _m_OLAAccountLabel.text = userManger.userName;
        }
            break;
        case OLASUCCESS:{
            _m_OLAAccountLabel.text = @"哦啦";
        }
            break;
            
        default:
            break;
    }
}

#pragma mark 返回
- (IBAction)backButtonClickAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}
#pragma mark 修改头像
- (IBAction)changeUserPic:(UIButton *)sender {
    _changeUserPicView.hidden = NO;
}

#pragma mark 绑定或者修改手机号
- (IBAction)bindingOrChangePhoneNumber:(UITapGestureRecognizer *)sender {
    
}
#pragma mark 修改密码
- (IBAction)changePassword:(UITapGestureRecognizer *)sender {
    
}

#pragma mark 退出账号
- (IBAction)logoutAccount:(UIButton *)sender {
    //登出的时候保存用户的信息
    UserManager* userManager = [UserManager getUserManagerInstance];
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    [userDefaultes setObject:userManager.userName forKey:@"userName"];
    [userDefaultes setInteger:userManager.verified forKey:@"verified"];
    [userDefaultes setObject:userManager.headImage forKey:@"headImage"];
    [userDefaultes setObject:userManager.passwd forKey:@"passwd"];
    [userDefaultes setObject:userManager.passwdMD5 forKey:@"passwdMD5"];
    [userDefaultes setInteger:userManager.isLog forKey:@"isLog"];
    [userDefaultes setObject:userManager.olaPhoneNum forKey:@"olaPhoneNum"];
    [userDefaultes setObject:userManager.nickName forKey:@"nickName"];
    [userDefaultes setObject:userManager.phoneVcode forKey:@"phoneVcode"];
    [userDefaultes setInteger:userManager.accountType forKey:@"accountType"];
    [userDefaultes setObject:userManager.currentBoxName forKey:@"currentBoxName"];
    [userDefaultes setObject:userManager.nickNameSetting forKey:@"nickNameSetting"];
    //初始化用户信息
    [[UserManager getUserManagerInstance] initUserManager];
}

#pragma mark ---- 修改头像
#pragma mark - 修改头像 拍照
- (IBAction)takePhotos:(UIButton *)sender {
    _changeUserPicView.hidden = YES;
}

#pragma mark - 修改头像 从相册中选择
- (IBAction)choosePicFromPhotoAlbum:(UIButton *)sender {
    _changeUserPicView.hidden = YES;
    UIImagePickerController *imgPickerController = [[UIImagePickerController alloc] init];
    imgPickerController.delegate = self;
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        NSArray *availableMediaTypeArr = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
        
        imgPickerController.mediaTypes = availableMediaTypeArr;
        [self presentViewController:imgPickerController animated:YES completion:NULL];
    }
}

#pragma mark - 修改头像 取消
- (IBAction)cancelChangeUserPic:(UIButton *)sender {
    _changeUserPicView.hidden = YES;
}

#pragma mark --修改头像
-(BOOL)changeHeadImage:(UIImage*) headImg{
    NSString* imgPath =  [self saveHeadImg:headImg];
    UserManager* userManger = [UserManager getUserManagerInstance];
    _accountType = userManger.accountType;
    NSString* imgurl = userManger.imgurl;
    NSString *url = nil;
    userManger.headImage = imgPath;
    //手机登陆修改头像
    if (_accountType == PHONENUMSUCCESS) {
        NSString* phoneVcode = userManger.phoneVcode;
        url = [[NSString alloc] initWithFormat:@"%@mobile=%@&vcode=%@&imgFile=%@&clientid=%@",CHANGEIMAGE,_m_userNickNameLabel.text, phoneVcode,imgurl,CLINETID];
        
    }else{//邮箱和OLA账号修改头像
        NSString* passwdMD5 = userManger.passwdMD5;
        NSString* vcode = [[CommonHeadFile getCommonHeadFileInstance] random6Code];//生成6位随机验证码
        NSString* md52 = [[NSString alloc] initWithFormat:@"%@%@",passwdMD5,vcode];
        NSString* passwd = [[CommonHeadFile getCommonHeadFileInstance] md5HexDigest:md52];
        url = [[NSString alloc] initWithFormat:@"%@user=%@passwd=%@&vcode=%@&imgFile=%@&clientid=%@",CHANGENICKNAME,_m_userNickNameLabel.text,passwd,vcode,imgurl,CLINETID];
    }
    
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest
                                          returningResponse:&response
                                                      error:&error];
    
    int status = -1;
    //连接成功
    if (error == nil){
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        if (dictionary){
            status =[[dictionary objectForKey:@"status"] intValue];
        }
        //status = 0 成功，-1失败
        if (!status) {
            NSLog(@"头像修改成功!");
            
            return YES;
        }else{
            NSLog(@"头像修改失败!");
            
            return NO;
        }
    }
    return NO;
}

#pragma mark -- UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //set selectd img to bird img
    
    //get selected image
    UIImage *selectedImg = [info valueForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:^(void){
        UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:nil message:@"      正在修改头像" preferredStyle:UIAlertControllerStyleAlert];

        UIActivityIndicatorView *activeView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
 
        activeView.frame = CGRectMake(50,25,10,10);
        [activeView startAnimating];
        [alertDialog.view addSubview:activeView];
        [self presentViewController:alertDialog animated:YES completion:nil];
        
        BOOL isSuccess = [self changeHeadImage:selectedImg];
        if (isSuccess) {
            [alertDialog dismissViewControllerAnimated:YES completion:^(void){
                //                NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
                //                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                //                {
                //                    ALAssetRepresentation *representation = [myasset defaultRepresentation];
                //                    NSString *fileName = [representation filename];
                //                    NSLog(@"fileName : %@",fileName);
                //                };
                //                ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                //                [assetslibrary assetForURL:imageURL
                //                               resultBlock:resultblock
                //                              failureBlock:nil];
                self.m_headImage.image = selectedImg;
            }];
        }
    }];
}

#pragma mark --保存图片
-(NSString*)saveHeadImg:(UIImage*) image{
    //NSString  *pngPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/HeadImg.png"];
    NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/HeadImg.jpg"];
    
    // Write a UIImage to JPEG with minimum compression (best quality)
    // The value 'image' must be a UIImage object
    // The value '1.0' represents image compression quality as value from 0.0 to 1.0
    [UIImageJPEGRepresentation(image, 1.0) writeToFile:jpgPath atomically:YES];
    
    NSString *fileName = @"HeadImg.jpg";
    
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask,YES);
    NSString *documentDirectory =[documentPaths objectAtIndex:0];
    NSString *FileName=[documentDirectory stringByAppendingPathComponent:fileName];
    NSLog(@"FileName is %@",FileName);
    return FileName;
    
    // Write image to PNG
    //[UIImagePNGRepresentation(image) writeToFile:pngPath atomically:YES];
}

 #pragma mark - Navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}
@end
