//
//  BBPostImageCell.m
//  BomBom
//
//  Created by Alexey Kolmyk on 18.12.13.
//  Copyright (c) 2013 SonnyBlack. All rights reserved.
//

#import "BBPostImageCell.h"

@implementation BBPostImageCell

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

-(void)awakeFromNib {
	[super awakeFromNib];
	
	self.postImage.layer.backgroundColor = [UIColor lightGrayColor].CGColor;
	self.postImage.layer.borderColor = [UIColor grayColor].CGColor;
	self.postImage.layer.borderWidth = 2;
}

- (void) configurePostImage:(UIImage *)postImage {
	self.postImage.image = postImage;
}

-(IBAction)tapOnImage:(id)sender {
	[self selectImage:sender];
}

-(IBAction)selectImage:(id)sender {
	if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectImagePressed)]) {
		[self.delegate didSelectImagePressed];
	}
}

-(IBAction)clearImage:(id)sender {
	if (self.delegate && [self.delegate respondsToSelector:@selector(didCancelImagePressed)]) {
		[self.delegate didCancelImagePressed];
	}
}

@end
