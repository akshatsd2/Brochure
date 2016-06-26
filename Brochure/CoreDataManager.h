//
//  CoreDataManager.h
//  Brochure
//
//  Created by Akshat Mittal on 26/06/16.
//  Copyright © 2016 Akshat Mittal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

extern NSString * const DataManagerDidSaveNotification;
extern NSString * const DataManagerDidSaveFailedNotification;

@interface CoreDataManager : NSObject
{
}

@property (nonatomic, readonly, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, readonly, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, readonly, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (CoreDataManager *)sharedInstance;
- (BOOL)save;
- (NSURL *)applicationDocumentsDirectory;

@end
