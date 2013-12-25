//
//  BBPostDescriptionCell.m
//  BomBom
//
//  Created by Alexey Kolmyk on 18.12.13.
//  Copyright (c) 2013 SonnyBlack. All rights reserved.
//

#import "BBPostDescriptionCell.h"

@implementation BBPostDescriptionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) awakeFromNib {
	[super awakeFromNib];
	
	self.textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
	self.textView.layer.borderWidth = 1.0;
	self.textView.layer.cornerRadius = 10.0;
}

- (UITextView *) getPostTextView {
	return self.textView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
