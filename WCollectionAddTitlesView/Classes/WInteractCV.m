//
//  WInteractCV.m
//  
//
//  Created by Zhibo Wang on 2016/12/29.
//  Copyright © 2016年 Zhibo Wang. All rights reserved.
//

#import "WInteractCV.h"
#import "WTitleScrollView.h"


@interface WInteractCV ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property(nonatomic, strong)NSArray<UIView *> *bgArr;

@end

@implementation WInteractCV


-(instancetype)initWithFrame:(CGRect)frame{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = frame.size;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    return [self initWithFrame:frame collectionViewLayout:layout];
}

-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        self.delegate = self;
        self.dataSource = self;
        self.pagingEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        self.triggerType = -1;
        self.backgroundColor = w_rgbaColor(245, 245, 245, 1);
    }
    return self;
}

-(void)setCombinedTitleView:(WTitleScrollView *)combinedTitleView{
    _combinedTitleView = combinedTitleView;
    _combinedTitleView.interactCV = self;
    
    NSMutableArray *tmpArr = [NSMutableArray array];
    for (int i = 0; i < self.combinedTitleView.titles.count; i++) {
        UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        v.tag = 1000;
        [tmpArr addObject:v];
    }
    self.bgArr = tmpArr;
    
    [self reloadData];
}


#pragma mark -

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.combinedTitleView.titles.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    UIView *bgView = [cell.contentView viewWithTag:1000];
    if (!bgView) {
        [cell.contentView addSubview:self.bgArr[indexPath.item]];
        if (self.shouldAddContentBlock) {
            self.shouldAddContentBlock(indexPath.item);
        }
    }else{
        if (bgView != self.bgArr[indexPath.item]) {
            [bgView removeFromSuperview];
            UIView *bg = self.bgArr[indexPath.item];
            if (bg.subviews.count == 0) {   //如果没有内容，则需添加
                if (self.shouldAddContentBlock) {
                    self.shouldAddContentBlock(indexPath.item);
                }
            }
            [cell.contentView addSubview:bg];
        }
    }
    
    return cell;
}


#pragma mark - 


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [self scrollDidCompleted];
    
}// called when scroll view grinds to a halt


//scroll view 翻页完成后执行的方法， 修改title的颜色，
-(void)scrollDidCompleted{
    
    self.currentIndex = self.contentOffset.x/self.frame.size.width; //翻页完成后， 记录当前索引值
    NSInteger currentIndex =  self.currentIndex;
    
//    NSIndexPath *indexPath = self.indexPathsForVisibleItems.firstObject;
//    NSLog(@"visible:%d", indexPath.item);
    
    //改变title颜色
    self.combinedTitleView.selectedButton = self.combinedTitleView.btnArr[currentIndex];
    
    
    if (self.turnedPageBlock) {
        
        self.turnedPageBlock(currentIndex);
    }
    
}



/*
 
 内容视图的滚动 会引起 title视图偏移量及 指示线frame的相应改变
 
 // *******<快速连续滑动时，不会触发 DidEndDecelerating 方法, 造成异常>****** 此异常已解决√
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
    
    CGFloat offsetX = scrollView.contentOffset.x;
//    NSLog(@"%.2f", offsetX);
    
    if (offsetX < 0 || offsetX > (scrollView.contentSize.width - self.frame.size.width)) {
        return;
    }
    //************************************************************************************
    //解决连续滑动时， 因无法触发Did End Decelerating方法，而无法更新当前索引造成的程序行为异常[--
    CGFloat offsetDistance = offsetX - self.currentIndex * self.frame.size.width;
    if (offsetDistance > self.frame.size.width  ) {       //连续向右滑动，且超一个content scroll view宽度
        self.currentIndex ++;                       //则当前索引值自增1
    }
    if (-offsetDistance > self.frame.size.width) {      //连续向左滑动， 且超过一个屏幕宽度
        self.currentIndex --;                       //则当前索引值自减1
    }//-]
    //************************************************************************************
    
    
    WTitleScrollView *titleView = self.combinedTitleView;
    
    
    CGRect originalLineFrame = [titleView lineFrameForTitleAtIndex:self.currentIndex];          //红线起始frame
//    NSLog(@"指示线起始位置 x:%.2f，w:%.2f", originalLineFrame.origin.x,originalLineFrame.size.width);
    CGRect finalLineFrame = {};                                                                 //指示线最终frame
    
    CGPoint originalTitleOffset = [titleView offsetChangeForIndex:self.currentIndex];            //title视图起始偏移量
    CGPoint finalTitleOffset = {};                                                               //title视图最终偏移量
    
    CGFloat  originalNewsOffsetX = self.currentIndex * self.frame.size.width;                //新闻视图， 起始偏移量
    
    CGFloat rate = 0;
    if (self.triggerType < 0) {
        rate = (offsetX-originalNewsOffsetX)/scrollView.frame.size.width;//手指翻页时 变化完成比率
    }else{
        //点击引起的翻页， 变化完成率
        if (self.triggerType == self.currentIndex) {  //
            return;
        }
        rate = (offsetX-originalNewsOffsetX)/(scrollView.frame.size.width * (self.triggerType - self.currentIndex));
    }
    
    if (rate < 0) {
        rate = rate * -1;
    }
    
    NSInteger finalIndex = 0;                           //目的地索引
    
    
    if (offsetX < originalNewsOffsetX) {                //向右滑动   , 指示线 向左移动
        
        
        if (self.triggerType < 0) {                       // 由手指滑动引起的滚动
            finalIndex = self.currentIndex - 1;
        }else{                                          // 由点击引起的滚动
            finalIndex = self.triggerType;
        }
        finalLineFrame = [titleView lineFrameForTitleAtIndex:(finalIndex)];
        finalTitleOffset = [titleView offsetChangeForIndex:(finalIndex)];
        
    } else if(offsetX > originalNewsOffsetX){           //向左滑动, 指示线 向右移动   （相等时， 执行会造成越界）
        
        if (self.triggerType < 0) {                       // 由手指滑动引起的滚动
            finalIndex = self.currentIndex + 1;
        }else{                                          // 由点击引起的滚动
            finalIndex = self.triggerType;
        }
        finalLineFrame = [titleView lineFrameForTitleAtIndex:(finalIndex)];
        finalTitleOffset = [titleView offsetChangeForIndex:(finalIndex)];
        
    }else{
        return;
    }
    if (finalIndex == self.currentIndex) {
        return;                             //避免， 在计算变化完成比率时除零
    }
    
    
    CGFloat changedWidth = finalLineFrame.size.width - originalLineFrame.size.width;               //指示线改变的宽度
    CGFloat changedX = finalLineFrame.origin.x - originalLineFrame.origin.x;                       //指示线 x轴位置的改变
    
    CGFloat changedOffsetX = finalTitleOffset.x - originalTitleOffset.x;                              //title整体 要改变的x轴偏移量
    
    titleView.underlineView.frame = CGRectMake(originalLineFrame.origin.x + changedX * rate, originalLineFrame.origin.y, originalLineFrame.size.width + changedWidth * rate, originalLineFrame.size.height);
    
    
    titleView.contentOffset = CGPointMake(originalTitleOffset.x + changedOffsetX * rate, 0);     //title整体偏移量的变化

}// any offset changes


-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    self.triggerType = -1;
    [self scrollDidCompleted];      //
}

#pragma mark - 

-(void)addContent:(UIView *)content toIndex:(NSUInteger)index{
    if (self.bgArr.count < index+1 || !content) {
        return;
    }
    UIView *bgView = self.bgArr[index];
    NSArray *subviews = bgView.subviews;
    for (UIView *v in subviews) {
        [v removeFromSuperview];
    }
    [bgView addSubview:content];
}

-(UIView *)contentAtIndex:(NSUInteger)index{
    NSAssert(self.bgArr.count != 0, @"还未初始化背景视图,请先联接 WTitleScrollView");
    
    NSArray *subviews = self.bgArr[index].subviews;
    return subviews.firstObject;
}


@end
