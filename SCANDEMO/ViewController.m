//
//  ViewController.m
//  SCANDEMO
//
//  Created by superMan on 16/9/8.
//  Copyright © 2016年 superMan. All rights reserved.
//

#import "ViewController.h"
#import "ScanViewController.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickBtn:(UIBarButtonItem *)sender {
    ScanViewController *scan = [[ScanViewController alloc]init];
    [self.navigationController pushViewController:scan animated:YES];
}

@end
