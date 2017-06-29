//
//  YJDataModel.h
//  CellHeightCalculatorDemo
//
//  Created by Jake on 16/11/30.
//  Copyright © 2016年 jJake.hu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YTBaseModel.h"

@interface YJDataModel : YTBaseModel
@property (nonatomic, strong) NSArray *feed;
@end

@interface YJDataFeedModel : YTBaseModel
@property (nonatomic, copy, readonly) NSString *identifier;
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *content;
@property (nonatomic, copy, readonly) NSString *username;
@property (nonatomic, copy, readonly) NSString *time;
@property (nonatomic, copy, readonly) NSString *imageName;
@end
