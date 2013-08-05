//
//  StageView.m
//  Fight
//
//  Created by Takashi MORIZANE on 2013/05/24.
//  Copyright (c) 2013年 M2. All rights reserved.
//

#import "StageView.h"
#import <QuartzCore/QuartzCore.h>
#import "FieldCell.h"
#import "Character.h"
#import "EffectLayer.h"
#import "FloatStatusView.h"
#import "ActionSelectView.h"

@interface StageView() <EffectLayerDelegate>
@property (nonatomic, strong) NSMutableArray *cells;
@property (nonatomic, weak) Character *activeCharacter;
@property (nonatomic, assign) CGPoint originPoint;
@property (nonatomic, assign) CGPoint activePoint;
@property (nonatomic, strong) UIImageView *floatView;
@property (nonatomic, strong) FloatStatusView *damageView;

@property (nonatomic, strong) NSCondition *cLock;
@property (nonatomic, assign) NSInteger endOneTurn;
@property (nonatomic, assign) BOOL movingProcess;
@property (nonatomic) ActionSelectView *actionSelectView;

@end

@implementation StageView

- (id)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if(self) {
    int i;
    _cells = [NSMutableArray array];
    for (i=0; i< kCellRows * kCellCols; i++) {
      [_cells addObject:[[FieldCell alloc] initWithId:i]];
    }
    [self addObserver:self forKeyPath:@"effectLayer" options:NSKeyValueObservingOptionNew context:NULL];
    _cLock = [[NSCondition alloc] init];
    
    
    //長押し判定追加
    UILongPressGestureRecognizer *longPressGR
    = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [self addGestureRecognizer:longPressGR];
    
    UINib* nib = [UINib nibWithNibName:@"ActionSelectView" bundle:nil];
    NSArray* array = [nib instantiateWithOwner:nil options:nil];
    _actionSelectView = (ActionSelectView *)[array objectAtIndex:0];
    _actionSelectView.hidden = YES;
    [self addSubview:_actionSelectView];
  }
  return self;
}

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    int i;
    _cells = [NSMutableArray array];
    for (i=0; i< kCellRows * kCellCols; i++) {
      [_cells addObject:[[FieldCell alloc] initWithId:i]];
    }
    [self addObserver:self forKeyPath:@"effectLayer" options:NSKeyValueObservingOptionNew context:NULL];
    _cLock = [[NSCondition alloc] init];
    
    //長押し判定追加
    UILongPressGestureRecognizer *longPressGR
    = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [self addGestureRecognizer:longPressGR];
    
    UINib* nib = [UINib nibWithNibName:@"ActionSelectView" bundle:nil];
    NSArray* array = [nib instantiateWithOwner:nil options:nil];
    _actionSelectView = (ActionSelectView *)[array objectAtIndex:0];
    _actionSelectView.hidden = YES;
    [self addSubview:_actionSelectView];
  }
  return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
  if([keyPath isEqualToString:@"effectLayer"]) {
    id layer = [change objectForKey:NSKeyValueChangeNewKey];
    if(layer) {
      self.effectLayer.delegate = self;
    } else {
      self.effectLayer.delegate = nil;
    }
  }
}

- (void)didFinishEffectAnimation
{
}

#ifdef MultiCharaOnCell /* multiple characters */
- (NSMutableArray *)characterWithX:(NSInteger)x Y:(NSInteger)y
{
  FieldCell *cell = [self cellAtX:x Y:y];
  if ([cell.characters count] == 0) {
    return nil;
  }
  return cell.characters;
}
- (BOOL)setCharacter:(Character *)character X:(NSInteger)x Y:(NSInteger)y
{
  FieldCell *cell = [self cellAtX:x Y:y];
  if(cell.characters == nil) {
    cell.characters = [[NSMutableArray alloc] init];
  }
  character.pos = CGPointMake(x, y);
  [cell.characters addObject:character];
  return YES;
}
- (BOOL)removeCharacter:(Character *)character
{
  FieldCell *cell = [self cellAtX:character.pos.x Y:character.pos.y];
  if ([cell.characters containsObject:character]) {
    [cell.characters removeObject:character];
    return YES;
  }
  return NO;
}
#else
- (Character *)characterWithX:(NSInteger)x Y:(NSInteger)y
{
  FieldCell *cell = [self cellAtX:x Y:y];
  return cell.character;
}

- (BOOL)setCharacter:(Character *)character X:(NSInteger)x Y:(NSInteger)y
{
  FieldCell *cell = [self cellAtX:x Y:y];
  if(cell.character) {
    return NO;
  }
  
  character.pos = CGPointMake(x, y);
  cell.character = character;
  return YES;
}

- (BOOL)removeCharacter:(Character *)character
{
  FieldCell *cell = [self cellAtX:character.pos.x Y:character.pos.y];
  if (cell.character == character) {
    cell.character = nil;
    return YES;
  }
  return NO;
}

- (BOOL)resetCharacter:(Character *)character X:(NSInteger)x Y:(NSInteger)y
{
  FieldCell *cell = [self cellAtX:x Y:y];
  if(cell.character) {
    return NO;
  }
  [self removeCharacter:character];
  [self setCharacter:character X:x Y:y];
  return YES;
}
#endif

NSInteger xPosWithXPoint(CGFloat xPoint)
{
  return xPoint/kCellPerSize;
}

NSInteger yPosWithYPoint(CGFloat yPoint)
{
  return yPoint/kCellPerSize;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  UITouch *tch = [touches anyObject];
  CGPoint pos = [tch locationInView:self];
  
  Character *actionChara = self.actionSelectView.character;
  if (actionChara && actionChara.actionType == ActionTypeAttack) {
    CGPoint current = CGPointMake(xPosWithXPoint(pos.x), yPosWithYPoint(pos.y));
    FieldCell *cell = [self cellAtX:current.x Y:current.y];
    actionChara.attackCells = [NSArray arrayWithObject:cell];//攻撃範囲指定
    [self displayAttackViewCell:cell byCharacter:actionChara];
    actionChara.moveEnd = YES;
    actionChara.isAttackEnd = YES;
    self.actionSelectView.character = nil;
    return;
  }
  

  if(self.activeCharacter) {
    return;
  }
  
  self.originPoint = CGPointMake(xPosWithXPoint(pos.x), yPosWithYPoint(pos.y));
  self.activePoint = self.originPoint;
  FieldCell *cell = [self cellAtX:xPosWithXPoint(pos.x) Y:yPosWithYPoint(pos.y)];
  //  NSLog(@"%@",cell);
#ifdef MultiCharaOnCell
  if(cell) {
    for (Character *character in cell.characters) {
      if (!character.group) {

        if (character.isAttackEnd) {
          break;//攻撃済みの場合
        }
        
        self.activeCharacter = character;
        if(self.activeCharacter) {
          if(self.activeCharacter.moveEnd) {
            self.activeCharacter.moveEnd = NO;
            self.activeCharacter.movePoint = self.activeCharacter.maxMovePoint;
            [self.activeCharacter.movingReservePos removeAllObjects];
          }
          self.activeCharacter.pos = self.originPoint;
          self.floatView = [[UIImageView alloc] initWithImage:self.activeCharacter.image];
          self.floatView.frame = CGRectMake(0,0,kCellPerSize,kCellPerSize);
          self.floatView.alpha = 0.6;
          [self addSubview:self.floatView];
          self.floatView.center = pos;
          //      NSLog(@"%@",NSStringFromCGPoint(pos));
          [self setNeedsDisplay];
        }
        break;
      }
    }
  }
#else
  if(cell && !cell.character.group) {
    self.activeCharacter = cell.character;
    if(self.activeCharacter) {
      if(self.activeCharacter.moveEnd) {
        self.activeCharacter.moveEnd = NO;
        self.activeCharacter.movePoint = self.activeCharacter.maxMovePoint;
        [self.activeCharacter.movingReservePos removeAllObjects];
      }
      self.activeCharacter.pos = self.originPoint;
      self.floatView = [[UIImageView alloc] initWithImage:self.activeCharacter.image];
      self.floatView.frame = CGRectMake(0,0,kCellPerSize,kCellPerSize);
      self.floatView.alpha = 0.6;
      [self addSubview:self.floatView];
      self.floatView.center = pos;
      //      NSLog(@"%@",NSStringFromCGPoint(pos));
      [self setNeedsDisplay];
    }
  }
#endif
  
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
  if(!self.activeCharacter) {
    return;
  }
  
  UITouch *tch = [touches anyObject];
  CGPoint pos = [tch locationInView:self];
  CGPoint current = CGPointMake(xPosWithXPoint(pos.x), yPosWithYPoint(pos.y));
  
  if (CGPointEqualToPoint(self.activePoint, current)) {
    self.floatView.center = pos;
    return;
  }
  
  FieldCell *cell = [self cellAtX:current.x Y:current.y];
  if(fabs(self.activePoint.x - current.x) < 2 && fabs(self.activePoint.y - current.y) < 2) {
    if([self.activeCharacter canMoveTo:current fromPos:self.activePoint ratio:cell.ratio]) {
      self.floatView.center = pos;
      
      //      NSLog(@"cell ratio %d",cell.ratio);
      [self.activeCharacter moveReserveTo:current];
      self.activeCharacter.movePoint -= ([self.activeCharacter spendPointTo:current fromPos:self.activePoint] * cell.ratio);
      self.activePoint = current;
      
      [self setNeedsDisplay];
    }
  }
}

- (void)moveToBackLayerCharacter:(Character *)chara
{
  //複数キャラクターがいる場合後ろ側に行く
  CGPoint point = chara.pos;
  FieldCell *cell = [self cellAtX:point.x Y:point.y];
  if ([cell.characters count] > 1) {
    [cell.characters removeObject:chara];
    [cell.characters addObject:chara];
  }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  if(self.activeCharacter) {
    self.activeCharacter.moveEnd = YES;

    [self moveToBackLayerCharacter:self.activeCharacter];
    
    [self removeFloatView];
    [self setNeedsDisplay];
    
    for (Character *c in self.charas) {
      if(!c.moveEnd && c.HP != 0) {
        return;
      }
    }
    
    self.movingProcess = YES;
    [self doMoveAndAction];
  }
}

/* one step */
- (void)oneTurnAction
{
  NSArray *speedSorted = [self.charas sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
    Character *c1 = obj1;
    Character *c2 = obj2;
    
    if(c1.speed < c2.speed) {
      return NSOrderedAscending;
    } else if (c1.speed == c2.speed){
      return NSOrderedSame;
    } else {
      return NSOrderedDescending;
    }
  }];
  
  for (Character *c in speedSorted) {
    CGPoint pos;
    if(c.movingReservePos.count > 0) {
      pos = [[c.movingReservePos objectAtIndex:0] CGPointValue];
      
#ifndef MultiCharaOnCell  /* 先頭は最後に */
      FieldCell *cell = [self cellAtX:pos.x Y:pos.y];
      if(cell.character) {
        if(cell.character.group != c.group) {
          [self.effectLayer fireAtPos:CGPointMake(CGRectGetMidX(cell.rect), CGRectGetMidY(cell.rect)) duration:0.5];
          [self displayAttackViewCell:cell byCharacter:c];
          [c.movingReservePos removeLastObject];
          NSLog(@"Attack !!!");
          continue;
        } else {
          NSLog(@"Collision");
          [c.movingReservePos removeLastObject];
          [self finishOneTurn];
          continue;
        }
      }
#endif
      c.isMoving = YES;
      UIImageView *img = [[UIImageView alloc] initWithImage:c.image];
      img.frame = [self cellRectWithX:c.pos.x Y:c.pos.y];
      [self addSubview:img];
      [self removeCharacter:c];
      c.pos = pos;
      [self setCharacter:c X:c.pos.x Y:c.pos.y];
      [c.movingReservePos removeObjectAtIndex:0];
      [self setNeedsDisplay];
      
      [UIView animateWithDuration:0.5
                            delay:0.0
                          options:UIViewAnimationOptionCurveLinear
                       animations:^{
                         FieldCell *cell = [self cellAtX:pos.x Y:pos.y];
                         img.center = CGPointMake(CGRectGetMidX(cell.rect), CGRectGetMidY(cell.rect));
                       }
                       completion:^(BOOL finished){
                         c.isMoving = NO;
                         [self setNeedsDisplay];
                         [img removeFromSuperview];
                         [self finishOneTurn];
                       }];
      
      
      
    } else {
      c.isMoving = NO;
      c.moveEnd = NO;
      [self setNeedsDisplay];
      [self finishOneTurn];
    }
    
  }
#ifdef MultiCharaOnCell
  for (FieldCell *cell in self.cells) {
    NSInteger g0IHP = 0 , g1IHP = 0;
    NSMutableArray *loseCahras = [[NSMutableArray alloc] init];
    for (Character *chara in cell.characters) {
      if (chara.group) {
        g1IHP += (chara.HP * chara.AP);
      } else {
        g0IHP += (chara.HP * chara.AP);
      }
    }
    int winGroup;
    double damage = 0;
    if (g0IHP == g1IHP) {
      winGroup = -1;
    } else if (g0IHP < g1IHP) {
      winGroup = 1;
      damage = (double)g1IHP / (g0IHP + g1IHP);
    } else {
      winGroup = 0;
      damage = (double)g0IHP / (g0IHP + g1IHP);
    }
    for (Character *chara in cell.characters) {
      if (chara.group != winGroup) {
        [loseCahras addObject:chara];
        chara.HP = 0;
        chara.moveEnd = YES;
        [self.activeCharacter.movingReservePos removeAllObjects];
      } else {
        chara.HP *= damage;
      }
    }
    for (Character *lose in loseCahras) {
      [cell.characters removeObject:lose];
    }
  }
#endif
}

- (void)finishOneTurn
{
  [self.cLock lock];
  self.endOneTurn++;
  [self.cLock signal];
  [self.cLock unlock];
}

- (void)doMoveAndAction
{
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    while (1) {
      NSInteger finish = 0;
      for (Character *c in self.charas) {
        if(c.movingReservePos.count == 0 || c.HP == 0) {
          finish++;
        }
      }
      if(finish == self.charas.count) {
        break;
      }
      dispatch_async(dispatch_get_main_queue(), ^{
        [self oneTurnAction];
      });
      
      [self.cLock lock];
      while (self.endOneTurn < self.charas.count) {
        [self.cLock wait];
      }
      [self.cLock unlock];
      self.endOneTurn = 0;
    }
    NSLog(@"All character move end");
    for (Character *c in self.charas) {
      NSLog(@"%@ HP %d/%d",c, c.HP, c.maxHP);
      c.movePoint = c.maxMovePoint;
      c.moveEnd = NO;
      c.isMoving = NO;
      c.isAttackEnd = NO;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
      self.movingProcess = NO;
      [self setNeedsDisplay];
      [self thinkEnemyTurn];
    });
  });
  
}
#ifdef MultiCharaOnCell
- (void)displayAttackViewCell:(FieldCell *)dstCell byCharacter:(Character *)srcCharacter
{
  for (Character *chara in dstCell.characters) {
    if(srcCharacter.group == chara.group) {
      continue;//味方には何もしない
    }
    [self.effectLayer fireAtPos:CGPointMake(CGRectGetMidX(dstCell.rect), CGRectGetMidY(dstCell.rect)) duration:0.5];

    if(self.damageView) {
      [self.damageView removeFromSuperview];
    }
    self.damageView = [[FloatStatusView alloc] initWithFrame:CGRectMake(0, 0, 50, 6)];
    self.damageView.center = CGPointMake(CGRectGetMidX(dstCell.rect), CGRectGetMidY(dstCell.rect));
    [self.effectLayer addSubview:self.damageView];
    self.damageView.maxHp = chara.maxHP;
    self.damageView.hp = chara.HP;
    CGFloat damage = srcCharacter.AP - chara.DP;
    
    [self.damageView damage:damage];
    
    double delayInSeconds = 1.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
      [self.damageView removeFromSuperview];
      self.damageView = nil;
      chara.HP -= damage;
      if(chara.HP < 1) {
        chara.HP = 0;
        if([self.delegate respondsToSelector:@selector(didStageViewEventAtCell:eventType:)]) {
          [self.delegate didStageViewEventAtCell:dstCell eventType:kStageEventTypeBattle];
        }
        [dstCell.characters removeObject:chara];//TODO:OK?
      }
      [self moveToBackLayerCharacter:srcCharacter];
      [self setNeedsDisplay];
      [self finishOneTurn];

      {//行動終了チェック
        BOOL isEnd = YES;
        for (Character *c in self.charas) {
          if(!(c.moveEnd || c.isAttackEnd) && c.HP != 0) {
            isEnd = NO;
            break;
          }
        }
        if (isEnd) {
          self.movingProcess = YES;
          [self doMoveAndAction];
        }
      }
    });
  }
  
}
#else
- (void)displayAttackViewCell:(FieldCell *)dstCell byCharacter:(Character *)srcCharacter
{
  if(self.damageView) {
    [self.damageView removeFromSuperview];
  }
  self.damageView = [[FloatStatusView alloc] initWithFrame:CGRectMake(0, 0, 50, 6)];
  self.damageView.center = CGPointMake(CGRectGetMidX(dstCell.rect), CGRectGetMidY(dstCell.rect));
  [self.effectLayer addSubview:self.damageView];
  self.damageView.maxHp = dstCell.character.maxHP;
  self.damageView.hp = dstCell.character.HP;
  CGFloat damage = srcCharacter.AP - dstCell.character.DP;
  
  [self.damageView damage:damage];
  
  double delayInSeconds = 1.5;
  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
  dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    [self.damageView removeFromSuperview];
    self.damageView = nil;
    dstCell.character.HP -= damage;
    if(dstCell.character.HP < 1) {
      dstCell.character.HP = 0;
      if([self.delegate respondsToSelector:@selector(didStageViewEventAtCell:eventType:)]) {
        [self.delegate didStageViewEventAtCell:dstCell eventType:kStageEventTypeBattle];
      }
      dstCell.character = nil;
      [self setNeedsDisplay];
    }
    [self finishOneTurn];
  });
}
#endif

- (void)moveCharacter:(UIImageView *)imageView X:(NSInteger)x Y:(NSInteger)y
{
  __block __weak StageView *wSelf = self;
  [UIView animateWithDuration:2.2 delay:0.0 options:UIViewAnimationOptionCurveLinear
                   animations:^{
                     FieldCell *cell = [self cellAtX:x Y:y];
                     imageView.center = CGPointMake(CGRectGetMidX(cell.rect), CGRectGetMidY(cell.rect));
                   }
                   completion:^(BOOL finished){
                     [wSelf setNeedsDisplay];
                     [imageView removeFromSuperview];
                     //                     [wSelf removeFloatView];
                   }];
}

- (void)thinkEnemyTurn
{
  for (Character *c in self.charas) {
    if(c.group && c.HP > 0) {
      c.moveEnd = YES;
      
      
      CGPoint current = c.pos;
      
      NSLog(@"%@",c);
      while (1) {
        if (random() % 10 < 1) {
          break;
        }
        
        CGPoint toPos = current;
        NSInteger frontParam = 7;
        NSInteger leftRightParam = 4;
        if(c.pos.y >= kCellCols - 5) {
          frontParam = 4;
          leftRightParam = 7;
        }else if(c.pos.y >= kCellCols -3) {
          frontParam = 3;
          leftRightParam = 2;
        }
        
        if (random() % 10 < frontParam) {
          /* 前 */
          toPos.y++;
          if(random() % 10 < 6) {
            /* 中央 */
            NSLog(@"F");
          } else if(random() % 10 < 5) {
            /* 左 */
            toPos.x--;
            NSLog(@"FL");
          } else {
            /* 右 */
            toPos.x++;
            NSLog(@"FR");
          }
        } else if(random() % 10 < leftRightParam) {
          if(random() % 10 < 5) {
            /* 左 */
            toPos.x--;
            NSLog(@"L");
          } else {
            /* 右 */
            toPos.x++;
            NSLog(@"R");
          }
        } else {
          /* 後ろ */
          if(random() % 10 < 6) {
            /* 中央 */
            toPos.y--;
            NSLog(@"B");
          } else if(random() % 10 < 5) {
            /* 左 */
            toPos.x--;
            NSLog(@"BL");
          } else {
            /* 右 */
            toPos.x++;
            NSLog(@"BR");
          }
        }
        
        if(toPos.x < 0) {
          toPos.x = 0;
        }
        
        if(toPos.y < 0) {
          toPos.y = 0;
        }
        
        if(toPos.x >= kCellRows) {
          toPos.x = kCellRows -1;
        }
        
        if(toPos.y >= kCellCols) {
          toPos.y = kCellCols -1;
        }
        
        FieldCell *cell = [self cellAtX:toPos.x Y:toPos.y];
        if([c canMoveTo:toPos fromPos:current ratio:cell.ratio]) {
          [c moveReserveTo:toPos];
          c.movePoint -= ([c spendPointTo:toPos fromPos:current] * cell.ratio);
          current = toPos;
        } else if(random() %10 < 5) {
          break;
        }
      }
    }
  }
}

- (void)removeFloatView
{
  if(self.activeCharacter) {
    self.activeCharacter = nil;
    [self.floatView removeFromSuperview];
    self.floatView = nil;
  }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
  [self setNeedsDisplay];
  [self removeFloatView];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
  [self setNeedsDisplay];
  [self removeFloatView];
}

- (CGRect)cellRectWithX:(NSInteger)x Y:(NSInteger)y
{
  return CGRectMake(x * kCellPerSize +1, y * kCellPerSize +1, kCellPerSize-2, kCellPerSize-2);
}

- (FieldCell *)cellAtX:(NSInteger)x Y:(NSInteger)y
{
  //  NSLog(@"%d, %d",x,y);
  int pos = y * kCellRows + x;
  if(pos >= self.cells.count || pos < 0 || x < 0 || y < 0 || x >= kCellRows || y>= kCellCols) {
    return nil;
  }
  return [self.cells objectAtIndex:pos];
}

- (void)drawBox:(CGContextRef)ctx X:(NSInteger)x Y:(NSInteger)y
{
  if(x < 0 || y < 0 || x >= kCellRows || y >= kCellCols) {
    return;
  }
  CGContextSetRGBFillColor (ctx, 1, 0, 0, 0.6);
  CGContextFillRect (ctx, [self cellRectWithX:x Y:y]);
}

- (void)drawCharacter:(Character *)character context:(CGContextRef)ctx x:(int)x y:(int)y
{
  if (character.isMoving) {
    return;
  }
  
  if(character.group) {
    CGContextDrawImage(ctx, [self cellRectWithX:x Y:y], [character.image CGImage]);
  } else {
    [character.image drawInRect:[self cellRectWithX:x Y:y]];
  }
  
  if(!self.movingProcess) {
    if(character.movingReservePos.count > 0) {
      CGContextBeginPath(ctx);
      if(character.group) {
        CGContextSetRGBStrokeColor(ctx, 0.5, 0.5, 0, 0.5);
      } else {
        CGContextSetRGBStrokeColor(ctx, 0, 0, 0.8, 0.5);
      }
      CGContextSetLineWidth(ctx, 5);
      CGRect rect = [self cellRectWithX:x Y:y];
      CGContextMoveToPoint(ctx, CGRectGetMidX(rect), CGRectGetMidY(rect));
      
      for (NSValue *mPos in character.movingReservePos) {
        CGPoint pos = [mPos CGPointValue];
        CGRect rect = [self cellRectWithX:pos.x Y:pos.y];
        CGContextAddLineToPoint(ctx, CGRectGetMidX(rect), CGRectGetMidY(rect));
      }
      CGContextStrokePath(ctx);
    }
    
    if(character.moveEnd) {
      CGPoint pos;
      if(character.movingReservePos.count > 0) {
        pos = [[character.movingReservePos lastObject] CGPointValue];
      } else {
        pos = CGPointMake(x, y);
      }
      
      CGRect rect = [self cellRectWithX:pos.x Y:pos.y];
      rect.origin.x += 10;
      rect.origin.y += 10;
      rect.size.width -= 20;
      rect.size.height -= 20;
      if(character.group) {
        CGContextSetRGBFillColor(ctx, 0.5, 0.5, 0, 0.6);
      } else {
        CGContextSetRGBFillColor(ctx, 0, 0, 0.8, 0.8);
      }
      CGContextFillEllipseInRect(ctx, rect);
    }
  }
}

- (void)drawRect:(CGRect)rect
{
  // Drawing code
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  
  int x,y;
  for (x=0; x<kCellRows; x++) {
    for (y=0; y<kCellCols; y++) {
      FieldCell *cell = [self cellAtX:x Y:y];
      
#ifdef MultiCharaOnCell
      //後ろのキャラから描画する
      NSUInteger charaNum = [cell.characters count];
      for (NSUInteger i = (charaNum - 1); i < charaNum; i--) {
        Character *chara = cell.characters[i];
        [self drawCharacter:chara context:ctx x:x y:y];
      }
#else
      if(cell.character) {
        [self drawCharacter:cell.character context:ctx x:x y:y];
      }
#endif
      
    }
  }
  
  if(self.activeCharacter) {
    switch (self.activeCharacter.actionType) {
      case ActionTypeAttack:
        break;
        
      default:
      case ActionTypeMove:
        for (y = -1; y < 2; y ++) {
          for (x = -1; x < 2; x++) {
            FieldCell *cell = [self cellAtX:self.activePoint.x + x Y:self.activePoint.y + y];
            if ([self.activeCharacter canMoveTo:CGPointMake(self.activePoint.x + x, self.activePoint.y + y) fromPos:self.activePoint ratio:cell.ratio]) {
              [self drawBox:ctx X:self.activePoint.x + x Y:self.activePoint.y + y];
            }
          }
        }
        break;
    }
  }
}

- (void)clearAllCell
{
  for (FieldCell *c in self.cells) {
#ifdef MultiCharaOnCell
    [c.characters removeAllObjects];
#else
    c.character = nil;
#endif
  }
}

- (void)startGame
{
  [self thinkEnemyTurn];
}

- (void)dealloc
{
  [self removeObserver:self forKeyPath:@"effectLayer"];
}


- (void)handleLongPress:(UILongPressGestureRecognizer *)sender
{
    CGPoint pos = [sender locationInView:self];
    
    self.originPoint = CGPointMake(xPosWithXPoint(pos.x), yPosWithYPoint(pos.y));
    self.activePoint = self.originPoint;
    FieldCell *cell = [self cellAtX:xPosWithXPoint(pos.x) Y:yPosWithYPoint(pos.y)];
    //  NSLog(@"%@",cell);
    
    if(cell) {
        if ([cell.characters count] > 0) {
//        for (Character *character in cell.characters) {
            self.actionSelectView.character = cell.characters[0];
            self.actionSelectView.hidden = NO;
        } else {
            self.actionSelectView.character = nil;
        }
        self.actionSelectView.hidden = NO;
    }
    
  //    self.userInteractionEnabled = NO;
//  if (self.activeCharacter) {
//    Character *ac = self.activeCharacter;
//    NSLog(@"%s %d %d %d",__func__, ac.HP, ac.AP, ac.DP);
//    
//    self.actionSelectView.character = self.activeCharacter;
//    self.actionSelectView.hidden = NO;
//  }
}

@end
