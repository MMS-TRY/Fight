//
//  StageView.h
//  Fight
//
//  Created by Takashi MORIZANE on 2013/05/24.
//  Copyright (c) 2013年 M2. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FieldCell, Character, EffectLayer;

typedef enum {
  kStageEventTypeBattle,
} kStageEventType;

#define kFieldWidth  320
#define kFieldHeight 568

@protocol StageViewDelegate <NSObject>
@optional
- (void)didStageViewEventAtCell:(FieldCell *)cell eventType:(kStageEventType)type;
@end


@interface StageView : UIView
@property (nonatomic, weak) id <StageViewDelegate> delegate;
@property (nonatomic, weak) EffectLayer *effectLayer;
@property (nonatomic, weak) NSArray *charas;
- (FieldCell *)cellAtX:(NSInteger)x Y:(NSInteger)y;
#ifdef MultiCharaOnCell
- (NSMutableArray *)characterWithX:(NSInteger)x Y:(NSInteger)y;
- (BOOL)setCharacter:(Character *)character X:(NSInteger)x Y:(NSInteger)y;
#else
- (Character *)characterWithX:(NSInteger)x Y:(NSInteger)y;
- (BOOL)setCharacter:(Character *)character X:(NSInteger)x Y:(NSInteger)y;
#endif
- (void)clearAllCell;
- (void)startGame;
@end
