//
//  TYSqliteModelTool.h
//  tabletest
//
//  Created by tuya on 2021/11/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    // 大于
    ColumnNameToValueRelationMore,
    // 小于
    ColumnNameToValueRelationLess,
    // 等于
    ColumnNameToValueRelationEqual,
    // 大于等于
    ColumnNameToValueRelationMoreEqual,
    // 小于等于
    ColumnNameToValueRelationLessEqual,
} ColumnNameToValueRelationType;

@interface TYSqliteModelTool : NSObject

// 关于这个工具类的封装
/**
 实现方案：
 1、基于配置，用户自己来设置
 2、runtime动态获取
 */
+(BOOL)createTable:(Class)cls dataBaseName:(NSString *)dataBaseName;

#pragma mark 判断是否要更新表
/**
 判断是否要更新表

 @param cls 类
 @param dataBaseName 数据库名字
 @return 返回一个是否更新的 BOOL： YES:需要更新 NO:不需要更新
 */
+(BOOL)isUpdateTable:(Class)cls dataBaseName:(NSString *)dataBaseName;

#pragma mark 更新表(前提是表已经判断 是否需要更新)
/**
 更新表(前提是表已经判断 是否需要更新)

 @param cls 类
 @param dataBaseName 数据库名字
 @return YES：更新成功 NO：更新表失败
 */
+(BOOL)updateTable:(Class)cls dataBaseName:(NSString *)dataBaseName;

#pragma mark 保存或者更新一个模型
/**
 保存或者更新一个模型

 @param model 类
 @param dataBaseName 数据库名字
 @return 返回一个保存的结果
 */
+(BOOL)saveOrUpdateModel:(id)model dataBaseName:(NSString *)dataBaseName;

#pragma mark 删除模型，也是删除模型中的全部数据，可以说是删除整个表
/**
 删除模型，也是删除模型中的全部数据，可以说是删除整个表
 */
+(BOOL)deleteModel:(id)model dataBaseName:(NSString *)dataBaseName;

#pragma mark 根据条件来删除一些数据
/**
 根据条件来删除一些数据

 @param model 模型对象
 @param condition 条件
 @param dataBaseName 数据库名字
 @return 返回一个结果
 */
+(BOOL)deleteModel:(id)model whereStr:(NSString *)condition dataBaseName:(NSString *)dataBaseName;

#pragma mark 简化用户删除模型数据的操作
/**
 简化用户删除模型数据的操作

 @param model 模型
 @param name 字段名
 @param relation 条件：ColumnNameToValueRelationType
 @param value 值
 @param dataBaseName 数据库名字
 @return 返回结果
 */
+(BOOL)deleteModel:(id)model columnName:(NSString *)name relation:(ColumnNameToValueRelationType)relation value:(NSString *)value dataBaseName:(NSString *)dataBaseName;

/** 查询模型中所有的数据 */
+(NSArray *)queryAllDataModel:(Class)cls dataBaseName:(NSString *)dataBaseName count:(NSInteger)count;
#pragma mark 根据条件来查询模型里面的部分数据
/**
 根据条件来查询模型里面的部分数据
 
 @param cls 模型类对象
 @param condition 条件 : 如： @"name = xx""
 @param dataBaseName 数据库名字
 @return 返回一个结果
 */
+(BOOL)queryDataModel:(Class)cls whereStr:(NSString *)condition dataBaseName:(NSString *)dataBaseName;

#pragma mark 简化用户查询模型数据的操作
/**
 简化用户查询模型数据的操作
 
 @param cls 类对象
 @param name 字段名
 @param relation 条件：ColumnNameToValueRelationType
 @param value 值
 @param dataBaseName 数据库名字
 @return 返回结果
 */
+(BOOL)queryDataModel:(Class)cls columnName:(NSString *)name relation:(ColumnNameToValueRelationType)relation value:(NSString *)value dataBaseName:(NSString *)dataBaseName;

@end

NS_ASSUME_NONNULL_END
