//
//  TYDebuggerMappingViewController.m
//  tabletest
//
//  Created by tuya on 2021/11/30.
//

#import "TYDebuggerMappingViewController.h"
#import "TYDebuggerMappingTabCell.h"
#import "TYMappingDetailViewController.h"
#import "TYDebuggerMappingModel.h"
#import <MJRefresh/MJRefresh.h>
#import "TYSqliteModelTool.h"

#define data_presentation_table_key @"data_presentation_table"

@interface TYDebuggerMappingViewController () <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong)UITableView *mappingTableView;

@end

@implementation TYDebuggerMappingViewController

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
    [TYSqliteModelTool deleteModel:NSClassFromString(@"TYDebuggerMappingModel") dataBaseName:data_presentation_table_key];
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
    NSArray *resultArray = [TYSqliteModelTool queryAllDataModel:NSClassFromString(@"TYDebuggerMappingModel") dataBaseName:data_presentation_table_key count:isRefresh ? 0 : self.mappingModelArray.count];
    if (isRefresh) {
        [self.mappingModelArray removeAllObjects];
    }
    [self.mappingTableView.mj_header endRefreshing];
    if (resultArray.count < 5) {
        [self.mappingTableView.mj_footer endRefreshingWithNoMoreData];
    } else {
        [self.mappingTableView.mj_footer endRefreshing];
    }
    for (TYDebuggerMappingModel *model in resultArray) {
        [modelarray addObject:model];
    }
    [self.mappingModelArray addObjectsFromArray:modelarray];
    [self.mappingTableView reloadData];
}


 - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     
     return 64;
 }


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TYDebuggerMappingTabCell *icell = [TYDebuggerMappingTabCell cellForTableView:tableView];
    TYDebuggerMappingModel *model = self.mappingModelArray[indexPath.row];
    icell.info.text = model.apiName;
    icell.textLabel.text = model.className;
    icell.detailTextLabel.text = model.time;
    return icell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mappingModelArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TYMappingDetailViewController *vc = [[TYMappingDetailViewController alloc]init];
    vc.mappingModel = self.mappingModelArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
