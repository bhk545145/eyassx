//
//  HomeViewController.m
//  MACProject
//
//  Created by MacKun on 16/8/12.
//  Copyright © 2016年 com.mackun. All rights reserved.
//

#import "HomeViewController.h"
//#import "CSStickyHeaderFlowLayout.h"
#import "ParallaxHeaderViewCell.h"
#import "NewCarouselListCell.h"
#import "CarLightViewCell.h"
#import "BannerCell.h"
#import "BookListViewCell.h"
#import "BaseService.h"
#import "BookListModel.h"
#import "BooksModel.h"
#import "UIImageView+MAC.h"
#import "BooksHeadView.h"
#import "BookSpreadModel.h"
#import "BookWebViewController.h"

@interface HomeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>{
    CGFloat headerHeight;
    NSMutableArray *bookListArr;
    NSMutableArray *booksArr;
    NSMutableArray *spReadArr;
    dispatch_queue_t queue;
}
@property (nonatomic,strong) UICollectionView *collectionView;

@end

@implementation HomeViewController

static NSString * const reuseIdentifier = @"BookListViewCell";
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_reset];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    queue = dispatch_queue_create("net.book.Queue", DISPATCH_QUEUE_SERIAL);
    
    
    [self initUI];
    [self initData];
    // Do any additional setup after loading the view.
}
-(void)initUI{
    // self.fd_prefersNavigationBarHidden=YES;
    headerHeight                                  = 200;
    self.title                                    = @"秉烛小说";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"faxian_gray"] style:UIBarButtonItemStylePlain target:self action:@selector(searchBtn)];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.headerReferenceSize        = CGSizeMake(self.view.width, headerHeight);
    
    flowLayout.itemSize                           = CGSizeMake(self.view.width, headerHeight);
    // If we want to disable the sticky header effect
    self.automaticallyAdjustsScrollViewInsets     = NO;//保证从0
    // flowLayout.disableStickyHeaders = NO;
    self.collectionView                           = [[UICollectionView alloc] initWithFrame:CGRectMake(0, -64, appWidth , appHeight+24) collectionViewLayout:flowLayout];
//    self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(-64, 0, 0, 0);
    self.collectionView.bounces                        = NO;
    self.collectionView.backgroundColor           = [UIColor whiteColor];
    self.collectionView.dataSource                = self;
    self.collectionView.delegate                  = self;
    [self.view addSubview:self.collectionView];
//    [self.collectionView registerNib:[ParallaxHeaderViewCell loadNib] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ParallaxHeaderViewCell"];
    [self.collectionView registerNib:[BooksHeadView loadNib] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"BooksHeadView"];
     [self.collectionView registerNib:[ParallaxHeaderViewCell loadNib] forCellWithReuseIdentifier:@"ParallaxHeaderViewCell"];
    [self.collectionView registerNib:[NewCarouselListCell loadNib] forCellWithReuseIdentifier:@"newCarouselListCell"];
    [self.collectionView registerNib:[BookListViewCell loadNib] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView registerClass:[BannerCell class] forCellWithReuseIdentifier:@"bannerCell"];
    [self.collectionView registerNib:[CarLightViewCell loadNib] forCellWithReuseIdentifier:@"carLightViewCell"];
}
-(void)initData{
    bookListArr = [NSMutableArray array];
    booksArr = [NSMutableArray array];
    spReadArr= [NSMutableArray array];
    [self loadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)searchBtn {
    BookWebViewController *bookWebVC = [[BookWebViewController alloc]init];
    bookWebVC.webUrl = eyassxURL;
    [self.navigationController pushViewControllerHideTabBar:bookWebVC animated:YES];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return booksArr.count;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return [booksArr[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSArray *arr   = @[@"newCarouselListCell",@"carLightViewCell" ,@"bannerCell"];
    NSArray *arr   = @[@"ParallaxHeaderViewCell"];
    if (indexPath.section < arr.count) {
        ParallaxHeaderViewCell   *cell = [collectionView dequeueReusableCellWithReuseIdentifier:arr[indexPath.section] forIndexPath:indexPath];
        cell.spreadArry = spReadArr;
        return cell;
    }else {
        BookListViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
        // Configure the cell
        BooksModel *booksModel = booksArr[indexPath.section-1][indexPath.row];
        [cell.bookImageView mac_setImageWithURL:[NSURL URLWithString:booksModel.cover] placeholderImage:[UIImage imageNamed:@"user_default_icon"]];
        cell.titleLable.text = booksModel.title;
        [cell.authorLable setTitle:booksModel.author forState:UIControlStateNormal];
        cell.shortIntroLable.text = booksModel.shortIntro;
        [cell.latelyFollowerLable setTitle:[NSString stringWithFormat:@"%ld",booksModel.latelyFollower] forState:UIControlStateNormal];
        [cell.minorCateLable setTitle:booksModel.minorCate forState:UIControlStateNormal];
        [cell.majorCateLable setTitle:booksModel.majorCate forState:UIControlStateNormal];
        return cell;
    }
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
    }else{
        if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
            BooksHeadView *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"BooksHeadView" forIndexPath:indexPath];
            BookListModel *model = bookListArr[indexPath.section -1];
            [cell.booksTitle setTitle:model.title forState:UIControlStateNormal];
            cell._id = model._id;
            return cell;
        }
    }
    
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    BooksModel *booksModel = booksArr[indexPath.section-1][indexPath.row];
    NSString *bookReaderURL = [NSString stringWithFormat:@"%@/#/book/%@",eyassxURL,booksModel._id];
    DLog(@"bookReaderURL:%@",bookReaderURL);
    BookWebViewController *bookWebVC = [[BookWebViewController alloc]init];
    bookWebVC.webUrl = bookReaderURL;
    [self.navigationController pushViewControllerHideTabBar:bookWebVC animated:YES];
}

#pragma  mark UICollectionViewDelegateFlowLayout
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    NSArray *arr   = @[@150.0f,@164.f,@150.0f];
//    if (indexPath.section < arr.count) {
//        return CGSizeMake(self.view.width, [arr[indexPath.section] floatValue]);
//    }
//
    return CGSizeMake(self.view.width, headerHeight);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeZero;
    }
    return CGSizeMake(self.view.width, 30);
    
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat alpha = 0;
    if (offsetY >= 64) {
        alpha=((offsetY-64)/64 <= 1.0 ? (offsetY-64)/64:1);
        [self.navigationController.navigationBar lt_setBackgroundColor:[[UIColor appNavigationBarColor] colorWithAlphaComponent:alpha]];
        
    }else{
        [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    }
    
//    if(offsetY < 0) {
//        ParallaxHeaderViewCell *cell = [ParallaxHeaderViewCell loadNibView];
//        CGRect tempFrame = cell.spreadImageView.frame;
//        tempFrame.origin.y = offsetY;
//        tempFrame.size.height = 200 - offsetY;
//        cell.spreadImageView.frame = tempFrame;
//        CGFloat scale = 1 - ((offsetY + 20) / 240.0);
//        cell.spreadImageView.transform = CGAffineTransformMakeScale(scale, scale);
//    }
    
}

//获取首页分类书  https://api.zhuishushenqi.com/recommendPage/nodes/5910018c8094b1e228e5868f
- (void)getHomeBookList{
    [BaseService GET:[NSString stringWithFormat:@"%@/recommendPage/nodes/5910018c8094b1e228e5868f",zhuishushenqiURL] parameters:nil result:^(NSInteger stateCode, NSMutableArray *result, NSError *error) {
        switch (stateCode) {
            case 1:
            {
                for (id obj in result[0]) {
                    BookListModel *model = [BookListModel mj_objectWithKeyValues:obj];
                    if (model.type == 0) {
                        [bookListArr addObject:model];
                    }
                }
                DLog(@"获取首页分类成功");
                for (BookListModel *model in bookListArr) {
                    [self getBooks:model._id];
                }
            }
                break;
            case 0:
            {
                DLog(@"请求失败");
            }
                break;
            default:
                break;
        }
    }];
}
//通过id获取分类书
- (void)getBooks:(NSString *)modelId{
    NSString *URLString = [NSString stringWithFormat:@"%@/recommendPage/books/%@",zhuishushenqiURL,modelId];
    [BaseService GET:URLString parameters:nil result:^(NSInteger stateCode, NSMutableArray *result, NSError *error) {
        switch (stateCode) {
            case 1:
            {
                NSMutableArray *booksList = [NSMutableArray array];
                for (id obj in result[0]) {
                    NSInteger show = [obj[@"show"] integerValue];
                    if (show) {
                        BooksModel *model = [BooksModel mj_objectWithKeyValues:obj[@"book"]];
                        [booksList addObject:model];
                    }
                }
                [booksArr addObject:booksList];
                DLog(@"通过id获取分类书成功");
            }
                break;
            case 0:
            {
                DLog(@"请求失败");
            }
                break;
            default:
                break;
        }
        [self.collectionView reloadData];
    }];
    
}

//获取轮播图  https://api.zhuishushenqi.com/recommendPage/node/spread/575f74f27a4a60dc78a435a3?pl=ios
- (void)getSpreadImage {
    NSString *URLString = [NSString stringWithFormat:@"%@/recommendPage/node/spread/575f74f27a4a60dc78a435a3?pl=ios",zhuishushenqiURL];
    [BaseService GET:URLString parameters:nil result:^(NSInteger stateCode, NSMutableArray *result, NSError *error) {
        switch (stateCode) {
            case 1:
            {
                for (id obj in result[0]) {
                    BookSpreadModel *model = [BookSpreadModel mj_objectWithKeyValues:obj];
                    [spReadArr addObject:model];
                }
                DLog(@"获取轮播图成功");
            }
                break;
            case 0:
            {
                DLog(@"请求失败");
            }
                break;
            default:
                break;
        }
        [self.collectionView reloadData];
    }];
}

-(void)loadData{
    dispatch_async(queue, ^{
        [self getSpreadImage];
        [self getHomeBookList];
    });
}


@end

