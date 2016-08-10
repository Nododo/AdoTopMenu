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

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (UIControl *)backgroundView {
    if (!_backgroundView) {
        self.backgroundView = [[UIControl alloc] initWithFrame:CGRectZero];
        _backgroundView.backgroundColor = [UIColor colorWithWhite:.8 alpha:.2];
        [_backgroundView addTarget:self action:@selector(touchBackgroundView) forControlEvents:UIControlEventTouchUpInside];
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

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context,kCGLineCapSquare);
    CGContextSetLineWidth(context,1.0);
    CGContextSetGrayStrokeColor(context, 0.5, 0.5);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context,0, CGRectGetHeight(rect));
    CGContextAddLineToPoint(context,CGRectGetWidth(rect), CGRectGetHeight(rect));
    CGContextStrokePath(context);
}

- (void)btnClick:(AdoTopMenuButton *)btn {
    NSInteger didColumn = btn.tag - kOriginTag;
    NSInteger deColumn = self.rotatedBtn.tag - kOriginTag;
    
    if (btn == self.rotatedBtn) {
        self.rotatedBtn.rotated = !self.rotatedBtn.rotated;
        if (self.rotatedBtn.rotated) {
            if ([self.delegate respondsToSelector:@selector(menu:didSelectColumn:)]) {
                [self.delegate menu:self didSelectColumn:didColumn];
            }
            [self showBackgroundView];
        } else {
            if ([self.delegate respondsToSelector:@selector(menu:deSelectColumn:)]) {
                [self.delegate menu:self deSelectColumn:deColumn];
            }
            [self hideBackgroundView];
        }
    } else {
        if (self.rotatedBtn.rotated) {
            if ([self.delegate respondsToSelector:@selector(menu:deSelectColumn:)]) {
                [self.delegate menu:self deSelectColumn:deColumn];
            }
            [self hideBackgroundView];
        }
        if ([self.delegate respondsToSelector:@selector(menu:didSelectColumn:)]) {
            [self.delegate menu:self didSelectColumn:didColumn];
        }
        [self showBackgroundView];
        btn.rotated = YES;
        self.rotatedBtn.rotated = NO;
        self.rotatedBtn = btn;
    }
}

- (void)showBackgroundView {
    CGRect superFrame = self.superview.frame;
    CGRect selfFrame = self.frame;
    CGRect backgroundFrame = CGRectOffset(superFrame, 0, CGRectGetMaxY(selfFrame));
    self.backgroundView.frame = backgroundFrame;
    [self.superview addSubview:self.backgroundView];
    [self.superview sendSubviewToBack:self.backgroundView];
}

- (void)hideBackgroundView {
    self.backgroundView.frame = CGRectZero;
    [self.backgroundView removeFromSuperview];
}


- (void)touchBackgroundView {
    NSInteger deColumn = self.rotatedBtn.tag - kOriginTag;
    self.rotatedBtn.rotated = NO;
    [self hideBackgroundView];
    if ([self.delegate respondsToSelector:@selector(menu:touchBackgroundViewForColumn:)]) {
        [self.delegate menu:self touchBackgroundViewForColumn:deColumn];
    }
}

- (void)menuReset {
    self.rotatedBtn.rotated = NO;
    [self hideBackgroundView];
}

- (void)reSetTitle:(NSString *)title ForColumn:(NSInteger)column {
    NSAssert(column < self.subviews.count, @"column is bigger than total columns i have");
    AdoTopMenuButton *columnButton = self.subviews[column];
    [columnButton setTitle:title forState:UIControlStateNormal];
}
@end
