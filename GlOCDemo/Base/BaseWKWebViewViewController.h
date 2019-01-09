//
//  BaseWKWebViewViewController.h
//  LemonTeach
//
//  Created by gleeeli on 2018/8/20.
//  Copyright © 2018年 boyue. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "WebViewJavascriptBridge.h"

typedef void(^UpdateContentHeight)(CGFloat height);
@interface BaseWKWebViewViewController : UIViewController<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>

@property (strong, nonatomic) WKWebView *webView;
@property (copy, nonatomic) NSString *baseURL;
@property (assign, nonatomic) BOOL isNeedWebViewTitle;
@property (assign, nonatomic) BOOL isNeedProgress;
@property (nonatomic, assign) BOOL isNeedBridge;
@property(nonatomic,strong)WebViewJavascriptBridge *webViewJavascriptBridge;
//更新网页内容高度
@property (nonatomic, copy) UpdateContentHeight updateContentHeight;

/**
 加载网路链接，不能传本地链接
 
 @param url 网络连接
 */
- (void)startLoadWebViewWithNetWorkUrl:(NSString *)url;

/**
 支持本地链接和网络链接
 */
- (void)startLoadWebWithURL:(NSURL *)url;

/**
 初始化自动加载一个url
 
 @param baseUrl 需要加载的url
 */
- (instancetype)initWithBaseHttpUrlStr:(NSString *)baseUrl;

/**
 *  清除wkwebview的缓存,刷新保持最新页面
 */
- (void)cleanWkWebViewCashComplete:(void(^)())complete;

//注册给js调用的方法
- (void)regiseterJavaScriptMethod;
//页面加载完成 此处可执行js代码
- (void)checkUrlRunJavaScript:(NSString *)url jsCode:(NSString *)jsCode;

/**
 自定义返回按钮
 */
-(void)createCustomLeftImgBarButton;
@end
