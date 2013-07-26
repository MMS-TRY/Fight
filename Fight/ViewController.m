//
//  ViewController.m
//  Fight
//
//  Created by Takashi MORIZANE on 2013/05/24.
//  Copyright (c) 2013年 PAVCMMS. All rights reserved.
//

#import "ViewController.h"
#import "StageView.h"
#import "Character.h"
#import "EffectLayer.h"
#import "FloatStatusView.h"
#import "EndView.h"
#import "BaseFieldView.h"

@interface ViewController () <StageViewDelegate, EndViewDelegate>
@property (nonatomic, weak) IBOutlet BaseFieldView *baseFieldView;
@property (nonatomic, weak) IBOutlet StageView *stageView;
@property (nonatomic, weak) IBOutlet EffectLayer *efLayer;
@property (nonatomic, strong) NSArray *charas;
@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if(self) {
    int i;
    NSMutableArray *ary = [NSMutableArray array];
    for (i=0; i<10; i++) {
      [ary addObject:[[Character alloc] init]];
    }
    _charas = [NSArray arrayWithArray:ary];
  }
  return self;
}

- (void)didStageViewEventAtCell:(FieldCell *)cell eventType:(kStageEventType)type
{
  NSInteger g0 = 0, g1 = 0;
  for (Character *c in self.charas) {
    if (c.HP > 0) {
      c.group ? g1++:g0++;
    }
  }
  
  if(g1 == 0 || g0 == 0) {
    EndView *v = [[EndView alloc] initWithFrame:CGRectMake(0, 0, 320, 516)];
    [v winPlayer:g1 == 0?1:2];
    v.delegate = self;
    [self.view addSubview:v];
  }
}

- (void)resetGame
{
  int i;

  [self.stageView clearAllCell];
  
  NSMutableArray *ary = [NSMutableArray array];
  for (i=0; i<10; i++) {
    [ary addObject:[[Character alloc] init]];
  }
  self.charas = [NSArray arrayWithArray:ary];

  for (i=0; i<5;i++) {
    ((Character *)self.charas[i]).group = 0;
    ((Character *)self.charas[i+5]).group = 1;
    ((Character *)self.charas[i+5]).image = [UIImage imageNamed:@"images-0.png"];
    [self.stageView setCharacter:self.charas[i] X:i+1 Y:9];
    [self.stageView setCharacter:self.charas[i+5] X:i+1 Y:0];
  }
  self.stageView.charas = self.charas;
  [self.stageView setNeedsDisplay];
  [self.stageView startGame];
}

- (void)didTouchedEndView:(id)obj
{
  EndView *v = obj;
  v.delegate = nil;
  [v removeFromSuperview];
  [self resetGame];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.baseFieldView.stageView = self.stageView;
  
  int i;
  for (i=0; i<5;i++) {
    ((Character *)self.charas[i]).group = 0;
    ((Character *)self.charas[i+5]).group = 1;
    ((Character *)self.charas[i+5]).image = [UIImage imageNamed:@"images-0.png"];
    [self.stageView setCharacter:self.charas[i] X:i+1 Y:9];
    [self.stageView setCharacter:self.charas[i+5] X:i+1 Y:0];
  }
  self.stageView.charas = self.charas;
  self.stageView.effectLayer = self.efLayer;
  self.stageView.delegate = self;
  [self.stageView startGame];
  
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
}
@end
