//
//  WButton.m
//  
//
//  Created by Zhibo Wang on 16/5/17.
//  Copyright © 2016年 Zhibo Wang. All rights reserved.
//

#import "WButton.h"

IB_DESIGNABLE
@implementation WButton


-(void)setCornerRadius:(CGFloat)cornerRadius{
    _cornerRadius  = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
}
-(void)setBorderColor:(UIColor *)borderColor{
    _borderColor = borderColor;
    self.layer.borderColor = borderColor.CGColor;
}

-(void)setBorderWidth:(CGFloat)borderWidth{
    _borderWidth = borderWidth;
    self.layer.borderWidth = borderWidth;
}

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    CGRect bounds = self.bounds;
    
    if (_hotZone == 0) {
        _hotZone = 44.0;
    }
    
    CGFloat widthDelta = MAX(_hotZone - bounds.size.width, 0);
    CGFloat heightDelta = MAX(_hotZone - bounds.size.height, 0);
    bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);
    
    return CGRectContainsPoint(bounds, point);
}


@end
