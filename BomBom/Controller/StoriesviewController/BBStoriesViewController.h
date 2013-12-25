//
//  BBStoriesViewController.h
//  BomBom
//
//  Created by Alexey Kolmyk on 18.12.13.
//  Copyright (c) 2013 SonnyBlack. All rights reserved.
//

#import "BBBasicViewController.h"

@interface BBStoriesViewController : BBBasicViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)	NSString				*segueIdentifier;

@property (nonatomic, strong)	NSMutableArray			*items;
@property (nonatomic, weak)		IBOutlet	UITableView	*tableView;

-(void)loadMoreDidPressed;

@end
