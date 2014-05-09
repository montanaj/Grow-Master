//
//  StartButton.m
//  Grow1
//
//  Created by Claire on 4/27/14.
//  Copyright (c) 2014 Calvin Hildreth. All rights reserved.
//

#import "StartButton.h"

@implementation StartButton

-(StartButton *)createStartButtonSceneContents
{
    StartButton *startButtonSprite = [[StartButton alloc] initWithImageNamed:@"StartButton.png"];
    startButtonSprite.zPosition = 150;
    startButtonSprite.size = CGSizeMake(263, 89);
    startButtonSprite.position = CGPointMake(330, 210);
    return startButtonSprite;
}
@end
