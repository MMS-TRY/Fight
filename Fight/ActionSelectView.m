//
//  ActionSelectView.m
//  Fight
//
//  Created by developer on 13/07/04.
//  Copyright (c) 2013年 M2. All rights reserved.
//

#import "ActionSelectView.h"
#import "AppDelegate.h"

@implementation ActionSelectView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
 */
- (void)updateDisplayFromCharacter
{
  self.nameTextField.text = _character.name;
  self.HPTextField.text = [NSString stringWithFormat:@"%d", self.character.HP];
  self.HPMaxTextField.text = [NSString stringWithFormat:@"%d", self.character.maxHP];
  self.APTextField.text = [NSString stringWithFormat:@"%d", self.character.AP];
  self.speedTextField.text = [NSString stringWithFormat:@"%d", self.character.speed];
  self.MovePointTextField.text = [NSString stringWithFormat:@"%d", self.character.movePoint];
  self.MovePointMaxTextField.text = [NSString stringWithFormat:@"%d", self.character.maxMovePoint];
  self.DPTextField.text = [NSString stringWithFormat:@"%d", self.character.DP];
}

- (void)updateCharaSettingEnable
{
  BOOL isCharaEnable = (self.character != nil);
  self.nameTextField.enabled = isCharaEnable;
  self.HPMaxTextField.enabled = isCharaEnable;
  self.HPMaxTextField.enabled = isCharaEnable;
  self.APTextField.enabled = isCharaEnable;
  self.speedTextField.enabled = isCharaEnable;
  self.MovePointTextField.enabled = isCharaEnable;
  self.MovePointMaxTextField.enabled = isCharaEnable;
  self.DPTextField.enabled = isCharaEnable;
  self.editCancelButton.hidden = !isCharaEnable;
  self.editEndButton.hidden = !isCharaEnable;
  if (self.character.isAttackEnd) {
    self.atackButton.hidden = YES;
  } else {
    self.atackButton.hidden = !isCharaEnable;
  }
}

- (void)setCharacterFromInput
{
  self.character.name = self.nameTextField.text;
  self.character.HP = [self.HPTextField.text integerValue];
  self.character.maxHP = [self.HPMaxTextField.text integerValue];
  self.character.AP = [self.APTextField.text integerValue];
  self.character.speed = [self.speedTextField.text integerValue];
  self.character.movePoint = [self.MovePointTextField.text integerValue];
  self.character.maxMovePoint = [self.MovePointMaxTextField.text integerValue];
  self.character.DP = [self.DPTextField.text integerValue];
}

- (void)setCharacter:(Character *)character
{
  _character = character;
  [self updateDisplayFromCharacter];
  [self updateCharaSettingEnable];
}

- (IBAction)tapEditEndButton:(id)sender {
  [self endEditing:YES];
  [self setCharacterFromInput];
  [self updateDisplayFromCharacter];
}

- (IBAction)tapEditCancelButton:(id)sender {
  [self endEditing:YES];
  [self updateDisplayFromCharacter];
}

- (IBAction)tapMoveButton:(id)sender {
  self.hidden = YES;
  [self.character setActionType:ActionTypeMove];
}

- (IBAction)tapAttackButton:(id)sender {
  self.hidden = YES;
  [self.character setActionType:ActionTypeAttack];
}

- (IBAction)DragExitButton:(id)sender {
  AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  [appDelegate.viewController dismissViewControllerAnimated:YES completion:nil]; 
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}
@end
