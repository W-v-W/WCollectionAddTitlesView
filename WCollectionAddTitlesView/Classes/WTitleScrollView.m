//
//  WTitleScrollView.m
//  
//
//  Created by Zhibo Wang on 2016/12/29.
//  Copyright © 2016年 Zhibo Wang. All rights reserved.
//

#import "WTitleScrollView.h"
#import "WInteractCV.h"
#import "WButton.h"

#define underline_more_than_part 8.0
#define underline_height 1.5

#define little_change 12.0

@interface WTitleScrollView ()

@end

@implementation WTitleScrollView

#pragma mark - getter

-(UIColor *)highlightColor{
    if (!_highlightColor) {
        _highlightColor =  [UIColor redColor];
    }
    return _highlightColor;
}
-(UIColor *)normalColor{
    if (!_normalColor) {
        _normalColor = [UIColor blackColor];
    }
    return _normalColor;
}
-(UIFont *)titleFont{
    if (!_titleFont) {
        _titleFont = [UIFont systemFontOfSize:15];
    }
    return _titleFont;
}
-(CGFloat)leftMargin{
    if (_leftMargin == 0) {
        _leftMargin = 16.0;
    }
    return _leftMargin;
}
-(CGFloat)rightMargin{
    if (_rightMargin == 0) {
        _rightMargin = 16.0;
    }
    return _rightMargin;
}
-(CGFloat)centerMargin{
    if (_centerMargin == 0) {
        _centerMargin = 40;
    }
    return _centerMargin;
}

#pragma mark - setter
-(void)setSelectedButton:(UIButton *)selectedButton{
    [self.selectedButton setTitleColor:self.normalColor forState:UIControlStateNormal];
    _selectedButton = selectedButton;
    [self.selectedButton setTitleColor:self.highlightColor forState:UIControlStateNormal];
}

#pragma mark - initalizer


-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray<NSDictionary *> *)titles{
    
    if (self = [super initWithFrame:frame]) {
        self.titles = titles;
        UIFont *font = self.titleFont;
        
        CGFloat startX = self.leftMargin;
        NSMutableArray *btns = [NSMutableArray array];
        
        for (int i = 0; i < titles.count; i++) {
            
            NSString *title = titles[i][@"name"];
           
            CGSize size = [title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 0) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:self.titleFont} context:nil].size;
            
            WButton *btn = [WButton buttonWithType:UIButtonTypeCustom];
            btn.bounds = CGRectMake(0, 0, size.width, size.height);
            btn.center = CGPointMake(startX + size.width/2, self.frame.size.height/2);
            startX += size.width + self.centerMargin;
            
            [btn setTitle:title forState:UIControlStateNormal];
            btn.titleLabel.font = font;
            [btn setTitleColor:self.normalColor forState:UIControlStateNormal];
            
            [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
            
            [self addSubview:btn];
            [btns addObject:btn];
        }
        self.btnArr = btns;
        
        //设置content size
        self.contentSize = CGSizeMake(startX + self.rightMargin - self.centerMargin, self.frame.size.height);
        
        //居中显示的情况
        if (self.contentSize.width < frame.size.width) {
            self.contentOffset = CGPointMake(-(self.frame.size.width-self.contentSize.width)/2, 0);
        }
        
        //隐藏水平滚动条
        self.showsHorizontalScrollIndicator = NO;
        
        // 添加指示线
        if (!self.underlineView) {
            self.underlineView = [[UIView alloc]initWithFrame:[self lineFrameForTitleAtIndex:0]];
            self.underlineView.backgroundColor = self.highlightColor;
        }
        [self addSubview:self.underlineView];
        
        
        self.selectedButton = self.btnArr.firstObject;
        
    }
    return self;
}

#pragma mark -

-(CGRect)lineFrameForTitleAtIndex:(NSUInteger)index{
    CGRect frame = self.btnArr[index].frame;
    CGFloat x = frame.origin.x - underline_more_than_part;
    CGFloat y = self.frame.size.height - underline_height;
    CGFloat w = frame.size.width + 2 * underline_more_than_part;
    return CGRectMake(x, y, w, underline_height);
}

// 计算相应索引的合适偏移量
-(CGPoint)offsetChangeForIndex:(NSUInteger)index{
    if (self.contentSize.width < self.frame.size.width) {
        return self.contentOffset;
    }
    if (0 == index) {
        return CGPointZero;
    }else{
        CGRect currentFrame = self.btnArr[index].frame;
        CGRect leftFrame = self.btnArr[index -1].frame;
        CGFloat offsetX = currentFrame.origin.x - leftFrame.size.width - self.centerMargin - little_change;
        if (offsetX > self.contentSize.width - self.frame.size.width) {
            offsetX = self.contentSize.width - self.frame.size.width;
        }
        
        return CGPointMake(offsetX, 0);
    }
    
}


#pragma mark -

-(void)click:(id)sender{
    NSInteger index = [self.btnArr indexOfObject:sender];
    NSLog(@"click title at :%@", @(index));
    self.interactCV.triggerType = index;
    [self.interactCV scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];

}

@end
