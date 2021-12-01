//
//  ViewController.m
//  DateBaseDemo
//
//  Created by 魏优优 on 2021/12/1.
//

#import "ViewController.h"
#import "TYDebuggerMappingModel.h"
#import "TYDebuggerRequestModel.h"
// 数据库操作的类
#import "TYSqliteDatabase.h"
// 模型的类
#import "TYSqliteModel.h"
// 操作模型的类
#import "TYSqliteModelTool.h"
// 操作表的类
#import "TYSqliteTableTool.h"

#import "TYDebuggerMappingViewController.h"

#import "TYDebuggerRequestViewController.h"

//异常记录表 == exception_record_table、接口数据展示表 == data_presentation_table ，
NSString *const aModelName = @"TYDebuggerMappingModel";
NSString *const bModelName = @"TYDebuggerRequestModel";
#define data_presentation_table_key @"data_presentation_table"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"接口检测";
    // Do any additional setup after loading the view.
    NSArray *titleArray = [[NSArray alloc] init];
    titleArray = @[@"创建表", @"加入数据", @"查询数据", @"删除表"];
    for (int i = 0; i < titleArray.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(self.view.frame.size.width / 6, 100 + 100 * i, self.view.frame.size.width / 3, 50);
        btn.backgroundColor = [UIColor magentaColor];
        btn.tag = 1000 + i;
        [btn setTitle:[NSString stringWithFormat:@"a_%@",titleArray[i]] forState:UIControlStateNormal];
        [btn addTarget:self
                action:@selector(abuttonAction:)
      forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    
    for (int i = 0; i < titleArray.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(self.view.frame.size.width / 2, 100 + 100 * i, self.view.frame.size.width / 3, 50);
        btn.backgroundColor = [UIColor orangeColor];
        btn.tag = 2000 + i;
        [btn setTitle:[NSString stringWithFormat:@"b_%@",titleArray[i]] forState:UIControlStateNormal];
        [btn addTarget:self
                action:@selector(bbuttonAction:)
      forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
}

- (void)abuttonAction:(UIButton *)sender {
    switch (sender.tag - 1000) {
        case 0:
        {
            //创建表
            [self createTableWithModelName:aModelName];
        }
            break;
        case 1:
        {
            //加入数据
            [self saveModelaWithModelName:aModelName];
        }
            break;
        case 2:
        {
            // 查询模型
            [self queryModelsWithModelName:aModelName];
            
        }
            break;
        case 3:
        {
            //删除表
            [self deleteModelWithModelName:aModelName];
        }
            break;;
    }
}


- (void)bbuttonAction:(UIButton *)sender {
    switch (sender.tag - 2000) {
        case 0:
        {
            //创建表
            [self createTableWithModelName:bModelName];
        }
            break;
        case 1:
        {
            //加入数据
            [self saveModelaWithModelName:bModelName];
        }
            break;
        case 2:
        {
            // 查询模型
            [self queryModelsWithModelName:bModelName];
            
        }
            break;
        case 3:
        {
            //删除表
            [self deleteModelWithModelName:bModelName];
        }
            break;;
    }
}


- (void)createTableWithModelName:(NSString *)modelName {
    BOOL result = [TYSqliteModelTool createTable:NSClassFromString(modelName) dataBaseName:data_presentation_table_key];
    if(result){
        NSLog(@"表创建成功");
    }else{
        NSLog(@"表创建失败");
    }
}

// 保存模型
-(void)saveModelaWithModelName:(NSString *)modelName{
    if ([[TYDebuggerMappingModel class] isEqual: NSClassFromString(modelName)]) {
        TYDebuggerMappingModel *model = [[TYDebuggerMappingModel alloc]init];
        model.requestKey = @"requestkey";
        model.apiName = @"www.tuya.com";
        model.time = @"2021-11-30";
        model.className = @"mycontroller";
        model.propertyList = @[@"篮球", @"足球", @"羽毛球"];
        BOOL result = [TYSqliteModelTool saveOrUpdateModel:model dataBaseName:data_presentation_table_key];
        if(result){
            // 保存成功
            NSLog(@" 保存成功");
        }else{
            // 保存失败
            NSLog(@" 保存失败");
        }
    } else {
        TYDebuggerRequestModel *model = [[TYDebuggerRequestModel alloc]init];
        model.postData = @"postdata";
        model.apiName = @"www.tuyacn.com";
        model.time = @"2021-12-30";
        model.result = @"success";
        model.version = @"0.0.6";
        BOOL result = [TYSqliteModelTool saveOrUpdateModel:model dataBaseName:data_presentation_table_key];
        if(result){
            // 保存成功
            NSLog(@" 保存成功");
        }else{
            // 保存失败
            NSLog(@" 保存失败");
        }
    }
}

// 查询模型
-(void)queryModelsWithModelName:(NSString *)modelName{
    if ([[TYDebuggerMappingModel class] isEqual: NSClassFromString(modelName)]) {
        TYDebuggerMappingViewController *vc = [[TYDebuggerMappingViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        TYDebuggerRequestViewController *vc = [[TYDebuggerRequestViewController alloc]init];
        vc.requestModelArray = modelarray;
        [self.navigationController pushViewController:vc animated:YES];
    }

}

#pragma mark 删除Model模型(也可以说是删除这个Model模型的表)
-(void)deleteModelWithModelName:(NSString *)modelName{
    [TYSqliteModelTool deleteModel:NSClassFromString(modelName) dataBaseName:data_presentation_table_key];
}


@end

