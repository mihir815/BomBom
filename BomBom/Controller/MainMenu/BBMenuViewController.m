//
//  BBMenuViewController.m
//  BomBom
//
//  Created by Alexey Kolmyk on 16.12.13.
//  Copyright (c) 2013 SonnyBlack. All rights reserved.
//

#import "BBMenuViewController.h"

#import "BBBasicViewController.h"
#import "QBClient.h"
#import "BBSpinnerView.h"

@interface BBMenuViewController () <SASlideMenuDataSource, SASlideMenuDelegate, UITableViewDataSource>

@end

@implementation BBMenuViewController

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
	
	[self.tableView setContentInset:UIEdgeInsetsMake(20,
													 self.tableView.contentInset.left,
													 self.tableView.contentInset.bottom,
													 self.tableView.contentInset.right)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark SASlideMenuDataSource

-(NSIndexPath *) selectedIndexPath{
    return [NSIndexPath indexPathForRow:0 inSection:0];
}

-(NSString*) segueIdForIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return kTopStoriesSegue;
    }else if (indexPath.row == 1){
        return kMyStoriesSegue;
    }else{
        return kMyProfileSegue;
    }
}

-(Boolean) allowContentViewControllerCachingForIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(Boolean) disablePanGestureForIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return YES;
    }
    return NO;
}

-(void) configureMenuButton:(UIButton *)menuButton{
    menuButton.frame = CGRectMake(0, 0, 40, 29);
	menuButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    [menuButton setImage:[UIImage imageNamed:@"menuIcon"] forState:UIControlStateNormal];
}

-(void) configureSlideLayer:(CALayer *)layer{
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOpacity = 0.3;
    layer.shadowOffset = CGSizeMake(-5, 0);
    layer.shadowRadius = 5;
    layer.masksToBounds = NO;
    layer.shadowPath =[UIBezierPath bezierPathWithRect:layer.bounds].CGPath;
}

-(CGFloat) leftMenuVisibleWidth{
    return 260;
}
-(void) prepareForSwitchToContentViewController:(UINavigationController *)content{
    UIViewController *controller = [content.viewControllers objectAtIndex:0];
    if ([controller isKindOfClass:[BBBasicViewController class]]) {
        BBBasicViewController *basicController = (BBBasicViewController *)controller;
        basicController.menuController = self;
    }
}


#pragma mark -
#pragma mark UITableViewDataSource

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	UITableViewCell *cell;
	if (indexPath.row == 0) {
		cell = [self.tableView dequeueReusableCellWithIdentifier:@"topStoriesItem"];
	}else if (indexPath.row == 1){
		cell = [self.tableView dequeueReusableCellWithIdentifier:@"myStoriesItem"];
	}else if (indexPath.row == 3){
		cell = [self.tableView dequeueReusableCellWithIdentifier:@"signOutItem"];
	}else {
		cell = [self.tableView dequeueReusableCellWithIdentifier:@"myProfileItem"];
	}
	
    return cell;
}

-(Boolean) shouldRespondToGesture:(UIGestureRecognizer*) gesture forIndexPath:(NSIndexPath*)indexPath {
    CGPoint touchPosition = [gesture locationInView:self.view];
    return (touchPosition.x < 50.0 || touchPosition.x > self.view.bounds.size.width - 50.0f);
}

#pragma mark -
#pragma mark UITableViewDelegate

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	
	if (indexPath.row == 3) {
		[self logout];
	}else{
		[super tableView:tableView didSelectRowAtIndexPath:indexPath];
	}
}



#pragma mark -
#pragma mark SASlideMenuDelegate

/*
-(void) slideMenuWillSlideIn:(UINavigationController *)selectedContent{
    NSLog(@"slideMenuWillSlideIn");
}
-(void) slideMenuDidSlideIn:(UINavigationController *)selectedContent{
    NSLog(@"slideMenuDidSlideIn");
}
-(void) slideMenuWillSlideToSide:(UINavigationController *)selectedContent{
    NSLog(@"slideMenuWillSlideToSide");
}
-(void) slideMenuDidSlideToSide:(UINavigationController *)selectedContent{
    NSLog(@"slideMenuDidSlideToSide");
}
-(void) slideMenuWillSlideOut:(UINavigationController *)selectedContent{
    NSLog(@"slideMenuWillSlideOut");
}
-(void) slideMenuDidSlideOut:(UINavigationController *)selectedContent{
    NSLog(@"slideMenuDidSlideOut");
}
-(void) slideMenuWillSlideToLeft:(UINavigationController *)selectedContent{
    NSLog(@"slideMenuWillSlideToLeft");
}
-(void) slideMenuDidSlideToLeft:(UINavigationController *)selectedContent{
    NSLog(@"slideMenuDidSlideToLeft");
}
*/

#pragma mark -
#pragma mark Other

-(void) logout {
	[BBSpinnerView showSpinner];
	[[QBClient shared] logoutWithBlock:^(BOOL isLogoitPerformed, NSError *anError) {
		[BBSpinnerView hideSpinner];
		if (isLogoitPerformed) {
			[self performSegueWithIdentifier:kLogoutSegue sender:nil];
		}else{
			[self showAlertWithText:[anError.userInfo objectForKey:@"userInfo"]];
		}
	}];
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
