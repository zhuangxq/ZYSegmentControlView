//
//  Demo3ViewController.m
//  SegementControlView
//
//  Created by zxq on 16/8/9.
//  Copyright © 2016年 zxq. All rights reserved.
//

#import "Demo3ViewController.h"
#import "ZYSegmentControlView.h"

@interface Demo3ViewController ()
@property (nonatomic, strong) ZYSegmentControlView *segmentControlView;
@end

@implementation Demo3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
    _segmentControlView = [[ZYSegmentControlView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 64)];
    
    UIView *page1 = [[UIView alloc] init];
    page1.backgroundColor = [UIColor blueColor];
    
    UIView *page2 = [[UIView alloc] init];
    page2.backgroundColor = [UIColor yellowColor];
    
    UIView *page3 = [[UIView alloc] init];
    page3.backgroundColor = [UIColor blueColor];
    
    UIView *page4 = [[UIView alloc] init];
    page4.backgroundColor = [UIColor yellowColor];
    
    UIView *page5 = [[UIView alloc] init];
    page5.backgroundColor = [UIColor blueColor];
    
    UIView *page6 = [[UIView alloc] init];
    page6.backgroundColor = [UIColor yellowColor];
    
    UIView *page7 = [[UIView alloc] init];
    page7.backgroundColor = [UIColor blueColor];
    
 
    _segmentControlView.titleMargin = 15;
    [self.segmentControlView setTitles:@[@"哈哈", @"嘿嘿嘿", @"噢噢噢噢", @"哦", @"噼噼啪啪", @"有意义有", @"嘿嘿嘿嘿嘿嘿嘿嘿嘿"] pageViews:@[page1, page2, page3, page4, page5, page6, page7]];
    
    
    [self.view addSubview:_segmentControlView];

    _segmentControlView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:_segmentControlView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:_segmentControlView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:_segmentControlView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1 constant:0];

    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:_segmentControlView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    
    [self.view addConstraints:@[left, right, top, bottom]];
    
    
    // Do any additional setup after loading the view.
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
