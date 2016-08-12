//
//  AdoTopMenu.h
//  AdoTopMenu
//
//  Created by 杜维欣 on 16/8/5.
//  Copyright © 2016年 Nododo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AdoTopMenu;

@protocol AdoTopMenuDataSource <NSObject>

@required

- (NSInteger)numberOfColumnsInMenu:(AdoTopMenu *)menu;

- (NSString *)menu:(AdoTopMenu *)menu titleForColumn:(NSInteger)column;

@end

@protocol AdoTopMenuDelegate <NSObject>

@optional

- (void)menu:(AdoTopMenu *)menu didSelectColumn:(NSInteger)column;

- (void)menu:(AdoTopMenu *)menu deSelectColumn:(NSInteger)column;

- (void)menu:(AdoTopMenu *)menu touchBackgroundViewForColumn:(NSInteger)column;

@end

@interface AdoTopMenu : UIView

@property (nonatomic, weak) id <AdoTopMenuDelegate> delegate;

@property (nonatomic, weak) id <AdoTopMenuDataSource> dataSource;

- (void)reSetTitle:(NSString *)title forColumn:(NSInteger)column;

- (void)menuReset;

- (void)menuReloadDataCompleteBlock:(void(^)())completeBlock;

- (void)menuSetBackgroundViewColor:(UIColor *)backgroundViewColor;

- (void)menuSetTitleColor:(UIColor *)titleColor;

- (void)menuSetTitleColor:(UIColor *)titleColor forColumn:(NSInteger)column;

- (void)menuSetTitleFont:(UIFont *)titlefont;

- (void)menuSetTitleFont:(UIFont *)titleFont forColumn:(NSInteger)column;

- (void)menuSetIndicatorColor:(UIColor *)indicatorColor;

- (void)menuSetSeperatorColor:(UIColor *)seperatorColor;

- (void)menuSetBottomLineColor:(UIColor *)bottomLineColor;
@end
