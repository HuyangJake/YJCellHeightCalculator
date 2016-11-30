//
//  UITableView+YJLayoutCellDebug.h
//  CellHeightCalculatorDemo
//
//  Created by Jake on 16/11/30.
//  Copyright © 2016年 jJake.hu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (YJLayoutCellDebug)
/// Helps to debug or inspect what is this "FDTemplateLayoutCell" extention doing,
/// turning on to print logs when "creating", "calculating", "precaching" or "hitting cache".
///
/// Default to NO, log by NSLog.
///
@property (nonatomic, assign) BOOL yj_debugLogEnabled;

/// Debug log controlled by "fd_debugLogEnabled".
- (void)yj_debugLog:(NSString *)message;

@end
