//
//  Domain+Model.m
//  MalometerWeek5
//
//  Created by Carlos Roig Salvador on 01/07/14.
//  Copyright (c) 2014 IronHack. All rights reserved.
//

#import "Domain+Model.h"
NSString * const kDomainEntityNameKey            = @"Domain";
NSString * const kPropertyNameKey                = @"name";

@implementation Domain (Model)

+ (instancetype)initWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context{
    Domain *domain = [NSEntityDescription insertNewObjectForEntityForName:kDomainEntityNameKey inManagedObjectContext:context];
    domain.name = name;
    return domain;
}

+ (Domain *)giveDomainTypeWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    Domain *domain;
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:kDomainEntityNameKey];
    NSSortDescriptor *nameSortDescriptor = [[NSSortDescriptor alloc] initWithKey:kPropertyNameKey
                                                                       ascending:YES];
    fetchRequest.sortDescriptors = @[nameSortDescriptor];
    
    NSError *error;
    NSArray *matches = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (matches){
        domain = [matches lastObject];
    }
    return domain;
}
@end
