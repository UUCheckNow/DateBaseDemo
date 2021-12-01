//
//  TYMappingDetailViewController.m
//  tabletest
//
//  Created by tuya on 2021/12/1.
//

#import "TYMappingDetailViewController.h"

@interface TYMappingDetailViewController ()

@property(nonatomic, strong)UITextView *myTextView;

@end

@implementation TYMappingDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情model数据";
    // Do any additional setup after loading the view.
    [self addView];
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)addView{
    self.myTextView = [[UITextView alloc]initWithFrame:CGRectMake(20, 0, self.view.frame.size.width - 40, self.view.frame.size.height)];
    self.myTextView.text = [NSString stringWithFormat:@"time:\n%@\n\nclassName:\n%@\n\napiName:\n%@\n\nrequestKey:\n%@\n\npropertyList:\n%@\n", self.mappingModel.time,self.mappingModel.className,self.mappingModel.apiName, self.mappingModel.requestKey,self.mappingModel.propertyList];
    [self.myTextView setFont:[UIFont systemFontOfSize:17]];
    self.myTextView.userInteractionEnabled = NO;
    [self.view addSubview:self.myTextView];
}

- (void)setMappingModel:(TYDebuggerMappingModel *)mappingModel {
    _mappingModel = mappingModel;
}


@end
