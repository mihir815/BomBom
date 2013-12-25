//
//  BBUserDataCellCell.h
//  BomBom
//
//  Created by Alexey Kolmyk on 17.12.13.
//  Copyright (c) 2013 SonnyBlack. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BBProfileCell.h"

@interface BBUserDataCellCell : BBProfileCell

@property (nonatomic, weak)	IBOutlet	UILabel	*topLabel;
@property (nonatomic, weak)	IBOutlet	UILabel	*bottomLabel;

@end
