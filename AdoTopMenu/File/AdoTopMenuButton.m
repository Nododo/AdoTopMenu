//
//  AdoTopMenuButton.m
//  AdoTopMenu
//
//  Created by 杜维欣 on 16/8/5.
//  Copyright © 2016年 Nododo. All rights reserved.
//

#import "AdoTopMenuButton.h"


@implementation AdoTopMenuButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CGPoint indicatorPoint = CGPointMake(CGRectGetWidth(frame) - 8, CGRectGetHeight(frame) / 2 - 2);
        CAShapeLayer *indicator = [self createIndicatorWithColor:[UIColor blueColor] andPosition:indicatorPoint];
        [self.layer addSublayer:indicator];
        [self setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.indicator = indicator;
    }
    
    return self;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGRect tempRect = contentRect;
    tempRect.size.width = contentRect.size.width - 8;
    return tempRect;
}

- (CAShapeLayer *)createIndicatorWithColor:(UIColor *)color andPosition:(CGPoint)point {
    CAShapeLayer *layer = [CAShapeLayer new];
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(8, 0)];
    [path addLineToPoint:CGPointMake(4, -5)];
    [path closePath];
    
    layer.path = path.CGPath;
    layer.lineWidth = 0.8;
    layer.fillColor = color.CGColor;
    
    CGPathRef bound = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, kCGLineCapButt, kCGLineJoinMiter, layer.miterLimit);
    layer.bounds = CGPathGetBoundingBox(bound);
    CGPathRelease(bound);
    layer.position = point;
    
    return layer;
}

- (void)rotateDown {
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    anim.values =  @[@0, @(M_PI)];
    anim.duration = 0.4;
    anim.fillMode = kCAFillModeForwards;
    anim.removedOnCompletion = NO;
    [self.indicator addAnimation:anim forKey:@"rotate"];
}

- (void)rotateReset {
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    anim.values =  @[@(M_PI), @0];
    anim.duration = 0.4;
    anim.fillMode = kCAFillModeForwards;
    anim.removedOnCompletion = NO;
    [self.indicator addAnimation:anim forKey:@"rotate"];
}

- (void)setRotated:(BOOL)rotated {
    if (rotated == _rotated) return;
    _rotated = rotated;
    if (rotated) {
        [self rotateDown];
    }else {
        [self rotateReset];
    }
    
}

@end
