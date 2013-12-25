//
//  BBBasicViewController.m
//  BomBom
//
//  Created by Alexey Kolmyk on 16.12.13.
//  Copyright (c) 2013 SonnyBlack. All rights reserved.
//

#import "BBBasicViewController.h"

@interface BBBasicViewController ()

@end

@implementation BBBasicViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) showAlertWithText:(NSString *) aText {
	UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:nil
														 message:aText
														delegate:nil
											   cancelButtonTitle:@"Ok"
											   otherButtonTitles:nil];
	[errorAlert show];
}


@end
