//
//  IHDetailViewController.m
//  MalometerWeek5
//
//  Created by Carlos Roig Salvador on 30/06/14.
//  Copyright (c) 2014 IronHack. All rights reserved.
//

#import "IHDetailViewController.h"

@interface IHDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *destructionPowerLabel;
@property (weak, nonatomic) IBOutlet UIStepper *destructionStepper;
@property (weak, nonatomic) IBOutlet UILabel *motivationLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIStepper *motivationStepper;

@property (strong, nonatomic) NSArray *destructionPowers;
@property (strong, nonatomic) NSArray *motivations;

- (void)configureView;
@end

@implementation IHDetailViewController

#pragma mark - Managing the detail item

- (void)setAgent:(id)newDetailItem
{
    if (_agent != newDetailItem) {
        _agent = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.agent) {
        self.detailDescriptionLabel.text = [[self.agent valueForKey:@"timeStamp"] description];
    }
}

#pragma mark - Lifecycle Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    [self setupArrays];
}

#pragma mark - Setup Methods

- (void)setupArrays {
    self.destructionPowers = @[@"Patoso",@"Debil",@"Neutro", @"Macho", @"Terminator"];
    self.motivations = @[@"Vamos", @"Me aburro", @"Me como el mundo", @"Me la pela", @"GO GO GO"];
}

#pragma mark - Action Methods

- (IBAction)cancelButtonPressed:(UIBarButtonItem *)sender {
    [self.delegate modifiedData];
}
- (IBAction)saveButtonPressed:(id)sender {
}


@end
