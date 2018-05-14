//
//  BookSearchViewController.m
//  MACProject
//
//  Created by 白洪坤 on 2018/5/12.
//  Copyright © 2018年 com.mackun. All rights reserved.
//

#import "BookSearchViewController.h"
#import "SearchCoreManager.h"
#import "BaseService.h"
#import "BooksModel.h"
#import "BookWebViewController.h"
@interface BookSearchViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>{
    BOOL isSearch;
    NSMutableArray *arrayIndexs;//索引组
    NSMutableArray *searchBooksArr;
}
@property(nonatomic, strong) UISearchBar *searchBar;
@property(nonatomic, strong) UITableView *searchTableView;
/**
 *  搜索索引ID
 */
@property(nonatomic, strong) NSMutableArray *resultArray;
/**
 *  sectionHeaderTitleAr
 */
@property(nonatomic, strong) NSMutableArray *indexTitleArr;
@end

@implementation BookSearchViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    searchBooksArr = [NSMutableArray array];
    [self initData];
    [self.searchTableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"搜索小说";
    
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.searchTableView];
}

-(void)initData{
//    [[SearchCoreManager share] Reset];
    [self getBookDic];
}

-(void)getBookDic{
    
}

- (UITableView *)searchTableView{
    if (!_searchTableView) {
        _searchTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 108.0f, self.view.width, self.view.height-64.0f-44.0f) style:UITableViewStylePlain];
        _searchTableView.dataSource = self;
        _searchTableView.delegate = self;
        _searchTableView.tableFooterView = [UIView new];
//        _searchTableView.tableHeaderView = self.headerView;
        _searchTableView.rowHeight = GTFixHeightFlaot(44.0f);
        _searchTableView.sectionIndexColor = [UIColor appRedColor];
    }
    return _searchTableView;
}

- (UISearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64.0f, self.view.width, 44.0f)];
        _searchBar.placeholder = @"输入小说名称";
        _searchBar.delegate = self;
        _searchBar.showsCancelButton = NO;
        _searchBar.tintColor = [UIColor appRedColor];
        _searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    }
    return _searchBar;
}

#pragma mark - tableView
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//    if (!isSearch) {
//        return _indexTitleArr;
//    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    if (!isSearch) {
//        return [_indexTitleArr count];
//    }
    
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    if (!isSearch) {
//        return _indexTitleArr[section];
//    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return searchBooksArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier=@"cityIdentifier";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.textLabel.font = [UIFont systemFontOfSize:20.0f];
    }
    
    BooksModel *model = searchBooksArr[indexPath.row];
    [cell.imageView mac_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://statics.zhuishushenqi.com%@",model.cover]] placeholderImage:[UIImage imageNamed:@"user_default_icon"]];
    cell.textLabel.text = model.title;
    cell.detailTextLabel.text = model.author;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BooksModel *model = searchBooksArr[indexPath.row];
    NSString *bookReaderURL = [NSString stringWithFormat:@"%@/#/book/%@",eyassxURL,model._id];
    BookWebViewController *bookWebVC = [[BookWebViewController alloc]init];
    bookWebVC.webUrl = bookReaderURL;;
    [self.navigationController pushViewControllerHideTabBar:bookWebVC animated:YES];
}

#pragma mark - searchBar
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    isSearch = YES;
    self.searchTableView.tableHeaderView = nil;
    [self.searchTableView reloadData];
    searchBar.showsCancelButton = YES;
}
- (void)searchBar:(UISearchBar *)_searchBar textDidChange:(NSString *)searchText
{
    [self.searchTableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = NO;
    [searchBar resignFirstResponder];
    [self getBookName:searchBar.text];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    isSearch = NO;
//    self.searchTableView.tableHeaderView = self.headerView;
    
    searchBar.text = nil;
    searchBar.showsCancelButton = NO;
    [searchBar resignFirstResponder];
    [self getBookName:searchBar.text];
    [self.searchTableView reloadData];
}

- (NSMutableArray *)resultArray{
    if (!_resultArray) {
        _resultArray = [[NSMutableArray alloc] init];
    }
    return _resultArray;
}

//搜索书  https://api.zhuishushenqi.com/book/fuzzy-search?query=雪中悍刀行
- (void)getBookName:(NSString *)bookName {
    [searchBooksArr removeAllObjects];
    NSString *URLString = [NSString stringWithFormat:@"%@/book/fuzzy-search",zhuishushenqiURL];
    NSDictionary *parameter=@{@"query": bookName};
    [BaseService GET:URLString parameters:parameter result:^(NSInteger stateCode, NSMutableArray *result, NSError *error) {
        switch (stateCode) {
            case 1:
            {
                if ([result isBlank]) {
                    if (isSearch) {
                        [self.view showSuccess:@"没有找到您搜索的小说"];
                        break;
                    }
                    
                    break;
                }
                for (id obj in result[0]) {
                    BooksModel *model = [BooksModel mj_objectWithKeyValues:obj];
                    [searchBooksArr addObject:model];
                }
                DLog(@"搜索成功");
                if ([searchBooksArr count] == 0) {
                    [self.view showSuccess:@"没有找到您搜索的小说"];
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
        [self.searchTableView reloadData];
    }];
}
@end
