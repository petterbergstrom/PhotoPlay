//
//  NSMutableArray+MccShuffling.m
//  Memory
//
//  Created by Petter Bergström on 2014-03-23.
//  Copyright (c) 2014 McCoy. All rights reserved.
//

#import "NSMutableArray+MccShuffling.h"

@implementation NSMutableArray (MccShuffling)
- (void)shuffle
{
    
    static BOOL seeded = NO;
    if(!seeded)
    {
        seeded = YES;
        srandom(time(NULL));
    }
    
    NSUInteger count = [self count];
    for (NSUInteger i = 0; i < count; ++i) {
        // Select a random element between i and end of array to swap with.
        int nElements = count - i;
        int n = (random() % nElements) + i;
        [self exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}
@end
