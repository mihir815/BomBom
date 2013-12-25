//
//  BBStoryCommentsViewController.m
//  BomBom
//
//  Created by Alexey Kolmyk on 19.12.13.
//  Copyright (c) 2013 SonnyBlack. All rights reserved.
//

#import "BBStoryCommentsViewController.h"

#import "BBBasicCommentCell.h"
#import "QBClient.h"

@interface BBStoryCommentsViewController () <UIAlertViewDelegate>

@property (nonatomic, strong) NSMutableArray *comments;
@property (nonatomic, assign) NSInteger		 postItemsCounter;

@end

@implementation BBStoryCommentsViewController

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
	
	self.isLoadedAllData = NO;
	
	UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
	[refreshControl addTarget:self action:@selector(updateData)
			 forControlEvents:UIControlEventValueChanged];
	
	self.pullRefresh = refreshControl;
	[self.tableView addSubview:refreshControl];
}

-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	self.tableView.delegate = self;
	
	self.postItemsCounter = 2;
	if (self.post.contentBlobId) {
		self.postItemsCounter = 3;
	}
	
	[[QBClient shared] fetchCommentsForPost:self.post.postID block:^(NSMutableArray *comments, NSError *anError) {
		if (comments) {
			self.comments = [[NSMutableArray alloc] initWithArray:comments];
			[self.tableView reloadData];
		}

	}];
}

-(void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	self.tableView.delegate = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableview delegate

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.postItemsCounter + [self.comments count];
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	BBBasicCommentCell *cell;
	if (indexPath.row == 0) {
		cell = [self.tableView dequeueReusableCellWithIdentifier:@"commentsTitleCell"];
		[cell configureForPost:self.post];
		
	}else if (indexPath.row == 1){
		cell = [self.tableView dequeueReusableCellWithIdentifier:@"textContentCell"];
		[cell configureForPost:self.post];
	
	}else if (indexPath.row == 2 && self.postItemsCounter == 3){
		cell = [self.tableView dequeueReusableCellWithIdentifier:@"imageContentCell"];
		[cell configureForPost:self.post];
	
	}else{
		cell = [self.tableView dequeueReusableCellWithIdentifier:@"commentsCell"];
		
		BBCommentEntity *comment = self.comments[indexPath.row - self.postItemsCounter];
		[cell configureForComment:comment];
	}
		
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0) {
		CGFloat height = [BBBasicCommentCell heightForTextInCell:self.post.title];
		return height;
	
	}else if (indexPath.row == 1) {
		CGFloat height = [BBBasicCommentCell heightForTextInCell:self.post.content];
		return height;
		
	}else if (indexPath.row == 2 && self.postItemsCounter == 3){
		return 320.0;
		
	}else {
		BBCommentEntity *comment = self.comments[indexPath.row - self.postItemsCounter];
		return [BBBasicCommentCell heightForCommentCell:comment.comment];
	}
	
	return 44.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	if ([self.comments count] > 0 && !self.isLoadedAllData) {
		return 50.0f;
	}else{
		return 0.0;
	}
	
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	if ([self.comments count] > 0 && !self.isLoadedAllData) {
		self.loadMoreView = [[BBLoadMoreView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 50.0)];
		[self.loadMoreView setTapSelector:@selector(loadMoreDidPressed) forTarget:self];
		self.loadMoreView.backgroundColor = [UIColor lightGrayColor];
		self.loadMoreView.alpha = 0.0;
		return self.loadMoreView;
	}else{
		return nil;
	}
}

-(IBAction)addComment:(id)sender {
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add comment"
													message:@"Your comment:"
												   delegate:self
										  cancelButtonTitle:@"Cancel"
										  otherButtonTitles:@"Ok", nil];
	
	[alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
	[[alert textFieldAtIndex:0] setPlaceholder:@"comment"];
	[alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 1) {
		UITextField *textField = [alertView textFieldAtIndex:0];
		[[QBClient shared] createCommentForObjectID:self.post.postID
											comment:textField.text
											  block:^(BBCommentEntity *comment, NSError *anError) {
												  if (comment) {
													  if (!self.comments) {
														  self.comments = [NSMutableArray new];
													  }
													  [self.comments insertObject:comment atIndex:0];
													  [self.tableView reloadData];
												  }
		}];
	}
	
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
	BBCommentEntity *firstObject = [self.comments firstObject];
	
	[[QBClient shared] updateCommentsForPost:self.post.postID lastTime:firstObject.date block:^(NSMutableArray *posts, NSError *anError) {
		if ([posts count] > 0) {
			if (!self.comments) {
				self.comments = [[NSMutableArray alloc] initWithArray:posts];
			}else{
				NSRange updateRange = NSMakeRange(0, [posts count]);
				NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:updateRange];
				[self.comments insertObjects:posts atIndexes:indexSet];
			}
			[self.tableView reloadData];
		}
		self.isLoadingNow = NO;
		[self.pullRefresh endRefreshing];
	}];
}

-(void) loadMoreDidPressed {

	BBCommentEntity *lastObject = [self.comments lastObject];
	if (!lastObject) {
		return;
	}
	
	if (self.isLoadingNow) {
		return;
	}
	self.isLoadingNow = YES;
	[[QBClient shared] pagingCommentsForPost:self.post.postID
								fromLastDate:lastObject.date
									   block:^(NSMutableArray *comments, NSError *anError) {
										   self.isLoadingNow = NO;
										   
										   if ([comments count] == 0) {
											   self.isLoadedAllData = YES;
											   [self.tableView reloadData];
										   }
										   
										   if (comments) {
											   [self.comments addObjectsFromArray:comments];
											   [self.tableView reloadData];
										   }
									   }];
}

@end
