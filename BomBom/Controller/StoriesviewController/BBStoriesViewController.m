//
//  BBStoriesViewController.m
//  BomBom
//
//  Created by Alexey Kolmyk on 18.12.13.
//  Copyright (c) 2013 SonnyBlack. All rights reserved.
//

#import "BBStoriesViewController.h"

#import "BBStoryListCell.h"
#import "BBStoryCommentsViewController.h"

@interface BBStoriesViewController ()

@end

@implementation BBStoriesViewController

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
	
}

-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	self.tableView.delegate = self;
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

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.items count];
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	BBStoryListCell *cell;
	cell = [self.tableView dequeueReusableCellWithIdentifier:@"postItemCell"];
	[cell configurePost:self.items[indexPath.row]];
	
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	return 100.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	if ([self.items count] > 0 && !self.isLoadedAllData) {
		return 50.0f;
	}else{
		return 0.0;
	}
	
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	if ([self.items count] > 0 && !self.isLoadedAllData) {
		self.loadMoreView = [[BBLoadMoreView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 50.0)];
		[self.loadMoreView setTapSelector:@selector(loadMoreDidPressed) forTarget:self];
		self.loadMoreView.backgroundColor = [UIColor lightGrayColor];
		self.loadMoreView.alpha = 0.0;
		return self.loadMoreView;
	}else{
		return nil;
	}
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	BBPostEntity *selectedPost = self.items[indexPath.row];
	
	[self performSegueWithIdentifier:self.segueIdentifier sender:selectedPost];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:self.segueIdentifier]) {
		BBStoryCommentsViewController *comments = (BBStoryCommentsViewController *)segue.destinationViewController;
		comments.post = sender;
	}
}

-(void)loadMoreDidPressed {
	
}

@end
