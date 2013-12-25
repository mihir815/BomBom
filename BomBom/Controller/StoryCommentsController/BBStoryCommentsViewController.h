//
//  BBStoryCommentsViewController.h
//  BomBom
//
//  Created by Alexey Kolmyk on 19.12.13.
//  Copyright (c) 2013 SonnyBlack. All rights reserved.
//

#import "BBBasicViewController.h"

#import "BBPostEntity.h"

@interface BBStoryCommentsViewController : BBBasicViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) BBPostEntity *post;

@property (nonatomic, weak) IBOutlet	UITableView	*tableView;

-(IBAction)addComment:(id)sender;

@end
