//
//  BBStoryListCell.m
//  BomBom
//
//  Created by Alexey Kolmyk on 18.12.13.
//  Copyright (c) 2013 SonnyBlack. All rights reserved.
//

#import "BBStoryListCell.h"

#import "BBDateConvertor.h"

@implementation BBStoryListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) configurePost:(BBPostEntity *)aPost {
	self.postTitle.text = aPost.title;
	self.postDate.text = [BBDateConvertor convertDate:aPost.date];
	
	if (self.authorLogin) {
		self.authorLogin.text = [NSString stringWithFormat:@"posted by %@", aPost.user.login];
	}
	
	if (self.avatar) {
		[self.avatar setBlobImage:aPost.user.blobID];
	}
}

@end
