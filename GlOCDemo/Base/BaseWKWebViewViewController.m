//
//  BaseWKWebViewViewController.m
//  LemonTeach
//
//  Created by 小柠檬 on 2018/8/20.
//  Copyright © 2018年 boyue. All rights reserved.
//

#import "BaseWKWebViewViewController.h"
#import "GlWebViewProgressView.h"

@interface BaseWKWebViewViewController ()
@property (strong, nonatomic) GlWebViewProgressView *progressView;
@property (assign, nonatomic) BOOL isAddprogressView;
//是否已经添加监听，否则移除会闪退
@property (nonatomic, assign) BOOL isAddObserver;
@end

@implementation BaseWKWebViewViewController

- (instancetype)initWithBaseHttpUrlStr:(NSString *)baseUrl
{
    self = [super init];
    if (self)
    {
        if ([baseUrl isKindOfClass:[NSString class]]) {
            self.baseURL = baseUrl;
        }
        self.isNeedProgress = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.isAddprogressView = NO;
    
    
    [self initWkWebViewInfo];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(!self.isAddprogressView)
    {
        self.isAddprogressView = YES;
        [self.navigationController.navigationBar addSubview:self.progressView];
    }
    
    if (self.isNeedProgress) {
        self.progressView.hidden = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.isNeedProgress) {
        self.progressView.hidden = YES;
    }
}

/**
 自定义返回按钮
 */
-(void)createCustomLeftImgBarButton{
    UIBarButtonItem *backItem;
    //配置返回按钮距离屏幕边缘的距离
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    UIButton *backButton;
    if (kSystemVersion >= 11.0) {
        backButton = [[UIButton alloc]init];
        [backButton setImage:[UIImage imageNamed:@"back_login"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(backItemClick:) forControlEvents:UIControlEventTouchUpInside];
        backItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
        
        backButton.sd_layout
        .leftEqualToView(self.navigationController.navigationBar)
        .topSpaceToView(self.navigationController.navigationBar, 0)
        .widthIs(44)
        .heightIs(44);
        
        backButton.imageView.sd_layout
        .centerYEqualToView(backButton).offset(-2)
        .leftSpaceToView(backButton, -8.4)
        .widthIs(25)
        .heightIs(25);
    }else {
        spaceItem.width = - 8;
        backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_login"] style:UIBarButtonItemStylePlain target:self action:@selector(backItemClick:)];
    }
    
    self.navigationItem.leftBarButtonItems = @[spaceItem,backItem];
    
    if (backButton) {
        [backButton updateLayout];
        [backButton.imageView updateLayout];
    }
    
}

- (void)backItemClick:(UIBarButtonItem *)btnItem {
    if (self.navigationController && [self.navigationController.viewControllers count] > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (GlWebViewProgressView *)progressView
{
    if (_progressView == nil) {
        CGFloat pheight = 1.0;
        CGFloat ptop = [self getNavigationBarHeight] - [self getStatusBarHeight] - pheight;
        _progressView = [[GlWebViewProgressView alloc] initWithFrame:CGRectMake(0, ptop, SCREEN_WIDTH, pheight)];
        
        _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    }
    return _progressView;
}

- (CGFloat)getNavigationBarHeight
{
    CGRect statusRect = [UIApplication sharedApplication].statusBarFrame;
    return statusRect.size.height + 44;
}
- (CGFloat)getStatusBarHeight
{
    CGRect statusRect = [UIApplication sharedApplication].statusBarFrame;
    return statusRect.size.height;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return YES;
    
    return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

- (void)setIsNeedProgress:(BOOL)isNeedProgress
{
    _isNeedProgress = isNeedProgress;
    
    if (_isNeedProgress)
    {
        self.progressView.hidden = NO;
    }
    else
    {
        self.progressView.hidden = YES;
    }
}

- (WKWebView *)webView
{
    if (_webView == nil) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.userContentController = [WKUserContentController new];
        
        WKPreferences *preferences = [WKPreferences new];
        preferences.javaScriptCanOpenWindowsAutomatically = YES;
        //preferences.minimumFontSize = 30.0;
        configuration.preferences = preferences;
        
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 150, SCREEN_WIDTH, 0) configuration:configuration];
        
    }
    
    return _webView;
}

/**
 *  初始化wkwebView
 */
- (void)initWkWebViewInfo
{
    NSLog(@"初始化WKWebView");
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.scrollView.scrollEnabled = YES;
    self.webView.scrollView.bounces = NO;
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    [self.webView setUserInteractionEnabled:YES];
    [self.webView setOpaque:NO];
    
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    
    self.webView.translatesAutoresizingMaskIntoConstraints = NO;

    CGFloat topHeight = self.isNeedProgress == YES? kTopHeight:0;
    
    if (@available(iOS 11, *)) {
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else if(self.isNeedProgress == YES) {//isNeedProgress == YES视为需要导航栏
        self.automaticallyAdjustsScrollViewInsets = NO;
//        if (iPhoneX) {
//            self.webView.scrollView.contentInset = UIEdgeInsetsMake(88, 0, 0, 0);
//        } else {
//            self.webView.scrollView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
//        }
    }
    [self.view addSubview:self.webView];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(topHeight);
    }];
    
    self.isAddObserver = YES;
    [self.webView addObserver:self forKeyPath:@"loading" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    if (self.baseURL && ![self.baseURL isEqualToString:@""])
    {
        [self startLoadWebViewWithNetWorkUrl:self.baseURL];
    }
    if (self.isNeedBridge) {
        [self registerBridge];
    }
}

-(void)registerBridge
{
    [WebViewJavascriptBridge enableLogging];
    _webViewJavascriptBridge = [WebViewJavascriptBridge bridgeForWebView:self.webView];
    [_webViewJavascriptBridge setWebViewDelegate:self];
    
    [self regiseterJavaScriptMethod];
}

- (void)regiseterJavaScriptMethod{
}

- (void)startLoadWebViewWithNetWorkUrl:(NSString *)url
{
    if (url == nil) {
        return;
    }
    self.baseURL = url;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20];
    [self.webView loadRequest:request];
}

- (void)startLoadWebWithURL:(NSURL *)url
{
    if (url == nil) {
        return;
    }
    self.baseURL = url.absoluteString;
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

#pragma mark UIDelegate WkWebView的代理方法
- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    //会拦截到window.open()事件.
    //只需要我们在在方法内进行处理
    if (!navigationAction.targetFrame.isMainFrame)
    {
        NSLog(@"拦截到window.open()事件,__blank");
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}



#pragma mark WKNavigationDelegate WkWebView的代理方法
/**
 *  页面开始加载时调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 */
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    
    NSLog(@"页面开始加载时调用：%s\n%@", __FUNCTION__,webView.URL.absoluteString);
}


/**
 *  当内容开始返回时调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 */
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    NSLog(@"当内容开始返回时调用：%s\n%@", __FUNCTION__,webView.URL.absoluteString);
    
}


/**
 *  页面加载完成之后调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    //self.isPageLoadTimeOut = NO;
    NSString *nowUrl = webView.URL.absoluteString;
    NSLog(@"页面加载完成之后调用：%s\n%@", __FUNCTION__,nowUrl);
    
    [self readGainContentHeight];
    [self checkUrlRunJavaScript:nowUrl jsCode:nil];
}

- (void)readGainContentHeight
{
    [self startGainContentHeight];
    //两秒后再执行一次 不然高度不准?
    kWeakSelf(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (weakself) {
            [weakself startGainContentHeight];
        }
    });
    
}
- (void)checkUrlRunJavaScript:(NSString *)url jsCode:(NSString *)jsCode{
    if (jsCode) {
        [self.webView evaluateJavaScript:jsCode completionHandler:^(id _Nullable sender, NSError * _Nullable error) {
            
        }];

    }
}




- (void)startGainContentHeight
{
    if (self.updateContentHeight) {
        kWeakSelf(self);
        //获取内容实际高度（像素）@"document.getElementById(\"content\").offsetHeight;"
        //document.body.offsetHeight
        //document.body.scrollHeight
        __block CGFloat webViewHeight = 0;
        [self.webView evaluateJavaScript:@"document.body.scrollHeight" completionHandler:^(id _Nullable result,NSError * _Nullable error) {
            //获取页面高度，并重置webview的frame
            webViewHeight = [result doubleValue];
            //webView.height = webViewHeight;
            NSLog(@"网页内容高度%f",webViewHeight);
            if (weakself) {
                weakself.updateContentHeight(webViewHeight);
            }
        }];
    }
}


- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"didFailNavigation：%s\n%@", __FUNCTION__,webView.URL.absoluteString);
    if(error.code == -999)//有遇到该情况
    {
        NSLog(@"取消转圈webfail");
    }
    else
    {
        NSLog(@"取消转圈fnav");
    }
}


/**
 *  加载失败时调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 *  @param error      错误
 */
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    
    NSLog(@"加载失败时调用：%s\n%@\nerror:%@", __FUNCTION__,webView.URL.absoluteString,error);
    //-1001 网络超时
    //-1002 unsupported URL
    //-999 中途被跳转
    //Code=102 "帧框加载已中断"
    if (error.code != 102)
    {
        NSString *msg = [NSString stringWithFormat:@"网络异常%ld",(long)error.code];
        //[MBProgressHUD showErrorWithText:msg];
    }
    
}


/**
 *  接收到服务器跳转请求之后调用
 *
 *  @param webView      实现该代理的webview
 *  @param navigation   当前navigation
 */
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation
{
    
    NSLog(@"接收到服务器跳转请求之后调用：%s\n%@", __FUNCTION__,webView.URL.absoluteString);
}


#pragma mark 决定是否跳转
/**
 *  在发送请求之前，决定是否跳转
 *
 *  @param webView          实现该代理的webview
 *  @param navigationAction 当前navigation
 *  @param decisionHandler  是否调转block
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSLog(@"在发送请求之前，决定是否跳转：%s\n%@,\nnavigation:%@", __FUNCTION__,webView.URL.absoluteString,navigationAction.request.URL.absoluteString);
    
    NSURL *url = navigationAction.request.URL;
    if ([url.absoluteString hasPrefix:@"itms-appss://"]) {
        [[UIApplication sharedApplication] openURL:url];
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    else
    {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}


/**
 *  在收到响应后，决定是否跳转
 *
 *  @param webView            实现该代理的webview
 *  @param navigationResponse 当前navigation
 *  @param decisionHandler    是否跳转block
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    
    NSLog(@"在收到响应后，决定是否跳转：%s\n%@", __FUNCTION__,navigationResponse.response.URL.absoluteString);
    decisionHandler(WKNavigationResponsePolicyAllow);
}


- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *__nullable credential))completionHandler
{
    NSURLCredential *cred = [[NSURLCredential alloc]initWithTrust:challenge.protectionSpace.serverTrust];
    completionHandler(NSURLSessionAuthChallengeUseCredential, cred);
    NSLog(@"didReceiveAuthenticationChallenge：%s\n%@", __FUNCTION__,webView.URL.absoluteString);
}


- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action)
                                {
                                    completionHandler();
                                }]];
    
    [self presentViewController:alertController animated:YES completion:^{}];
}


- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                          completionHandler(YES);
                                                      }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action){
                                                          completionHandler(NO);
                                                      }]];
    
    [self presentViewController:alertController animated:YES completion:^{}];
}
    
-(void)viewDidLayoutSubviews{
     [self.webView setNeedsLayout];
}

#pragma mark - 监听WkWebView加载进度事件 KVO
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context
{
    NSString *webString = self.webView.URL.absoluteString;
    
    if ([keyPath isEqualToString:@"loading"])
    {
        NSLog(@"loading");
    }
    else if ([keyPath isEqualToString:@"title"])
    {
        NSLog(@"title:%@",self.webView.title);
        if (self.isNeedWebViewTitle)
        {
            self.title = self.webView.title;
        }
    }
    else if ([keyPath isEqualToString:@"estimatedProgress"])
    {
        NSLog(@"progress: %f", self.webView.estimatedProgress);
        
        self.progressView.progress = self.webView.estimatedProgress;
    }
    
    // 加载完成
    if (!self.webView.loading)
    {
        NSLog(@"加载完成:%@",webString);
    }
}

- (void)dealloc
{
    if (self.isAddObserver) {
        [self.webView removeObserver:self forKeyPath:@"loading"];
        [self.webView removeObserver:self forKeyPath:@"title"];
        [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    [self.progressView removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/**
 *  清除wkwebview的缓存,刷新保持最新页面
 */
- (void)cleanWkWebViewCashComplete:(void(^)())complete
{
    if (kSystemVersion >= 9.0)
    {
        NSSet *websiteDataTypes = [NSSet setWithArray:@[
                                                        WKWebsiteDataTypeDiskCache,
                                                        WKWebsiteDataTypeOfflineWebApplicationCache,
                                                        WKWebsiteDataTypeMemoryCache,
                                                        WKWebsiteDataTypeLocalStorage,
                                                        WKWebsiteDataTypeCookies,
                                                        WKWebsiteDataTypeSessionStorage,
                                                        WKWebsiteDataTypeIndexedDBDatabases,
                                                        WKWebsiteDataTypeWebSQLDatabases
                                                        ]];
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes
                                                   modifiedSince:dateFrom completionHandler:^
         {
             NSLog(@"清除web缓存完成");
             complete();
         }];
        
        [self clearAllCache];
    }
    else
    {
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
        NSError *errors;
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
        complete();
    }
}

/**
 清除所有缓存，兼容模式
 */
- (void)clearAllCache
{
    NSString *libraryDir = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,
                                                               NSUserDomainMask, YES)[0];
    NSString *bundleId  =  [[[NSBundle mainBundle] infoDictionary]
                            objectForKey:@"CFBundleIdentifier"];
    NSString *webkitFolderInLib = [NSString stringWithFormat:@"%@/WebKit",libraryDir];
    NSString *webKitFolderInCaches = [NSString
                                      stringWithFormat:@"%@/Caches/%@/WebKit",libraryDir,bundleId];
    NSString *webKitFolderInCachesfs = [NSString
                                        stringWithFormat:@"%@/Caches/%@/fsCachedData",libraryDir,bundleId];
    
    NSError *error;
    /* iOS8.0 WebView Cache的存放路径 */
    [[NSFileManager defaultManager] removeItemAtPath:webKitFolderInCaches error:&error];
    [[NSFileManager defaultManager] removeItemAtPath:webkitFolderInLib error:nil];
    
    /* iOS7.0 WebView Cache的存放路径 */
    [[NSFileManager defaultManager] removeItemAtPath:webKitFolderInCachesfs error:&error];
}
@end
