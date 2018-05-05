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

@interface HomeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>{
    CGFloat headerHeight;
    NSMutableArray *bookListArr;
    NSMutableArray *booksArr;
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
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.headerReferenceSize        = CGSizeMake(self.view.width, headerHeight);
    
    flowLayout.itemSize                           = CGSizeMake(self.view.width, headerHeight);
    // If we want to disable the sticky header effect
    self.automaticallyAdjustsScrollViewInsets     = NO;//保证从0
    // flowLayout.disableStickyHeaders = NO;
    self.collectionView                           = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, appWidth , appHeight-40) collectionViewLayout:flowLayout];
//    self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(-64, 0, 0, 0);
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
    [self loadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        UICollectionViewCell   *cell = [collectionView dequeueReusableCellWithReuseIdentifier:arr[indexPath.section] forIndexPath:indexPath];
        return cell;
    }else {
        BookListViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
        // Configure the cell
        BooksModel *booksModel = booksArr[indexPath.section-1][indexPath.row];
        [cell.bookImageView mac_setImageWithURL:[NSURL URLWithString:booksModel.cover] placeholderImage:[UIImage imageNamed:@"user_default_icon"]];
        cell.titleLable.text = booksModel.title;
        cell.authorLable.text = booksModel.author;
        cell.shortIntroLable.text = booksModel.shortIntro;
        return cell;
    }
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        BooksHeadView *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"BooksHeadView" forIndexPath:indexPath];
        BookListModel *model = bookListArr[indexPath.section-1];
        cell.booksTitle.text = model.title;
        DLog(@"model.title:%@",model.title);
        DLog(@"booksTitle:%@",cell.booksTitle.text);
        return cell;
        
    }
    return nil;
}


#pragma  mark UICollectionViewDelegateFlowLayout
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    DLog(@"section:%ld",(long)indexPath.section);
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
    
}

//获取首页分类书  https://api.zhuishushenqi.com/recommendPage/nodes/5910018c8094b1e228e5868f
- (void)getHomeBookList{
    [BaseService GET:@"https://api.zhuishushenqi.com/recommendPage/nodes/5910018c8094b1e228e5868f" parameters:nil result:^(NSInteger stateCode, NSMutableArray *result, NSError *error) {
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
    NSString *URLString = [NSString stringWithFormat:@"https://api.zhuishushenqi.com/recommendPage/books/%@",modelId];
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

-(void)loadData{
    dispatch_async(queue, ^{
        [self getHomeBookList];
    });
}


@end

