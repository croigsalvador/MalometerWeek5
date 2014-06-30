//
//  IHDetailViewController.m
//  MalometerWeek5
//
//  Created by Carlos Roig Salvador on 30/06/14.
//  Copyright (c) 2014 IronHack. All rights reserved.
//

#import "IHAgentEditViewController.h"

@interface IHAgentEditViewController ()
@property (weak, nonatomic) IBOutlet UILabel *destructionPowerLabel;
@property (weak, nonatomic) IBOutlet UIStepper *destructionStepper;
@property (weak, nonatomic) IBOutlet UILabel *motivationLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIStepper *motivationStepper;

@property (strong, nonatomic) NSArray *destructionPowers;
@property (strong, nonatomic) NSArray *motivations;

@property (nonatomic, getter = isEditing) BOOL editing;

- (void)configureView;
@end

@implementation IHAgentEditViewController

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
        self.nameTextField.text = [[self.agent valueForKey:@"name"] description];
    }
}

#pragma mark - Lifecycle Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    [self configureView];
    [self setupArrays];
    [self setupDefaultLabelValues];
}

#pragma mark - Setup Methods

- (void)setupDefaultLabelValues {
    self.destructionPowerLabel.text = self.destructionPowers[[[self.agent valueForKey:@"destructionPower"] intValue]];
    self.motivationLabel.text = self.motivations[[[self.agent valueForKey:@"motivation"] intValue]];
    
}

- (void)setupArrays {
    self.destructionPowers = @[@"Patoso",@"Debil",@"Neutro", @"Macho", @"Terminator"];
    self.motivations = @[@"Vamos", @"Me aburro", @"Me como el mundo", @"Me la pela", @"GO GO GO"];
}

#pragma mark - Action Methods

- (IBAction)cancelButtonPressed:(UIBarButtonItem *)sender {
    [self.delegate modifiedData];
}

- (IBAction)saveButtonPressed:(id)sender {
 
        [self.nameTextField resignFirstResponder];
        [self.agent setValue:self.nameTextField.text forKey:@"name"];
        
        NSUInteger value =(NSUInteger)self.destructionStepper.value;
        [self.agent setValue:[NSNumber numberWithInt:value] forKey:@"destructionPower"];
        
        NSUInteger motivationValue = (NSUInteger)self.motivationStepper.value;
        [self.agent setValue:[NSNumber numberWithInt:motivationValue] forKey:@"motivation"];
}

- (IBAction)destructionPowerChanged:(UIStepper *)sender {
    NSUInteger value =(NSUInteger)sender.value;
    self.destructionPowerLabel.text = self.destructionPowers[value];
}

- (IBAction)motivationValueChanged:(UIStepper *)sender {
    NSUInteger value =(NSUInteger)sender.value;
    self.motivationLabel.text = self.motivations[value];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
