//
//  TYRequestDetailViewController.m
//  tabletest
//
//  Created by tuya on 2021/12/1.
//

#import "TYRequestDetailViewController.h"

@interface TYRequestDetailViewController ()

@property(nonatomic, strong)UITextView *myTextView;

@end

@implementation TYRequestDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情request数据";
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self addView];
}

-(void)addView{
    self.myTextView = [[UITextView alloc]initWithFrame:CGRectMake(20, 0, self.view.frame.size.width - 40, self.view.frame.size.height)];
    self.myTextView.text = [NSString stringWithFormat:@"time:\n%@\n\nversion:\n%@\n\napiName:\n%@\n\nresult:\n%@\n\npostData:\n%@\n", self.requestModel.time,self.requestModel.version,self.requestModel.apiName, self.requestModel.result,self.requestModel.postData];
    [self.myTextView setFont:[UIFont systemFontOfSize:17]];
    self.myTextView.userInteractionEnabled = NO;
    [self.view addSubview:self.myTextView];
}

- (void)setRequestModel:(TYDebuggerRequestModel *)requestModel {
    _requestModel = requestModel;
}

@end
