//
//  ViewController.m
//  AssociatedObject
//
//  Created by DuBenben on 2020/10/16.
//  Copyright © 2020 CNKI. All rights reserved.
//

#import "ViewController.h"
#import "TestVC.h"


@interface ViewController ()

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [super touchesBegan:touches withEvent:event];
    
    TestVC *vc = [TestVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
