//
//  BBCommentCell.m
//  BomBom
//
//  Created by Alexey Kolmyk on 19.12.13.
//  Copyright (c) 2013 SonnyBlack. All rights reserved.
//

#import "BBCommentCell.h"

#import "BBDateConvertor.h"

@implementation BBCommentCell

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

-(void) configureForComment:(BBCommentEntity *)comment {
	self.comment.text = comment.comment;
	self.date.text = [BBDateConvertor convertDate:comment.date];
	self.autorName.text = comment.user.login;
	[self.avatar setBlobImage:comment.user.blobID];
}

@end
