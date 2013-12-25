//
//  BBSignInViewController.m
//  BomBom
//
//  Created by Alexey Kolmyk on 16.12.13.
//  Copyright (c) 2013 SonnyBlack. All rights reserved.
//

#import "BBSignInViewController.h"

#import "BBSpinnerView.h"
#import "QBClient.h"

@interface BBSignInViewController ()

@end

@implementation BBSignInViewController

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

- (IBAction)signIn:(id)sender {
	if (self.login.text.length == 0 || self.pass.text.length == 0) {
		UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:nil
															 message:@"Empty fields!"
															delegate:nil
												   cancelButtonTitle:@"Ok"
												   otherButtonTitles:nil];
		[errorAlert show];
		return;
	}
	
	[BBSpinnerView showSpinner];
	[[QBClient shared] signInWithLogin:self.login.text
								  pass:self.pass.text
								 block:^(QBUUser *aUser, NSError *anError) {
									 [BBSpinnerView hideSpinner];
									 if (aUser) {
										 [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
										 [self performSegueWithIdentifier:ksuccessSignInSegue sender:nil];
									 }else{
										 UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:nil
																							  message:[anError.userInfo objectForKey:@"userInfo"]
																							 delegate:nil
																					cancelButtonTitle:@"Ok"
																					otherButtonTitles:nil];
										 [errorAlert show];
									 }

	}];
}

@end
