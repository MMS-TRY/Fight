//
//  FieldCell.m
//  Fight
//
//  Created by Takashi MORIZANE on 2013/05/24.
//  Copyright (c) 2013年 PAVCMMS. All rights reserved.
//

#import "FieldCell.h"

@implementation FieldCell

- (id)initWithId:(int)id
{
  self = [super init];
  if (self) {
    self.rect = CGRectMake((id % kCellRows) * kCellPerSize, (id / kCellRows) * kCellPerSize,
                           kCellPerSize, kCellPerSize);

#if 1 /* grass only */
    _image = [UIImage imageNamed:@"grassField"];
    _type = FieldCellTypePlain;
    _ratio = 1;
#else
    NSInteger v = random()%10;
    if(v > 2) {
      _image = [UIImage imageNamed:@"grassField"];
      _type = FieldCellTypePlain;
      _ratio = 1;
    } else if(v == 2){
      _image = [UIImage imageNamed:@"mountain"];
      _type = FieldCellTypeMountain;
      _ratio = 4;
    } else {
      _image = [UIImage imageNamed:@"seaField"];
      _type = FieldCellTypeSea;
      _ratio = 7;
    }
#endif

#ifdef MutiCharaOnCell
    _characters = [[NSMutableArray alloc] init];
#endif
  }
  return self;
}

@end
