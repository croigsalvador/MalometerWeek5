//
//  IHDetailViewController.h
//  MalometerWeek5
//
//  Created by Carlos Roig Salvador on 30/06/14.
//  Copyright (c) 2014 IronHack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IHDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
