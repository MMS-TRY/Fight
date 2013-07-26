//
//  FloatStatusView.m
//  Fight
//
//  Created by Takashi MORIZANE on 2013/05/28.
//  Copyright (c) 2013年 PAVCMMS. All rights reserved.
//

#import "FloatStatusView.h"
#import <QuartzCore/QuartzCore.h>

@interface FloatStatusView()
@property (nonatomic, strong) CALayer *statusLayer;
@end

@implementation FloatStatusView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
      self.backgroundColor = [UIColor redColor];
      self.alpha = 0.7;
      _statusLayer = [CALayer layer];
      _statusLayer.backgroundColor = [[UIColor blueColor] CGColor];
      _statusLayer.borderWidth = 1.0f;
      _statusLayer.borderColor = [[UIColor whiteColor] CGColor];
      _statusLayer.anchorPoint = CGPointMake(0, 0);
      _statusLayer.frame = self.bounds;
      [self.layer addSublayer:_statusLayer];
      [self addObserver:self forKeyPath:@"maxHp" options:NSKeyValueObservingOptionNew context:NULL];
      [self addObserver:self forKeyPath:@"hp" options:NSKeyValueObservingOptionNew context:NULL];
    }
    return self;
}

- (CGRect)calFrameRectWithMaxHp:(CGFloat)maxHp curHp:(CGFloat)curHp
{
  CGFloat width = CGRectGetWidth(self.bounds);
  if(maxHp > 0.0 && curHp <= maxHp) {
    CGFloat ratio = (curHp / maxHp);
    width *= ratio;
    CGRect bound = self.bounds;
    bound.size.width = width;
    
    return bound;
  }
  return CGRectZero;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
  if([keyPath isEqualToString:@"hp"]) {
    CGFloat newVal = [[change objectForKey:NSKeyValueChangeNewKey] floatValue];
    if(self.maxHp > 0.0 && newVal <= self.maxHp) {
      self.statusLayer.frame = [self calFrameRectWithMaxHp:self.maxHp curHp:newVal];
    }
  } else if([keyPath isEqualToString:@"maxHp"]) {
    CGFloat newVal = [[change objectForKey:NSKeyValueChangeNewKey] floatValue];
    if(newVal > 0.0 && self.hp <= newVal) {
      self.statusLayer.frame = [self calFrameRectWithMaxHp:newVal curHp:self.hp];
    }
  }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
  if(flag) {
    self.statusLayer.frame = [self calFrameRectWithMaxHp:self.maxHp curHp:self.hp];
  }
}

- (void)damage:(CGFloat)val;
{
  _hp -= val;
  if(_hp < 0.0) {
    _hp = 0.0;
  }
  CGRect frame = [self calFrameRectWithMaxHp:self.maxHp curHp:self.hp];
  
  CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"bounds"];
  animation.delegate = self;
  animation.fromValue = [NSValue valueWithCGRect:self.statusLayer.bounds];
  animation.toValue = [NSValue valueWithCGRect:frame];
  animation.duration = 1.0f;
  animation.removedOnCompletion = NO;
  animation.fillMode = kCAFillModeForwards;
  [self.statusLayer addAnimation:animation forKey:@"bounds"];
  
//  self.statusLayer.frame = frame;
}

- (void)dealloc
{
  [self removeObserver:self forKeyPath:@"hp"];
  [self removeObserver:self forKeyPath:@"maxHp"];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
