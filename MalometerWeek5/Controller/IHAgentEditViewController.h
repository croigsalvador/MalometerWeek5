//
//  IHDetailViewController.h
//  MalometerWeek5
//
//  Created by Carlos Roig Salvador on 30/06/14.
//  Copyright (c) 2014 IronHack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IHDismissProtocol.h"

@class Agent;

@interface IHAgentEditViewController : UIViewController

@property (strong, nonatomic) Agent *agent;
@property (nonatomic, weak) id <IHDismissProtocol> delegate;

@end
