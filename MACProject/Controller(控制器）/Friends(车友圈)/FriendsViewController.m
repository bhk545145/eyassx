//
//  FriendsViewController.m
//  MACProject
//
//  Created by MacKun on 16/8/11.
//  Copyright © 2016年 com.mackun. All rights reserved.
//

#import "FriendsViewController.h"
#import "FriendsCell.h"
#import "ContactsVC.h"
#import "SOFViewController.h"
#import "QRScanViewController.h"
#import "BookWebViewController.h"
@interface FriendsViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *_titleArr;
    NSMutableArray *_iconArr;
    NSMutableArray *_classArr;

}
@property (strong, nonatomic)  UITableView *tableView;

@end

@implementation FriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self initData];
    // Do any additional setup after loading the view from its nib.
}
-(void)initUI{
    self.title = @"书友圈";
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.rowHeight = 49.f;
    [self.tableView registerNib:[FriendsCell loadNib] forCellReuseIdentifier:@"FriendsCell"];
    [self.view addSubview:self.tableView];
}
-(void)initData{
    _titleArr = [[NSMutableArray alloc]initWithArray:@[@[@"书友圈",@"扫一扫"],@[@"我的消息"]]];
    _iconArr = [[NSMutableArray alloc]initWithArray:@[@[@"user_identify_icon",@"user_introduce_icon"],@[@"user_phone_icon"]]];
    _classArr = [[NSMutableArray alloc]initWithArray:@[@[@"SOFViewController",@"QRScanViewController"],@[@"MessageViewController"]]];
   // [self.tableView reloadData];
}
#pragma mark TableView delegate datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _titleArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_titleArr arrayWithIndex:section].count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FriendsCell *cell   = [tableView dequeueReusableCellWithIdentifier:@"FriendsCell"];
    cell.nameLabel.text = [_titleArr arrayWithIndex:indexPath.section][indexPath.row];
    cell.imgView.image  = [UIImage imageNamed:[_iconArr arrayWithIndex:indexPath.section][indexPath.row]];
    cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return GTFixHeightFlaot(15.f);
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController *viewController = [[NSClassFromString([_classArr arrayWithIndex:indexPath.section][indexPath.row]) alloc] init];
    if ([viewController isKindOfClass:[QRScanViewController class]]) {
        QRScanViewController *scanVC = [[QRScanViewController alloc]init];
        scanVC.title = @"扫一扫";
        [scanVC doneScanBlock:^(id assetDicArray) {
            NSString *strResultWithBase64 = [NSString stringWithFormat:@"%@", assetDicArray];
            strResultWithBase64 = [strResultWithBase64 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            NSData *data = [[NSData alloc]initWithBase64EncodedString:strResultWithBase64 options:0];
            NSString *strResult = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            [scanVC showAlertMessage:strResult title:@"扫描内容" clickArr:@[@"确定",@"取消"] click:^(NSInteger index) {
                switch (index) {
                    case 0:{
                        [scanVC.navigationController popViewControllerAnimated:YES];
                        BookWebViewController *bookWebVC = [[BookWebViewController alloc]init];
                        bookWebVC.webUrl = assetDicArray;
                        [self.navigationController pushViewControllerHideTabBar:bookWebVC animated:YES];
                    }
                        break;
                    case 1:{
                        [scanVC.navigationController popViewControllerAnimated:YES];
                    }
                        break;
                    default:
                        break;
                }
                return;
            }];
        }];
        [self.navigationController pushViewControllerHideTabBar:scanVC animated:YES];
    }else{
        [self.navigationController pushViewControllerHideTabBar:viewController animated:YES];
    }
    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
