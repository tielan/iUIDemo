//
//  ViewController.m
//  UIDemo
//
//  Created by iosteams on 2018/10/10.
//  Copyright © 2018年 tielan. All rights reserved.
//

#import "ViewController.h"
#import "TLWebViewViewController.h"
#import "LBXPermission.h"
#import "LBXPermissionSetting.h"
#import "TLScanViewController.h"
#import "CreateBarCodeViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"UIDemo";
    {
        UIButton *lineBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [lineBtn addTarget:self action:@selector(webviewAciton) forControlEvents:UIControlEventTouchUpInside];
        [lineBtn setTitle:@"webview" forState:UIControlStateNormal];
        [lineBtn setTitle:@"webview" forState:UIControlStateHighlighted];
        lineBtn.frame = CGRectMake(0, 84, 200, 44);
        [self.view addSubview:lineBtn];
    }
    {
        UIButton *lineBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [lineBtn addTarget:self action:@selector(scanView) forControlEvents:UIControlEventTouchUpInside];
        [lineBtn setTitle:@"scanView" forState:UIControlStateNormal];
        [lineBtn setTitle:@"scanView" forState:UIControlStateHighlighted];
        lineBtn.frame = CGRectMake(0, 84+64, 200, 44);
        [self.view addSubview:lineBtn];
    }
    {
        UIButton *lineBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [lineBtn addTarget:self action:@selector(createCode) forControlEvents:UIControlEventTouchUpInside];
        [lineBtn setTitle:@"createCode" forState:UIControlStateNormal];
        [lineBtn setTitle:@"createCode" forState:UIControlStateHighlighted];
        lineBtn.frame = CGRectMake(0, 84+64+64, 200, 44);
        [self.view addSubview:lineBtn];
    }
}

-(void)webviewAciton{
    TLWebViewViewController *vc = [TLWebViewViewController new];
    vc.pageUrl = @"http://news.cctv.com/m/la/index.shtml?id=ARTIGgV7iVpmT9Q82ICVnaS2181121";
    //vc.pageUrl = @"http://news.cctv1dfasdfasdf.com/m/la/index.shtml?id=ARTIGgV7iVpmT9Q82ICVnaS2181121";

    [self.navigationController pushViewController:vc animated:YES];
}

-(void)scanView{
    [LBXPermission authorizeWithType:LBXPermissionType_Camera completion:^(BOOL granted, BOOL firstTime) {
        if (granted) {
            //添加一些扫码或相册结果处理
            TLScanViewController *vc = [TLScanViewController new];
            //镜头拉远拉近功能
            vc.isVideoZoom = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if(!firstTime)
        {
            [LBXPermissionSetting showAlertToDislayPrivacySettingWithTitle:@"提示" msg:@"没有相机权限，是否前往设置" cancel:@"取消" setting:@"设置" ];
        }
    }];
}

-(void)createCode{
    CreateBarCodeViewController *vc = [CreateBarCodeViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

     
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
