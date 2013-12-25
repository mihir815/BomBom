//
//  BBAvatarCell.m
//  BomBom
//
//  Created by Alexey Kolmyk on 17.12.13.
//  Copyright (c) 2013 SonnyBlack. All rights reserved.
//

#import "BBAvatarCell.h"


@implementation BBAvatarCell

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


-(void) configureForAvatar:(NSUInteger)blobID
				  delegate:(id)delegate
					  type:(BBProfileCellType)aType {
	
	self.avatar.layer.borderColor = [UIColor whiteColor].CGColor;
	self.avatar.layer.borderWidth = 4.0;
	[self.avatar setBlobImage:blobID];
	
	self.delegate = delegate;
	self.type = aType;
}

@end
