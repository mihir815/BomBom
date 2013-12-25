//
//  BBTextField.m
//  BomBom
//
//  Created by Alexey Kolmyk on 16.12.13.
//  Copyright (c) 2013 SonnyBlack. All rights reserved.
//

#import "BBTextField.h"

@implementation BBTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
		self.layer.borderColor = [UIColor blackColor].CGColor;
		self.layer.borderWidth = 1.0;
		self.layer.cornerRadius = 10.0;
		self.layer.backgroundColor = [UIColor whiteColor].CGColor;

	}
	return self;
}

//-(void)awakeFromNib {
//	[super awakeFromNib];
//	
//	self.layer.borderColor = [UIColor blackColor].CGColor;
//	self.layer.borderWidth = 1.0;
//	self.layer.cornerRadius = 10.0;
//	self.layer.backgroundColor = [UIColor whiteColor].CGColor;
//}

@end
