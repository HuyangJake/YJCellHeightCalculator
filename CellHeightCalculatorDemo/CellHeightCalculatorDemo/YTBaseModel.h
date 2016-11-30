//
//  YTBaseModel.h
//  YuanTu
//
//  Created by Jake on 2016/11/19.
//  Copyright © 2016年 panweijian. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YTBaseModelDelegate <NSObject>

+ (id)parse:(id)responseObj;

@end

@interface YTBaseModel : NSObject <YTBaseModelDelegate>

/**
 替换服务器返回的键的名字，在子类中重写此方法如：
 - (NSDictionary *)yt_replaceKeys{
    return @{@"id" : @"identify", @"description" : @"desc"};
 }
 */
- (NSDictionary *)yt_replaceKeys;

/**
 解析时替换键对应的值得解析类，在子类中重写此方法如：
 - (NSDictionary *)yt_replaceParseMethods{
    return @{@"data":@"YTHomeDataModel"};
 }
 */
- (NSDictionary *)yt_replaceParseMethods;

@end
