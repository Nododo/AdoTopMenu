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
/**
 *  多少列
 *
 *  @param menu
 *
 *  @return 列数
 */
- (NSInteger)numberOfColumnsInMenu:(AdoTopMenu *)menu;
/**
 *  每一列的标题
 *
 *  @param menu
 *  @param column 那一列
 *
 *  @return 标题
 */
- (NSString *)menu:(AdoTopMenu *)menu titleForColumn:(NSInteger)column;

@end

@protocol AdoTopMenuDelegate <NSObject>

@optional
/**
 *  选中了那一列
 *
 *  @param menu
 *  @param column 那一列
 */
- (void)menu:(AdoTopMenu *)menu didSelectColumn:(NSInteger)column;
/**
 *  取消选中了那一列
 *
 *  @param menu
 *  @param column 那一列
 */
- (void)menu:(AdoTopMenu *)menu deSelectColumn:(NSInteger)column;
/**
 *  点击了背景
 *
 *  @param menu
 *  @param column 那一列的背景
 */
- (void)menu:(AdoTopMenu *)menu touchBackgroundViewForColumn:(NSInteger)column;

@end

@interface AdoTopMenu : UIView
/**
 *  代理
 */
@property (nonatomic, weak) id <AdoTopMenuDelegate> delegate;
/**
 *  数据源
 */
@property (nonatomic, weak) id <AdoTopMenuDataSource> dataSource;
/**
 *  重置那一列的标题
 *
 *  @param title  标题
 *  @param column 那一列
 */
- (void)reSetTitle:(NSString *)title forColumn:(NSInteger)column;
/**
 *  重置背景颜色
 *
 *  @param backgroundViewColor 背景颜色
 */
- (void)menuSetBackgroundViewColor:(UIColor *)backgroundViewColor;
/**
 *  重置标题颜色
 *
 *  @param titleColor 标题颜色
 */
- (void)menuSetTitleColor:(UIColor *)titleColor;
/**
 *  重置某列标题颜色
 *
 *  @param titleColor 标题颜色
 *  @param column     那一列
 */
- (void)menuSetTitleColor:(UIColor *)titleColor forColumn:(NSInteger)column;
/**
 *  重置那列背景颜色
 *
 *  @param titleBackgroundColor 背景颜色
 */
- (void)menuSetTitleBackgroundColor:(UIColor *)titleBackgroundColor;
/**
 *  重置某列背景颜色
 *
 *  @param titleBackgroundColor 背景颜色
 *  @param column               那一列
 */
- (void)menuSetTitleBackgroundColor:(UIColor *)titleBackgroundColor forColumn:(NSInteger)column;
/**
 *  重置标题字体大小
 *
 *  @param titlefont 字体大小
 */
- (void)menuSetTitleFont:(UIFont *)titlefont;
/**
 *  重置某列字体大小
 *
 *  @param titleFont 字体大小
 *  @param column    那一列
 */
- (void)menuSetTitleFont:(UIFont *)titleFont forColumn:(NSInteger)column;
/**
 *  重置三角颜色
 *
 *  @param indicatorColor 三角的颜色
 */
- (void)menuSetIndicatorColor:(UIColor *)indicatorColor;
/**
 *  重置分割线颜色
 *
 *  @param seperatorColor 分割线颜色
 */
- (void)menuSetSeperatorColor:(UIColor *)seperatorColor;
/**
 *  重置底部线条颜色
 *
 *  @param bottomLineColor 线条颜色
 */
- (void)menuSetBottomLineColor:(UIColor *)bottomLineColor;
/**
 *  回到默认状态
 */
- (void)menuReset;
/**
 *  清除所有选项   重新从数据源获取数据  重新加载
 *
 *  @param completeBlock 重新加载后调用block
 */
- (void)menuReloadDataCompleteBlock:(void(^)())completeBlock;

@end
