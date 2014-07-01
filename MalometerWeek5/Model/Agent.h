//
//  Agent.h
//  MalometerWeek5
//
//  Created by Carlos Roig Salvador on 01/07/14.
//  Copyright (c) 2014 IronHack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Domain;

@interface Agent : NSManagedObject

@property (nonatomic, retain) NSNumber * assesment;
@property (nonatomic, retain) NSNumber * destructionPower;
@property (nonatomic, retain) NSNumber * motivation;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * pictureURL;
@property (nonatomic, retain) NSManagedObject *category;
@property (nonatomic, retain) NSSet *domains;
@end

@interface Agent (CoreDataGeneratedAccessors)

- (void)addDomainsObject:(Domain *)value;
- (void)removeDomainsObject:(Domain *)value;
- (void)addDomains:(NSSet *)values;
- (void)removeDomains:(NSSet *)values;

@end