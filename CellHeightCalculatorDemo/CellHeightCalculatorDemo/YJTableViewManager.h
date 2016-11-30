//
//  YJTableViewManager.h
//  CellHeightCalculatorDemo
//
//  Created by Jake on 16/11/30.
//  Copyright © 2016年 jJake.hu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LayoutType) {
    Frame,
    AutoLayout,
};

@interface YJTableViewManager : NSObject

@property (nonatomic, assign) BOOL isMultiSection;//default is NO
@property (nonatomic, weak) NSArray *dataSource;

- (instancetype)initWithTableView:(UITableView *)tableView layoutType:(LayoutType)type;

@end
