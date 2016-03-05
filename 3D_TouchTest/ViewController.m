//
//  ViewController.m
//  3D_TouchTest
//
//  Created by Walden on 16/3/2.
//  Copyright © 2016年 Walden. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, UIViewControllerPreviewingDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ViewController

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        for (int i = 0; i < 30; i++) {
            NSString *title = [NSString stringWithFormat:@"随机数数据: %d", arc4random()];
            [_dataArray addObject:title];
        }
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"first";
    

    [self configTableView];
}

- (void)configTableView
{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDelegate UITableViewDataSourse
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] init];
        // 判断控制器是否支持3DTouch
        if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
            // 注册支持3DTouch的视图:cell,并设置代理
            // @interface ViewController () <UIViewControllerPreviewingDelegate>
            [self registerForPreviewingWithDelegate:self sourceView:cell];
        }
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SecondViewController *secondVC = [[SecondViewController alloc] init];
    secondVC.content = self.dataArray[indexPath.row];
    
    [self.navigationController pushViewController:secondVC animated:YES];
//    [self presentViewController:secondVC animated:YES completion:nil];
}


#pragma mark - UIViewControllerPreviewingDelegate
// If you return nil, a preview presentation will not be performed
- (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location NS_AVAILABLE_IOS(9_0)
{
    location = [self.tableView convertPoint:location fromView:[previewingContext sourceView]];
    NSIndexPath *path = [self.tableView indexPathForRowAtPoint:location];
    
    SecondViewController *secondVC = [[SecondViewController alloc] init];
    secondVC.content = self.dataArray[path.row];
//    secondVC.preferredContentSize = CGSizeMake(0, 200); // 只能设置高度,宽度是固定的, 这里除了设置高度, 还可以设置很多其他的属性, 详见api

//    vc.view.backgroundColor = [UIColor greenColor]; // 在这里可以对 viewController 进行一些基本的设置
    
    return secondVC;
}
- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit NS_AVAILABLE_IOS(9_0)
{
    [self presentViewController:viewControllerToCommit animated:YES completion:nil];// 动画是无效的
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
