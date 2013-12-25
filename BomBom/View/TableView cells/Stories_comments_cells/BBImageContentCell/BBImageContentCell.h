//
//  BBImageContentCell.h
//  BomBom
//
//  Created by Alexey Kolmyk on 20.12.13.
//  Copyright (c) 2013 SonnyBlack. All rights reserved.
//

#import "BBBasicCommentCell.h"

#import "BBImageView.h"

@interface BBImageContentCell : BBBasicCommentCell

@property (nonatomic, weak)	IBOutlet	BBImageView	*postImage;

@end
