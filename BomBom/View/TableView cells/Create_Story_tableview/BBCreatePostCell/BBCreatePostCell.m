//
//  BBCreatePostCell.m
//  BomBom
//
//  Created by Alexey Kolmyk on 18.12.13.
//  Copyright (c) 2013 SonnyBlack. All rights reserved.
//

#import "BBCreatePostCell.h"

@implementation BBCreatePostCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(IBAction)createPost:(id)sender {
	if (self.delegate && [self.delegate respondsToSelector:@selector(createPostDidPressed)]) {
		[self.delegate createPostDidPressed];
	}
}

@end
