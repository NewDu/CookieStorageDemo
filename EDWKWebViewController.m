//
//  EDWKWebViewController.m
//  CookieStorageDemo
//
//  Created by Ella on 2018/5/21.
//  Copyright © 2018年 com.dove. All rights reserved.
//

#import "EDWKWebViewController.h"
#import <WebKit/WebKit.h>
#import "EDWebviewCookieManager.h"
#import <WebKit/WKWebsiteDataStore.h>
#import <WebKit/WKWebsiteDataRecord.h>
#import "EDMacros.h"

static inline WKUserScript * WKCookieUserScript(NSString *cookieString) {
    if (!cookieString.length) {
        return nil;
    }
    WKUserScript *cookieScript = [[WKUserScript alloc] initWithSource:cookieString
                                                        injectionTime:WKUserScriptInjectionTimeAtDocumentStart
                                                     forMainFrameOnly:NO];
    return cookieScript;
}

typedef void(^EDLoadRequestAction)(void);

@interface EDWKWebViewController ()<WKUIDelegate, WKNavigationDelegate>

@property (nonatomic, copy) NSString *rootUrl;
@property (nonatomic, strong) WKWebView *webview;
@property (nonatomic, strong) WKWebView *cookieWebview;
@property (nonatomic, copy) EDLoadRequestAction loadAction;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@end

@implementation EDWKWebViewController

+ (WKProcessPool *)sharedProcessPool
{
    static WKProcessPool *processPool;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        processPool = [WKProcessPool new];
    });
    return processPool;
}

- (instancetype)initWithUrlString:(NSString *)url {
    if (self = [super init]) {
        _rootUrl = url;
    }
    return self;
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"EDWKWebViewController";
    [self.view addSubview:self.webview];
    [self.webview addSubview:self.indicatorView];
    [self startToLoadRequest];
}

- (void)startToLoadRequest {
    [self.indicatorView startAnimating];
    NSURL *url = [NSURL URLWithString:self.rootUrl];
    __weak typeof(self) weakSelf = self;
    self.loadAction = ^{
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf.webview loadRequest:[NSURLRequest requestWithURL:url]];
    };
    [self syncCookieForURL:url loadAction:self.loadAction];
}

- (void)syncCookieForURL:(NSURL *)url loadAction:(EDLoadRequestAction)loadAction {
    [[EDWebviewCookieManager sharedCookieManager] shouldLoadRequestURL:url scriptCallback:^(NSString *cookieScript) {
        if (cookieScript.length) {
            [self.cookieWebview.configuration.userContentController removeAllUserScripts];
            [self.cookieWebview.configuration.userContentController addUserScript:WKCookieUserScript(cookieScript)];
            NSString *baseWebUrl = [NSString stringWithFormat:@"%@://%@", url.scheme,url.host];
            //如果需要加载cookie，则需要再cookie webview加载结束后再加载url，也就是在webView:(WKWebView *)webView didFinishNavigation方法中开始加载url
            [self.cookieWebview loadHTMLString:@"" baseURL:[NSURL URLWithString:baseWebUrl]];
        } else {
            //如果没有cookie需要加载，则直接加载url
            if (loadAction) {
                loadAction();
            }
        }
    }];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    if (webView == self.cookieWebview) {
        //cookieWebview加载成功后开始加载真正的url
        if (self.loadAction) {
            self.loadAction();
        }
        return;
    }
    [self.indicatorView stopAnimating];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self.indicatorView stopAnimating];
}

#pragma mark - getter
- (WKWebView *)webview {
    if (!_webview) {
        WKUserContentController *userContentController = WKUserContentController.new;
        WKWebViewConfiguration* webViewConfig = WKWebViewConfiguration.new;
        webViewConfig.userContentController = userContentController;
        //processPool需要和_cookieWebview的公用一个才能共享_cookieWebview的cookie
        webViewConfig.processPool = [EDWKWebViewController sharedProcessPool];
        
        _webview = [[WKWebView alloc] initWithFrame:CGRectMake(0, NavigationBarHeight, Screen_Width, Screen_Height-NavigationBarHeight) configuration:webViewConfig];
        _webview.UIDelegate = self;
        _webview.navigationDelegate = self;
    }
    return _webview;
}

- (WKWebView *)cookieWebview {
    if (!_cookieWebview) {
        WKUserContentController *userContentController = WKUserContentController.new;
        WKWebViewConfiguration* webViewConfig = WKWebViewConfiguration.new;
        webViewConfig.userContentController = userContentController;
        webViewConfig.processPool = [EDWKWebViewController sharedProcessPool];
        
        _cookieWebview = [[WKWebView alloc] initWithFrame:CGRectZero configuration:webViewConfig];
        _cookieWebview.UIDelegate = self;
        _cookieWebview.navigationDelegate = self;
    }
    return _cookieWebview;
}

- (UIActivityIndicatorView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicatorView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, 200);
    }
    return _indicatorView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
