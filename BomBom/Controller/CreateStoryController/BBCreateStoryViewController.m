//
//  BBCreateStoryViewController.m
//  BomBom
//
//  Created by Alexey Kolmyk on 18.12.13.
//  Copyright (c) 2013 SonnyBlack. All rights reserved.
//

#import "BBCreateStoryViewController.h"

#import "BBBasicPostCell.h"
#import "BBImagePicker.h"
#import "BBSpinnerView.h"
#import "QBClient.h"
#import "UIImage+Additions.h"

@interface BBCreateStoryViewController () <UITableViewDataSource, UITableViewDelegate, BBPostCellDelegate>

@property (nonatomic, weak)		UITextField	*postTitle;
@property (nonatomic, weak)		UITextView	*postContent;
@property (nonatomic, strong)	UIImage		*postImage;

@end

@implementation BBCreateStoryViewController

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
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(didShowKeyboard:)
												 name:UIKeyboardDidShowNotification object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(willHideKeyboard:)
												 name:UIKeyboardWillHideNotification object:nil];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableview delegate

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	BBBasicPostCell *cell;
	if (indexPath.row == 0) {
		cell = [self.tableView dequeueReusableCellWithIdentifier:@"postTitleCell"];
		self.postTitle = [cell getPostTextField];
			
	}else if (indexPath.row == 1){
		cell = [self.tableView dequeueReusableCellWithIdentifier:@"postDescriptionCell"];
		self.postContent = [cell getPostTextView];
		
	}else if (indexPath.row == 2){
		cell = [self.tableView dequeueReusableCellWithIdentifier:@"postImageCell"];
		[cell configurePostImage:self.postImage];
		
	}else{
		cell = [self.tableView dequeueReusableCellWithIdentifier:@"createPostCell"];
	}
	
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0) {
		return 50.0;
		
	}else if (indexPath.row == 1){
		return 160.0;
	
	}else if (indexPath.row == 2){
		return 130.0;
		
	}else{
		return 60.0;
	}
	
	return 44.0;
}

#pragma mark - UIKeyboard notifications

-(void) didShowKeyboard:(NSNotification *)notification {
	
	CGRect infoRect;
	[[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&infoRect];
	CGRect tableRect = self.tableView.frame;
	
	CGRect keyboardFrame = [self.view convertRect:infoRect toView:nil];
	tableRect.size.height -= keyboardFrame.size.height;
	
	self.tableView.frame = tableRect;
}

-(void)willHideKeyboard:(NSNotification *)notification {
	self.tableView.frame = self.view.frame;
}


#pragma mark - Cell delegate

-(void)didSelectImagePressed {
	[[BBImagePicker shared] getImageFromGalleryForViewController:self
													   withBlock:^(UIImage *image, BBImageStatus status) {
														   if (status == BBImageStatusSelected) {
															   UIImage *croppedImage = [UIImage compressedImageFromImage:image];
															   self.postImage = croppedImage;
															   [self.tableView reloadData];
														   }
													   }];
}

-(void)didCancelImagePressed {
	self.postImage = nil;
	[self.tableView reloadData];
}

-(void)createPostDidPressed {
	if (self.postTitle.text.length == 0 || !self.postTitle.text) {
		[self showAlertWithText:@"Post title is empty"];
		return;
	}
	
	if (self.postContent.text.length == 0 || !self.postContent.text) {
		[self showAlertWithText:@"Post content is empty"];
		return;
	}
	[BBSpinnerView showSpinner];
	
	if (self.postImage) {
		[[QBClient shared] uploadImage:self.postImage block:^(NSUInteger blobID, NSError *anError) {
			if (blobID > 0) {
				[self createPostWithBlobId:blobID];
			}else{
				[BBSpinnerView hideSpinner];
				[self showAlertWithText:[anError.userInfo objectForKey:@"userInfo"]];
			}
		}];
	}else{
		[self createPostWithBlobId:0];
	}
}

-(void) createPostWithBlobId:(NSUInteger) blobId {
	[[QBClient shared] createCustomObjectWithTitle:self.postTitle.text
										   content:self.postContent.text
											blobId:blobId
											 block:^(BBPostEntity *post, NSError *anError) {
												 [BBSpinnerView hideSpinner];
												 if (post) {
//													 [self showAlertWithText:@"Your post has been created!"];
													 [self.navigationController popViewControllerAnimated:YES];
												 }else{
													 [self showAlertWithText:[anError.userInfo objectForKey:@"userInfo"]];
												 }
											 }];
}

@end
