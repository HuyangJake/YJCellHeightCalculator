//
//  YTBaseModel.m
//  YuanTu
//
//  Created by Jake on 2016/11/19.
//  Copyright © 2016年 panweijian. All rights reserved.
//

#import "YTBaseModel.h"
#import <objc/runtime.h>

@implementation YTBaseModel

- (NSDictionary *)yt_replaceKeys {
    return nil;
}

- (NSDictionary *)yt_replaceParseMethods {
    return nil;
}

//解析字典方法
+ (id)parseDic:(id)responseObj {
    id model = [self new];
    NSDictionary *replaceDic = [model yt_replaceKeys];
    NSDictionary *replaceMethods = [model yt_replaceParseMethods];
    [responseObj enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([replaceDic valueForKey:key]) {
            key = replaceDic[key];
        }
        
        if ([replaceMethods valueForKey:key]) {
            Class class = replaceMethods[key];
            obj = [class parse:obj];
        }
        [model setValue:obj forKey:key];
    }];
    return model;
}

//解析数组方法
+ (NSArray *)parseArray:(NSArray *)array {
    NSMutableArray *arr = [NSMutableArray new];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        id object = [self parse:obj];
        [arr addObject:object];
    }];
    return [arr mutableCopy];
}

+ (id)parse:(id)responseObj {
    id obj = responseObj;
    if ([obj isKindOfClass:[NSDictionary class]]) {
        return [self parseDic:obj];
    } else if ([obj isKindOfClass:[NSArray class]]) {
        return [self parseArray:obj];
    } else if ([obj isKindOfClass:[NSData class]]) {
        return [self parse:[self jsonSerialization:obj]];
    } else {
        return nil;
    }
}

//json序列化
+ (id)jsonSerialization:(NSData *)responseObj {
    NSError *error = nil;
    id data = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableLeaves|NSJSONReadingMutableContainers|NSJSONReadingAllowFragments error:&error];
    BOOL success = [data isKindOfClass:[NSArray class]] || [data isKindOfClass:[NSString class]] || [data isKindOfClass:[NSDictionary class]] || [data isKindOfClass:[NSNumber class]] || [data isKindOfClass:[NSNull class]];
    //如果序列化出问题了 或者 序列化的结果类型不正确
    //__FUNCTION__会打印出当前是哪个类的哪个方法
    NSAssert1(!error||success, @"JSON数据有问题 %s", __FUNCTION__);
    return data;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    unsigned int count ;
    objc_property_t *propertyList = class_copyPropertyList([self class], &count);
    for (unsigned int i = 0; i<count ; i++) {
        
        objc_property_t property = propertyList[i];
        
        const char *name = property_getName(property);
        
        NSString *properName = [NSString stringWithUTF8String:name];
        
        [aCoder encodeObject:[self valueForKey:properName] forKey:properName];
        
    }
    free(propertyList);
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        unsigned int count ;
        objc_property_t *propertyList = class_copyPropertyList([self class], &count);
        for (unsigned int i = 0; i<count ; i++) {
            
            objc_property_t property = propertyList[i];
            
            const char *name = property_getName(property);
            
            NSString *properName = [NSString stringWithUTF8String:name];
            
            [self setValue:[aDecoder decodeObjectForKey:properName] forKey:properName];
        }
        free(propertyList);
        
    }
    return self;
}


@end
