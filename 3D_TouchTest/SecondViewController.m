//
//  SecondViewController.m
//  3D_TouchTest
//
//  Created by Walden on 16/3/3.
//  Copyright © 2016年 Walden. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@property (nonatomic, strong) NSArray *preActions;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [self configUI];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureClick:)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)tapGestureClick:(UITapGestureRecognizer *)tapGesture
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)configUI
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 300, 30)];
    [self.view addSubview:label];
    label.text = self.content;
    label.textColor = [UIColor redColor];
    label.font = [UIFont systemFontOfSize:20];
}

// 使用懒加载的数组.
- (NSArray *)preActions
{
    UIPreviewAction *action1 = [UIPreviewAction actionWithTitle:@"大赞" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"你点击了    大赞");
    }];
    
    UIPreviewAction *action2 = [UIPreviewAction actionWithTitle:@"中赞" style:UIPreviewActionStyleDestructive handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"你点击了    中赞");
    }];
    
    UIPreviewAction *action3 = [UIPreviewAction actionWithTitle:@"小赞" style:UIPreviewActionStyleSelected handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"你点击了    小赞");
    }];
    
    
    
    return @[action1, action2, action3];
}

// 这个方法的返回值, 才是会显示的组, 本例使用懒加载加载数据.
- (NSArray<id<UIPreviewActionItem>> *)previewActionItems
{
    return self.preActions;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
