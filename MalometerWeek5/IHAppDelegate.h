//
//  IHAppDelegate.h
//  MalometerWeek5
//
//  Created by Carlos Roig Salvador on 30/06/14.
//  Copyright (c) 2014 IronHack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IHAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
