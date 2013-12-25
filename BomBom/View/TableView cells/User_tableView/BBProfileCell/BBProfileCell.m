//
//  BBProfileCell.m
//  BomBom
//
//  Created by Alexey Kolmyk on 17.12.13.
//  Copyright (c) 2013 SonnyBlack. All rights reserved.
//

#import "BBProfileCell.h"

@implementation BBProfileCell

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

-(IBAction)buttonDidPressed:(id)sender {
	
	if (self.delegate && [self.delegate respondsToSelector:@selector(changeUserData:)]) {
		[self.delegate changeUserData:self.type];
	}
}

-(void) configureFieldWithTopText:(NSString *)topText
					   bottomText:(NSString *)bottomText
						 delegate:(id)delegate
							 type:(BBProfileCellType)aType {
	
}

-(void) configureForAvatar:(NSUInteger)blobID
				  delegate:(id)delegate
					  type:(BBProfileCellType)aType {
	
}

@end
