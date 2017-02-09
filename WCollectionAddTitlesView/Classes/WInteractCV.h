//
//  WInteractCV.h
//  
//
//  Created by Zhibo Wang on 2016/12/29.
//  Copyright © 2016年 Zhibo Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WInteractMacro.h"

@class WTitleScrollView;
@interface WInteractCV : UICollectionView

@property(nonatomic, strong)WTitleScrollView *combinedTitleView;

@property(nonatomic, assign)NSInteger currentIndex; //起始位置

// 滚动触发类型 负:表示手指滑动 其他:表示点击标题
@property(nonatomic, assign)NSInteger triggerType;
@property(nonatomic, copy)void(^turnedPageBlock)(NSUInteger index);
@property(nonatomic, copy)void(^shouldAddContentBlock)(NSUInteger index);


-(instancetype)initWithFrame:(CGRect)frame;



// 向指定索引添加内容视图
-(void)addContent:(UIView *)content toIndex:(NSUInteger)index;
-(UIView *)contentAtIndex:(NSUInteger)index;

-(void)scrollDidCompleted;

@end
