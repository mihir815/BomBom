//
//  BBMyProfileViewController.h
//  BomBom
//
//  Created by Alexey Kolmyk on 17.12.13.
//  Copyright (c) 2013 SonnyBlack. All rights reserved.
//

#import "BBBasicViewController.h"

@interface BBMyProfileViewController : BBBasicViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet	UITableView	*tableView;

@end
