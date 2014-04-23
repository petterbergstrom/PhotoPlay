//
//  MccMemoryCard.m
//  Memory
//
//  Created by Petter Bergström on 2014-03-23.
//  Copyright (c) 2014 McCoy. All rights reserved.
//

#import "MccMemoryCard.h"
#import "MccGrapicsUtil.h"

@implementation MccMemoryCard



- (UIImage*) getCardImage:(CGSize) size{
    NSString *key = [self getImageKey:size];
    if ([MccMemoryCard.createdImagesDictionary objectForKey:key]==nil) {
        UIImage *newCard  = [MccGrapicsUtil createCardImage:_image size:size];
        [MccMemoryCard.createdImagesDictionary  setObject:newCard forKey:key];
    }
    return [MccMemoryCard.createdImagesDictionary objectForKey:key];
}



- (NSString*) getImageKey:(CGSize) size{
    return [NSString stringWithFormat:@"%lu w%f h%f",(unsigned long)_image.hash, size.width, size.height];
}

+(NSMutableDictionary*) createdImagesDictionary
{
    static NSMutableDictionary* sCreatedImagesDictionary = nil;
    
    if (nil == sCreatedImagesDictionary)
    {
        sCreatedImagesDictionary = [[NSMutableDictionary alloc]init];
    }
    
    return sCreatedImagesDictionary;
}
@end
