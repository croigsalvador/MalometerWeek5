//
//  FreakType+Model.m
//  MalometerWeek5
//
//  Created by Carlos Roig Salvador on 01/07/14.
//  Copyright (c) 2014 IronHack. All rights reserved.
//

#import "FreakType+Model.h"

NSString * const kFreakTypeEntityNameKey         = @"FreakType";
NSString * const kPropertyNameKey                = @"name";

@implementation FreakType (Model)


+ (instancetype)initWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context{
    FreakType *freakType = [NSEntityDescription insertNewObjectForEntityForName:kFreakTypeEntityNameKey inManagedObjectContext:context];
    freakType.name = name;
    return freakType;
}

+ (FreakType *)giveFreakTypeWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    FreakType *freakType;
   
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:kFreakTypeEntityNameKey];
    NSSortDescriptor *nameSortDescriptor = [[NSSortDescriptor alloc] initWithKey:kPropertyNameKey
                                                                        ascending:YES];
    fetchRequest.sortDescriptors = @[nameSortDescriptor];
    
    NSError *error;
    NSArray *matches = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (matches){
        freakType = [matches lastObject];
    }
    return freakType;
}

@end
