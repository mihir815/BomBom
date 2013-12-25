//
//  BBSignUpViewController.m
//  BomBom
//
//  Created by Alexey Kolmyk on 16.12.13.
//  Copyright (c) 2013 SonnyBlack. All rights reserved.
//

#import "BBSignUpViewController.h"

#import "QBClient.h"
#import "BBSpinnerView.h"
#import "BBImagePicker.h"
#import "UIImage+Additions.h"

@interface BBSignUpViewController ()

@end

@implementation BBSignUpViewController

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

-(IBAction)signUp:(id)sender {
	
	if (self.login.text.length == 0 || self.pass.text.length == 0 || self.confirmPass.text.length == 0) {
		UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:nil
														message:@"Empty fields!"
													   delegate:nil
											  cancelButtonTitle:@"Ok"
											  otherButtonTitles:nil];
		[errorAlert show];
		return;
	}
	if (![self.pass.text isEqualToString:self.confirmPass.text]) {
		UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:nil
															 message:@"Passwords missmatch!"
															delegate:nil
												   cancelButtonTitle:@"Ok"
												   otherButtonTitles:nil];
		[errorAlert show];
		return;
	}

	[BBSpinnerView showSpinner];
	
	[[QBClient shared] signUpWithLogin:self.login.text
								  pass:self.pass.text
								 block:^(QBUUser *aUser, NSError *anError) {
									 [BBSpinnerView showSpinner];
									 if (aUser) {
										 [[QBClient shared] signInWithLogin:self.login.text
																	   pass:self.pass.text
																	  block:^(QBUUser *aUser, NSError *anError) {
																		  if (aUser) {
																			  [[QBClient shared] uploadImage:self.avatar.image block:^(NSUInteger blobID, NSError *anError) {
																				  if (blobID != 0) {
																					  [[QBClient shared] updateCurrentUserBlobId:blobID block:^(QBUUser *aUser, NSError *anError) {
																						  [BBSpinnerView hideSpinner];
																						  
																						  if (aUser) {
																							  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
																							  [self performSegueWithIdentifier:kSuccessSignUpSegue sender:nil];
																						  }else{
																							   [QBClient showAlertForError:anError];
																						  }
																					  }];
																					  
																				  }else{
																					   [BBSpinnerView hideSpinner];
																					   [QBClient showAlertForError:anError];
																				  }
																			  }];
																			  
																		  }else{
																			  [BBSpinnerView hideSpinner];
																			  [QBClient showAlertForError:anError];
																		  }
										 }];
									 }else{
										 [BBSpinnerView hideSpinner];
										 [QBClient showAlertForError:anError];
									 }
								 }];
}

- (IBAction)pickImage:(id)sender {
//	UIButton *b = (UIButton *)sender;
//	b.layer.borderColor = [UIColor redColor].CGColor;
//	b.layer.borderWidth = 1.0;
	
	[[BBImagePicker shared] getImageFromGalleryForViewController:self
													   withBlock:^(UIImage *image, BBImageStatus status) {
														   if (status == BBImageStatusSelected) {
															   UIImage *croppedImage = [UIImage imageWithImage:image scaledToSize:CGSizeMake(80.0, 80.0)];
															   self.avatar.image = croppedImage;
														   }
	}];
}

@end
