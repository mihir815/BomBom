//
//  BBUserDataCellCell.m
//  BomBom
//
//  Created by Alexey Kolmyk on 17.12.13.
//  Copyright (c) 2013 SonnyBlack. All rights reserved.
//

#import "BBUserDataCellCell.h"

@implementation BBUserDataCellCell

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

-(void) configureFieldWithTopText:(NSString *)topText
					   bottomText:(NSString *)bottomText
						 delegate:(id)delegate
							 type:(BBProfileCellType)aType {
	
	self.delegate = delegate;
	self.type = aType;
	self.topLabel.text = topText;
	
	if (bottomText.length == 0) {
		self.bottomLabel.textColor = [UIColor grayColor];
		bottomText = @"Empty";
	}else{
		self.bottomLabel.textColor = [UIColor blackColor];
	}
	
	self.bottomLabel.text = bottomText;
}

@end
