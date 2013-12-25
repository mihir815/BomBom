//
//  BBAllStoriesViewController.m
//  BomBom
//
//  Created by Alexey Kolmyk on 19.12.13.
//  Copyright (c) 2013 SonnyBlack. All rights reserved.
//

#import "BBAllStoriesViewController.h"

#import "QBClient.h"

@interface BBAllStoriesViewController ()

@end

@implementation BBAllStoriesViewController

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
	
	self.segueIdentifier = kStoryCommentsSegue;
	
	UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
	[refreshControl addTarget:self action:@selector(updateData)
			 forControlEvents:UIControlEventValueChanged];
	
	self.pullRefresh = refreshControl;
	[self.tableView addSubview:refreshControl];
	
	[[QBClient shared] fetchStoriesWithBlock:^(NSMutableArray *posts, NSError *anError) {
		self.items = [[NSMutableArray alloc] initWithArray:posts];
		[self.tableView reloadData];
	}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
	
	[UIView animateWithDuration:0.2 animations:^{
		self.loadMoreView.alpha = alphaState;
	}];
}


#pragma mark - Refresh & Load more

-(void) updateData {
	self.isLoadingNow = YES;
	BBPostEntity *firstObject = [self.items firstObject];

	[[QBClient shared] updateStoriesFromLastDate:firstObject.date
									   withBlock:^(NSMutableArray *posts, NSError *anError) {
										   if ([posts count] > 0) {
											   if (!self.items) {
												   self.items = [[NSMutableArray alloc] initWithArray:posts];
											   }else{
												   NSRange updateRange = NSMakeRange(0, [posts count]);
												   NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:updateRange];
												   [self.items insertObjects:posts atIndexes:indexSet];
											   }
											   [self.tableView reloadData];
										   }
										   self.isLoadingNow = NO;
										   [self.pullRefresh endRefreshing];
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
	
	[[QBClient shared] pagingStoriesFromLastDate:lastObject.date withBlock:^(NSMutableArray *posts, NSError *anError) {
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
