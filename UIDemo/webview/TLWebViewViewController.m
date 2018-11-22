//
//  TLWebViewViewController.m
//  UIDemo
//
//  Created by iosteams on 2018/11/22.
//  Copyright © 2018年 tielan. All rights reserved.
//

#import "TLWebViewViewController.h"
#import <WebKit/WebKit.h>
#import "JHUD.h"

#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

#define kIs_iPhoneX  kScreenHeight >=812.0f
#define kNavBarAndStatusBarHeight (CGFloat)(kIs_iPhoneX?(88.0):(64.0))
#define kBottomSafeHeight (CGFloat)(kIs_iPhoneX?(34.0):(0))


@interface TLWebViewViewController ()<WKUIDelegate, WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *  webView;
@property (nonatomic, strong) UIProgressView * progressView;
@property (nonatomic, strong) JHUD * hudView;

@end

@implementation TLWebViewViewController


#pragma mark -- Getter
- (UIProgressView *)progressView
{
    if (!_progressView){
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, kNavBarAndStatusBarHeight + 1, self.view.frame.size.width, 2)];
        _progressView.tintColor = [UIColor blueColor];
        _progressView.trackTintColor = [UIColor clearColor];
        _progressView.hidden = YES;
    }
    return _progressView;
}

- (WKWebView *)webView{
    if(_webView == nil){
        //创建网页配置对象
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        // 创建设置对象
        WKPreferences *preference = [[WKPreferences alloc]init];
        //最小字体大小 当将javaScriptEnabled属性设置为NO时，可以看到明显的效果
        preference.minimumFontSize = 0;
        //设置是否支持javaScript 默认是支持的
        preference.javaScriptEnabled = YES;
        // 在iOS上默认为NO，表示是否允许不经过用户交互由javaScript自动打开窗口
        preference.javaScriptCanOpenWindowsAutomatically = YES;
        config.preferences = preference;
        // 是使用h5的视频播放器在线播放, 还是使用原生播放器全屏播放
        config.allowsInlineMediaPlayback = YES;
        //设置是否允许画中画技术 在特定设备上有效
        config.allowsPictureInPictureMediaPlayback = YES;
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) configuration:config];
        // UI代理
        _webView.UIDelegate = self;
        // 导航代理
        _webView.navigationDelegate = self;
        // 是否允许手势左滑返回上一级, 类似导航控制的左滑返回
        _webView.allowsBackForwardNavigationGestures = YES;
    }
    return _webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationItem];
    [self.view addSubview:self.webView];
    [self.view addSubview:self.progressView];
    self.hudView = [[JHUD alloc] initWithFrame:self.webView.bounds];
    
    
    //添加监测网页加载进度的观察者
    [self.webView addObserver:self
                   forKeyPath:NSStringFromSelector(@selector(estimatedProgress))
                      options:0
                      context:nil];
    [self.webView addObserver:self forKeyPath:@"title"  options:NSKeyValueObservingOptionNew  context:nil];
    if(self.pageUrl != nil){
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.pageUrl]];
        request.timeoutInterval = 3000;
        [self.webView loadRequest:request];
    }
}


- (void)setupNavigationItem{
    // 后退按钮
    UIButton * goBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [goBackButton setImage:[UIImage imageNamed:@"backbutton"] forState:UIControlStateNormal];
    [goBackButton addTarget:self action:@selector(goBackAction:) forControlEvents:UIControlEventTouchUpInside];
    goBackButton.frame = CGRectMake(0, 0, 30, kNavBarAndStatusBarHeight);
    UIBarButtonItem * goBackButtonItem = [[UIBarButtonItem alloc] initWithCustomView:goBackButton];
      self.navigationItem.leftBarButtonItems = @[goBackButtonItem];
    // 刷新按钮
    UIButton * refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [refreshButton setImage:[UIImage imageNamed:@"webRefreshButton"] forState:UIControlStateNormal];
    [refreshButton addTarget:self action:@selector(refreshAction:) forControlEvents:UIControlEventTouchUpInside];
    refreshButton.frame = CGRectMake(0, 0, 30, kNavBarAndStatusBarHeight);
    UIBarButtonItem * refreshButtonItem = [[UIBarButtonItem alloc] initWithCustomView:refreshButton];
    self.navigationItem.rightBarButtonItems = @[refreshButtonItem,];
    
}

- (void)goBackAction:(id)sender{
    if([_webView canGoBack]){
        [_webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
- (void)refreshAction:(id)sender{
    [_webView reload];
}


//kvo 监听进度 必须实现此方法
-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                      context:(void *)context{
    
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))]
        && object == _webView) {
        NSLog(@"网页加载进度 = %f",_webView.estimatedProgress);
        self.progressView.progress = _webView.estimatedProgress;
        if (_webView.estimatedProgress >= 1.0f) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progressView.progress = 0;
            });
        }
    }else if([keyPath isEqualToString:@"title"]
             && object == _webView){
        self.navigationItem.title = _webView.title;
    }else{
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
    }
}


#pragma mark -- WKNavigationDelegate
/*
 WKNavigationDelegate主要处理一些跳转、加载处理操作，WKUIDelegate主要处理JS脚本，确认框，警告框等
 */

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"页面开始加载时调用->didStartProvisionalNavigation");
    //显示
    [self.hudView showAtView:self.webView hudType:JHUDLoadingTypeCircle];
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    [self.progressView setProgress:0.0f animated:NO];
    NSLog(@"页面加载失败时调用->didFailProvisionalNavigation");
    [self.hudView showAtView:self.webView hudType:JHUDLoadingTypeFailure];
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    NSLog(@"当内容开始返回时调用->didCommitNavigation");
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"页面加载完成之后调用->didFinishNavigation");
    //隐藏
    [self.hudView hide];
}

//提交发生错误时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self.progressView setProgress:0.0f animated:NO];
    NSLog(@"提交发生错误时调用->didFailNavigation");
}

// 接收到服务器跳转请求即服务重定向时之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"接收到服务器跳转请求即服务重定向时之后调用->didReceiveServerRedirectForProvisionalNavigation");
}

// 根据WebView对于即将跳转的HTTP请求头信息和相关信息来决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSString * urlStr = navigationAction.request.URL.absoluteString;
    //自己定义的协议头
    NSString *htmlHeadString = @"github://";
    if([urlStr hasPrefix:htmlHeadString]){
        decisionHandler(WKNavigationActionPolicyCancel);
    }else{
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

// 根据客户端受到的服务器响应头以及response相关信息来决定是否可以跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    NSString * urlStr = navigationResponse.response.URL.absoluteString;
    NSLog(@"当前跳转地址：%@",urlStr);
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
}

//进程被终止时调用
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
    
}

#pragma mark -- WKUIDelegate

/**
 *  web界面中有弹出警告框时调用
 *
 *  @param webView           实现该代理的webview
 *  @param message           警告框中的内容
 *  @param completionHandler 警告框消失调用
 */
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}
// 确认框
//JavaScript调用confirm方法后回调的方法 confirm是js中的确定框，需要在block中把用户选择的情况传递进去
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}
// 输入框
//JavaScript调用prompt方法后回调的方法 prompt是js中的输入框 需要在block中把用户输入的信息传入
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}
// 页面是弹出窗口 _blank 处理
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

- (void)dealloc{
    //移除观察者
    [_webView removeObserver:self
                  forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
    [_webView removeObserver:self
                  forKeyPath:NSStringFromSelector(@selector(title))];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}












@end
