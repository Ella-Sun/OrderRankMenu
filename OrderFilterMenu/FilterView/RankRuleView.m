//
//  RankRuleView.m
//  OrderFilterMenu
//
//  Created by sunhong on 2016/10/19.
//  Copyright © 2016年 sunhong Funds Management. All rights reserved.
//

#import "RankRuleView.h"

#import "LimitFilterView.h"
#import "FilterButton.h"
#import "RankFilterCell.h"

#define RANKHEIGHT 44.f
#define arrowImage [UIImage imageNamed:@"icon_sort_arrow"]

static CGFloat aniDuration = 0.5f;

@interface RankRuleView ()<UITableViewDataSource, UITableViewDelegate>

//排序
@property (nonatomic, strong) FilterButton * rankButton;
//竖线
@property (nonatomic, strong) UIView * vLineView;
//筛选
@property (nonatomic, strong) LimitFilterView * filterView;
//展示默认排序
@property (nonatomic, strong) UITableView * defTableView;

@property (nonatomic, strong) UIView * upView;

@property (nonatomic, strong) NSArray * rankRules;

@property (nonatomic, copy) NSString * selectRankStr;//选择的排序条件
@property (nonatomic, assign) NSInteger selectRankIndex;//选择的排序行数

@property (nonatomic, assign) NSInteger moneyCount;//金额点击的次数
@property (nonatomic, assign) NSInteger dateCount;//日期点击的次数

@end

@implementation RankRuleView

- (instancetype)initWithFrame:(CGRect)frame superView:(UIView *)view
{
    self.upView = view;
    return [self initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.rankRules = @[@"默认排序",@"金额",@"日期"];
        
        self.selectRankIndex = 0;
        
        [self setupDefaultViews];
        [self setNeedsLayout];
    }
    return self;
}


/**
 创建默认视图
 */
- (void)setupDefaultViews {
    
    //排序
    _rankButton = [self generalCommonButton];
    _rankButton.tag = 351;
    [self addSubview:_rankButton];
    
    //竖线
    _vLineView = [[UIView alloc] initWithFrame:CGRectZero];
    _vLineView.backgroundColor = [UIColor lightGrayColor];//MidPieViewBackgroundColor;
    [self addSubview:_vLineView];
    
    //筛选
    _filterView = [[LimitFilterView alloc] initWithFrame:CGRectZero superView:self.upView];
    [self addSubview:_filterView];
    
    CGFloat filterY = CGRectGetMaxY(self.frame);
    _filterView.customeMaskYpixel = filterY;
    
    __weak typeof(self)weakSelf = self;
    //点击筛选按钮
    _filterView.ClickButtonBlock = ^(){
        if (weakSelf.rankButton.selected) {
            weakSelf.rankButton.selected = NO;
            [weakSelf dismiss];
        }
    };
    //遮罩视图消失——>传值 取消点击状态 tableview消失
    _filterView.LimitFilterBlock = ^(NSInteger moneyIndex, NSInteger dateIndex){
        if (weakSelf.FilterBlock) {
            weakSelf.FilterBlock(weakSelf.selectRankStr,moneyIndex,dateIndex);
            if (weakSelf.rankButton.selected) {
                weakSelf.rankButton.selected = NO;
                [weakSelf dismiss];
            }
        }
    };
}

- (void)dismiss {
    
    CGRect tabelFrame = self.defTableView.frame;
    tabelFrame.size.height = 1;
    [UIView animateWithDuration:aniDuration
                     animations:^{
                         
                         _defTableView.frame = tabelFrame;
                     } completion:^(BOOL finished) {
                         
                         [self.defTableView removeFromSuperview];
                         self.defTableView = nil;
                     }];
    
    self.rankButton.selected = NO;
    self.rankButton.imageView.transform = CGAffineTransformIdentity;
}

//生成tableview
- (void)setupTabelView {
    
    if (_defTableView) {
        return;
    }
    CGFloat viewWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat maxY = CGRectGetMaxY(self.frame);
    CGRect tableFrame = CGRectMake(0, maxY, viewWidth, 0);
    
    _defTableView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
    _defTableView.tableFooterView = [[UIView alloc] init];
    _defTableView.backgroundColor = [UIColor clearColor];
    _defTableView.separatorColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    _defTableView.dataSource = self;
    _defTableView.delegate = self;
    _defTableView.bounces = NO;
    
    tableFrame.size.height = self.rankRules.count * 44;
    [UIView animateWithDuration:aniDuration
                     animations:^{
                         _defTableView.frame = tableFrame;
                     }];
    
    [self.upView addSubview:_defTableView];
}

/**
 *  生成基础button
 *
 */
- (FilterButton *)generalCommonButton {
    
    FilterButton *button = [FilterButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor clearColor];
    [button setTitle:@"默认排序" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14.f];
    
    [button setTitleColor:[UIColor colorWithWhite:0.498 alpha:1.000] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(tapFilterAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [button setImage:arrowImage forState:UIControlStateNormal];
    
    return button;
}

//点击排序  如果先点击筛选 后点击排序 排序的按钮怎么办
- (void)tapFilterAction:(UIButton *)sender
{
//    if (sender.selected) {
//        return;
//    }
    //产生遮罩视图    使之前点击的筛选按钮恢复 本按钮selected = yes
    [self.filterView tapFilterAction:sender];

    [self setupTabelView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat viewWidth = self.bounds.size.width;
    CGFloat viewHeight = self.bounds.size.height;
    CGFloat btnWidth = 100.f;
    
    CGFloat vLineX = viewWidth / 3.0;
    CGFloat vLineHeight = viewHeight * 0.7;
    CGFloat vLineY = (viewHeight - vLineHeight) * 0.5;
    CGRect vLineFrame = CGRectMake(vLineX, vLineY, 0.5f, vLineHeight);
    
    CGFloat btnX = (vLineX - btnWidth) * 0.5;
    CGRect btnFrame = CGRectMake(btnX, 0, btnWidth, viewHeight);
    
    CGRect filterFrame = CGRectMake(vLineX+1, 0, viewWidth*2/3, viewHeight);
    
    self.rankButton.frame = btnFrame;
    self.vLineView.frame = vLineFrame;
    self.filterView.frame = filterFrame;
    
    CGFloat filterY = CGRectGetMaxY(self.frame);
    _filterView.customeMaskYpixel = filterY;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.rankRules.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"rankCell";
    
    RankFilterCell *cell = [RankFilterCell cellWithTableView:tableView withIdenfier:identifier];
    
    NSString *titleStr = self.rankRules[indexPath.row];
    cell.btnTitle = titleStr;
    if (indexPath.row == 0) {
        cell.style = ButtonStatusStyleNonImage;
    } else {
        cell.style = ButtonStatusStyleDefault;
    }
    
    if (indexPath.row == self.selectRankIndex) {
        cell.style = ButtonStatusStyleUp;
    }
    
    return cell;
}

//点击单元行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger selectIndex = indexPath.row;
    BOOL isSameCell;
    RankFilterCell *currentCell, *beforeCell;

    currentCell = (RankFilterCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if (selectIndex == self.selectRankIndex) {
        isSameCell = YES;
    }
    if (!isSameCell && self.selectRankIndex>= 0) {
        NSString *beforeStr = self.rankRules[self.selectRankIndex];
        NSIndexPath *beforePath = [NSIndexPath indexPathForRow:self.selectRankIndex inSection:0];
        beforeCell = (RankFilterCell *)[tableView cellForRowAtIndexPath:beforePath];
        
        beforeCell.style = ButtonStatusStyleDefault;
        beforeCell.btnTitle = beforeStr;
    }
    
    NSString *addStr = @"";
    switch (selectIndex) {
        case 0:{
            currentCell.style = ButtonStatusStyleUp;
        }
            break;
        case 1:{
            self.moneyCount++;
            self.dateCount = 0;
            if (self.moneyCount%2) {//奇数次
                currentCell.style = ButtonStatusStyleUp;
                addStr = @"↑";
            } else {//偶数次
                currentCell.style = ButtonStatusStyleDown;
                addStr = @"↓";
            }
        }
            break;
        case 2:{
            self.dateCount++;
            self.moneyCount = 0;
            if (self.dateCount%2) {//奇数次
                currentCell.style = ButtonStatusStyleUp;
                addStr = @"↑";
            } else {//偶数次
                currentCell.style = ButtonStatusStyleDown;
                addStr = @"↓";
            }
        }
            break;
            
        default:
            break;
    }
    
    NSString *rankTitleStr = self.rankRules[selectIndex];
    NSString *rankFlagStr = [NSString stringWithFormat:@"%@ %@",rankTitleStr,addStr];
    currentCell.btnTitle = rankFlagStr;
    
    [self.rankButton setTitle:rankFlagStr forState:UIControlStateNormal];
    self.selectRankIndex = selectIndex;
}


@end
