//
//  BBCommentsContentCell.m
//  BomBom
//
//  Created by Alexey Kolmyk on 19.12.13.
//  Copyright (c) 2013 SonnyBlack. All rights reserved.
//

#import "BBTextContentCell.h"

@implementation BBTextContentCell

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
	self.postContent.text = post.content;
//	self.postContent.layer.borderColor = [UIColor redColor].CGColor;
//	self.postContent.layer.borderWidth = 1.0;
//	
//	self.contentView.layer.borderColor = [UIColor redColor].CGColor;
//	self.contentView.layer.borderWidth = 1.0;
}

@end
