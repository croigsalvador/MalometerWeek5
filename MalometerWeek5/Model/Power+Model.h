//
//  Power+Model.h
//  MalometerWeek5
//
//  Created by Carlos Roig Salvador on 03/07/14.
//  Copyright (c) 2014 IronHack. All rights reserved.
//

#import "Power.h"

extern NSString * const kPowerEntityKey;

@interface Power (Model)
+ (Power *)fetchPowerWithName:(NSString *)name inManagedObjectConext:(NSManagedObjectContext *)context;
@end
