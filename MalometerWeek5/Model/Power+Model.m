//
//  Power+Model.m
//  MalometerWeek5
//
//  Created by Carlos Roig Salvador on 03/07/14.
//  Copyright (c) 2014 IronHack. All rights reserved.
//

#import "Power+Model.h"

NSString * const kPowerEntityKey                         = @"Power";
NSString * const kNamePropertyKey                        = @"name";


@implementation Power (Model)

+ (Power *)fetchPowerWithName:(NSString *)name inManagedObjectConext:(NSManagedObjectContext *)context {
    Power *power;
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:kPowerEntityKey];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:kNamePropertyKey ascending:YES]];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"name == %@", name];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:fetchRequest error:&error];
    
    if (matches) {
        power = [matches lastObject];
    }
    return power;
}

@end
