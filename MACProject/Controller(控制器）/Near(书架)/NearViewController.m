//
//  NearViewController.m
//  MACProject
//
//  Created by MacKun on 16/8/11.
//  Copyright © 2016年 com.mackun. All rights reserved.
//

#import "NearViewController.h"
#import "bookshelfCell.h"
#import "ContactsVC.h"
#import "SOFViewController.h"
#import "BookWebViewController.h"

@interface NearViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSArray *_titleArr;
    NSMutableArray *_iconArr;
    NSMutableArray *_classArr;
}
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) UIImageView *imageView;
@end

@implementation NearViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getBookShelfList];
    [self initUI];
    [self initData];
    // Do any additional setup after loading the view from its nib.
    
}
-(void)viewWillAppear:(BOOL)animated{
    [self getBookShelfList];
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated{
    self.imageView.hidden = YES;
    self.tableView.hidden = YES;
}

-(void)initUI{
    self.title = @"书架";

    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width * 0.25, appNavigationBarHeight + appStatusBarHeight + 64, self.view.frame.size.width/2, self.view.frame.size.height  /2)];
    [self.imageView mac_setImageWithURL:[NSURL URLWithString:@"http://novel.eyassx.com/static/images/empty.png"] placeholderImage:nil];
    [self.view addSubview:self.imageView];
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.rowHeight = 129.f;
    [self.tableView registerNib:[bookshelfCell loadNib] forCellReuseIdentifier:@"bookshelfCell"];
    [self.view addSubview:self.tableView];
}
-(void)initData{
    [self getBookShelfList];
    _iconArr = [[NSMutableArray alloc]initWithArray:@[@[@"user_identify_icon",@"user_introduce_icon"],@[@"user_phone_icon",@"user_registerTime_icon"]]];
    _classArr = [[NSMutableArray alloc]initWithArray:@[@[@"SOFViewController",@"ContactsVC"],@[@"RandomViewController",@"MessageViewController"]]];
}

#pragma mark TableView delegate datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    bookshelfCell *cell   = [tableView dequeueReusableCellWithIdentifier:@"bookshelfCell"];
    NSDictionary *dic = _titleArr[indexPath.row];
    cell.titile.text = dic[@"title"];
    cell.author.text = dic[@"author"];
    cell.lastChapter.text = dic[@"lastChapter"];
    [cell.bookImage mac_setImageWithURL:dic[@"cover"] placeholderImage:[UIImage imageNamed:@"user_default_icon"]];
    cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return GTFixHeightFlaot(21.f);
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *bookReaderURL = [NSString stringWithFormat:@"%@/#/read/%@",eyassxH5,_titleArr[indexPath.row][@"id"]];
    DLog(@"bookReaderURL:%@",bookReaderURL);
    BookWebViewController *bookWebVC = [[BookWebViewController alloc]init];
    bookWebVC.webUrl = bookReaderURL;;
    [self.navigationController pushViewControllerHideTabBar:bookWebVC animated:YES];
}

//读取书架数据
- (void)getBookShelfList {
    _titleArr = [[[NSUserDefaults standardUserDefaults] objectForKey:@"bookshelfList"] mj_JSONObject];
    if (_titleArr == nil) {
        self.tableView.hidden = YES;
        self.imageView.hidden = NO;
    }else{
        self.tableView.hidden = NO;
        self.imageView.hidden = YES;
    }
}
@end
