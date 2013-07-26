//
//  Character.h
//  Fight
//
//  Created by Takashi MORIZANE on 2013/05/24.
//  Copyright (c) 2013年 PAVCMMS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FieldCell.h"

typedef enum {
  ActionTypeMove,
  ActionTypeAttack,
} ActionType;

@interface Character : NSObject
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger speed;
@property (nonatomic, assign) NSInteger maxHP;
@property (nonatomic, assign) NSInteger HP;
@property (nonatomic, assign) NSInteger AP;
@property (nonatomic, assign) NSInteger DP;
@property (nonatomic, assign) NSInteger maxMovePoint;
@property (nonatomic, assign) NSInteger movePoint;
@property (nonatomic, assign) BOOL moveEnd;
@property (nonatomic, assign) BOOL isMoving;
@property (nonatomic, assign) NSInteger group;
@property (nonatomic, assign) CGPoint pos;
@property (nonatomic, copy) NSMutableArray *movingReservePos;
@property (nonatomic, strong) NSArray *attackCells;
@property (nonatomic, assign) ActionType actionType;
@property (nonatomic, assign) BOOL isAttackEnd;

/* 
   7 0 1    各方角に対して、移動属性を持つ
   6 X 2
   5 4 3
 */
@property (nonatomic, strong) NSArray *moveArea;

- (void)moveReserveTo:(CGPoint)pos;
- (NSInteger)spendPointTo:(CGPoint)toPos fromPos:(CGPoint)fromPos;
//- (NSArray *)movableAreaAtPos:(CGPoint)pos;
//- (BOOL)canMoveTo:(CGPoint)toPos fromPos:(CGPoint)fromPos;
- (BOOL)canMoveTo:(CGPoint)toPos fromPos:(CGPoint)fromPos ratio:(NSInteger)ratio;

- (void)setCharaParamerWithPattern:(NSInteger)patternNum;

@end
