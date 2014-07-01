//
//  FreakType+Model.h
//  MalometerWeek5
//
//  Created by Carlos Roig Salvador on 01/07/14.
//  Copyright (c) 2014 IronHack. All rights reserved.
//

#import "FreakType.h"

extern NSString * const kFreakTypeEntityNameKey;
extern NSString * const kPropertyNameKey;

@interface FreakType (Model)

+ (instancetype)initWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context;
+ (FreakType *)giveFreakTypeWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end
