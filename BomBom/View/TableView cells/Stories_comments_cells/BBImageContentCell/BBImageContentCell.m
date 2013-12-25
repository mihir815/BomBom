//
//  BBImageContentCell.m
//  BomBom
//
//  Created by Alexey Kolmyk on 20.12.13.
//  Copyright (c) 2013 SonnyBlack. All rights reserved.
//

#import "BBImageContentCell.h"

@implementation BBImageContentCell

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

-(void) configureForPost:(BBPostEntity *)post {
	[self.postImage setBlobImage:post.contentBlobId];
}

@end
