//
//  LimitFilterView.h
//  OrderFilterMenu
//
//  Created by sunhong on 2016/9/12.
//  Copyright © 2016年 sunhong. All rights reserved.
//

#import "LimitFilterView.h"

#import "FilterButton.h"
#import "NSDictionary+FilterFactorAnalyse.h"

#define viewHeight self.bounds.size.height
#define APP_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

#define didSelectColor [UIColor blueColor]
#define didNormalColor [UIColor blockColor]
#define arrowImage [UIImage imageNamed:@"icon_sort_arrow"]

static CGFloat aniDuration = 0.5f;

@interface LimitFilterView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray * filterAry;
@property (nonatomic, strong) NSArray * dateAry;
@property (nonatomic, strong) NSArray * moneyAry;
//承载俩个筛选按钮
@property (nonatomic, strong) UIView * filterView;
//日期筛选
@property (nonatomic, strong) FilterButton * dateButton;
//金额筛选
@property (nonatomic, strong) FilterButton * moneyButton;
//横线
@property (nonatomic, strong) UIView * lineView;
//展示筛选条件
@property (nonatomic, strong) UITableView * showTableView;
//遮罩视图
@property (nonatomic, strong) UIView * bMaskView;
//遮罩视图所在的父视图
@property (nonatomic, strong) UIView * upView;

@property (nonatomic, assign) NSInteger selectFilter;//之前选择的筛选条件

//default NO
@property (nonatomic, assign) BOOL isMoney;

@property (nonatomic, assign) NSInteger selectDate;//选择的日期
@property (nonatomic, assign) NSInteger selectMoney;//选择的金额

@end

@implementation LimitFilterView

- (void)filterViewDismiss {
    
    self.selectDate = -1;
    self.selectMoney = -1;
    
    [self allSubviewsToOrigin];
}

- (void)dismiss {
    
    __weak typeof(self)weakSelf = self;
    if (self.LimitFilterBlock) {
        NSLog(@"%ld---%ld",weakSelf.selectDate,weakSelf.selectMoney);
        self.LimitFilterBlock(weakSelf.selectDate, weakSelf.selectMoney);
    }
    
    [self allSubviewsToOrigin];
}

- (void)allSubviewsToOrigin {
    
    CGRect tabelFrame = self.showTableView.frame;
    tabelFrame.size.height = 1;
    [UIView animateWithDuration:aniDuration
                     animations:^{
                         
                         _showTableView.frame = tabelFrame;
                         _bMaskView.alpha = 0.2;
                     } completion:^(BOOL finished) {
                         
                         [self.showTableView removeFromSuperview];
                         self.showTableView = nil;
                         
                         [self.bMaskView removeFromSuperview];
                         self.bMaskView = nil;
                     }];
    
    self.dateButton.selected = NO;
    self.dateButton.imageView.transform = CGAffineTransformIdentity;
    self.moneyButton.selected = NO;//使按钮颜色改变
    self.moneyButton.imageView.transform = CGAffineTransformIdentity;
    
    self.selectFilter = -1;//否则再次出现下拉菜单 不能重建tableview
}

- (instancetype)initWithFrame:(CGRect)frame superView:(UIView *)view {
    
    self = [self initWithFrame:frame];
    self.upView = view;
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.dateAry = [NSDictionary alloc].dateAry;
        self.moneyAry = [NSDictionary alloc].moneyAry;
        
        self.selectDate = -1;
        self.selectMoney = -1;
        
//        self.filterAry = self.dateAry;
        
        [self setupFilterViews];
        
        [self setNeedsLayout];
    }
    return self;
}
/**
 *  创建默认视图
 */
- (void)setupFilterViews {
    //筛选行
    _filterView = [[UIView alloc] initWithFrame:CGRectZero];
    _filterView.backgroundColor = [UIColor whiteColor];
    //左侧
    _dateButton = [self generalCommonButton];
    _dateButton.tag = 180;
    //右侧
    _moneyButton = [self generalCommonButton];
    _moneyButton.tag = 181;
    [_moneyButton setTitle:@"金额" forState:UIControlStateNormal];
    //横线
    _lineView = [[UIView alloc] initWithFrame:CGRectZero];
    _lineView.backgroundColor = [UIColor colorWithWhite:0.902 alpha:1.000];
    
    [self addSubview:_filterView];
    
    [self.filterView addSubview:_dateButton];
    [self.filterView addSubview:_moneyButton];
    
    [self addSubview:_lineView];
}

//展开
- (void)foldFilterTableView {
    
    if (_bMaskView) {
        return;
    }
    CGFloat maxY = CGRectGetMaxY(self.frame);
    if (self.customeMaskYpixel > 0) {
        maxY = self.customeMaskYpixel;
    }
    
//    CGFloat viewWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat maxHeight = [UIScreen mainScreen].bounds.size.height - maxY;
    
    CGRect maskFrame = CGRectMake(0, maxY, APP_SCREEN_WIDTH, maxHeight);
    _bMaskView = [[UIView alloc] initWithFrame:maskFrame];
    _bMaskView.backgroundColor = [UIColor colorWithWhite:0.498 alpha:0.600];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [_bMaskView addGestureRecognizer:tap];
    
    if (self.upView) {
        
        [self.upView insertSubview:_bMaskView belowSubview:self];
    } else {
        NSLog(@"需要把遮罩视图安放在controller的view上");
        [self insertSubview:_bMaskView belowSubview:_showTableView];
    }
    
}

//生成tableview
- (void)generalTableView {
    
    if (_showTableView) {
        [_showTableView removeFromSuperview];
        _showTableView = nil;
    }
    CGFloat viewWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat maxY = CGRectGetMaxY(self.frame);
    if (self.customeMaskYpixel > 0) {
        maxY = self.customeMaskYpixel;
    }
    CGRect tableFrame = CGRectMake(0, maxY, viewWidth, 0);
    
    _showTableView = [[UITableView alloc] initWithFrame:tableFrame];
    _showTableView.backgroundColor = [UIColor whiteColor];
    _showTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _showTableView.dataSource = self;
    _showTableView.delegate = self;
    _showTableView.tableFooterView = [[UIView alloc] init];
    _showTableView.bounces = NO;
    
    tableFrame.size.height = self.filterAry.count * 44;
    [UIView animateWithDuration:aniDuration
                     animations:^{
                         _showTableView.frame = tableFrame;
                     }];
    
    [self.upView insertSubview:_showTableView belowSubview:self];
}

/**
 *  生成基础button
 *
 */
- (FilterButton *)generalCommonButton {
    
    FilterButton *button = [FilterButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor clearColor];
    [button setTitle:@"日期" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14.f];
    
    [button setTitleColor:[UIColor colorWithWhite:0.498 alpha:1.000] forState:UIControlStateNormal];
    [button setTitleColor:didSelectColor forState:UIControlStateSelected];
    [button addTarget:self action:@selector(tapFilterAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [button setImage:arrowImage forState:UIControlStateNormal];
    
    return button;
}

//点击不同筛选
- (void)tapFilterAction:(UIButton *)sender {
    
    [self foldFilterTableView];
    //取消排序按钮的点击被状态
    if (self.ClickButtonBlock) {
        self.ClickButtonBlock();
    }
    
    if (sender.tag == self.selectFilter) {
        [self dismiss];
        return;
    }
    
    [self rotateViewAnimated:sender.imageView
                withDuration:0.01
                     byAngle:M_PI];
    
    if (self.selectFilter > 0) {
        UIButton *button = [self.filterView viewWithTag:self.selectFilter];
        button.imageView.transform = CGAffineTransformIdentity;
        button.selected = NO;
    }
    
    sender.selected = !sender.selected;
    //更改数组  更改右侧小箭头
    NSInteger flag = sender.tag - 180;
    switch (flag) {
        case 0:{
            self.filterAry = self.dateAry;
            self.isMoney = NO;
        }
            break;
        case 1:{
            self.filterAry = self.moneyAry;
            self.isMoney = YES;
        }
            break;
        default:
            NSLog(@"赋值失败");
            break;
    }
    self.selectFilter = sender.tag;
    
    if (flag > 1) {
        if (_showTableView) {
            [_showTableView removeFromSuperview];
            _showTableView = nil;
        }
        return;
    }
    [self generalTableView];
    
}

/**
 *  让筛选小按钮旋转
 *
 *  @param view     需要旋转的按钮
 *  @param duration 时间隔
 *  @param angle    旋转角度
 */
- (void)rotateViewAnimated:(UIView*)view
              withDuration:(CFTimeInterval)duration
                   byAngle:(CGFloat)angle
{
    [CATransaction begin];
    CABasicAnimation *rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.byValue = [NSNumber numberWithFloat:angle];
    rotationAnimation.duration = duration;
    rotationAnimation.removedOnCompletion = YES;
    
    [CATransaction setCompletionBlock:^{
        view.transform = CGAffineTransformRotate(view.transform, angle);
    }];
    
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    [CATransaction commit];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filterAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"filter-cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:12.f];
    }
    cell.textLabel.text = self.filterAry[indexPath.row];
    
    if (_isMoney && self.selectMoney >= 0) {
        if (indexPath.row == self.selectMoney) {
            cell.textLabel.textColor = didSelectColor;
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    if (!_isMoney && self.selectDate >= 0) {
        if (indexPath.row == self.selectDate) {
            cell.textLabel.textColor = didSelectColor;
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    
    return cell;
}

#pragma mark - layoutSubviews

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat viewWidth = self.bounds.size.width;
    
    CGFloat btnWidth = 80.f;
    //筛选行
    CGRect filterFrame = CGRectMake(0, 0, viewWidth, viewHeight);
    CGRect dateFrame = CGRectMake(0, 0, btnWidth, viewHeight);
    CGRect moneyFrame = CGRectMake(0, 0, btnWidth, viewHeight);
    
    CGFloat filterY = viewHeight * 0.5;
    CGFloat dateX = viewWidth * 0.5 * 0.5;
    CGFloat moneyX = viewWidth - dateX;
    
    CGPoint dateCenter = CGPointMake(dateX, filterY);
    CGPoint moneyCnter = CGPointMake(moneyX, filterY);
    
    //下方详情
    CGFloat lineX = self.bounds.size.width - self.upView.bounds.size.width;
    CGRect lineFrame = CGRectMake(lineX, viewHeight-1, self.upView.bounds.size.width, 1);
    
    self.filterView.frame = filterFrame;
    
    self.dateButton.frame = dateFrame;
    self.dateButton.center = dateCenter;
    
    self.moneyButton.frame = moneyFrame;
    self.moneyButton.center = moneyCnter;
    
    self.lineView.frame = lineFrame;
}

#pragma mark - UITableViewDelegaate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger beforeSelect = -1;
    if (!_isMoney) {
        if (indexPath.row != self.selectDate) {
            beforeSelect = self.selectDate;
        }
    } else {
        if (indexPath.row != self.selectMoney) {
            beforeSelect = self.selectMoney;
        }
    }
    if (beforeSelect >= 0) {
        NSIndexPath *beforePath = [NSIndexPath indexPathForRow:beforeSelect inSection:0];
        UITableViewCell *beforeCell = [tableView cellForRowAtIndexPath:beforePath];
        beforeCell.textLabel.textColor = [UIColor blackColor];
        beforeCell.accessoryType = UITableViewCellAccessoryNone;
        
    }
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = didSelectColor;
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    if (!_isMoney) {
        self.selectDate = indexPath.row;
    } else {
        self.selectMoney = indexPath.row;
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.accessoryType = UITableViewCellAccessoryNone;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 30, 0, 30)];
    }
    // 内容左右各留出30间隙
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 30, 0, 30)];
    }
}

@end
