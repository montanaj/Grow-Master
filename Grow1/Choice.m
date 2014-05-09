//
//  Choice.m
//  Grow1
//
//  Created by Calvin Hildreth on 4/22/14.
//  Copyright (c) 2014 Calvin Hildreth. All rights reserved.
//

#import "Choice.h"

@implementation Choice

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    NSNumber *indexToNextPage = [NSNumber numberWithInt:self.indexToNextPage];
    [aCoder encodeObject:indexToNextPage forKey:@"indexToNextPage"];
    [aCoder encodeObject:self.buttonText forKey:@"buttonText"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super init]))
    {
        self.buttonText = [aDecoder decodeObjectForKey:@"buttonText"];
        NSNumber *indexToNextPage = [aDecoder decodeObjectForKey:@"indexToNextPage"];
        self.indexToNextPage = indexToNextPage.intValue;
    }
    return self;
}
@end
