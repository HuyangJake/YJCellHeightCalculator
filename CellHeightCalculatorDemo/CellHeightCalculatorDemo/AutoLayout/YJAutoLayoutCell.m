//
//  YJAutoLayoutCell.m
//  CellHeightCalculatorDemo
//
//  Created by Jake on 16/11/30.
//  Copyright © 2016年 jJake.hu. All rights reserved.
//

#import "YJAutoLayoutCell.h"
#import "YJDataModel.h"

@interface YJAutoLayoutCell()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation YJAutoLayoutCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Fix the bug in iOS7 - initial constraints warning
    self.contentView.bounds = [UIScreen mainScreen].bounds;
}

- (void)bindData:(YJDataFeedModel *)model {
    self.title.text = model.title;
    self.content.text = model.content;
    self.userName.text = model.username;
    self.time.text = model.time;
    self.imgView.image = [UIImage imageNamed:model.imageName];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
