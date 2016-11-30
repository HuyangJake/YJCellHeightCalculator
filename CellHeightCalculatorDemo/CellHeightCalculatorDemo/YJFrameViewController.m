//
//  YJFrameViewController.m
//  CellHeightCalculatorDemo
//
//  Created by Jake on 16/11/30.
//  Copyright © 2016年 jJake.hu. All rights reserved.
//

#import "YJFrameViewController.h"
#import "YJFrameCell.h"
#import "YJDataModel.h"
#import "YJTableViewManager.h"

@interface YJFrameViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) YJDataModel *dataModel;
@property (nonatomic, strong) YJTableViewManager *manager;
@end

@implementation YJFrameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"YJFrameCell" bundle:nil] forCellReuseIdentifier:@"FrameCell"];
    [self loadDataThen:^{
        self.manager.dataSource = self.dataModel.feed;
    }];
}

- (void)loadDataThen:(void (^)())then {
    // Simulate an async request
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Data from `data.json`
        NSString *dataFilePath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:dataFilePath];
        NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        self.dataModel = [YJDataModel parse:rootDict];
        // Callback
        dispatch_async(dispatch_get_main_queue(), ^{
            !then ?: then();
        });
    });
    
}

- (YJTableViewManager *)manager {
    if (!_manager) {
        _manager = [[YJTableViewManager alloc]initWithTableView:self.tableView layoutType:Frame];
    }
    return _manager;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
