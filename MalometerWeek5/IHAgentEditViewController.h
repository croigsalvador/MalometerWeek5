//
//  IHDetailViewController.h
//  MalometerWeek5
//
//  Created by Carlos Roig Salvador on 30/06/14.
//  Copyright (c) 2014 IronHack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IHDismissProtocol.h"


@interface IHAgentEditViewController : UIViewController

@property (strong, nonatomic) id agent;

@property (nonatomic, weak) id <IHDismissProtocol> delegate;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
