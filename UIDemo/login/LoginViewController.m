//
//  LoginViewController.m
//  UIDemo
//
//  Created by iosteams on 2018/11/23.
//  Copyright © 2018年 tielan. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@property(nonatomic,strong) UIView *contentView;
@property(nonatomic,strong) UIImageView *logoView;
@property(nonatomic,strong) UILabel *titleLable;
@property(nonatomic,strong) UILabel *subTitleLable;

@property(nonatomic,strong) UIView *fistView;
@property(nonatomic,strong) UIView *secendView;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    UIButton *exitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [exitBtn setTitle:@"exit" forState:UIControlStateNormal];
    [exitBtn setTitle:@"exit" forState:UIControlStateHighlighted];
    exitBtn.frame = CGRectMake(0, 22, 40, 40);
    [exitBtn addTarget:self action:@selector(exitAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:exitBtn];
    
    self.contentView = [[UIView alloc] init];
    self.contentView.frame = CGRectMake(0, 80+88, self.view.frame.size.width, 600);
    [self.view addSubview:self.contentView];
    
    self.logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    self.logoView.backgroundColor = [UIColor whiteColor];
    self.logoView.frame = CGRectMake(65, 0, 78, 78);
    [self.contentView addSubview:self.logoView];
    
    self.titleLable = [[UILabel alloc] init];
    self.titleLable.text = @"平和堂商城";
    self.titleLable.textColor = [UIColor whiteColor];
    self.titleLable.frame = CGRectMake(65+78+13, 20, 100, 16);
    [self.contentView addSubview:self.titleLable];
    
    self.subTitleLable = [[UILabel alloc] init];
    self.subTitleLable.text = @"「地域社会へ尽くす」企業を目指します";
    self.subTitleLable.textColor = [UIColor whiteColor];
    self.subTitleLable.frame = CGRectMake(65+78+10, 46, 200, 10);
    [self.contentView addSubview:self.subTitleLable];
    
    self.fistView = [[UIView alloc] init];
    self.fistView.frame = CGRectMake(68, 282-95, 240, 41);
    [self.view addSubview:self.fistView];
    
    self.secendView = [[UIView alloc] init];
    [self.view addSubview:self.secendView];
    
}

-(void)exitAction{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end















