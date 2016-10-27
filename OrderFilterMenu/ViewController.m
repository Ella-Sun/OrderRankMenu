//
//  ViewController.m
//  OrderFilterMenu
//
//  Created by sunhong on 2016/10/27.
//  Copyright © 2016年 sunhong. All rights reserved.
//

#import "ViewController.h"

#import "NSDictionary+FilterFactorAnalyse.h"

//方案二 示例添加排序
#import "RankRuleView.h"

//方案一
#import "LimitFilterView.h"

@interface ViewController ()

@property (nonatomic, strong) RankRuleView * filterView;

@property (nonatomic, strong) LimitFilterView * limitView;

//筛选条件
@property (nonatomic, copy) NSString * rankStr;
@property (nonatomic, strong) NSDictionary * moneyDic;
@property (nonatomic, strong) NSDictionary * dateDic;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    
    [self setupOriginView];
//    [self setupMainView];
}

- (void)setupOriginView {
    //筛选
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGRect filterFrame = CGRectMake(0, 64.f, width, 44.f);
    
    _limitView = [[LimitFilterView alloc] initWithFrame:filterFrame superView:self.view];
    [self.view addSubview:_limitView];
    
    __weak typeof(self)weakSelf = self;
    //遮罩视图消失——>传值 取消点击状态 tableview消失
    _limitView.LimitFilterBlock = ^(NSInteger moneyIndex, NSInteger dateIndex){

        weakSelf.moneyDic = [[NSDictionary alloc] accordMoneyTypeGetBeginAndEndMoney:moneyIndex];
        weakSelf.dateDic = [[NSDictionary alloc] accordDateTypeGetBeginAndEndDate:dateIndex];
    };

}

//创建列表视图
- (void)setupMainView {
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGRect filterFrame = CGRectMake(0, 150.f, width, 44.f);
    _filterView = [[RankRuleView alloc]initWithFrame:filterFrame superView:self.view];
    [self.view addSubview:_filterView];
    
    __weak typeof(self)weakSelf = self;
    _filterView.FilterBlock = ^(NSString *rankStr,NSInteger moneyIndex, NSInteger dateIndex){
        NSLog(@"rankStr=%@,moneyIndex=%ld,dateIndex=%ld",rankStr,moneyIndex,dateIndex);
        weakSelf.rankStr = rankStr;
        weakSelf.moneyDic = [[NSDictionary alloc] accordMoneyTypeGetBeginAndEndMoney:moneyIndex];
        weakSelf.dateDic = [[NSDictionary alloc] accordDateTypeGetBeginAndEndDate:dateIndex];
    };
}


@end
