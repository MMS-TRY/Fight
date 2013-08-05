//
//  BaseFieldView.m
//  Fight
//
//  Created by Takashi MORIZANE on 2013/05/31.
//  Copyright (c) 2013年 M2. All rights reserved.
//

#import "BaseFieldView.h"
#import "FieldCell.h"

@implementation BaseFieldView

- (id)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if(self) {

  }
  return self;
}

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
  
  }
  return self;
}

- (CGRect)cellRectWithX:(NSInteger)x Y:(NSInteger)y
{
  return CGRectMake(x * kCellPerSize +1, y * kCellPerSize +1, kCellPerSize-2, kCellPerSize-2);
}

int
makeBoxLines(CGPoint *posAry, size_t size)
{
  int i;
  
  
  int j=0;
  for (i=0; i<kCellRows; i++) {
    if (i%2 == 0) {
      posAry[j++] = CGPointMake(i * kCellPerSize, 0);
      posAry[j++] = CGPointMake(i * kCellPerSize, kFieldHeight);
    } else {
      posAry[j++] = CGPointMake(i * kCellPerSize, kFieldHeight);
      posAry[j++] = CGPointMake(i * kCellPerSize, 0);
    }
  }
  
  for (i=0; i<kCellCols; i++) {
    if (i%2 == 0) {
      posAry[j++] = CGPointMake(0, i * kCellPerSize);
      posAry[j++] = CGPointMake(kFieldWidth, i * kCellPerSize);
    } else {
      posAry[j++] = CGPointMake(kFieldWidth, i * kCellPerSize);
      posAry[j++] = CGPointMake(0, i * kCellPerSize);
    }
  }
  
  return j-0;
}

- (void)drawBox:(CGContextRef)ctx X:(NSInteger)x Y:(NSInteger)y
{
  if(x < 0 || y < 0 || x >= kCellRows || y >= kCellCols) {
    return;
  }
  CGContextSetRGBFillColor (ctx, 1, 0, 0, 0.6);
  CGContextFillRect (ctx, [self cellRectWithX:x Y:y]);
}

- (void)drawRect:(CGRect)rect
{
  // Drawing code
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  CGPoint *posAry = alloca(sizeof(CGPoint) * 100);
  
  int n = makeBoxLines(posAry, sizeof(*posAry));
  
  /* Draw Base Triangle */
  CGContextSetRGBStrokeColor(ctx, 0.0, 0.0, 0.0, 0.8);
  CGContextSetLineWidth(ctx, 1);
  CGContextAddLines(ctx, posAry, n);
  CGContextClosePath(ctx);
  CGContextStrokePath(ctx);
  
  int x,y;
  for (x=0; x<kCellRows; x++) {
    for (y=0; y<kCellCols; y++) {
      FieldCell *cell = [self.stageView cellAtX:x Y:y];
      [cell.image drawInRect:[self cellRectWithX:x Y:y]];
    }
  }
}

@end
