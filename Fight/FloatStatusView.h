//
//  FloatStatusView.h
//  Fight
//
//  Created by Takashi MORIZANE on 2013/05/28.
//  Copyright (c) 2013年 PAVCMMS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FloatStatusView : UIView
@property (nonatomic, assign) CGFloat maxHp;
@property (nonatomic, assign) CGFloat hp;
- (void)damage:(CGFloat)val;
@end
