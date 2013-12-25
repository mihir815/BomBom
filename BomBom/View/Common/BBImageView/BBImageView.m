//
//  BBImageView.m
//  BomBom
//
//  Created by Alexey Kolmyk on 22.12.13.
//  Copyright (c) 2013 SonnyBlack. All rights reserved.
//

#import "BBImageView.h"
#import "UIImageView+QBContent.h"

@interface BBImageView ()

@property (nonatomic, strong)	UIActivityIndicatorView	*spinner;

@end

@implementation BBImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

//-(id)initWithCoder:(NSCoder *)aDecoder {
//	self = [super initWithCoder:aDecoder];
//	if (self) {
//		[self setup];
//	}
//	return self;
//}

-(void)awakeFromNib {
	[super awakeFromNib];
	
	[self setup];
}

-(void)setup {
	self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	self.spinner.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
	[self addSubview:self.spinner];
	[self.spinner startAnimating];
}

-(void)setBlobImage:(NSUInteger)aBlobId {
	[self loadImageWithBlobId:aBlobId completion:^(BOOL isLoaded, NSError *anError) {
		if (isLoaded){
			[self.spinner stopAnimating];
			[self.spinner removeFromSuperview];
		}
	}];
}

@end
