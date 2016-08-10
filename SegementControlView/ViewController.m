//
//  ViewController.m
//  SegementControlView
//
//  Created by zxq on 16/8/9.
//  Copyright © 2016年 zxq. All rights reserved.
//

#import "ViewController.h"
#import "Demo1ViewController.h"
#import "Demo2ViewController.h"
#import "Demo3ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.dataSource = @[@"样式1", @"样式2", @"样式3"];
    
    self.tableView.tableFooterView = [UIView new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewIdentifier"];
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}

#pragma mark - UITableView Deleagate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        Demo1ViewController *demo1 = [[Demo1ViewController alloc] init];
        [self.navigationController pushViewController:demo1 animated:YES];
    }else if (indexPath.row == 1){
        Demo2ViewController *demo2 = [[Demo2ViewController alloc] init];
        [self.navigationController pushViewController:demo2 animated:YES];
    }else if (indexPath.row == 2){
        Demo3ViewController *demo3 = [[Demo3ViewController alloc] init];
        [self.navigationController pushViewController:demo3 animated:YES];
    }
}




@end
