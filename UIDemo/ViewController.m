//
//  ViewController.m
//  UIDemo
//
//  Created by iosteams on 2018/10/10.
//  Copyright © 2018年 tielan. All rights reserved.
//

#import "ViewController.h"
#import "TLWebViewViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"UIDemo";
    UIButton *lineBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [lineBtn addTarget:self action:@selector(webviewAciton) forControlEvents:UIControlEventTouchUpInside];
    [lineBtn setTitle:@"webview" forState:UIControlStateNormal];
     [lineBtn setTitle:@"webview" forState:UIControlStateHighlighted];
    lineBtn.frame = CGRectMake(0, 84, 200, 44);
    [self.view addSubview:lineBtn];
}

-(void)webviewAciton{
    TLWebViewViewController *vc = [TLWebViewViewController new];
    vc.pageUrl = @"http://news.cctv.com/m/la/index.shtml?id=ARTIGgV7iVpmT9Q82ICVnaS2181121";
    //vc.pageUrl = @"http://news.cctv1dfasdfasdf.com/m/la/index.shtml?id=ARTIGgV7iVpmT9Q82ICVnaS2181121";

    [self.navigationController pushViewController:vc animated:YES];
}

     
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
