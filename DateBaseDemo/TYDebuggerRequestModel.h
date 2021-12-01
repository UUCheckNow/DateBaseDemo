//
//  TYDebuggerRequestModel.h
//  tabletest
//
//  Created by tuya on 2021/11/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYDebuggerRequestModel : NSObject

@property (nonatomic, strong) NSString *time;


@property (nonatomic, strong) NSString *apiName;
@property (nonatomic, strong) NSString *postData;
@property (nonatomic, strong) NSString *version;
@property (nonatomic, strong) NSString *result;

@end

NS_ASSUME_NONNULL_END
