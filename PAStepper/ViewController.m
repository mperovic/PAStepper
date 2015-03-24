//
//  ViewController.m
//  PAStepper
//
//  Created by Miroslav Perovic on 12/1/12.
//  Copyright (c) 2012 Pure Agency. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.paStepper.minimumValue = 1;
    self.paStepper.maximumValue = 50;
    //self.paStepper.editableManually = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setPaStepper:nil];

    [super viewDidUnload];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
