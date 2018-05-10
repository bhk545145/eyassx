//
//  IWWKWebView.m
//  ShoppingGuide
//
//  Created by 白洪坤 on 2017/9/8.
//  Copyright © 2017年 Andrew554. All rights reserved.
//

#import "IWWKWebView.h"
#import <WebKit/WebKit.h>
#import "SVProgressHUD.h"

@interface IWWKWebView()<WKNavigationDelegate,WKUIDelegate>{
    dispatch_queue_t queue;
    
}
@property (nonatomic, strong) UIProgressView *progressView;
@end

@implementation IWWKWebView



- (instancetype)initWithURL:(NSString *)webUrl{
    self = [super init];
    self.backgroundColor = [UIColor whiteColor];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.progressView];
    queue = dispatch_queue_create("latiaoQueue", DISPATCH_QUEUE_CONCURRENT);
    self.UIDelegate = self;
    self.navigationDelegate = self;
    [self addObserver:self
                   forKeyPath:@"estimatedProgress"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
    [SVProgressHUD showWithStatus:@"正在加载中"];
    NSString *zanPinURL = [NSString stringWithFormat:@"%@",webUrl];
    [self loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:zanPinURL]]];
    return self;
}

- (void)setWebUrl:(NSString *)webUrl {
    _webUrl = webUrl;
//    dispatch_async(queue, ^{
//        NSString *zanPinURL = [NSString stringWithFormat:@"%@",webUrl];
//        [self loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:zanPinURL]]];
//    });
}



#pragma mark- XXXXXXXXXXXXXXX懒加载部分XXXXXXXXXXXXXXXXXXXX
- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] init];
        _progressView.progressTintColor = [UIColor appMainColor];
        _progressView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 2);
    }
    return _progressView;
}
- (void)dealloc {
    [self removeObserver:self forKeyPath:@"estimatedProgress" context:nil];
}

#pragma mark- XXXXXXXXXXXXXXXKVO监听XXXXXXXXXXXXXXXXXXXX
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = self.estimatedProgress;
        // 加载完成
        if (self.estimatedProgress  >= 1.0f ) {
            [UIView animateWithDuration:0.25f animations:^{
                self.progressView.alpha = 0.0f;
                self.progressView.progress = 0.0f;
                [SVProgressHUD dismiss];
            }];
        }else{
            self.progressView.alpha = 1.0f;
        }
    }
}

#pragma mark - WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    //    [SVProgressHUD showWithStatus:@"正在加载"];
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    _zanPinurl = webView.URL.absoluteString;
    _webviewTitle = webView.title;
    DLog(@"URL.absoluteString:%@",webView.URL.absoluteString);
    DLog(@"%@",webView.title);
    [self getLatelyBookDic];
    [self getBookshelfData];
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    [SVProgressHUD showErrorWithStatus:@"加载失败"];
}
// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    return;
}
// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    DLog(@"request.URL.absoluteString:%@",navigationAction.request.URL.absoluteString);
    [self getLatelyBookDic];
    [self getBookshelfData];
    //如果是跳转一个新页面
    if (navigationAction.targetFrame == nil) {
        [webView loadRequest:navigationAction.request];
        decisionHandler(WKNavigationActionPolicyCancel);
    }else {
        //允许跳转
        decisionHandler(WKNavigationActionPolicyAllow);
        [self foraward:navigationAction.request];
    }
    
}
#pragma mark - WKUIDelegate
// 创建一个新的WebView
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    return [[WKWebView alloc]init];
}
// 输入框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler{
    completionHandler(@"http");
}
// 确认框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
    completionHandler(YES);
}
// 警告框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    NSLog(@"%@",message);
    completionHandler();
}

//获取上次阅读的书
- (NSDictionary *)getLatelyBookDic {
    __block NSDictionary *latelyBookDic = [NSDictionary dictionary];
    //    NSString * userContent = [NSString stringWithFormat:@"{\"token\": \"%@\", \"userId\": %@}", @"a1cd4a59-974f-44ab-b264-46400f26c849", @"89"];
    // 设置localStorage
    //    NSString *jsString = [NSString stringWithFormat:@"localStorage.setItem('userContent', '%@')", userContent];
    // 移除localStorage
    // NSString *jsString = @"localStorage.removeItem('userContent')";
    // 获取localStorage
    NSString *jsString = @"localStorage.getItem('RM_LATELY_BOOK')";
    [self evaluateJavaScript:jsString completionHandler:^(id _Nullable localStorage, NSError * _Nullable error) {
        latelyBookDic = localStorage;
        if (latelyBookDic != nil && ![latelyBookDic isKindOfClass:[NSNull class]]) {
            [[NSUserDefaults standardUserDefaults] setObject:latelyBookDic forKey:@"latelyBookDic"];
        }
    }];
    return latelyBookDic;
}

//读取书架数据
- (NSArray *)getBookshelfData {
    __block NSArray *bookshelfList = [NSArray array];
    NSString *jsString = @"localStorage.getItem('RM_SHEFLBOOK')";
    [self evaluateJavaScript:jsString completionHandler:^(id _Nullable localStorage, NSError * _Nullable error) {
        bookshelfList = localStorage;
        if (bookshelfList != nil && ![bookshelfList isKindOfClass:[NSNull class]]) {
            [[NSUserDefaults standardUserDefaults] setObject:bookshelfList forKey:@"bookshelfList"];
        }
    }];
    return bookshelfList;
}

-(void)foraward:(NSURLRequest *)request{
    NSString *URLString = [NSString stringWithFormat:@"%@",request.URL];
    
    
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]) {
        // 淘宝
        if ([URLString containsString:@"taobao://m.taobao.com"]) {
            if ([[UIApplication sharedApplication] canOpenURL:request.URL]) {
                [[UIApplication sharedApplication] openURL:request.URL options:@{} completionHandler:nil];
            }
        }
        
        if ([URLString containsString:@"tbopen://m.taobao.com"]) {
            if ([[UIApplication sharedApplication] canOpenURL:request.URL]) {
                [[UIApplication sharedApplication] openURL:request.URL options:@{} completionHandler:nil];
            }
        }
        
        // 天猫
        if ([URLString containsString:@"tmall://m.tmall.com"]) {
            if ([[UIApplication sharedApplication] canOpenURL:request.URL]) {
                [[UIApplication sharedApplication] openURL:request.URL options:@{} completionHandler:nil];
            }
        }
    } else {
        [[UIApplication sharedApplication] openURL:request.URL];
    }
    
}

@end
