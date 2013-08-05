//
//  topViewController.m
//  Fight
//
//  Created by developer on 13/07/10.
//  Copyright (c) 2013年 M2. All rights reserved.
//

#import "TopViewController.h"
#import "ViewController.h"

@interface TopViewController ()

@end

@implementation TopViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tapStartButton:(id)sender {
   ViewController *viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
  [self presentViewController:viewController animated:YES completion:nil];
}
@end
