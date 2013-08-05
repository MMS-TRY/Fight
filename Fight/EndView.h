//
//  EndView.h
//  Fight
//
//  Created by Takashi MORIZANE on 2013/05/29.
//  Copyright (c) 2013年 M2. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EndViewDelegate <NSObject>
- (void)didTouchedEndView:(id)obj;
@end

@interface EndView : UIView
@property (nonatomic, weak) id <EndViewDelegate>delegate;
- (void)winPlayer:(NSInteger)no;
@end
