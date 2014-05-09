//
//  FirstRunObject.m
//  Grow1
//
//  Created by Calvin Hildreth on 4/30/14.
//  Copyright (c) 2014 Calvin Hildreth. All rights reserved.
//

#import "FirstRunObject.h"

@implementation FirstRunObject

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    NSNumber *isFirstRun = [NSNumber numberWithBool:self.isFirstRun];
    [aCoder encodeObject:isFirstRun forKey:@"isFirstRun"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        NSNumber *isFirstRun = [aDecoder decodeObjectForKey:@"isFirstRun"];
        self.isFirstRun = isFirstRun.boolValue;
    }
    return self;
}

@end
