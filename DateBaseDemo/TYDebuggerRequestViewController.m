//
//  TYDebuggerRequestViewController.m
//  tabletest
//
//  Created by tuya on 2021/11/30.
//

#import "TYDebuggerRequestViewController.h"
#import "TYDebuggerMappingTabCell.h"
#import "TYRequestDetailViewController.h"
#import "TYDebuggerRequestModel.h"
#import <MJRefresh/MJRefresh.h>
// 操作模型的类
#import "TYSqliteModelTool.h"

#define data_presentation_table_key @"data_presentation_table"

@interface TYDebuggerRequestViewController () <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong)UITableView *mappingTableView;

@property(nonatomic, strong)NSMutableArray *requestModelArray;

@end

@implementation TYDebuggerRequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"mappingmodellist";
    // Do any additional setup after loading the view.
    [self setNavigationBar];
    [self setTableView];

}

- (void)setNavigationBar {
    UIButton * button =[UIButton buttonWithType:UIButtonTypeCustom];
     button.frame=CGRectMake(20, 20, 60, 40);
     [button setTitle:@"清空数据" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(deteleTable) forControlEvents:UIControlEventTouchUpInside];

        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
}

- (void)deteleTable {
    [TYSqliteModelTool deleteModel:NSClassFromString(@"TYDebuggerRequestModel") dataBaseName:data_presentation_table_key];
    [self loadMoreDataIsRefresh:YES];
}

- (void)setTableView {
    self.mappingTableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.mappingTableView.delegate = self;
    self.mappingTableView.dataSource = self;
    self.mappingTableView.tableFooterView = [UIView new];
    [self.view addSubview:self.mappingTableView];
    
    __weak typeof(self) weakSelf = self;
    //进行数据刷新操作
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.mappingTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //进行数据刷新操作
        [weakSelf loadMoreDataIsRefresh:YES];
    }];

    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.mappingTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreDataIsRefresh:NO];
    }];
    
    // 马上进入刷新状态
    [self.mappingTableView.mj_header beginRefreshing];
}

// 查询模型
-(void)loadMoreDataIsRefresh:(BOOL)isRefresh {
    NSMutableArray *modelarray = [NSMutableArray array];
    NSArray *resultArray = [TYSqliteModelTool queryAllDataModel:NSClassFromString(@"TYDebuggerRequestModel") dataBaseName:data_presentation_table_key count:isRefresh ? 0 : self.requestModelArray.count];
    if (isRefresh) {
        [self.requestModelArray removeAllObjects];
    }
    [self.mappingTableView.mj_header endRefreshing];
    if (resultArray.count < 5) {
        [self.mappingTableView.mj_footer endRefreshingWithNoMoreData];
    } else {
        [self.mappingTableView.mj_footer endRefreshing];
    }
    for (TYDebuggerRequestModel *model in resultArray) {
        [modelarray addObject:model];
    }
    [self.requestModelArray addObjectsFromArray:modelarray];
    [self.mappingTableView reloadData];
}


 - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     
     return 64;
 }


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TYDebuggerMappingTabCell *icell = [TYDebuggerMappingTabCell cellForTableView:tableView];
    TYDebuggerRequestModel *model = self.requestModelArray[indexPath.row];
    icell.info.text = model.apiName;
    icell.textLabel.text = model.result;
    icell.detailTextLabel.text = model.time;
    return icell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.requestModelArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TYRequestDetailViewController *vc = [[TYRequestDetailViewController alloc]init];
    vc.requestModel = self.requestModelArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
