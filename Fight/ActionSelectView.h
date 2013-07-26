//
//  ActionSelectView.h
//  Fight
//
//  Created by developer on 13/07/04.
//  Copyright (c) 2013年 PAVCMMS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Character.h"

@interface ActionSelectView : UIView

@property (nonatomic) Character *character;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *HPTextField;
@property (weak, nonatomic) IBOutlet UITextField *HPMaxTextField;
@property (weak, nonatomic) IBOutlet UITextField *APTextField;
@property (weak, nonatomic) IBOutlet UITextField *speedTextField;
@property (weak, nonatomic) IBOutlet UITextField *MovePointTextField;
@property (weak, nonatomic) IBOutlet UITextField *MovePointMaxTextField;
@property (weak, nonatomic) IBOutlet UITextField *DPTextField;
@property (weak, nonatomic) IBOutlet UIButton *editCancelButton;
@property (weak, nonatomic) IBOutlet UIButton *editEndButton;
@property (weak, nonatomic) IBOutlet UIButton *atackButton;
- (IBAction)tapEditEndButton:(id)sender;
- (IBAction)tapEditCancelButton:(id)sender;
- (IBAction)tapMoveButton:(id)sender;
- (IBAction)tapAttackButton:(id)sender;

- (IBAction)DragExitButton:(id)sender;
@end