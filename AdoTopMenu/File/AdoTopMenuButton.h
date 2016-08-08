//
//  AdoTopMenuButton.h
//  AdoTopMenu
//
//  Created by 杜维欣 on 16/8/5.
//  Copyright © 2016年 Nododo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdoTopMenuButton : UIButton

@property (nonatomic,weak)CAShapeLayer *indicator;

//- (void)rotateDown;
//
//- (void)rotateReset;

@property (nonatomic,assign)BOOL rotated;

@end
