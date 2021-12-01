//
//  TYDebuggerMappingTabCell.m
//  tabletest
//
//  Created by tuya on 2021/12/1.
//

#import "TYDebuggerMappingTabCell.h"

@implementation TYDebuggerMappingTabCell

+ (instancetype)cellForTableView:(UITableView*)tableView{
    
    NSString *reuseId = [NSString stringWithFormat:@"com.rose.%@.%@",NSStringFromClass(tableView.class),NSStringFromClass([self class])];
    
    TYDebuggerMappingTabCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        cell = [[TYDebuggerMappingTabCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseId];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self commonInit];
    }
    return self;
}
- (void)commonInit{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat x = screenW - 250;
    CGFloat y = 0;
    CGFloat w = 220;
    CGFloat h = 64;
    
    UILabel *info = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
    info.textColor = [UIColor blueColor];
    info.font = [UIFont systemFontOfSize:14];
    info.textAlignment = NSTextAlignmentRight;
    self.info = info;
    [self addSubview:info];
}


@end
