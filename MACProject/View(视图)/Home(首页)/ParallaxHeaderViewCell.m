//
//  ParallaxHeaderViewCell.m
//  MACProject
//
//  Created by MacKun on 16/8/12.
//  Copyright © 2016年 com.mackun. All rights reserved.
//

#import "ParallaxHeaderViewCell.h"
#import "UIButton+LXMImagePosition.h"
#import "CitysViewController.h"
#import "BookSpreadModel.h"
#import "BookWebViewController.h"
@implementation ParallaxHeaderViewCell
- (IBAction)cityAction:(id)sender {
    DLog(@"点击城市选择！");
    
    CitysViewController *citysVC = [[CitysViewController alloc]init];
    [_btnCity.viewController.navigationController pushViewControllerHideTabBar:citysVC animated:YES];
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    _link = @"";
    [_btnCity setImagePosition:LXMImagePositionRight spacing:5.0f];
}

-(void)setSpreadArry:(NSMutableArray *)spreadArry {
    _spreadArry = spreadArry;
    //bannerView
    self.bannerView = [[UIScrollView alloc]init];
    self.bannerView.delegate = self;
    self.bannerView.pagingEnabled = YES;
    
    self.bannerView.showsHorizontalScrollIndicator = NO;
    self.bannerView.showsVerticalScrollIndicator = NO;
    self.bannerView.contentSize = CGSizeMake(self.width*spreadArry.count, 0);
    [self addSubview:self.bannerView];

    //对srcollView添加点击响应
    UITapGestureRecognizer *sigleTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGesture:)];
    sigleTapRecognizer.numberOfTapsRequired = 1;
    [self.bannerView addGestureRecognizer:sigleTapRecognizer];

    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self);
    }];
    for (int i = 0;i <spreadArry.count; i++) {
        BookSpreadModel *model = spreadArry[i];
        UIImageView *img1 = [[UIImageView alloc] initWithFrame:CGRectMake(self.width*i, 0, self.width, self.height)];
        [img1 mac_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"sy_banner"]];
        [self.bannerView addSubview:img1];
    }
    
    //pageControl
    self.pageControl = [[UIPageControl alloc]init];
    self.pageControl.numberOfPages = spreadArry.count;
    self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor appBlueColor];
    [self addSubview:self.pageControl];
    
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.height.mas_equalTo(@37);
    }];
}

-(void)handleTapGesture:( UITapGestureRecognizer *)tapRecognizer
{
    NSUInteger tapCount = tapRecognizer.numberOfTapsRequired;
    // 先取消任何操作???????这句话存在的意义？？？
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    switch (tapCount){
        case 1:
            [self performSelector:@selector(spreadImageViewBtn) withObject:nil afterDelay:0.22];
            break;
            //        case 2:
            //           [self handleDoubleTap:tapRecognizer];
            break;
    }
}
-(void)spreadImageViewBtn {
    NSString *bookReaderURL = nil;
    if ([_link isBlank]) {
        BookSpreadModel *model = _spreadArry[0];
        bookReaderURL = [NSString stringWithFormat:@"http://novel.eyassx.com/#/book/%@",model.link];
    }else{
        bookReaderURL =[NSString stringWithFormat:@"http://novel.eyassx.com/#/book/%@",_link];
    }
    BookWebViewController *bookWebVC = [[BookWebViewController alloc]init];
    bookWebVC.webUrl = bookReaderURL;
    [_spreadImageView.viewController.navigationController pushViewControllerHideTabBar:bookWebVC animated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x;
    DLog(@"ScrollView offsetX = %f",offsetX/self.width);
    //  CGFloat alpha=0;
    self.pageControl.currentPage=(NSInteger)(offsetX/self.width);
    BookSpreadModel *model = _spreadArry[self.pageControl.currentPage];
    _link = model.link;
}
@end
