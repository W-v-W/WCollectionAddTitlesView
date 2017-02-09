//
//  WTitleScrollView.h
//  
//
//  Created by Zhibo Wang on 2016/12/29.
//  Copyright © 2016年 Zhibo Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WInteractCV;
@interface WTitleScrollView : UIScrollView

@property(nonatomic, strong)UIColor *highlightColor;
@property(nonatomic, strong)UIColor *normalColor;
@property(nonatomic, strong)UIFont *titleFont;
@property(nonatomic, assign)CGFloat leftMargin;     // 左边距
@property(nonatomic, assign)CGFloat rightMargin;    // 右边距
@property(nonatomic, assign)CGFloat centerMargin;   // 中间距

@property(nonatomic, strong)NSArray<UIButton *> *btnArr;
@property(nonatomic, strong)UIView *underlineView;
@property(nonatomic, strong)UIButton *selectedButton;


@property(nonatomic, weak) WInteractCV *interactCV;

@property(nonatomic, strong)NSArray<NSDictionary *> *titles;

-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray<NSDictionary *> *)titles;

// 对应索引处的指示线大小
-(CGRect)lineFrameForTitleAtIndex:(NSUInteger)index;
-(CGPoint)offsetChangeForIndex:(NSUInteger)index;



@end
