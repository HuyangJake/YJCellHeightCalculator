# YJCellHeightCalculator
自动计算动态cell高度,并缓存高度

###  使用方法：

``` objectivec

#import "UITableView+YJCellHeightCalculator.h"

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView yj_heightForCellWithIdentifier:@"reuse identifer" configuration:^(id cell) {
        // Configure this cell with data, same as what you've done in "-tableView:cellForRowAtIndexPath:"
        // Like:
        //    cell.entity = self.feedEntities[indexPath.row];
    }];
}

```


### 提交历史：

2016.11.30 首次提交

2017.07.03 修复iOS10.3中的bug，添加高度缓存


_感谢 [UITableView-FDTemplateLayoutCell](https://github.com/forkingdog/UITableView-FDTemplateLayoutCell)_
