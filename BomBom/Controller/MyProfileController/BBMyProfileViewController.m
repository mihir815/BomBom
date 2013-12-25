//
//  BBMyProfileViewController.m
//  BomBom
//
//  Created by Alexey Kolmyk on 17.12.13.
//  Copyright (c) 2013 SonnyBlack. All rights reserved.
//

#import "BBMyProfileViewController.h"

#import "QBClient.h"
#import "BBImagePicker.h"
#import "BBProfileCell.h"
#import "BBSpinnerView.h"
#import "UIImage+Additions.h"

@interface BBMyProfileViewController () <BBProfileCellDelegate, UIAlertViewDelegate>

@property (nonatomic, copy) QBUUser	*currentUser;


@end

@implementation BBMyProfileViewController

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
	
	self.currentUser = [[QBClient shared] getCurrentUser];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITable view delegate

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	BBProfileCell *cell;
	if (indexPath.row == 0) {
		cell = [self.tableView dequeueReusableCellWithIdentifier:@"avatarCell"];
		[cell configureForAvatar:self.currentUser.blobID
						delegate:self
							type:BBProfileCellTypeAvatar];
		
	}else if (indexPath.row == 1){
		cell = [self.tableView dequeueReusableCellWithIdentifier:@"loginCell"];
		[cell configureFieldWithTopText:@"My login:"
							 bottomText:self.currentUser.login
							   delegate:self
								   type:BBProfileCellTypeLogin];
		
	}else if (indexPath.row == 2){
		cell = [self.tableView dequeueReusableCellWithIdentifier:@"emailCell"];
		[cell configureFieldWithTopText:@"My email:"
							 bottomText:self.currentUser.email
							   delegate:self
								   type:BBProfileCellTypeEmail];
		
	}else {
		cell = [self.tableView dequeueReusableCellWithIdentifier:@"passwordCell"];
		[cell configureFieldWithTopText:@"My password:"
							 bottomText:self.currentUser.password
							   delegate:self
								   type:BBProfileCellTypePassword];
		
	}
	
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0) {
		return 160.0;
		
	}else{
		return 100.0;
	}
	
	return 44.0;
}

#pragma mark - User's data editing

-(void)changeUserData:(BBProfileCellType)aType {
	if (aType == BBProfileCellTypeAvatar)  {
		[self updatePhoto];
		
	}else{
		[self showAlertViewWithType:aType];
	}
}

-(void) showAlertViewWithType:(BBProfileCellType)type {
	
	UIAlertViewStyle style;
	NSString *message;
	NSString *placeholder;
	
	if (type == BBProfileCellTypeAvatar) {
		style = UIAlertViewStylePlainTextInput;
		message = @"";
		placeholder = @"";
		
	}else if (type == BBProfileCellTypeLogin) {
		style = UIAlertViewStylePlainTextInput;
		message = @"Enter new login:";
		placeholder = @"login";
		
	}else if (type == BBProfileCellTypeEmail) {
		style = UIAlertViewStylePlainTextInput;
		message = @"Enter new email:";
		placeholder = @"email";
		
	}else {
		style = UIAlertViewStyleLoginAndPasswordInput;
		message = @"Enter old and new passwords:";
		placeholder = @"";
	}
	
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
												 message:message
												delegate:self
									   cancelButtonTitle:@"Cancel"
									   otherButtonTitles:@"Ok", nil];

	alert.tag = type;
	[alert setAlertViewStyle:style];
	
	if (style == UIAlertViewStyleLoginAndPasswordInput) {
		[[alert textFieldAtIndex:0] setSecureTextEntry:YES];
		[[alert textFieldAtIndex:1] setSecureTextEntry:YES];
		[[alert textFieldAtIndex:0] setPlaceholder:@"old password"];
		[[alert textFieldAtIndex:1] setPlaceholder:@"new password"];

	}
	
	// Alert style customization
	[alert show];
}

#pragma mark - UIAlertView delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	if (alertView.tag == BBProfileCellTypeAvatar) {
		
	}else if (alertView.tag == BBProfileCellTypeLogin) {
		if (buttonIndex == 1) {
			UITextField *textField = [alertView textFieldAtIndex:0];
			[self updateLogin:textField.text];
		}
		
	}else if (alertView.tag == BBProfileCellTypeEmail) {
		if (buttonIndex == 1) {
			UITextField *textField = [alertView textFieldAtIndex:0];
			[self updateEmail:textField.text];
		}
		
	}else if (alertView.tag == BBProfileCellTypePassword) {
		if (buttonIndex == 1) {
			UITextField *oldPass = [alertView textFieldAtIndex:0];
			UITextField *newPass = [alertView textFieldAtIndex:1];
		
			[self updatePassword:oldPass.text aNewPass:newPass.text];
		}
	}
}

#pragma mark - Update actions

-(void) updatePhoto {
	[[BBImagePicker shared] getImageFromGalleryForViewController:self
													   withBlock:^(UIImage *image, BBImageStatus status) {
		   if (status == BBImageStatusSelected) {
			   UIImage *croppedImage = [UIImage imageWithImage:image scaledToSize:CGSizeMake(80.0, 80.0)];
			   
			   [BBSpinnerView showSpinner];
			   [[QBClient shared] updateImage:croppedImage
									   blobID:self.currentUser.blobID
										block:^(NSUInteger blobID, NSError *anError) {
											if (blobID != 0) {
												[[QBClient shared] updateCurrentUserBlobId:blobID block:^(QBUUser *aUser, NSError *anError) {
													[BBSpinnerView hideSpinner];
													if (aUser) {
														self.currentUser = aUser;
														[self.tableView reloadData];
														[self showAlertWithText:@"Your avatar has been successfully updated."];
													}else{
														[self showAlertWithText:[anError.userInfo objectForKey:@"userInfo"]];
													}
												}];
											}else{
												[BBSpinnerView hideSpinner];
												[self showAlertWithText:[anError.userInfo objectForKey:@"userInfo"]];
											}
				   
			   }];
		   }
	}];
}

-(void) updateLogin:(NSString *)aNewLogin {
	
	if (!aNewLogin || aNewLogin.length == 0) {
		[self showAlertWithText:@"Empty login!"];
		return;
	}
	
	[[QBClient shared] updateCurrentUserLogin:aNewLogin
										block:^(QBUUser *aUser, NSError *anError) {
		if (aUser) {
			self.currentUser = aUser;
			[self.tableView reloadData];
			[self showAlertWithText:@"Your login has been successfully updated."];
		}else{
			[self showAlertWithText:[anError.userInfo objectForKey:@"userInfo"]];
		}
	}];
}

-(void) updateEmail:(NSString *)aNewEmail {
	
	if (!aNewEmail || aNewEmail.length == 0) {
		[self showAlertWithText:@"Empty email!"];
		return;
	}
	
	[[QBClient shared] updateCurrentUserEmail:aNewEmail
										block:^(QBUUser *aUser, NSError *anError) {
		if (aUser) {
			self.currentUser = aUser;
			[self.tableView reloadData];
			[self showAlertWithText:@"Your login has been successfully updated."];
		}else{
			[self showAlertWithText:[anError.userInfo objectForKey:@"userInfo"]];
		}
	}];
}

-(void) updatePassword:(NSString *)anOldPass
			  aNewPass:(NSString *)aNewPass {
	
	if (!anOldPass || anOldPass.length == 0) {
		[self showAlertWithText:@"Empty old pass field!"];
		return;
	}
	
	if (!aNewPass || aNewPass.length == 0) {
		[self showAlertWithText:@"Empty new pass field!"];
		return;
	}
	
	[[QBClient shared] updateCurrentUserWithOldPassword:anOldPass
												newPass:aNewPass
												  block:^(QBUUser *aUser, NSError *anError) {
	  if (aUser) {
		  self.currentUser = aUser;
		  [self.tableView reloadData];
		  [self showAlertWithText:@"Your password has been successfully updated."];
	  }else{
		  [self showAlertWithText:[anError.userInfo objectForKey:@"userInfo"]];
	  }
	}];
}


@end
