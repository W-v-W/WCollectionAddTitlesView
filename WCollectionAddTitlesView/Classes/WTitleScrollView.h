//
//  WTitleScrollView.h
//  
//
//  Created by Zhibo Wang on 2016/12/29.
//  Copyright © 2016年 Zhibo Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WInteractCV, WButton;
@interface WTitleScrollView : UIScrollView

@property(nonatomic, strong)UIColor *highlightColor;
@property(nonatomic, strong)UIColor *normalColor;
@property(nonatomic, strong)UIFont *titleFont;

@property(nonatomic, assign, readonly)CGFloat leftMargin;     // 左边距
@property(nonatomic, assign, readonly)CGFloat rightMargin;    // 右边距
@property(nonatomic, assign, readonly)CGFloat centerMargin;   // 中间距

@property(nonatomic, strong, readonly)NSArray<WButton *> *btnArr;
@property(nonatomic, strong, readonly)UIView *underlineView;
@property(nonatomic, strong, readonly)NSArray<NSDictionary *> *titles;

@property(nonatomic, strong)WButton *selectedButton;

@property(nonatomic, weak) WInteractCV *interactCV;


-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray<NSDictionary *> *)titles;

// 对应索引处的指示线大小
-(CGRect)lineFrameForTitleAtIndex:(NSUInteger)index;
-(CGPoint)offsetChangeForIndex:(NSUInteger)index;

-(void)setMarginsLeft:(CGFloat)leftMargin center:(CGFloat)centerMargin right:(CGFloat)rightMargin;

@end
