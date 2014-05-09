//
//  Page.m
//  Grow1
//
//  Created by Calvin Hildreth on 4/22/14.
//  Copyright (c) 2014 Calvin Hildreth. All rights reserved.
//

#import "Page.h"

@implementation Page

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.pageText forKey:@"pageText"];
    [aCoder encodeObject:self.choices forKey:@"choices"];
    NSNumber *isGoodEnding = [NSNumber numberWithBool:self.isGoodEnding];
    NSNumber *indexOfPage = [NSNumber numberWithInt:self.indexOfPage];
    [aCoder encodeObject:isGoodEnding forKey:@"isGoodEnding"];
    [aCoder encodeObject:indexOfPage forKey:@"indexOfPage"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super init])) {
        self.pageText = [aDecoder decodeObjectForKey:@"pageText"];
        self.choices = [aDecoder decodeObjectForKey:@"choices"];
        NSNumber *isGoodEnding = [aDecoder decodeObjectForKey:@"isGoodEnding"];
        NSNumber *indexOfPage = [aDecoder decodeObjectForKey:@"indexOfPage"];
        self.isGoodEnding = isGoodEnding.boolValue;
        self.indexOfPage = indexOfPage.intValue;
    }
    
    return self;
}

@end
