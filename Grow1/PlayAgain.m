//
//  PlayAgain.m
//  Grow1
//
//  Created by Claire on 4/28/14.
//  Copyright (c) 2014 Calvin Hildreth. All rights reserved.
//

#import "PlayAgain.h"

@implementation PlayAgain

+(PlayAgain *)createPlayAgainButtonContents
{
    PlayAgain *playAgainButton = [[PlayAgain alloc] initWithImageNamed:@"PlayAgainButton.png"];
    playAgainButton.position = CGPointMake(330, 600);
    playAgainButton.size = CGSizeMake(278, 111);
    playAgainButton.zPosition = 10;
    NSLog(@"buttontime");
    return playAgainButton;

}
@end
