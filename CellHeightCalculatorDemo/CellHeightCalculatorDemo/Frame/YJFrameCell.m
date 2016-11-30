//
//  YJFrameCell.m
//  CellHeightCalculatorDemo
//
//  Created by Jake on 16/11/30.
//  Copyright © 2016年 jJake.hu. All rights reserved.
//

#import "YJFrameCell.h"
#import "YJDataModel.h"
#import "UITableView+YJCellHeightCalculator.h"

@interface YJFrameCell()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation YJFrameCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Fix the bug in iOS7 - initial constraints warning
    self.contentView.bounds = [UIScreen mainScreen].bounds;
    self.yj_enforceFrameLayout = YES;
}

- (void)bindData:(YJDataFeedModel *)model {
    self.title.text = model.title;
    self.content.text = model.content;
    self.userName.text = model.username;
    self.time.text = model.time;
    self.imgView.image = [UIImage imageNamed:model.imageName];
}

//使用frame计算高度
- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat totalHeight = 0;
    totalHeight += [self.title sizeThatFits:size].height;
    totalHeight += [self.content sizeThatFits:size].height;
    totalHeight += [self.imgView sizeThatFits:size].height;
    totalHeight += [self.userName sizeThatFits:size].height;
    totalHeight += 40; // margins
    return CGSizeMake(size.width, totalHeight);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
