//
//  IHDismissProtocol.h
//  MalometerWeek5
//
//  Created by Carlos Roig Salvador on 30/06/14.
//  Copyright (c) 2014 IronHack. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IHAgentEditViewController;

@protocol IHDismissProtocol <NSObject>

- (void)modifiedDataInController:(IHAgentEditViewController *)controller modified:(BOOL)modified;

@end
