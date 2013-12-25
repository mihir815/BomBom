//
//  BBMyStoriesViewController.m
//  BomBom
//
//  Created by Alexey Kolmyk on 18.12.13.
//  Copyright (c) 2013 SonnyBlack. All rights reserved.
//

#import "BBMyStoriesViewController.h"

#import "BBStoryCommentsViewController.h"
#import "QBClient.h"

@interface BBMyStoriesViewController ()

@end

@implementation BBMyStoriesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[[QBClient shared] fetchMyStoriesWithBlock:^(NSMutableArray *posts, NSError *anError) {
		self.items = [[NSMutableArray alloc] initWithArray:posts];
		[self.tableView reloadData];
	}];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	
	self.segueIdentifier = kMyStoryCommentsSegue;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 60.0;
}

#pragma mark - Scroll view delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	
	CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize size = scrollView.contentSize;
    UIEdgeInsets inset = scrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
	
    CGFloat alphaState = 0.0;
    if(y > h - 100) {
		alphaState = 1.0;
    }else{
		alphaState = 0.0;
	}
	
	[UIView animateWithDuration:0.1 animations:^{
		self.loadMoreView.alpha = alphaState;
	}];
}

-(void) loadMoreDidPressed {
	
	BBCommentEntity *lastObject = [self.items lastObject];
	if (!lastObject) {
		return;
	}
	
	if (self.isLoadingNow) {
		return;
	}
	self.isLoadingNow = YES;
	
	[[QBClient shared] pagingMyStoriesFromLastDate:lastObject.date
									   withBlock:^(NSMutableArray *posts, NSError *anError) {
		self.isLoadingNow = NO;
										   
	   if ([posts count] == 0) {
		   self.isLoadedAllData = YES;
		   [self.tableView reloadData];
	   }
										   
		if (posts) {
			[self.items addObjectsFromArray:posts];
			[self.tableView reloadData];
		}
	}];
}


@end
