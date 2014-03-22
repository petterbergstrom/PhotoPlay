//
//  MccAppDelegate.h
//  Memory
//
//  Created by Petter Bergström on 2014-03-22.
//  Copyright (c) 2014 McCoy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MccAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
