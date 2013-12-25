//
//  BBNavigationController.m
//  BomBom
//
//  Created by Alexey Kolmyk on 16.12.13.
//  Copyright (c) 2013 SonnyBlack. All rights reserved.
//

#import "BBNavigationController.h"

@interface BBNavigationController ()

@end

@implementation BBNavigationController

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
	// Do any additional setup after loading the view.
	
	self.navigationBar.barTintColor = [UIColor colorWithRed:30.0/255.0
													  green:30.0/255.0
													   blue:34.0/255.0
													  alpha:1.0];
	self.navigationBar.tintColor = [UIColor whiteColor];
	self.navigationBar.translucent = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
