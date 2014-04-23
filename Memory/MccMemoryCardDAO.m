//
//  MccMemoryCardDAO.m
//  Memory
//
//  Created by Petter Bergström on 2014-03-25.
//  Copyright (c) 2014 McCoy. All rights reserved.
//

#import "MccMemoryCardDAO.h"
#import "MemoryCard.h"
#import "MccAppDelegate.h"
#import "MccMemoryCard.h"

@interface MccMemoryCardDAO ()

@property (nonatomic, retain) NSManagedObjectContext* managedObjectContext;

@end

@implementation MccMemoryCardDAO

@synthesize managedObjectContext;

-(NSArray *) getAllCards{
    NSManagedObjectContext *context = [self getManagedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MemoryCard" inManagedObjectContext:context];
    [request setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:request error:&error];
    for (MemoryCard *card in fetchedObjects) {
        NSLog(@"Label: %@", card.label);
        NSLog(@"DataLength %lu", (unsigned long)[card.imageData length]);
    }
    return fetchedObjects;
}

- (MemoryCard*) insertCard:(NSString*)label  image:(UIImage*) image{
    NSManagedObjectContext *context = [self getManagedObjectContext];
    MemoryCard *persistedCard = [NSEntityDescription
                                      insertNewObjectForEntityForName:@"MemoryCard"
                                      inManagedObjectContext:context];
    persistedCard.label = label;
    persistedCard.imageData = UIImagePNGRepresentation(image);
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Couldn't save: %@", [error localizedDescription]);
    }
    return persistedCard;
}

- (void) deleteCard:(MemoryCard*) cardToDelete{
    NSManagedObjectContext *context = [self getManagedObjectContext];
    [context deleteObject:cardToDelete];
}

- (NSManagedObjectContext *) getManagedObjectContext{
    if (self.managedObjectContext == nil) {
        MccAppDelegate *appDelegate = (MccAppDelegate *)[[UIApplication sharedApplication] delegate];
        self.managedObjectContext = [appDelegate managedObjectContext];
    }
    return self.managedObjectContext;
}

+ (MccMemoryCard*) convertToMccMemoryCard:(MemoryCard*) memoryCard{
    MccMemoryCard* card = [MccMemoryCard alloc];
    card.card  = memoryCard;
    card.label = memoryCard.label;
    card.image = [[UIImage alloc]initWithData:memoryCard.imageData];
    return card;
}



+ (MccMemoryCardDAO *)sharedSingleton
//SIngleton implenentation
{
    static MccMemoryCardDAO *sharedSingleton;
    
    @synchronized(self)
    {
        if (!sharedSingleton)
            sharedSingleton = [[MccMemoryCardDAO alloc] init];
        
        return sharedSingleton;
    }
}


@end
