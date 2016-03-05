//
//  ForceView.m
//  3D_TouchTest
//
//  Created by Walden on 16/3/5.
//  Copyright © 2016年 Walden. All rights reserved.
//

#import "ForceView.h"

@interface ForceView ()

@property (nonatomic, strong) UIBezierPath *path;

@end

@implementation ForceView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    [[UIColor greenColor] set];
    
    [self.path fill];
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    NSLog(@"touch force = %f", touch.force);
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path addArcWithCenter:[touch locationInView:self] radius:touch.force*15 startAngle:0 endAngle:2*M_PI clockwise:YES];
    self.path = path;
    
    [self setNeedsDisplay];
}


@end
