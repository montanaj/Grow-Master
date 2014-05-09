//
//  Choice.h
//  Grow1
//
//  Created by Calvin Hildreth on 4/22/14.
//  Copyright (c) 2014 Calvin Hildreth. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Choice : NSObject<NSCoding>
@property (strong, nonatomic) NSString *buttonText;
@property int indexToNextPage;
@end
