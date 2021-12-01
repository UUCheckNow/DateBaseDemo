//
//  TYSqliteDatabase.h
//  tabletest
//
//  Created by tuya on 2021/11/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYSqliteDatabase : NSObject

#pragma mark //异常记录表 == exception_record_table、接口数据展示表 == data_presentation_table ，操作数据库

/**
 用户机制，操作数据库
 
 @param sql sql 语句
 @param dataBaseName 数据库名字
 */
+(BOOL)deal:(NSString *)sql withDataBaseName:(NSString *)dataBaseName;

#pragma mark 查询数据

/**
 查询数据
 
 @param sql sql 语句
 @param dataBaseName 数据库名字
 @return 字典组成的数组，每一个字典都是一行记录
 */
+(NSMutableArray <NSMutableDictionary *>*)querySql:(NSString *)sql withDataBaseName:(NSString *)dataBaseName;

#pragma mark 执行多条sql语句
/**
 执行多条sql语句
 
 @param sqls sql 语句
 @param dataBaseName 数据库名字
 @return 返回是否都执行成功 YES：都执行成功 NO：没有全部执行成功
 */
+(BOOL)dealSqls:(NSArray <NSString *>*)sqls withDataBaseName:(NSString *)dataBaseName;


@end

NS_ASSUME_NONNULL_END
