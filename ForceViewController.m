//
//  ForceViewController.m
//  3D_TouchTest
//
//  Created by Walden on 16/3/5.
//  Copyright © 2016年 Walden. All rights reserved.
//

#import "ForceViewController.h"
#import "ForceView.h"

@interface ForceViewController ()

@end

@implementation ForceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"force";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configUI];
}

- (void)configUI
{
    ForceView *forceView = [[ForceView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:forceView];
    forceView.backgroundColor = [UIColor lightGrayColor];
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
