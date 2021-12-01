//
//  TYSqliteTableTool.h
//  tabletest
//
//  Created by tuya on 2021/11/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYSqliteTableTool : NSObject

#pragma mark 取出表中所有的字段名
/**
 取出表中所有的字段名
 
 @param cls 模型类
 @param dataBaseName 数据库名字
 @return 返回字段名数组
 */
+(NSArray *)tableColumnNames:(Class)cls dataBaseName:(NSString *)dataBaseName;

#pragma mark 是否存在表格
/** 是否存在表格 */
+(BOOL)isTableExists:(Class)cls dataBaseName:(NSString *)dataBaseName;


@end

NS_ASSUME_NONNULL_END
