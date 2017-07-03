//
//  UITableView+YJCellHeightCalculator.m
//  CellHeightCalculatorDemo
//
//  Created by Jake on 16/11/30.
//  Copyright © 2016年 Jake.hu. All rights reserved.
//

#import "UITableView+YJCellHeightCalculator.h"
#import "UITableView+YJIndexPathHeightCache.h"
#import <objc/runtime.h>

@implementation UITableView (YJCellHeightCalculator)

- (CGFloat)yj_systemFittingHeightForConfiguratedCell:(UITableViewCell *)cell {
    CGFloat contentViewWidth = CGRectGetWidth(self.frame);
    //cell中有accessoryView的情况cell的contentView的宽度会比tableView窄
    if (cell.accessoryView) {
        contentViewWidth -= 16 + CGRectGetWidth(cell.accessoryView.frame);
    } else {
        //系统的accessory的宽度
        static const CGFloat systemAccessoryWidths[] = {
            [UITableViewCellAccessoryNone] = 0,
            [UITableViewCellAccessoryDisclosureIndicator] = 34,
            [UITableViewCellAccessoryDetailDisclosureButton] = 68,
            [UITableViewCellAccessoryCheckmark] = 40,
            [UITableViewCellAccessoryDetailButton] = 48
        };
        contentViewWidth -= systemAccessoryWidths[cell.accessoryType];
    }
    
    CGFloat fittingHeight = 0;
    
    if (!cell.yj_enforceFrameLayout && contentViewWidth > 0) {
        //给cell添加一个当前宽度的约束，用于更新约束时间宽度不变获取正确的高度
        NSLayoutConstraint *widthFenceConstraint = [NSLayoutConstraint constraintWithItem:cell.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:contentViewWidth];
        
        //iOS10.3之后，Auto Layout会给cell的contentView添加一个默认为0的宽度约束，此处手动给contentView添加上下左右约束
        static BOOL isSystemVersionEqualOrGreaterThen10_2 = NO;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            isSystemVersionEqualOrGreaterThen10_2 = [UIDevice.currentDevice.systemVersion compare:@"10.2" options:NSNumericSearch] != NSOrderedAscending;
        });
        
        NSArray<NSLayoutConstraint *> *edgeConstraints;
        if (isSystemVersionEqualOrGreaterThen10_2) {
            //为了避免约束冲突，将原有的宽度约束的优先级下降
            widthFenceConstraint.priority = UILayoutPriorityRequired - 1;
            
            // Build edge constraints
            NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:cell.contentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
            NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:cell.contentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
            NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:cell.contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
            NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:cell.contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
            edgeConstraints = @[leftConstraint, rightConstraint, topConstraint, bottomConstraint];
            [cell addConstraints:edgeConstraints];
        }
        
        [cell.contentView addConstraint:widthFenceConstraint];
        //使用autolayout进行cell布局自适应，获取当前高度
        fittingHeight = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        [cell.contentView removeConstraint:widthFenceConstraint];
        if (isSystemVersionEqualOrGreaterThen10_2) {
            [cell removeConstraints:edgeConstraints];
        }
#if DEBUG
        NSLog(@"%@",[NSString stringWithFormat:@"calculate using system fitting size (AutoLayout) - %@", @(fittingHeight)]);
#endif
    }
    
    if (fittingHeight == 0) {
#if DEBUG
        // 使用约束自动布局却获取的高度是0
        if (cell.contentView.constraints.count > 0) {
            if (!objc_getAssociatedObject(self, _cmd)) {
                NSLog(@"[YJCellHeightCalculator] Warning once only: 不能通过 '- systemFittingSize:'(AutoLayout)获取正确的高度，请检查cell中的约束是否设置正确。cell需要满足约束'self-sizing'");
                objc_setAssociatedObject(self, _cmd, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
        }
#endif
        //使用frame自行计算高度，需要在cell中重写 sizeThatFits: 方法
        fittingHeight = [cell sizeThatFits:CGSizeMake(contentViewWidth, 0)].height;
#if DEBUG
        NSLog(@"%@",[NSString stringWithFormat:@"calculate using sizeThatFits - %@", @(fittingHeight)]);
#endif
    }
    
    //获取高度失败，最后只能使用默认的高度
    if (fittingHeight == 0) {
        fittingHeight = 44;
    }
    
    // 添加一个像素用于显示Cell的分割线
    if (self.separatorStyle != UITableViewCellSeparatorStyleNone) {
        fittingHeight += 1.0 / [UIScreen mainScreen].scale;
    }
    
    return fittingHeight;
    
}

- (__kindof UITableViewCell *)yj_templateCellForReuseIdentifier:(NSString *)identifier {
    NSAssert(identifier.length > 0, @"无效的identifier - %@", identifier);
    //添加一个templateCellByIdentifiers的字典属性
    NSMutableDictionary<NSString *, UITableViewCell *> *templateCellsByIdentifiers = objc_getAssociatedObject(self, _cmd);
    if (!templateCellsByIdentifiers) {
        templateCellsByIdentifiers = @{}.mutableCopy;
        objc_setAssociatedObject(self, _cmd, templateCellsByIdentifiers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    UITableViewCell *templateCell = templateCellsByIdentifiers[identifier];
    
    if (!templateCell) {
        templateCell = [self dequeueReusableCellWithIdentifier:identifier];
        NSAssert(templateCell != nil, @"Cell must be registered to table view for identifier - %@", identifier);
        templateCell.yj_isTemplateLayoutCell = YES;
        templateCell.contentView.translatesAutoresizingMaskIntoConstraints = NO;
        templateCellsByIdentifiers[identifier] = templateCell;
#if DEBUG
        NSLog(@"%@",[NSString stringWithFormat:@"layout cell created - %@", identifier]);
#endif
    }
    return templateCell;
}

- (CGFloat)yj_heightForCellWithIdentifier:(NSString *)identifier configuration:(void (^)(id cell))configuration {
    if (!identifier) {
        return 0;
    }
    
    UITableViewCell *templateLayoutCell = [self yj_templateCellForReuseIdentifier:identifier];
    
    // 将模板Cell添加到重用队列中
    [templateLayoutCell prepareForReuse];
    
    // 在block中对cell的内容进行填充
    if (configuration) {
        configuration(templateLayoutCell);
    }
    
    return [self yj_systemFittingHeightForConfiguratedCell:templateLayoutCell];
}

- (CGFloat)yj_heightForCellWithIdentifier:(NSString *)identifier cacheByIndexPath:(NSIndexPath *)indexPath configuration:(void (^)(id))configuration {
    if (!identifier || !indexPath) {
        return 0;
    }
    if ([self.yj_indexPathHeightCache existsHeightAtIndexPath:indexPath]) {
#if DEBUG
        NSLog(@"%@",[NSString stringWithFormat:@"获得缓存的高度index path[%@:%@] - %@", @(indexPath.section), @(indexPath.row), @([self.yj_indexPathHeightCache heightForIndexPath:indexPath])]);
#endif
        return [self.yj_indexPathHeightCache heightForIndexPath:indexPath];
    }
    
    CGFloat height = [self yj_heightForCellWithIdentifier:identifier configuration:configuration];
    [self.yj_indexPathHeightCache cacheHeight:height byIndexPath:indexPath];
#if DEBUG
    NSLog(@"%@",[NSString stringWithFormat: @"缓存高度 index path[%@:%@] - %@", @(indexPath.section), @(indexPath.row), @(height)]);
#endif
    return height;
}

@end

@implementation UITableViewCell (YJCellHeightCalculator)

- (BOOL)yj_isTemplateLayoutCell {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setYj_isTemplateLayoutCell:(BOOL)isTemplateLayoutCell {
    objc_setAssociatedObject(self, @selector(yj_isTemplateLayoutCell), @(isTemplateLayoutCell), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)yj_enforceFrameLayout {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setYj_enforceFrameLayout:(BOOL)enforceFrameLayout {
    objc_setAssociatedObject(self, @selector(yj_enforceFrameLayout), @(enforceFrameLayout), OBJC_ASSOCIATION_RETAIN);
}

@end
