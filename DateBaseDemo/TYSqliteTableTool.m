//
//  TYSqliteTableTool.m
//  tabletest
//
//  Created by tuya on 2021/11/30.
//

#import "TYSqliteTableTool.h"
#import "TYSqliteModel.h"
#import "TYSqliteDatabase.h"


@implementation TYSqliteTableTool

/**
 取出表中所有的字段名
 
 @param cls 模型类
 @param dataBaseName 数据库名字
 @return 返回字段名数组
 */
+(NSArray *)tableColumnNames:(Class)cls dataBaseName:(NSString *)dataBaseName
{
    // 1.获取表名
    NSString *tableName = [TYSqliteModel tableName:cls];
    
    // 2.获取通过查询数据库中所有的表的来获取相应的模型对应表的 sql 语句
    NSString *queryCreateTableSqlString = [NSString stringWithFormat:@"select sql from sqlite_master where type = 'table' and name = '%@'",tableName];
    
    // 3.查询模型的sql语句
    NSMutableDictionary *resultDic = [TYSqliteDatabase querySql:queryCreateTableSqlString withDataBaseName:dataBaseName].firstObject;

    NSLog(@"resultDic=%@",resultDic);
    
    // 4、根据sql键取出创建模型的sql语句

    // 大写变小写没必要
    // NSString *createTableSqlString = [resultDic[@"sql"] lowercaseString];
    NSString *createTableSqlString = resultDic[@"sql"];
    // 过滤 \"
    createTableSqlString = [createTableSqlString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    // 过滤 \t
    createTableSqlString = [createTableSqlString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    // 过滤 \n
    createTableSqlString = [createTableSqlString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    if (createTableSqlString.length == 0) {
        return nil;
    }
    
    // 4.1、分割 createTableSqlString 语句取出相应的字段名
    // <1>、根据 `(` 取出 `studentName text,studentNumber integer,studentAge integer,studentScore real, primary key`
    NSString *nameTypeStr = [createTableSqlString componentsSeparatedByString:@"("][1];
    // <2>、再利用 `,` 分割<1>中的字符串,变成一个数组

    NSArray *nameTypeArray = [nameTypeStr componentsSeparatedByString:@","];
    
    // 存放字段名的数组
    NSMutableArray *namesArray = [NSMutableArray array];
    
    for (NSString *nameType in nameTypeArray) {
        
        // 如果包含 primary 跳过 ，因为它不是字段名
        if ([nameType containsString:@"primary"]) {
            continue;
        }
        
        // 去除首尾空格
        NSString *nameType2 = [nameType stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
        
        // 取出类型名字
        NSString *name = [nameType2 componentsSeparatedByString:@" "].firstObject;
        // 放进数组
        [namesArray addObject:name];
    }
    
    // 5.字段排序
    // 不可变的数组，不需要重新赋值，排序后的数组就是变化后的数组
    [namesArray sortUsingComparator:^NSComparisonResult(NSString *obj1,NSString *obj2) {
        return [obj1 compare:obj2];
    }];
    
    return namesArray;
}

/** 是否存在表格 */
+(BOOL)isTableExists:(Class)cls dataBaseName:(NSString *)dataBaseName{
    
    // 1.获取表名
    NSString *tableName = [TYSqliteModel tableName:cls];
    
    // 2.获取通过查询数据库中所有的表的来获取相应的模型对应表的 sql 语句
    NSString *queryCreateTableSqlString = [NSString stringWithFormat:@"select sql from sqlite_master where type = 'table' and name = '%@'",tableName];
    // 3.查询模型的sql语句: 结果是所有表的数组
    NSMutableArray *resultArray = [TYSqliteDatabase querySql:queryCreateTableSqlString withDataBaseName:dataBaseName];
    return resultArray.count > 0;
}

@end
