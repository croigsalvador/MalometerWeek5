//
//  Agent+Model.m
//  MalometerWeek5
//
//  Created by Carlos Roig Salvador on 30/06/14.
//  Copyright (c) 2014 IronHack. All rights reserved.
//

#import "Agent+Model.h"

NSString * const kAssesmentKey                 = @"assesment";
NSString * const kDestructionPowerKey          = @"destructionPower";
NSString * const kMotivationKey                = @"motivation";

@implementation Agent (Model)

- (void)setDestructionPower:(NSNumber *)destructionPower {
    [self willChangeValueForKey:kDestructionPowerKey];
    [self setPrimitiveValue:destructionPower forKey:kDestructionPowerKey];
    [self didChangeValueForKey:kDestructionPowerKey];
}

- (void)setMotivation:(NSNumber *)motivation {
    [self willChangeValueForKey:kMotivationKey];
    [self setPrimitiveValue:motivation forKey:kMotivationKey];
    [self didChangeValueForKey:kMotivationKey];
}

- (NSNumber *)assesment {
    return [NSNumber numberWithInt:([self.destructionPower intValue]+ [self.motivation intValue]) /2];
}

//+ (NSSet *)keyPathsForValuesAffectingAssesment {
//    return [NSSet setWithObjects:kDestructionPowerKey,kMotivationKey, nil];
//}


@end
