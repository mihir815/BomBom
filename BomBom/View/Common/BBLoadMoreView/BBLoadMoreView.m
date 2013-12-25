//
//  BBLoadMoreView.m
//  BomBom
//
//  Created by Alexey Kolmyk on 23.12.13.
//  Copyright (c) 2013 SonnyBlack. All rights reserved.
//

#import "BBLoadMoreView.h"

@interface BBLoadMoreView ()

@property (nonatomic, strong)	UIButton	*button;

@end

@implementation BBLoadMoreView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		
		self.button = [[UIButton alloc] initWithFrame:self.bounds];
		[self.button setTitle:@"Load more" forState:UIControlStateNormal];
		[self addSubview:self.button];
		
		self.layer.borderColor = [UIColor blackColor].CGColor;
		self.layer.borderWidth = 1.0;
    }
    return self;
}

-(void) setTapSelector:(SEL)selector forTarget:(id)target {
	[self.button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
}

@end
