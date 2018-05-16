//
//  ParallaxHeaderViewCell.h
//  MACProject
//
//  Created by MacKun on 16/8/12.
//  Copyright © 2016年 com.mackun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParallaxHeaderViewCell : UICollectionViewCell<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnCity;
@property (weak, nonatomic) IBOutlet UIButton *spreadImageView;
@property (strong, nonatomic)  NSMutableArray *spreadArry;
@property(nonatomic,strong) UIScrollView *bannerView;
@property(nonatomic,strong) UIPageControl *pageControl;
@property (strong, nonatomic)  NSString *link;
@property (nonatomic, retain)NSTimer* rotateTimer;  //让视图自动切换
@end
