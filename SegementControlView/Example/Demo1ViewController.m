//
//  Demo1ViewController.m
//  SegementControlView
//
//  Created by zxq on 16/8/9.
//  Copyright © 2016年 zxq. All rights reserved.
//

#import "Demo1ViewController.h"
#import "ZYSegmentControlView.h"

@interface Demo1ViewController ()

@property (nonatomic, strong) ZYSegmentControlView *segmentControlView;

@end

@implementation Demo1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *page1 = [[UIView alloc] init];
    page1.backgroundColor = [UIColor blueColor];
    
    UIView *page2 = [[UIView alloc] init];
    page2.backgroundColor = [UIColor yellowColor];
    
    _segmentControlView = [[ZYSegmentControlView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 64)];
    
    _segmentControlView.segmentColor = [UIColor redColor];
    [self.segmentControlView setTitles:@[@"page1", @"page2"] pageViews:@[page1, page2]];
    [self.view addSubview:_segmentControlView];
    // Do any additional setup after loading the view.
    
    _segmentControlView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:_segmentControlView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:_segmentControlView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:_segmentControlView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:_segmentControlView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    
    [self.view addConstraints:@[left, right, top, bottom]];
    
    
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
