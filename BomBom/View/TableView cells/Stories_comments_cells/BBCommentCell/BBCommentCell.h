//
//  BBCommentCell.h
//  BomBom
//
//  Created by Alexey Kolmyk on 19.12.13.
//  Copyright (c) 2013 SonnyBlack. All rights reserved.
//

#import "BBBasicCommentCell.h"

#import "BBImageView.h"

@interface BBCommentCell : BBBasicCommentCell

@property (nonatomic, weak) IBOutlet	UILabel			*autorName;
@property (nonatomic, weak) IBOutlet	UILabel			*comment;
@property (nonatomic, weak) IBOutlet	UILabel			*date;
@property (nonatomic, weak) IBOutlet	BBImageView		*avatar;

@end
