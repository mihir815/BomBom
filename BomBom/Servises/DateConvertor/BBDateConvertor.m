//
//  BBDateConvertor.m
//  BomBom
//
//  Created by Alexey Kolmyk on 19.12.13.
//  Copyright (c) 2013 SonnyBlack. All rights reserved.
//

#import "BBDateConvertor.h"

@implementation BBDateConvertor

static NSDateFormatter *formatter;

+(NSString *)convertDate:(NSDate *)aDate {
	if (!formatter) {
		formatter = [NSDateFormatter new];
	}
	
	formatter.dateFormat = @"HH:mm dd.MM.YYYY";
	NSString *retVal = [formatter stringFromDate:aDate];
	return retVal;
}

@end
