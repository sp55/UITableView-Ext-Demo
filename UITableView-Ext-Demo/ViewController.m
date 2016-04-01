//
//  ViewController.m
//  UITableView-Ext-Demo
//
//  Created by admin on 16/3/31.
//  Copyright © 2016年 AlezJi. All rights reserved.
//

#import "ViewController.h"
//你真的会用UITableView嘛
//http://ios.jobbole.com/84377/


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //Q-->1--->当我们的数据未能显示满一屏幕的时候，UITableView会显示多余的横线，这个时候你如果希望去掉这些横线，你可以加上这句话
    self.tableView.tableFooterView = [[UIView alloc]init];

    //Q-->2--->UITableView的分割线默认是开头空15像素点的（好像是15来着～～），产品经理有时候希望能够定格显示，那么你可能会这么做。
    self.tableView.separatorInset = UIEdgeInsetsZero;
    //但是你很快就会发现这么做并没有效果，这是因为separatorInset这个属性在iOS7以后就已经失效了，但是我们还是能够达到同样的效果，你可以在你的tablevView的代理协议实现界面加上下面这段代码：
    
    
    
    //Q-->3--->很多情况下我们的UITableViewCell的高度是动态不确定的，比如说很多聊天的界面都需要我们去动态的计算cell的高度，你可能会在heightForRowAtIndexPath代理协议方法中返回你计算好的cell高度，然后在苹果推出约束以后，我们其实有更加方便的方法去实现相同的效果。你可以尝试在你的代码中加入以下两行代码：
    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
//    再次运行你的程序，其实你发现了好像你的cell并没有动态的返回高度，这是因为上面说了，这两行代码必须配合约束来使用。
//    我们拖出一个SB，然后在cell上放上一个label，讲label的numberOfLines属性设置为0，然后设置好label的上下左右约束，然后再对label的内容进行赋值，再次运行你的程序，这个时候你的cell就会动态的显示高度了，label的高度取决于你的内容的多少，同时按照你的约束进行显示。
//    -你可能写过这样下面这样的代码
}
//A->2->方法
/**
 *  分割线顶头
 */
-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    
    
    //A->3---
    CGFloat offSet = tableView.contentOffset.y;
    if (offSet<=0) {
        return;
    }
    CGRect oldRect = cell.frame;
    CGRect newRect = cell.frame;
    newRect.origin.x += 50;
    cell.frame = newRect;
    [UIView animateWithDuration:0.5 animations:^{
        cell.frame = oldRect;
    }];
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    label.tag=1000+indexPath.row;
    label.textColor = [UIColor blackColor];
    label.text = @"核心代码只有以下几行核心代码只有以下几行核心代码只有以下几行核心代码只有以下几行核心代码只有以下几行核心代码只有以下几行";
    [cell.contentView addSubview:label];
//    cell.textLabel.text = [NSString stringWithFormat:@"--row-------->%d",indexPath.row];
    return cell;

}
//A->3->方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    [tableView deselectRowAtIndexPath:indexPath animated:true];
//    [tableView beginUpdates];
//    ROW--;//此操作表示减少数据源的个数。
//    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
//    [tableView endUpdates];
    
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel *label = [cell.contentView viewWithTag:1000+indexPath.row];
    [tableView beginUpdates];
    if (label.numberOfLines == 0) {
        label.numberOfLines = 1;
    }else{
        label.numberOfLines = 0;
    }
    [tableView endUpdates];
}



-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    for (UITableViewCell *cell in _tableView.visibleCells) {
        /**
         *  你可以在这里对当前的cell进行一些操作
         *
         */
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UILabel *label = [self.view viewWithTag:1000+indexPath.row];
    if (label.numberOfLines==1) {
        return 44;
    }
    return 44+60;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
