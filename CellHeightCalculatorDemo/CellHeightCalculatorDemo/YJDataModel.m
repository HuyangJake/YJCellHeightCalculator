//
//  YJDataModel.m
//  CellHeightCalculatorDemo
//
//  Created by Jake on 16/11/30.
//  Copyright © 2016年 jJake.hu. All rights reserved.
//

#import "YJDataModel.h"

@implementation YJDataModel

- (NSDictionary *)yt_replaceParseMethods {
    return @{@"feed" : [YJDataFeedModel class]};
}

@end

@implementation YJDataFeedModel

@end