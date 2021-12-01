//
//  TYDebuggerMappingTabCell.h
//  tabletest
//
//  Created by tuya on 2021/12/1.
//

#import <UIKit/UIKit.h>
#import "TYDebuggerMappingModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TYDebuggerMappingTabCell : UITableViewCell

+ (instancetype)cellForTableView:(UITableView*)tableView;

@property (nonatomic, strong) UILabel *info;

@end

NS_ASSUME_NONNULL_END
