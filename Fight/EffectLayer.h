//
//  EffectLayer.h
//  Fight
//
//  Created by Takashi MORIZANE on 2013/05/28.
//  Copyright (c) 2013年 M2. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EffectLayerDelegate <NSObject>
- (void)didFinishEffectAnimation;
@end

@interface EffectLayer : UIView
@property (nonatomic, weak) id <EffectLayerDelegate> delegate;
- (void)fireAtPos:(CGPoint)pos duration:(NSTimeInterval)duration;
@end
