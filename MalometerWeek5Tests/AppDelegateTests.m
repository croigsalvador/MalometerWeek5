//
//  AppDelegateTests.m
//  MalometerWeek5
//
//  Created by Carlos Roig Salvador on 01/07/14.
//  Copyright (c) 2014 IronHack. All rights reserved.
//


#import <XCTest/XCTest.h>
//#import <OCMock/OCMock.h>
#import "IHAppDelegate.h"

@interface FakeMOC : NSManagedObjectContext

@property (nonatomic) BOOL hasSave;

@end

@implementation FakeMOC

- (BOOL)hasChanges {
    return NO;
}

- (BOOL)save:(NSError *__autoreleasing *)error {
    self.hasSave = YES;
    return self.hasSave;
}

@end



@interface AppDelegateTests : XCTestCase {
    // Core Data stack objects.
    NSManagedObjectModel *model;
    NSPersistentStoreCoordinator *coordinator;
    NSPersistentStore *store;
    NSManagedObjectContext *context;
    // Object to test.
    IHAppDelegate *sut;
}

@end


@implementation AppDelegateTests

#pragma mark - Set up and tear down

- (void) setUp {
    [super setUp];

//    [self createCoreDataStack];
    [self createFixture];
    [self createSut];
}


- (void) createCoreDataStack {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    model = [NSManagedObjectModel mergedModelFromBundles:@[bundle]];
    coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    store = [coordinator addPersistentStoreWithType: NSInMemoryStoreType
                                      configuration: nil
                                                URL: nil
                                            options: nil
                                              error: NULL];
    context = [[NSManagedObjectContext alloc] init];
    context.persistentStoreCoordinator = coordinator;
}


- (void) createFixture {
    // Test data
}


- (void) createSut {
    sut = [[IHAppDelegate alloc] init];
}


- (void) tearDown {
    [self releaseSut];
    [self releaseFixture];
//    [self releaseCoreDataStack];

    [super tearDown];
}


- (void) releaseSut {
    sut = nil;
}


- (void) releaseFixture {

}


- (void) releaseCoreDataStack {
    context = nil;
    store = nil;
    coordinator = nil;
    model = nil;
}


#pragma mark - Basic test

- (void) testObjectIsNotNil {
    // Prepare

    // Operate

    // Check
    XCTAssertNotNil(sut, @"The object to test must be created in setUp.");
}

- (void) testModelObjectContextIsNotNill {
    // Prepare
    // Operate

    // Check
    XCTAssertNotNil(sut.managedObjectContext, @"The object to test must be created in setUp.");
}

- (void)testDoesntSaveWithNotChange {
    // Prepare (Arrange)
    FakeMOC *moc = [[FakeMOC alloc] init];
    [sut setValue:moc forKey:@"managedObjectContext"];
    // Operate (Act)
    [sut saveContext];
    // Check
    XCTAssertFalse(moc.hasSave, @"Moc save must not be called if there isn't changes");
}

- (void)testAppDocumentDirectoryIsNotNil{
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    XCTAssertNotNil(documentsPath, @"The object is nil");
}
- (void)testManagedObjectModelIsCreated{
    FakeMOC *moc = [[FakeMOC alloc] init];
    [sut setValue:moc forKey:@"managedObjectContext"];
    NSManagedObjectModel *moModel = sut.managedObjectModel;
    XCTAssertNotNil(moModel, @"The object is nil");
}
- (void)testManagedObjectPersistentStoreIsNotNil{
    NSPersistentStoreCoordinator *coordinatorPersistent = sut.persistentStoreCoordinator;
    XCTAssertNotNil(coordinatorPersistent, @"The object is nil");
}





@end
