//
//  AdoTopMenu.m
//  AdoTopMenu
//
//  Created by 杜维欣 on 16/8/5.
//  Copyright © 2016年 Nododo. All rights reserved.
//

#import "AdoTopMenu.h"
#import "AdoTopMenuButton.h"

#define kScreenWidth [[UIScreen mainScreen]                                                                                                                         bounds].size.width
#define kScreenHeight [[UIScreen mainScreen]                                                                                                                        bounds].size.height
#define kOriginTag                                                                                                                                                  1000

#define kRandomColor                    ([UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0f])

@interface AdoTopMenu ()

@property (nonatomic,weak)AdoTopMenuButton *rotatedBtn;
@property (nonatomic,strong)UIControl *backgroundView;


@end

@implementation AdoTopMenu

- (UIControl *)backgroundView {
    if (!_backgroundView) {
        self.backgroundView = [[UIControl alloc] initWithFrame:CGRectZero];
        _backgroundView.backgroundColor = [UIColor colorWithWhite:.5 alpha:.3];
        [_backgroundView addTarget:self action:@selector(menuReset) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backgroundView;
}

- (void)setDataSource:(id<AdoTopMenuDataSource>)dataSource {
    _dataSource = dataSource;
    if ([_dataSource respondsToSelector:@selector(numberOfColumnsInMenu:)]) {
        NSInteger columns = [_dataSource numberOfColumnsInMenu:self];
        CGFloat btnW = kScreenWidth / columns;
        for (int i = 0; i < columns; i ++) {
            CGFloat btnX =  btnW * i;
            AdoTopMenuButton *btn = [[AdoTopMenuButton alloc] initWithFrame:CGRectMake(btnX, 0, btnW, CGRectGetHeight(self.frame))];
            btn.backgroundColor = kRandomColor;
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = kOriginTag + i;
            [self addSubview:btn];
            [self configTitleForBtnAtColumn:i];
        }
    }
}

- (void)configTitleForBtnAtColumn:(NSInteger)column {
    if ([self.dataSource respondsToSelector:@selector(menu:titleForColumn:)]) {
        NSString *title = [self.dataSource menu:self titleForColumn:column];
        AdoTopMenuButton *btn = self.subviews[column];
        [btn setTitle:title forState:UIControlStateNormal];
    }
}

- (void)btnClick:(AdoTopMenuButton *)btn {
    NSInteger didColumn = btn.tag - kOriginTag;
    NSInteger deColumn = self.rotatedBtn.tag - kOriginTag;
    CGRect superFrame = self.superview.frame;
    CGRect selfFrame = self.frame;
    CGRect backgroundFrame = CGRectOffset(superFrame, 0, CGRectGetMaxY(selfFrame));
    if (btn == self.rotatedBtn) {
        self.rotatedBtn.rotated = !self.rotatedBtn.rotated;
        if (self.rotatedBtn.rotated) {
            if ([self.delegate respondsToSelector:@selector(menu:didSelectColumn:)]) {
                [self.delegate menu:self didSelectColumn:didColumn];
            }
            self.backgroundView.frame = backgroundFrame;
            [self.superview addSubview:self.backgroundView];
            [self.superview sendSubviewToBack:self.backgroundView];
        } else {
            if ([self.delegate respondsToSelector:@selector(menu:deSelectColumn:)]) {
                [self.delegate menu:self deSelectColumn:deColumn];
                self.backgroundView.frame = CGRectZero;
                [self.backgroundView removeFromSuperview];
            }
        }
    } else {
        if (self.rotatedBtn.rotated) {
            if ([self.delegate respondsToSelector:@selector(menu:deSelectColumn:)]) {
                [self.delegate menu:self deSelectColumn:deColumn];
            }
            self.backgroundView.frame = CGRectZero;
            [self.backgroundView removeFromSuperview];
        }
        if ([self.delegate respondsToSelector:@selector(menu:didSelectColumn:)]) {
            [self.delegate menu:self didSelectColumn:didColumn];
            self.backgroundView.frame = backgroundFrame;
            [self.superview addSubview:self.backgroundView];
            [self.superview sendSubviewToBack:self.backgroundView];
        }
        btn.rotated = YES;
        self.rotatedBtn.rotated = NO;
        self.rotatedBtn = btn;
    }
}

- (void)menuReset {
    NSInteger deColumn = self.rotatedBtn.tag - kOriginTag;
    self.rotatedBtn.rotated = NO;
    self.backgroundView.frame = CGRectZero;
    [self.backgroundView removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(menu:deSelectColumn:)]) {
        [self.delegate menu:self deSelectColumn:deColumn];
    }
}

@end
