//
//  UITableView+YJLayoutCellDebug.m
//  CellHeightCalculatorDemo
//
//  Created by Jake on 16/11/30.
//  Copyright © 2016年 jJake.hu. All rights reserved.
//

#import "UITableView+YJLayoutCellDebug.h"
#import <objc/runtime.h>

@implementation UITableView (YJLayoutCellDebug)

- (BOOL)yj_debugLogEnabled {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setYj_debugLogEnabled:(BOOL)debugLogEnabled {
    objc_setAssociatedObject(self, @selector(yj_debugLogEnabled), @(debugLogEnabled), OBJC_ASSOCIATION_RETAIN);
}

- (void)yj_debugLog:(NSString *)message {
    if (self.yj_debugLogEnabled) {
        NSLog(@"** CellHeightCalculator ** %@", message);
    }
}

@end
