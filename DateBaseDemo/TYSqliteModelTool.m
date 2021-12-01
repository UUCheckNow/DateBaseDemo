//
//  TYSqliteModelTool.m
//  tabletest
//
//  Created by tuya on 2021/11/30.
//

#import "TYSqliteModelTool.h"
#import "TYSqliteModel.h"
// sql语句执行
#import "TYSqliteDatabase.h"
// 操作表的类
#import "TYSqliteTableTool.h"


@implementation TYSqliteModelTool

// 关于这个工具类的封装
/**
 实现方案：
 1、基于配置，用户自己来设置
 2、runtime动态获取
 */
+(BOOL)createTable:(Class)cls dataBaseName:(NSString *)dataBaseName{
    
    // 1.创建表格的sql语句给拼接出来
    /**
     create table if not exists 表名(字段1 字段1类型(约束),字段2 字段2类型(约束),字段3 字段3类型(约束),.....,primary(字段))
     
     primary： 主键自增
     */
    // 1.1、获取表名
    NSString *tableName = [TYSqliteModel tableName:cls];
    // 1.2、获取一个模型里面所有的字段名字，以及类型
    NSString *createTableSql = [NSString stringWithFormat:@"create table if not exists %@(%@, id integer PRIMARY KEY AUTOINCREMENT)",tableName,[TYSqliteModel columnNamesAndTypesStr:cls]];
    // 2、执行(返回是否创建成功)
    return [TYSqliteDatabase deal:createTableSql withDataBaseName:dataBaseName];
}

/**
 判断是否要更新表
 
 @param cls 类
 @param dataBaseName 数据库名字
 @return 返回一个是否更新的 BOOL： YES:需要更新 NO:不需要更新
 */
+(BOOL)isUpdateTable:(Class)cls dataBaseName:(NSString *)dataBaseName{
   
    // 1.获取模型里面的所有成员变量的名字
    NSArray *modelNames = [TYSqliteModel allTableSortedIvarNames:cls];
    // 2.获取dataBaseName对应数据库里面对应表的字段数组
    NSArray *tableNames = [TYSqliteTableTool tableColumnNames:cls dataBaseName:dataBaseName];
    // 3.判断两个数组是否相等，返回响应的结果,取反：相等不需要更新，不相等才需要去更新
    return ![modelNames isEqualToArray:tableNames];
    
}

/**
 更新表(前提是表已经判断 是否需要更新)
 
 @param cls 类
 @param dataBaseName 数据库名字
 @return YES：更新成功 NO：更新表失败
 */
+(BOOL)updateTable:(Class)cls dataBaseName:(NSString *)dataBaseName{
    
    // 1、获取表名
    // 临时表名
    NSString *tmpTableName = [TYSqliteModel tmpTableName:cls];
    // 旧表名
    NSString *oldTableName = [TYSqliteModel tableName:cls];
    // 创建数组记录执行的sql
    NSMutableArray *execSqls = [NSMutableArray array];
    
    NSString *dropTmpTableSql = [NSString stringWithFormat:@"drop table if exists %@;", tmpTableName];
    [execSqls addObject:dropTmpTableSql];
    
    // 2、获取一个模型里面所有的字段名字，以及类型
    NSString *createTmpTableSql = [NSString stringWithFormat:@"create table if not exists %@(%@, primary key AUTOINCREMENT);",tmpTableName,[TYSqliteModel columnNamesAndTypesStr:cls]];
    
    [execSqls addObject:createTmpTableSql];
    
    // 5.把旧表删除
    NSString *deleteOldTableSqlStr = [NSString stringWithFormat:@"drop table if exists %@;",oldTableName];
    
    [execSqls addObject:deleteOldTableSqlStr];
    
    // 6.把新表的名字改为旧表的名字，就行隐形替换
    NSString *renameTmpTableNameSqlStr = [NSString stringWithFormat:@"alter table %@ rename to %@;",tmpTableName,oldTableName];
    
    [execSqls addObject:renameTmpTableNameSqlStr];
    
    // 7.执行上面的sql 语句
    return [TYSqliteDatabase dealSqls:execSqls withDataBaseName:dataBaseName];
}

/**
 保存一个模型
 
 @param model 类
 @param dataBaseName 数据库名字
 @return 返回一个保存的结果
 */
+(BOOL)saveOrUpdateModel:(id)model dataBaseName:(NSString *)dataBaseName{
    
    // 用户在使用的过程中直接调用这个方法，来保存模型
    
    Class cls = [model class];
    // 1、判断表格是否存在，不存在就去创建
    if (![TYSqliteTableTool isTableExists:cls dataBaseName:dataBaseName]) {
        // 创建表格
        if (![self createTable:cls dataBaseName:dataBaseName]) {
            // 创建失败
            return NO;
        }
    }
    // 获取表名
    NSString *tableName = [TYSqliteModel tableName:cls];
    // 进行查询
    // 获取表中所有的字段（下面的方法获取的是字典，我们取其键）
    NSArray *columnNames = [TYSqliteModel classIvarNameTypeDictionary:cls].allKeys;
    // 获取模型里面所有的值数组
    NSMutableArray *columnNameValues = [NSMutableArray array];
    for (NSString *columnName in columnNames) {
        
        id columnNameValue = [model valueForKeyPath:columnName];
        
        // 判断类型是不是数组或者字典
        if ([columnNameValue isKindOfClass:[NSArray class]] || [columnNameValue isKindOfClass:[NSDictionary class]]) {
            // 在这里我们把数组或者字典处理成一个字符串，才能正确的保存到数据库里面去
            
            // 字典/数组 -> NSData ->NSString
            NSData *data = [NSJSONSerialization dataWithJSONObject:columnNameValue options:NSJSONWritingPrettyPrinted error:nil];
            columnNameValue = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        }
        if (!columnNameValue) {
            columnNameValue = @"";
        }
        [columnNameValues addObject:columnNameValue];
    }
    
    // 把字段和值拼接生成  字段 = 值   字符的数组
    NSInteger count = columnNames.count;
    NSMutableArray *setValueArray = [NSMutableArray array];
    for (int i = 0; i<count; i++) {
        
        NSString *name = columnNames[i];
        id value = columnNameValues[i];
        NSString *setStr = [NSString stringWithFormat:@"%@ = '%@'",name,value];
        [setValueArray addObject:setStr];
    }
        // 不存在数据，进行记录的插入操作
        // 提示这里 insert into %@(%@) values('%@');，其中的value 要是： 'value1','value2','value2'这样的格式
    NSString *execSql = [NSString stringWithFormat:@"insert into %@(%@) values('%@');",tableName,[columnNames componentsJoinedByString:@","],[columnNameValues componentsJoinedByString:@"','"]];
    
    return [TYSqliteDatabase deal:execSql withDataBaseName:dataBaseName];
    
}

/**
 删除模型，也是删除模型中的全部数据，可以说是删除整个表
 */
+(BOOL)deleteModel:(id)model dataBaseName:(NSString *)dataBaseName{
    
    Class cls = [model class];

    // 获取表名
    NSString *tableName = [TYSqliteModel tableName:cls];
    
    if (![TYSqliteTableTool isTableExists:cls dataBaseName:dataBaseName]) {
        // 表不存在默认删除成功
        return YES;
    }
    
    // 组建删除表的语句
    NSString *deleteSql = [NSString stringWithFormat:@"drop table %@;",tableName];
    
    return [TYSqliteDatabase deal:deleteSql withDataBaseName:dataBaseName];
}

/**
 根据条件来删除一些数据
 
 @param model 模型对象
 @param condition 条件
 @param dataBaseName 数据库名字
 @return 返回一个结果
 */
+(BOOL)deleteModel:(id)model whereStr:(NSString *)condition dataBaseName:(NSString *)dataBaseName{
    
    Class cls = [model class];
    
    // 获取表名
    NSString *tableName = [TYSqliteModel tableName:cls];
    
    // 条件小于0直接返回
    if (!(condition.length > 0)) {
        return NO;
    }
    
    // 组建删除表的语句
    NSString *deleteSql = [NSString stringWithFormat:@"delete from %@ where %@;",tableName,condition];
    
    return [TYSqliteDatabase deal:deleteSql withDataBaseName:dataBaseName];
}

/**
 简化用户删除模型数据的操作
 
 @param model 模型
 @param name 字段名
 @param relation 条件：ColumnNameToValueRelationType
 @param value 值
 @param dataBaseName 数据库名字
 @return 返回结果
 */
+(BOOL)deleteModel:(id)model columnName:(NSString *)name relation:(ColumnNameToValueRelationType)relation value:(NSString *)value dataBaseName:(NSString *)dataBaseName{
    
    Class cls = [model class];
    
    // 获取表名
    NSString *tableName = [TYSqliteModel tableName:cls];
    
    // 组建删除表的语句
    /**
      self.columnNameToValueRelationTypeDic[@(relation)] 利用映射取值
     */
    NSString *deleteSql = [NSString stringWithFormat:@"delete from %@ where %@ %@ %@;",tableName,name,self.columnNameToValueRelationTypeDic[@(relation)],value];
    
    return [TYSqliteDatabase deal:deleteSql withDataBaseName:dataBaseName];
}

/** 查询模型中自增id倒序后的 5条数据 例如 （0，10）表示第0条后面的记录开始展示后10条数据，10是偏移量。*/
+(NSArray *)queryAllDataModel:(Class)cls dataBaseName:(NSString *)dataBaseName count:(NSInteger)count{
    
    // 1.查询前序
    // 获取表名
    NSString *tableName = [TYSqliteModel tableName:cls];
    // 组合查询语句
    NSString *querySql = [NSString stringWithFormat:@"select * from %@ order by id desc limit %ld, 5",tableName,count];
    
    // 2.执行查询 key value
    // 模型的属性名称 和 属性值
    NSArray <NSDictionary *>*results = [TYSqliteDatabase querySql:querySql withDataBaseName:dataBaseName];
    
    // 3.处理查询结果集 -> 模型数组
    return [self parseResults:results withClass:cls];
}

/**
 根据条件来查询模型里面的部分数据
 
 @param cls 模型对象
 @param condition 条件
 @param dataBaseName 数据库名字
 @return 返回一个结果
 */
+(BOOL)queryDataModel:(Class)cls whereStr:(NSString *)condition dataBaseName:(NSString *)dataBaseName{
    
    // 1.查询前序
    // 获取表名
    NSString *tableName = [TYSqliteModel tableName:cls];
    // 组合查询语句
    NSString *querySql = [NSString stringWithFormat:@"select * from %@ where %@;",tableName,condition];
    
    // 2.执行查询 key value
    // 模型的属性名称 和 属性值
    NSArray <NSDictionary *>*results = [TYSqliteDatabase querySql:querySql withDataBaseName:dataBaseName];
    
    // 3.处理查询结果集 -> 模型数组
    return [self parseResults:results withClass:cls];
}

/**
 简化用户查询模型数据的操作
 
 @param cls 类对象
 @param name 字段名
 @param relation 条件：ColumnNameToValueRelationType
 @param value 值
 @param dataBaseName 数据库名字
 @return 返回结果
 */
+(BOOL)queryDataModel:(Class)cls columnName:(NSString *)name relation:(ColumnNameToValueRelationType)relation value:(NSString *)value dataBaseName:(NSString *)dataBaseName{
    
    // 1.查询前序
    // 获取表名
    NSString *tableName = [TYSqliteModel tableName:cls];
    // 组合查询语句
    NSString *querySql = [NSString stringWithFormat:@"select * from %@ where %@ %@ %@;",tableName,name,self.columnNameToValueRelationTypeDic[@(relation)],value];
    
    // 2.执行查询 key value
    // 模型的属性名称 和 属性值
    NSArray <NSDictionary *>*results = [TYSqliteDatabase querySql:querySql withDataBaseName:dataBaseName];
    
    // 3.处理查询结果集 -> 模型数组
    return [self parseResults:results withClass:cls];
}

+ (NSArray *)parseResults:(NSArray <NSDictionary *>*)results withClass:(Class)cls {
    
    // 属性名称 -> 类型 dic
    NSDictionary *nameTypeDic = [TYSqliteModel classIvarNameTypeDictionary:cls];
    
    // 3. 处理查询的结果集 -> 模型数组
    NSMutableArray *models = [NSMutableArray array];
    
    for (NSDictionary *modelDic in results) {
        id model = [[cls alloc] init];
        [models addObject:model];
        
        [modelDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            // 如果包含 primary 跳过 ，因为它不是字段名
            if (![key containsString:@"id"]) {
                NSString *type = nameTypeDic[key];
                //
                id resultValue = obj;
                if ([type isEqualToString:@"NSArray"] || [type isEqualToString:@"NSDictionary"]) {
                    
                    // 字符串 -> NSData -> 相应的类型
                    NSData *data = [obj dataUsingEncoding:NSUTF8StringEncoding];
                    /**
                     NSJSONReadingMutableContainers = (1UL << 0), 可变的
                     NSJSONReadingMutableLeaves = (1UL << 1), 可变的的类型里面还有可变的
                     NSJSONReadingAllowFragments =
                     kNilOptions 不可变
                     */
                    resultValue = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                    
                    
                }else if ([type isEqualToString:@"NSMutableArray"] || [type isEqualToString:@"NSMutableDictionary"]){
                    
                    // 字符串 -> NSData -> 相应的类型
                    NSData *data = [obj dataUsingEncoding:NSUTF8StringEncoding];
                    resultValue = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                }
                
                [model setValue:resultValue forKey:key];
            }
        }];
    }
    
    return models;
}

// 条件的映射
+(NSDictionary *)columnNameToValueRelationTypeDic{
    
    return @{@(ColumnNameToValueRelationMore):@">",
             @(ColumnNameToValueRelationLess):@"<",
             @(ColumnNameToValueRelationEqual):@"=",
             @(ColumnNameToValueRelationMoreEqual):@">=",
             @(ColumnNameToValueRelationLessEqual):@"<"
             };
}


@end
