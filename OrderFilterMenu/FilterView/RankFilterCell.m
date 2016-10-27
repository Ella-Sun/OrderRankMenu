//
//  RankFilterCell.m
//  OrderFilterMenu
//
//  Created by sunhong on 2016/10/20.
//  Copyright © 2016年 sunhong Funds Management. All rights reserved.
//

#import "RankFilterCell.h"

#import "FilterButton.h"

@interface RankFilterCell ()

@property (nonatomic, strong) FilterButton * button;

@end

@implementation RankFilterCell

- (void)setStyle:(ButtonStatusStyle)style {
    _style = style;
    switch (style) {
        case ButtonStatusStyleDefault:{
            self.button.selected = NO;
            self.button.imageView.image = [UIImage imageNamed:@""];
        }
            break;
        case ButtonStatusStyleUp:{
            self.button.selected = YES;
            self.button.imageView.image = [UIImage imageNamed:@""];
        }
            break;
        case ButtonStatusStyleDown:{
            self.button.selected = YES;
            self.button.imageView.image = [UIImage imageNamed:@""];
        }
            break;
        case ButtonStatusStyleNonImage:{
            self.button.selected = NO;
            self.button.imageView.hidden = YES;
        }
            break;
        default:
            break;
    }
}

- (void)setBtnTitle:(NSString *)btnTitle {
    _btnTitle = btnTitle;
    [self.button setTitle:btnTitle forState:UIControlStateNormal];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView withIdenfier:(NSString *)identifier
{
    RankFilterCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[RankFilterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //添加点击每行cell的背景颜色
        UIView *view = [[UIView alloc] initWithFrame:self.bounds];
        view.backgroundColor = [UIColor colorWithRed:241/255.0 green:242/255.0 blue:246/255.0 alpha:1.000];
        self.selectedBackgroundView = view;
        
        [self setupDefaultViews];
        [self setNeedsLayout];
    }
    return self;
}

//创建按钮
- (void)setupDefaultViews
{
    FilterButton *button = [FilterButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor clearColor];
    button.titleLabel.font = [UIFont systemFontOfSize:14.f];
    
    [button setTitleColor:[UIColor colorWithWhite:0.498 alpha:1.000] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    
    [button setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    button.userInteractionEnabled = NO;
    
    self.button = button;
    
    _button.imageView.backgroundColor = [UIColor redColor];
    [self addSubview:_button];
}


#pragma mark - 计算label的宽度

- (CGFloat)getLabelWidthAccordLabel:(UILabel *)label
                     andLabelHeight:(CGFloat)height
                         andContent:(NSString *)text{
    
    NSDictionary *addressAttribute = @{NSFontAttributeName:label.font};
    CGFloat width = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                       options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                    attributes:addressAttribute
                                       context:nil].size.width;
    return width;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat leftSpace = 20.f;
    CGFloat labelHeight = 20.f;
    CGFloat labelY = (self.bounds.size.height - labelHeight) * 0.5;
    CGFloat labelWidth = [self getLabelWidthAccordLabel:_button.titleLabel
                                         andLabelHeight:labelHeight andContent:_button.titleLabel.text];
    CGFloat btnWidth = labelWidth + 30.f;
    CGRect btnFrame = CGRectMake(leftSpace, labelY, btnWidth, labelHeight);
    self.button.frame = btnFrame;
}

@end
