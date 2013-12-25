//
//  BBStoryListCell.h
//  BomBom
//
//  Created by Alexey Kolmyk on 18.12.13.
//  Copyright (c) 2013 SonnyBlack. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BBPostEntity.h"
#import "BBImageView.h"

@interface BBStoryListCell : UITableViewCell

@property (nonatomic, weak) IBOutlet	UILabel		*postTitle;
@property (nonatomic, weak) IBOutlet	UILabel		*authorLogin;
@property (nonatomic, weak) IBOutlet	UILabel		*postDate;
@property (nonatomic, weak) IBOutlet	BBImageView	*avatar;

-(void) configurePost:(BBPostEntity *)aPost;

@end
