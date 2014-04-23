//
//  MccMemoryCardDAO.h
//  Memory
//
//  Created by Petter Bergström on 2014-03-25.
//  Copyright (c) 2014 McCoy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MemoryCard.h"
#import "MccMemoryCard.h"

@interface MccMemoryCardDAO : NSObject

-(NSArray *) getAllCards;
-(MemoryCard*) insertCard:(NSString*)label  image:(UIImage*) image;
- (void) deleteCard:(MemoryCard*) cardToDelete;


+ (MccMemoryCard*) convertToMccMemoryCard:(MemoryCard*) memoryCard;
+ (MccMemoryCardDAO *)sharedSingleton;
@end
