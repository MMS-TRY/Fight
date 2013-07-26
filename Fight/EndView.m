//
//  EndView.m
//  Fight
//
//  Created by Takashi MORIZANE on 2013/05/29.
//  Copyright (c) 2013年 PAVCMMS. All rights reserved.
//

#import "EndView.h"

@interface EndView()
@property (nonatomic, strong) UILabel *label;
@end

@implementation EndView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      self.userInteractionEnabled = YES;
      self.backgroundColor = [UIColor blackColor];
      UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
      l.backgroundColor = [UIColor clearColor];
      l.textColor = [UIColor whiteColor];
      [self addSubview:l];
      _label = l;
    }
    return self;
}

- (void)winPlayer:(NSInteger)no
{
  self.label.text = [NSString stringWithFormat:@"Player %d Win !!", no];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{

}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
  
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  if([self.delegate respondsToSelector:@selector(didTouchedEndView:)]) {
    [self.delegate didTouchedEndView: self];
  }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
  
}

@end
