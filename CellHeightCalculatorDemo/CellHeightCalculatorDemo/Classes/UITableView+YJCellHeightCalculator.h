//
//  UITableView+YJCellHeightCalculator.h
//  CellHeightCalculatorDemo
//
//  Created by Jake on 16/11/30.
//  Copyright © 2016年 jJake.hu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (YJCellHeightCalculator)

- (__kindof UITableViewCell *)yj_templateCellForReuseIdentifier:(NSString *)identifier;

/**
 通过identifier获取用于cell,在block中填充数据,返回计算的高度
 */
- (CGFloat)yj_heightForCellWithIdentifier:(NSString *)identifier configuration:(void (^)(id cell))configuration;

/**
 通过identifier获取用于cell,在block中填充数据,返回计算的高度,并进行缓存
 */
- (CGFloat)yj_heightForCellWithIdentifier:(NSString *)identifier cacheByIndexPath:(NSIndexPath *)indexPath configuration:(void (^)(id cell))configuration;

@end


@interface UITableViewCell (YJCellHeightCalculator)
/// Indicate this is a template layout cell for calculation only.
/// You may need this when there are non-UI side effects when configure a cell.
/// Like:
///   - (void)configureCell:(FooCell *)cell atIndexPath:(NSIndexPath *)indexPath {
///       cell.entity = [self entityAtIndexPath:indexPath];
///       if (!cell.fd_isTemplateLayoutCell) {
///           [self notifySomething]; // non-UI side effects
///       }
///   }
///
@property (nonatomic, assign) BOOL yj_isTemplateLayoutCell;


/**
 选择使用frame layout还是auto layout ,需要手动地控制template cell的高度的时候，设置为YES并重写sizeThatFit: 方法
 */
@property (nonatomic, assign) BOOL yj_enforceFrameLayout;//default to NO.
@end
