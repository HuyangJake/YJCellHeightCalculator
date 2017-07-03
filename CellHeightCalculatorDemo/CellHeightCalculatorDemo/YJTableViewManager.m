//
//  YJTableViewManager.m
//  CellHeightCalculatorDemo
//
//  Created by Jake on 16/11/30.
//  Copyright © 2016年 jJake.hu. All rights reserved.
//

#import "YJTableViewManager.h"
#import "YJAutoLayoutCell.h"
#import "YJFrameCell.h"
#import "UITableView+YJCellHeightCalculator.h"

@interface YJTableViewManager ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, assign) LayoutType type;
@end

@implementation YJTableViewManager

- (instancetype)initWithTableView:(UITableView *)tableView layoutType:(LayoutType)type{
    self = [super init];
    if (self) {
        tableView.delegate = self;
        tableView.dataSource = self;
        self.tableView = tableView;
        self.type = type;
    }
    return self;
}

- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.isMultiSection) {
        return self.dataSource.count;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isMultiSection) {
        return [self.dataSource[section] count];
    } else {
        return self.dataSource.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    switch (self.type) {
        case Frame:
            cell = [tableView dequeueReusableCellWithIdentifier:@"FrameCell"];
            [(YJFrameCell*)cell bindData:self.dataSource[indexPath.row]];
        break;
        case AutoLayout:
            cell = [tableView dequeueReusableCellWithIdentifier:@"YJAutoLayoutCell"];
            [(YJAutoLayoutCell*)cell bindData:self.dataSource[indexPath.row]];
        break;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = nil;
    switch (self.type) {
        case Frame:
            identifier = @"FrameCell";
        break;
        case AutoLayout:
            identifier = @"YJAutoLayoutCell";
        break;
    }
    
    __weak typeof(self)weakSelf = self;
    return [tableView yj_heightForCellWithIdentifier:identifier cacheByIndexPath:indexPath configuration:^(id cell)  {
        [cell bindData:weakSelf.dataSource[indexPath.row]];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
