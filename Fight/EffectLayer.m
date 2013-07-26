//
//  EffectLayer.m
//  Fight
//
//  Created by Takashi MORIZANE on 2013/05/28.
//  Copyright (c) 2013年 PAVCMMS. All rights reserved.
//

#import "EffectLayer.h"
#import <QuartzCore/QuartzCore.h>

@interface EffectLayer()
@property (nonatomic, strong) CAEmitterLayer *emitLayer;

@end

@implementation EffectLayer

- (void)setupLayer
{
  _emitLayer = (CAEmitterLayer *)self.layer;
  self.emitLayer.emitterPosition = CGPointZero;
  self.emitLayer.emitterSize = CGSizeMake(10, 10);
  self.emitLayer.renderMode = kCAEmitterLayerAdditive;
  [self addEmitCell];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if(self) {
    [self setupLayer];
  }
  return self;
}

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    [self setupLayer];
  }
  return self;
}

+ (Class) layerClass //3
{
  //configure the UIView to have emitter layer
  return [CAEmitterLayer class];
}

- (void)setPosition:(CGPoint)pos
{
  self.emitLayer.emitterPosition = pos;
}

- (void)active:(BOOL)active
{
  [self.emitLayer setValue:[NSNumber numberWithInt:active?120:0]
             forKeyPath:@"emitterCells.fire.birthRate"];
}

- (void)fireAtPos:(CGPoint)pos duration:(NSTimeInterval)duration
{
  [self setPosition:pos];
  [self active:YES];
  double delayInSeconds = duration;
  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
  dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    [self active:NO];
    if([self.delegate respondsToSelector:@selector(didFinishEffectAnimation)]) {
      [self.delegate didFinishEffectAnimation];
    }
  });
}

- (void)addEmitCell
{
  CAEmitterCell* fire = [CAEmitterCell emitterCell];
  fire.birthRate = 0;
  fire.lifetime = 0.5;
  fire.lifetimeRange = 0.2;
  fire.color = [[UIColor colorWithRed:0.8 green:0.4 blue:0.2 alpha:0.1]
                CGColor];
  fire.contents = (id)[[UIImage imageNamed:@"Particles_fire.png"] CGImage];
  
  fire.velocity = 10;
  fire.velocityRange = 10;
  fire.emissionRange = M_PI_2;
  
  fire.scaleSpeed = 0.5;
  fire.spin = 0.5;
  
  [fire setName:@"fire"];
  
  //add the cell to the layer and we're done
  self.emitLayer.emitterCells = [NSArray arrayWithObject:fire];
}

@end
