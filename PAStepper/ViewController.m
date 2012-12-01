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
@end
