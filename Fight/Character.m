//
//  Character.m
//  Fight
//
//  Created by Takashi MORIZANE on 2013/05/24.
//  Copyright (c) 2013年 PAVCMMS. All rights reserved.
//

#import "Character.h"

@implementation Character

- (id)init
{
  self = [super init];
  if(self) {
    _speed = arc4random()%5 + 1;
    _maxMovePoint = random()%7 + 3;
    _movePoint = _maxMovePoint;
//    _moveArea = @[@(random()%5+1),@(random()%3+1),@(random()%5+1),@(random()%3+1),@(random()%5+1),@(random()%3+1),@(random()%5+1),@(random()%3+1)];
    _moveArea = @[@(1),@(1),@(1),@(1),@(1),@(1),@(1),@(1)];
    _maxHP = random() %50 + 50;
    _HP = _maxHP;
    _AP = random() %50 + 30;
    _DP = random() %25 + 1;
    _image = [UIImage imageNamed:[NSString stringWithFormat:@"images-%ld.png",random()%11+1]];
    _movingReservePos = [NSMutableArray array];
  }
  return self;
}

//- (void)spendMovePoint:(CGPoint)toPos fromPos:(CGPoint)fromPos
//{
//  self.movePoint -= [self spendPointTo:toPos fromPos:fromPos];
//}

- (void)moveReserveTo:(CGPoint)pos
{
  [self.movingReservePos addObject:[NSValue valueWithCGPoint:pos]];
}

- (NSInteger)spendPointTo:(CGPoint)toPos fromPos:(CGPoint)fromPos
{
  NSInteger xPos, yPos;
  int pos[] = {7, 0, 1, 6, 0, 2, 5, 4, 3};
  
  if (toPos.x < fromPos.x) {
    xPos = 0;
  } else if(toPos.x == fromPos.x) {
    xPos = 1;
  } else {
    xPos = 2;
  }

  if(toPos.y < fromPos.y) {
    yPos = 0;
  } else if(toPos.y == fromPos.y) {
    yPos = 1;
  } else {
    yPos = 2;
  }
  
  if(xPos == 1 && yPos == 1) {
    return 0;
  }

  NSInteger spendValue = [[_moveArea objectAtIndex:pos[yPos * 3 + xPos]] integerValue];

  return spendValue;
}

//- (NSArray *)movableAreaAtPos:(CGPoint)pos
//{
//  NSMutableArray *ary = [NSMutableArray array];
//  CGFloat x,y;
//
//  for (y = -1; y < 2; y ++) {
//    for (x = -1; x < 2; x++) {
//      if ([self canMoveTo:CGPointMake(pos.x + x, pos.y + y) fromPos:pos]) {
//        [ary addObject:[NSValue valueWithCGPoint:CGPointMake(pos.x + x, pos.y + y)]];
//      }
//    }
//  }
//
//  return ary;
//}

- (BOOL)canMoveTo:(CGPoint)toPos fromPos:(CGPoint)fromPos ratio:(NSInteger)ratio
{
  if ((self.movePoint - ([self spendPointTo:toPos fromPos:fromPos] * ratio)) < 0) {
    return NO;
  }
  return YES;
}


// for test
- (void)setCharaParamerWithPattern:(NSInteger)patternNum
{
  switch (patternNum) {
    default:
      break;

    case 0:
      self.speed          = 5;
      self.maxMovePoint   = 7;
      self.movePoint      = self.maxMovePoint;
      self.moveArea       = @[@(1),@(1),@(1),@(1),@(1),@(1),@(1),@(1)];
      self.maxHP          = 100;
      self.HP             = self.maxHP;
      self.AP             = 60;
      self.DP             = 0;
      break;

    case 1:
      self.speed          = 5;
      self.maxMovePoint   = 7;
      self.movePoint      = self.maxMovePoint;
      self.moveArea       = @[@(1),@(1),@(1),@(1),@(1),@(1),@(1),@(1)];
      self.maxHP          = 100;
      self.HP             = self.maxHP;
      self.AP             = 60;
      self.DP             = 0;
      break;
      
    case 2:
      self.speed          = 5;
      self.maxMovePoint   = 7;
      self.movePoint      = self.maxMovePoint;
      self.moveArea       = @[@(1),@(1),@(1),@(1),@(1),@(1),@(1),@(1)];
      self.maxHP          = 100;
      self.HP             = self.maxHP;
      self.AP             = 60;
      self.DP             = 0;
      break;
      
    case 3:
      self.speed          = 5;
      self.maxMovePoint   = 7;
      self.movePoint      = self.maxMovePoint;
      self.moveArea       = @[@(1),@(1),@(1),@(1),@(1),@(1),@(1),@(1)];
      self.maxHP          = 100;
      self.HP             = self.maxHP;
      self.AP             = 60;
      self.DP             = 0;
      break;
      
    case 4:
      self.speed          = 5;
      self.maxMovePoint   = 7;
      self.movePoint      = self.maxMovePoint;
      self.moveArea       = @[@(1),@(1),@(1),@(1),@(1),@(1),@(1),@(1)];
      self.maxHP          = 100;
      self.HP             = self.maxHP;
      self.AP             = 60;
      self.DP             = 0;
      break;
      
    case 5:
      self.speed          = 5;
      self.maxMovePoint   = 7;
      self.movePoint      = self.maxMovePoint;
      self.moveArea       = @[@(1),@(1),@(1),@(1),@(1),@(1),@(1),@(1)];
      self.maxHP          = 100;
      self.HP             = self.maxHP;
      self.AP             = 60;
      self.DP             = 0;
      break;
      
    case 6:
      self.speed          = 5;
      self.maxMovePoint   = 7;
      self.movePoint      = self.maxMovePoint;
      self.moveArea       = @[@(1),@(1),@(1),@(1),@(1),@(1),@(1),@(1)];
      self.maxHP          = 100;
      self.HP             = self.maxHP;
      self.AP             = 60;
      self.DP             = 0;
      break;
      
    case 7:
      self.speed          = 5;
      self.maxMovePoint   = 7;
      self.movePoint      = self.maxMovePoint;
      self.moveArea       = @[@(1),@(1),@(1),@(1),@(1),@(1),@(1),@(1)];
      self.maxHP          = 100;
      self.HP             = self.maxHP;
      self.AP             = 60;
      self.DP             = 0;
      break;
      
    case 8:
      self.speed          = 5;
      self.maxMovePoint   = 7;
      self.movePoint      = self.maxMovePoint;
      self.moveArea       = @[@(1),@(1),@(1),@(1),@(1),@(1),@(1),@(1)];
      self.maxHP          = 100;
      self.HP             = self.maxHP;
      self.AP             = 60;
      self.DP             = 0;
      break;
      
    case 9:
      self.speed          = 5;
      self.maxMovePoint   = 7;
      self.movePoint      = self.maxMovePoint;
      self.moveArea       = @[@(1),@(1),@(1),@(1),@(1),@(1),@(1),@(1)];
      self.maxHP          = 100;
      self.HP             = self.maxHP;
      self.AP             = 60;
      self.DP             = 0;
      break;
  }
}

@end
