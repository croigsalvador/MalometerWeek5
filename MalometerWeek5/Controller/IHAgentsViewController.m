//
//  IHMasterViewController.m
//  MalometerWeek5
//
//  Created by Carlos Roig Salvador on 30/06/14.
//  Copyright (c) 2014 IronHack. All rights reserved.
//

#import "IHAgentsViewController.h"
#import "IHAgentEditViewController.h"
#import "Agent+Model.h"

static NSString *kSegueIdentifier       = @"CreateAgent";
static NSString *kAgentKey              = @"Agent";

@interface IHAgentsViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation IHAgentsViewController
@synthesize undoManager;
- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}


#pragma mark -
#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self.managedObjectContext.undoManager beginUndoGrouping];
    if ([[segue identifier] isEqualToString:kSegueIdentifier]) {
        [self moveToDetailsViewControllerWithSegue:segue];
    } else {
        [self moveToCellDetailsControllerWithSegue:segue andSender:sender];
    }
}

- (void)moveToCellDetailsControllerWithSegue:(UIStoryboardSegue *)segue andSender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    Agent *agent = [self.fetchedResultsController objectAtIndexPath:indexPath];
    IHAgentEditViewController *detailsViewController =(IHAgentEditViewController *) [[segue destinationViewController]topViewController];
    detailsViewController.agent = agent;
    detailsViewController.delegate = self;
}

- (void)moveToDetailsViewControllerWithSegue:(UIStoryboardSegue *)segue {
    Agent *agent = [NSEntityDescription insertNewObjectForEntityForName:kAgentKey inManagedObjectContext:self.managedObjectContext];
    UINavigationController *navViewController = [segue destinationViewController];
    IHAgentEditViewController *detailsViewController =  [navViewController.viewControllers lastObject];
    detailsViewController.agent = agent;
    detailsViewController.delegate = self;
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}


- (void) displayControlledDomainsInTitle {
    NSError *error;
    NSUInteger controlledDomains = [self.managedObjectContext countForFetchRequest:[Domain fetchRequestControlledDomains] error:&error];
        
    self.title = [NSString stringWithFormat:@"Controlled domains: %d", controlledDomains];
}


#pragma mark - Fetched results controller

- (NSFetchedResultsController *) fetchedResultsController {
    if (_fetchedResultsController == nil) {
        [NSFetchedResultsController deleteCacheWithName:@"Agents"];
        NSSortDescriptor *categoryNameSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"category.name" ascending:YES];
        NSSortDescriptor *destPowSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:kDestructionPowerKey ascending:NO];
        NSSortDescriptor *nameSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:kNameKey ascending:YES];
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:[Agent fetchAllAgentsWithSortDescriptors:@[categoryNameSortDescriptor, destPowSortDescriptor, nameSortDescriptor]]managedObjectContext:self.managedObjectContext
                                                        sectionNameKeyPath:nil
                                                        sectionNameKeyPath:@"category.name"
                                                                 cacheName:@"Agents"];
    
    _fetchedResultsController.delegate = self;
    }
}




- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
    [self displayControlledDomainsInTitle];
}
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}



- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Agent *agent = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [agent.name description];
}

#pragma mark -
#pragma mark - Details Delegate methods

- (void)modifiedDataInController:(IHAgentEditViewController *)controller modified:(BOOL)modified {
    [self.managedObjectContext.undoManager setActionName:@"Bad Action"];
    [self.managedObjectContext.undoManager endUndoGrouping];
    if (!modified) {
        [self.managedObjectContext.undoManager undo];
    } else {
        [self saveContext];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Core Data Save

- (void) saveContext {
    // Save the context.
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

@end
