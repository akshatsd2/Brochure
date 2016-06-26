//
//  CoreDataManager.m
//  Brochure
//
//  Created by Akshat Mittal on 26/06/16.
//  Copyright © 2016 Akshat Mittal. All rights reserved.
//

#import "CoreDataManager.h"

NSString * const DataManagerDidSaveNotification = @"DataManagerDidSaveNotification";
NSString * const DataManagerDidSaveFailedNotification = @"DataManagerDidSaveFailedNotification";

@implementation CoreDataManager

@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;

NSString * const kDataManagerModelName = @"BrochureDataModel";
NSString * const kDataManagerSQLiteName = @"BrochureDataModel.sqlite";

+ (CoreDataManager*)sharedInstance
{
    static dispatch_once_t pred;
    static CoreDataManager *sharedInstance = nil;
    
    dispatch_once(&pred, ^{ sharedInstance = [[self alloc] init]; });
    return sharedInstance;
}

- (void)dealloc
{
    
}

- (NSManagedObjectModel*)managedObjectModel
{
    if (_managedObjectModel)
        return _managedObjectModel;
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *modelPath = [bundle pathForResource:kDataManagerModelName ofType:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:[NSURL fileURLWithPath:modelPath]];
    
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator*)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator)
        return _persistentStoreCoordinator;
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:kDataManagerSQLiteName];
    
    /* Define the Core Data version migration options */
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption,
                             nil];
    
    /* Attempt to load the persistent store */
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                   configuration:nil
                                                             URL:storeURL
                                                         options:options
                                                           error:&error]) {
        NSLog(@"Fatal error while creating persistent store: %@", error);
        abort(); //songsData should be removed in release good habit
    }
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext*)managedObjectContext
{
    if (![NSThread isMainThread])
        NSLog(@"MainObjectContext used from thread other than main thread");
    if (_managedObjectContext)
        return _managedObjectContext;
    
    /* Create the main context only on the main thread */
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(managedObjectContext)
                               withObject:nil
                            waitUntilDone:YES];
        return _managedObjectContext;
    }
    
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
    
    return _managedObjectContext;
}
- (BOOL)save
{
    if (![self.managedObjectContext hasChanges])
        return YES;
    
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        //NSLog(@"Error while saving: %@\n%@", [error localizedDescription], [error userInfo]);
        [[NSNotificationCenter defaultCenter] postNotificationName:DataManagerDidSaveFailedNotification
                                                            object:error];
        return NO;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:DataManagerDidSaveNotification object:nil];
    return YES;
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask] lastObject];
}
@end