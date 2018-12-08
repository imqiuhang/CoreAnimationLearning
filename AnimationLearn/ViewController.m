//
//  ViewController.m
//  AnimationLearn
//
//  Created by imqiuhang on 2018/11/9.
//  Copyright © 2018 imqiuhang. All rights reserved.
//

#import "ViewController.h"
#import "LayerAndViewViewController.h"
#import "LayerAndViewLayerViewController.h"
#import "ExplicitTransactionViewController.h"
#import "LayerDelegateTestViewController.h"
#import "LayerActionForLayerTestViewController.h"
#import "PopDemoViewController.h"
#import "POPAndCAComparisonViewController.h"
#import "CAEmitterCellDemoViewController.h"

static NSString *const cellIdentify = @"cellIdentify";

@interface VMModel : NSObject
@property (nonatomic,strong)Class vcClass;
@property (nonatomic,strong)NSString *title;
+ (instancetype)modelWithClass:(Class)class title:(NSString *)title;
@end

@implementation VMModel

+ (instancetype)modelWithClass:(Class)class title:(NSString *)title{
    VMModel *model  = [VMModel new];
    model.vcClass = class;
    model.title = title;
    return model;
}
@end

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSArray <VMModel *>*dataSource;
@property (nonatomic,strong)UITableView *dataTableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"🐨大家晚上好";
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    VMModel *model = self.dataSource[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    cell.textLabel.font = [UIFont systemFontOfSize:17];
    cell.textLabel.text = model.title;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    VMModel *model = self.dataSource[indexPath.row];
    UIViewController *vc = [[model.vcClass alloc]init];
    vc.title = model.title;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setup {
    self.dataSource =
    @[
      [VMModel modelWithClass:LayerAndViewViewController.class title:@"例子1：layer和view的属性改变"],
      [VMModel modelWithClass:ExplicitTransactionViewController.class title:@"例子2：显式提交事务"],
      [VMModel modelWithClass:LayerAndViewLayerViewController.class title:@"例子3：直接add layer和add subview的layer属性改变对比"],
      [VMModel modelWithClass:LayerDelegateTestViewController.class title:@"例子4：LayerDelegate测试"],
      [VMModel modelWithClass:LayerActionForLayerTestViewController.class title:@"例子5：actionForLayer返回值的时机"],
      [VMModel modelWithClass:PopDemoViewController.class title:@"POP Demo"],
      [VMModel modelWithClass:POPAndCAComparisonViewController.class title:@"POP和CA的对比"],
      [VMModel modelWithClass:CAEmitterCellDemoViewController.class title:@"CAEmitterCellDemo"]
      ];
    
    self.dataTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.dataTableView.delegate = self;
    self.dataTableView.dataSource = self;
    self.dataTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:self.dataTableView];
    [self.dataTableView registerClass:UITableViewCell.class forCellReuseIdentifier:cellIdentify];
    
    [UIView animateWithDuration:1.f animations:^{
        
    }];
}

@end
