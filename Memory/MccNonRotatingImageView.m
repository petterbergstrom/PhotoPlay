//
//  MccNonRotatingImageView.m
//  Memory
//
//  Created by Petter Bergström on 2014-03-29.
//  Copyright (c) 2014 McCoy. All rights reserved.
//

#import "MccNonRotatingImageView.h"

@implementation MccNonRotatingImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
