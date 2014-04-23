//
//  MccMemoryCard.h
//  Memory
//
//  Created by Petter Bergström on 2014-03-23.
//  Copyright (c) 2014 McCoy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MemoryCard.h"

@interface MccMemoryCard : NSObject

typedef enum cardStates
{
    STATE_FACE_UP,
    STATE_FACE_DOWN,
    STATE_FLIPPED
} CardState;

//@property NSString *imageName;
@property CardState state;
//@property int imageId; //TODO: remove
@property MemoryCard *card;
@property NSString *label;
@property UIImage *image;

- (UIImage*) getCardImage:(CGSize) size;
@end
