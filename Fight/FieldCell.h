//
//  FieldCell.h
//  Fight
//
//  Created by Takashi MORIZANE on 2013/05/24.
//  Copyright (c) 2013年 M2. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Character;

#define kCellRows 7
#define kCellCols 10
#define kCellPerSize  46

typedef enum {
  FieldCellTypePlain,
  FieldCellTypeMountain,
  FieldCellTypeSea,
} FiledCellType;

@interface FieldCell : NSObject
@property (nonatomic, assign) CGRect rect;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) FiledCellType type;
#ifdef MultiCharaOnCell
@property (nonatomic, strong) NSMutableArray *characters;
#else
@property (nonatomic, strong) Character *character;
#endif
@property (nonatomic, assign) NSInteger ratio;

- (id)initWithId:(int)id;
@end
