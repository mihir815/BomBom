//
//  BBAvatarCell.h
//  BomBom
//
//  Created by Alexey Kolmyk on 17.12.13.
//  Copyright (c) 2013 SonnyBlack. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BBProfileCell.h"
#import "BBImageView.h"

@interface BBAvatarCell : BBProfileCell

@property (nonatomic, weak) IBOutlet	BBImageView		*avatar;

@end
