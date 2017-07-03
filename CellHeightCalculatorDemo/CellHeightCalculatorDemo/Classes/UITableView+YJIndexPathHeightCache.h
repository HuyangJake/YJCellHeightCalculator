//
//  UITableView+YJIndexPathHeightCache.h
//  CellHeightCalculatorDemo
//
//  Created by Jake on 16/11/30.
//  Copyright © 2016年 Jake.hu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YJIndexPathHeightCache : NSObject
//是否自动取消高度缓存，在刷新的时候
@property (nonatomic, assign) BOOL automaticallyInvalidateEnabled;

// Height cache
- (BOOL)existsHeightAtIndexPath:(NSIndexPath *)indexPath;
- (void)cacheHeight:(CGFloat)height byIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)heightForIndexPath:(NSIndexPath *)indexPath;
- (void)invalidateHeightAtIndexPath:(NSIndexPath *)indexPath;
- (void)invalidateAllHeightCache;

@end

@interface UITableView (YJIndexPathHeightCache)
@property (nonatomic, strong, readonly) YJIndexPathHeightCache *yj_indexPathHeightCache;
@end

@interface UITableView (YJIndexPathHeightCacheInvalidation)
//用于调用reloadData并不删除高度的缓存
- (void)yj_reloadDataWithoutInvalidateIndexPathHeightCache;
@end
