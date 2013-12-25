//
//  BBBasicCommentCell.m
//  BomBom
//
//  Created by Alexey Kolmyk on 19.12.13.
//  Copyright (c) 2013 SonnyBlack. All rights reserved.
//

#import "BBBasicCommentCell.h"

@implementation BBBasicCommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) configureForPost:(BBPostEntity *)post {
}

-(void) configureForComment:(BBCommentEntity *)comment {	
}

+(CGFloat) heightForTextInCell:(NSString *)aTitle; {
	
	NSDictionary *attributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:17.0]
														   forKey:NSFontAttributeName];
	
	CGRect rect = [aTitle boundingRectWithSize:CGSizeMake(280.0, 100000.0)
									   options:NSStringDrawingUsesLineFragmentOrigin
									attributes:attributes
									   context:nil];
	
	return rect.size.height + 15.0 + 15.0;
}

+(CGFloat) heightForCommentCell:(NSString *)comment {
	
	NSDictionary *attributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:15.0]
														   forKey:NSFontAttributeName];
	
	CGRect rect = [comment boundingRectWithSize:CGSizeMake(260.0, 100000.0)
										options:NSStringDrawingUsesLineFragmentOrigin
									 attributes:attributes
										context:nil];
	
	// one line, so we hardcode
	CGFloat authorNameHeight = 20.0;
	CGFloat dateNameHeight = 20.0;
	
	
	return 10.0 + rect.size.height + 10.0 + authorNameHeight + 10.0 + dateNameHeight + 10.0;
}

@end
