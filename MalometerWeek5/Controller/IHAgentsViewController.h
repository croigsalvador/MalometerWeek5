//
//  IHMasterViewController.h
//  MalometerWeek5
//
//  Created by Carlos Roig Salvador on 30/06/14.
//  Copyright (c) 2014 IronHack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IHDismissProtocol.h"
#import <CoreData/CoreData.h>

@interface IHAgentsViewController : UITableViewController <NSFetchedResultsControllerDelegate, IHDismissProtocol>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
