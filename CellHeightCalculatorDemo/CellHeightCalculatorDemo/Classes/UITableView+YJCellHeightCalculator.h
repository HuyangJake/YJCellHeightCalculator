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

@end


@interface UITableViewCell (YJCellHeightCalculator)

/**
 标记当前cell为模板cell用于计算高度
 */
@property (nonatomic, assign) BOOL yj_isTemplateLayoutCell;

/**
 选择使用frame layout还是auto layout 
 需要手动地控制template cell的高度的时候
 设置为YES并在Cell中重写 sizeThatFit: 方法返回cell的高度
 */
@property (nonatomic, assign) BOOL yj_enforceFrameLayout;//default to NO.
@end
