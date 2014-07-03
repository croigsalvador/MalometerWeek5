//
//  AgentToAgentMigrationPolicy.m
//  MalometerWeek5
//
//  Created by Carlos Roig Salvador on 03/07/14.
//  Copyright (c) 2014 IronHack. All rights reserved.
//

#import "AgentToAgentMigrationPolicy.h"
#import "Agent+Model.h"
#import "Power+Model.h"

@implementation AgentToAgentMigrationPolicy

- (BOOL)createDestinationInstancesForSourceInstance:(NSManagedObject *)sInstance entityMapping:(NSEntityMapping *)mapping manager:(NSMigrationManager *)manager error:(NSError *__autoreleasing *)error {
    NSManagedObject *dstInstance = [NSEntityDescription insertNewObjectForEntityForName:mapping.destinationEntityName
                                                                 inManagedObjectContext:manager.destinationContext];
    
    NSArray *dstAttributeKeys = [dstInstance.entity.attributesByName allKeys];
    for (NSString *key in dstAttributeKeys) {
        id value = [sInstance valueForKey:key];
        
        if (value && ![value isEqual:[NSNull null]]) {
            [dstInstance setValue:value forKey:key];
        }
    }

    [self extractPowerInstanceWithName:[sInstance valueForKey:@"power"] relatedWithInstance:dstInstance];
    [manager associateSourceInstance:sInstance
             withDestinationInstance:dstInstance forEntityMapping:mapping];

    return YES;
}



- (void) extractPowerInstanceWithName:(NSString *)name relatedWithInstance:(NSManagedObject *)dstInstance {
    if (name) {
        Power *power = [Power fetchPowerWithName:name inManagedObjectConext:dstInstance.managedObjectContext];
        if (!power) {
            power = [NSEntityDescription insertNewObjectForEntityForName:kPowerEntityKey
                                                  inManagedObjectContext:dstInstance.managedObjectContext];
            power.name = name;
        }
        [power addAgentsObject:(Agent *)dstInstance];
    }
}

@end
