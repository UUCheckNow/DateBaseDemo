//
//  TYDebuggerMappingModel.h
//  tabletest
//
//  Created by tuya on 2021/11/30.
//
//异常记录表

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYDebuggerMappingModel : NSObject


@property (nonatomic, strong) NSString *requestKey;
@property (nonatomic, strong) NSString *apiName;


@property (nonatomic, strong) NSString *time;


@property (nonatomic, strong) NSString *className;
@property (nonatomic, strong) NSArray *propertyList;


@end

NS_ASSUME_NONNULL_END
