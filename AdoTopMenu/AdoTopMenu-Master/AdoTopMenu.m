//
//  AdoTopMenu.m
//  AdoTopMenu
//
//  Created by 杜维欣 on 16/8/5.
//  Copyright © 2016年 Nododo. All rights reserved.
//

#import "AdoTopMenu.h"
#import "AdoTopMenuButton.h"

#define kScreenWidth  [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height
#define kOriginTag    1000

@interface AdoTopMenu ()

@property (nonatomic,weak)AdoTopMenuButton *rotatedBtn;
@property (nonatomic,strong)UIControl *backgroundView;
@property (nonatomic,strong)UIColor *bottomLineColor;
@property (nonatomic,strong)UIFont *titleFont;
@property (nonatomic,strong)UIColor *titleColor;
@property (nonatomic,strong)UIColor *indicatorColor;
@property (nonatomic,strong)UIColor *seperatorColor;

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
            [self configBtnAtColumn:i];
        }
    }
}

- (void)configBtnAtColumn:(NSInteger)column {
    if ([self.dataSource respondsToSelector:@selector(menu:titleForColumn:)]) {
        NSString *title = [self.dataSource menu:self titleForColumn:column];
        AdoTopMenuButton *btn = self.subviews[column];
        [btn setTitle:title forState:UIControlStateNormal];
        btn.titleLabel.font = _titleFont?:[UIFont systemFontOfSize:14];
        [btn setTitleColor:_titleColor?:[UIColor blackColor] forState:UIControlStateNormal];
        btn.indicator.fillColor = (_indicatorColor?: [UIColor blueColor]).CGColor;
        btn.line.strokeColor = (_seperatorColor?:[UIColor grayColor]).CGColor;
    }
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context,kCGLineCapSquare);
    CGContextSetLineWidth(context,1.0);
    CGContextSetStrokeColorWithColor(context, (self.bottomLineColor?: [UIColor grayColor]).CGColor);
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
            [self showBackgroundView];
            if ([self.delegate respondsToSelector:@selector(menu:didSelectColumn:)]) {
                [self.delegate menu:self didSelectColumn:didColumn];
            }
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
        [self showBackgroundView];
        if ([self.delegate respondsToSelector:@selector(menu:didSelectColumn:)]) {
            [self.delegate menu:self didSelectColumn:didColumn];
        }
        btn.rotated = YES;
        self.rotatedBtn.rotated = NO;
        self.rotatedBtn = btn;
    }
}

- (void)showBackgroundView {
    CGRect superFrame = self.superview.frame;
    CGRect selfFrame = self.frame;
    CGRect backgroundFrame = CGRectMake(0, CGRectGetMaxY(selfFrame), CGRectGetWidth(superFrame), CGRectGetHeight(superFrame) - CGRectGetHeight(selfFrame));
    self.backgroundView.frame = backgroundFrame;
    [self.superview addSubview:self.backgroundView];
    [self.superview bringSubviewToFront:self.backgroundView];
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

- (void)reSetTitle:(NSString *)title forColumn:(NSInteger)column {
    NSAssert(column < self.subviews.count, @"you must set the dataSource first or column is bigger than total columns i have");
    AdoTopMenuButton *columnButton = self.subviews[column];
    [columnButton setTitle:title forState:UIControlStateNormal];
}

- (void)menuReloadDataCompleteBlock:(void(^)())completeBlock {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self menuReset];
    self.dataSource = _dataSource;
    if (completeBlock) {
        completeBlock();
    }
}

- (void)menuSetBackgroundViewColor:(UIColor *)backgroundViewColor {
    _backgroundView.backgroundColor = backgroundViewColor;
}

- (void)menuSetTitleFont:(UIFont *)titlefont {
    _titleFont = titlefont;
    NSInteger columns = [_dataSource numberOfColumnsInMenu:self];
    for (int i = 0; i < columns; i ++) {
        [self menuSetTitleFont:titlefont forColumn:i];
    }
}

- (void)menuSetTitleFont:(UIFont *)titleFont forColumn:(NSInteger)column {
    NSAssert(column < self.subviews.count, @"you must set the dataSource first or column is bigger than total columns i have");
    AdoTopMenuButton *btn = self.subviews[column];
    [btn.titleLabel setFont:titleFont];
}

- (void)menuSetTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    NSInteger columns = [_dataSource numberOfColumnsInMenu:self];
    for (int i = 0; i < columns; i ++) {
        [self menuSetTitleColor:titleColor forColumn:i];
    }
}

- (void)menuSetTitleColor:(UIColor *)titleColor forColumn:(NSInteger)column {
    NSAssert(column < self.subviews.count, @"you must set the dataSource first or column is bigger than total columns i have");
    AdoTopMenuButton *btn = self.subviews[column];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
}

- (void)menuSetIndicatorColor:(UIColor *)indicatorColor {
    _indicatorColor = indicatorColor;
    NSInteger columns = [_dataSource numberOfColumnsInMenu:self];
    for (int i = 0; i < columns; i ++) {
        AdoTopMenuButton *btn = self.subviews[i];
        btn.indicator.fillColor = indicatorColor.CGColor;
    }
}

- (void)menuSetSeperatorColor:(UIColor *)seperatorColor {
    _seperatorColor = seperatorColor;
    NSInteger columns = [_dataSource numberOfColumnsInMenu:self];
    for (int i = 0; i < columns; i ++) {
        AdoTopMenuButton *btn = self.subviews[i];
        btn.line.strokeColor = seperatorColor.CGColor;
    }
}

- (void)menuSetBottomLineColor:(UIColor *)bottomLineColor {
    self.bottomLineColor = bottomLineColor;
    [self setNeedsDisplay];
}
@end
