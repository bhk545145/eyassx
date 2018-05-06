//
//  IWWKWebView.h
//  ShoppingGuide
//
//  Created by 白洪坤 on 2017/9/8.
//  Copyright © 2017年 Andrew554. All rights reserved.
//

#import <WebKit/WebKit.h>

@interface IWWKWebView : WKWebView

@property (nonatomic, strong) NSString *webUrl;

@property (nonatomic, strong) NSString *zanPinurl;

@property (nonatomic, strong)NSString *webviewTitle;
- (instancetype)initWithURL:(NSString *)webUrl;
@end
