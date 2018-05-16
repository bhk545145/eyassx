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
    //启动定时器
    self.rotateTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(changeView) userInfo:nil repeats:YES];
    
}

-(void)setSpreadArry:(NSMutableArray *)spreadArry {
    _spreadArry = spreadArry;
    //bannerView
    self.bannerView = [[UIScrollView alloc]init];
    self.bannerView.delegate = self;
    self.bannerView.pagingEnabled = YES;
    
    self.bannerView.bounces = NO;
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

#pragma mark -- 滚动视图的代理方法
//开始拖拽的代理方法，在此方法中暂停定时器。
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NSLog(@"正在拖拽视图，所以需要将自动播放暂停掉");
    //setFireDate：设置定时器在什么时间启动
    //[NSDate distantFuture]:将来的某一时刻
    [self.rotateTimer setFireDate:[NSDate distantFuture]];
}
//视图静止时（没有人在拖拽），开启定时器，让自动轮播
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //视图静止之后，过1.5秒在开启定时器
//    [NSDate dateWithTimeInterval:1.5 sinceDate:[NSDate date]];
    //返回值为从现在时刻开始 再过1.5秒的时刻。
    NSLog(@"开启定时器");
    [self.rotateTimer setFireDate:[NSDate dateWithTimeInterval:3.0 sinceDate:[NSDate date]]];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x;
//    DLog(@"ScrollView offsetX = %f",offsetX/self.width);
    //  CGFloat alpha=0;
    self.pageControl.currentPage=(NSInteger)(offsetX/self.width);
    BookSpreadModel *model = _spreadArry[self.pageControl.currentPage];
    _link = model.link;
}

//定时器的回调方法 切换界面
- (void)changeView{
    //得到scrollView
    UIScrollView *scrollView = self.bannerView;
    //通过改变contentOffset来切换滚动视图的子界面
    float offset_X = scrollView.contentOffset.x;
    //每次切换一个屏幕
    offset_X += CGRectGetWidth(self.frame);
    //说明要从最右边的多余视图开始滚动了，最右边的多余视图实际上就是第一个视图。所以偏移量需要更改为第一个视图的偏移量。
    if (offset_X > CGRectGetWidth(self.frame)*_spreadArry.count) {
        scrollView.contentOffset = CGPointMake(0, 0);
    }
    //说明正在显示的就是最右边的多余视图，最右边的多余视图实际上就是第一个视图。所以pageControl的小白点需要在第一个视图的位置。
    if (offset_X == CGRectGetWidth(self.frame)*_spreadArry.count) {
        self.pageControl.currentPage = 0;
    }else{
        self.pageControl.currentPage = offset_X/CGRectGetWidth(self.frame);
    }
    //得到最终的偏移量
    CGPoint resultPoint = CGPointMake(offset_X, 0);
    //切换视图时带动画效果
    //最右边的多余视图实际上就是第一个视图，现在是要从第一个视图向第二个视图偏移，所以偏移量为一个屏幕宽度
    if (offset_X >CGRectGetWidth(self.frame)*_spreadArry.count) {
        self.pageControl.currentPage = 1;
        [scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.frame), 0) animated:YES];
    }else{
        [scrollView setContentOffset:resultPoint animated:YES];
    }
}

@end
