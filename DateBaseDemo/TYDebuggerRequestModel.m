//
//  TYDebuggerRequestModel.m
//  tabletest
//
//  Created by tuya on 2021/11/30.
//

#import "TYDebuggerRequestModel.h"

@implementation TYDebuggerRequestModel

- (NSString *)time{
    if (_time == nil) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss:SSS"];
        _time = [formatter stringFromDate:[NSDate date]];
    }
    return _time;
}

@end
