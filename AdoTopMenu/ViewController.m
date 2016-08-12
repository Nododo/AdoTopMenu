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
@property (nonatomic,weak)UIButton *button0;
@property (nonatomic,weak)UIButton *button1;
@property (nonatomic,weak)UIButton *button2;
@property (nonatomic,weak)UIButton *button3;
@property (nonatomic,weak)AdoTopMenu *topMenu;
@property (nonatomic,assign)NSInteger columns;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.columns = 4;
    AdoTopMenu *topMenu = [[AdoTopMenu alloc] initWithFrame:CGRectMake(0, 64, 375, 44)];
    topMenu.dataSource = self;
    topMenu.delegate = self;
    [topMenu menuSetTitleColor:[UIColor blackColor]];
    [topMenu menuSetSeperatorColor:[UIColor redColor]];
    [topMenu menuSetBottomLineColor:[UIColor cyanColor]];
    [topMenu menuSetIndicatorColor:[UIColor magentaColor]];
    [topMenu menuSetTitleFont:[UIFont systemFontOfSize:10]];
    [self.view addSubview:topMenu];
    self.topMenu = topMenu;
}
- (IBAction)reloadMenu:(id)sender {
    self.columns = 6;
    [self.topMenu menuReloadDataCompleteBlock:^{
        [self.button0 removeFromSuperview];
        [self.button1 removeFromSuperview];
        [self.button2 removeFromSuperview];
        [self.button3 removeFromSuperview];
        [self.topMenu menuSetBackgroundViewColor:[UIColor darkGrayColor]];

    }];
}

- (void)menu:(AdoTopMenu *)menu didSelectColumn:(NSInteger)column {
    [self showTipViewWithColumn:column];
}

- (void)menu:(AdoTopMenu *)menu deSelectColumn:(NSInteger)column {
    if (column == 0) {
        [self tapB0];
    } else if (column ==  1) {
        [self tapB1];
    } else if (column ==  2) {
       [self tapB2];
    } else if (column ==  3) {
        [self tapB3];
    }
}

- (NSInteger)numberOfColumnsInMenu:(AdoTopMenu *)menu {
    return self.columns;
}

- (NSString *)menu:(AdoTopMenu *)menu titleForColumn:(NSInteger)column {
    return [NSString stringWithFormat:@"这是第%ld列",column];
}

- (void)menu:(AdoTopMenu *)menu touchBackgroundViewForColumn:(NSInteger)column {
    if (column == 0) {
        [self tapB0];
    } else if (column ==  1) {
        [self tapB1];
    } else if (column ==  2) {
        [self tapB2];
    } else if (column ==  3) {
        [self tapB3];
    }
}


- (void)showTipViewWithColumn:(NSInteger)column {
    if (column == 0) {
        [self showButton0];
    } else if (column ==  1) {
        [self showButton1];
    } else if (column ==  2) {
        [self showButton2];
    } else if (column ==  3) {
        [self showButton3];
    }
}

- (void)tapB0 {
    [self.button0 removeFromSuperview];
    [self.topMenu menuReset];
}

- (void)showButton0 {
    UIButton *button0 = [[UIButton alloc] initWithFrame:CGRectMake(0, 108, 375, 100)];
    button0.backgroundColor = [UIColor greenColor];
    [self.view addSubview:button0];
    [button0 addTarget:self action:@selector(tapB0) forControlEvents:UIControlEventTouchUpInside];
    self.button0 = button0;
    [self.topMenu reSetTitle:@"haveTouch00" forColumn:0];
}


- (void)tapB1 {
    [self.button1 removeFromSuperview];
    [self.topMenu menuReset];
}

- (void)showButton1 {
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 108, 375, 100)];
    button1.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:button1];
    [button1 addTarget:self action:@selector(tapB1) forControlEvents:UIControlEventTouchUpInside];
    self.button1 = button1;
}

- (void)tapB2 {
    [self.button2 removeFromSuperview];
    [self.topMenu menuReset];
}

- (void)showButton2 {
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 108, 375, 100)];
    button2.backgroundColor = [UIColor greenColor];
    [self.view addSubview:button2];
    [button2 addTarget:self action:@selector(tapB2) forControlEvents:UIControlEventTouchUpInside];
    self.button2 = button2;
}

- (void)tapB3 {
    [self.button3 removeFromSuperview];
    [self.topMenu menuReset];
}

- (void)showButton3 {
    UIButton *button3 = [[UIButton alloc] initWithFrame:CGRectMake(0, 108, 375, 100)];
    button3.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:button3];
    [button3 addTarget:self action:@selector(tapB3) forControlEvents:UIControlEventTouchUpInside];
    self.button3 = button3;
}

@end
