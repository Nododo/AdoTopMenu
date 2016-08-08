//
//  ViewController.m
//  AdoTopMenu
//
//  Created by 杜维欣 on 16/8/5.
//  Copyright © 2016年 Nododo. All rights reserved.
//

#import "ViewController.h"
#import "AdoTopMenu.h"

@interface ViewController ()<AdoTopMenuDataSource, AdoTopMenuDelegate>
@property (nonatomic,weak)UIButton *top;
@property (nonatomic,weak)AdoTopMenu *a;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AdoTopMenu *a = [[AdoTopMenu alloc] initWithFrame:CGRectMake(0, 100, 365, 44)];
    a.dataSource = self;
    a.delegate = self;
    [self.view addSubview:a];
    self.a = a;
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)menu:(AdoTopMenu *)menu didSelectColumn:(NSInteger)column {
    NSLog(@"select = %ld", column);
    UIButton *top = [[UIButton alloc] initWithFrame:CGRectMake(0, 144, 375, 100)];
    [top addTarget:self action:@selector(gtttth) forControlEvents:UIControlEventTouchUpInside];
    top.backgroundColor = [UIColor greenColor];
    [self.view addSubview:top];
    self.top = top;
}

- (void)menu:(AdoTopMenu *)menu deSelectColumn:(NSInteger)column {
    NSLog(@"deSelect = %ld", column);
}

- (NSInteger)numberOfColumnsInMenu:(AdoTopMenu *)menu {
    return 4;
}

- (NSString *)menu:(AdoTopMenu *)menu titleForColumn:(NSInteger)column {
    return [NSString stringWithFormat:@"这是第%ld列",column];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)gtttth{
    [self.top removeFromSuperview];
    self.top = nil;
    [self.a menuReset];
}
@end
