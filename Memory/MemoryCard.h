//
//  MemoryCard.h
//  Memory
//
//  Created by Petter Bergström on 2014-03-25.
//  Copyright (c) 2014 McCoy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MemoryCard : NSManagedObject

@property (nonatomic, retain) NSString * label;
@property (nonatomic, retain) NSData * imageData;

@end
