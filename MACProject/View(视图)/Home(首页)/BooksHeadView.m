//
//  BooksHeadView.m
//  MACProject
//
//  Created by 白洪坤 on 2018/5/6.
//  Copyright © 2018年 com.mackun. All rights reserved.
//

#import "BooksHeadView.h"
#import "UIButton+LXMImagePosition.h"
#import "BookWebViewController.h"
@implementation BooksHeadView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_booksTitle setImagePosition:LXMImagePositionLeft spacing:5.0f];
    [_moreBooksBtn setImagePosition:LXMImagePositionRight spacing:5.0f];
}
- (IBAction)moreBooksBtn:(id)sender {
    NSString *bookReaderURL =[NSString stringWithFormat:@"http://novel.eyassx.com/#/list/%@",__id];
    BookWebViewController *bookWebVC = [[BookWebViewController alloc]init];
    bookWebVC.webUrl = bookReaderURL;
    [_moreBooksBtn.viewController.navigationController pushViewControllerHideTabBar:bookWebVC animated:YES];
}

@end
