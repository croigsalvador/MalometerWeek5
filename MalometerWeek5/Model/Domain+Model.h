//
//  Domain+Model.h
//  MalometerWeek5
//
//  Created by Carlos Roig Salvador on 01/07/14.
//  Copyright (c) 2014 IronHack. All rights reserved.
//

#import "Domain.h"

@interface Domain (Model)

+ (instancetype)initWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context;
+ (Domain *)giveDomainTypeWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end
