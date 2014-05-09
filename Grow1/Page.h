//
//  Page.h
//  Grow1
//
//  Created by Calvin Hildreth on 4/22/14.
//  Copyright (c) 2014 Calvin Hildreth. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Page : NSObject<NSCoding>
@property (strong, nonatomic) NSString *pageText;
@property (strong, nonatomic) NSMutableArray *choices;
@property BOOL isGoodEnding;
@property int indexOfPage;
@end
