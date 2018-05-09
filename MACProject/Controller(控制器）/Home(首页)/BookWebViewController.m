//
//  BookWebViewController.m
//  MACProject
//
//  Created by 白洪坤 on 2018/5/6.
//  Copyright © 2018年 com.mackun. All rights reserved.
//

#import "BookWebViewController.h"
#import "IWWKWebView.h"
@interface BookWebViewController ()
@property (strong, nonatomic) IWWKWebView *webView;
@end

@implementation BookWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupWebView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//设置赞品View
- (void)setupWebView {
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];

    //网页自适配
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tabBarController.tabBar.barTintColor = [UIColor whiteColor];
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"checkUserType_backward_9x15_"] style:UIBarButtonItemStylePlain target:self action:@selector(navigationBackClick)];
    //    self.navigationItem.leftBarButtonItem.enabled = NO;
    UIBarButtonItem *refreshBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"refresh"] style:UIBarButtonItemStylePlain target:self action:@selector(refreshClick)];
    UIBarButtonItem *shareBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"shareZanpin"] style:UIBarButtonItemStylePlain target:self action:@selector(shareZanpinClick)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:refreshBtn, nil];
}

#pragma mark- XXXXXXXXXXXXXXX懒加载部分XXXXXXXXXXXXXXXXXXXX
- (WKWebView *)webView {
    if (!_webView) {
        if (!_webUrl) {
            _webView = [[IWWKWebView alloc] initWithURL:@"http://novel.eyassx.com/#/rank/hot"];
        }else{
            _webView = [[IWWKWebView alloc] initWithURL:_webUrl];
        }
    }
    return _webView;
}

// 返回事件
- (void)navigationBackClick {
    if ([_webView canGoBack]) {
        [self.webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
// 刷新事件
- (void)refreshClick {
    [self.webView reload];
}
// 分享赞品
- (void)shareZanpinClick {
//    [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Bottom;
//    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_IconAndBGRadius;
//    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
//        //在回调里面获得点击的
//        [self runShareWithType:platformType];
//    }];
}



@end
