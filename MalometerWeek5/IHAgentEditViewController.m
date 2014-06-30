//
//  IHDetailViewController.m
//  MalometerWeek5
//
//  Created by Carlos Roig Salvador on 30/06/14.
//  Copyright (c) 2014 IronHack. All rights reserved.
//

#import "IHAgentEditViewController.h"
#import "Agent.h"

@interface IHAgentEditViewController ()
@property (weak, nonatomic) IBOutlet UILabel *destructionPowerLabel;
@property (weak, nonatomic) IBOutlet UIStepper *destructionStepper;
@property (weak, nonatomic) IBOutlet UILabel *motivationLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIStepper *motivationStepper;
@property (weak, nonatomic) IBOutlet UILabel *assesmentLabel;

@property (strong, nonatomic) NSArray *destructionPowers;
@property (strong, nonatomic) NSArray *motivations;
@property (strong, nonatomic) NSArray *assesments;

@property (nonatomic, getter = isModified) BOOL modified;

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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.agent addObserver:self forKeyPath:@"destructionPower" options:0 context:NULL];
    [self.agent addObserver:self forKeyPath:@"motivation" options:0 context:NULL];
    [self.agent addObserver:self forKeyPath:@"assesment" options:0 context:NULL];

}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.agent removeObserver:self forKeyPath:@"destructionPower"];
    [self.agent removeObserver:self forKeyPath:@"motivation"];
    [self.agent removeObserver:self forKeyPath:@"assesment"];
}

#pragma mark - Setup Methods

- (void)setupDefaultLabelValues {
    self.destructionPowerLabel.text = self.destructionPowers[[[self.agent valueForKey:@"destructionPower"] intValue]];
    self.motivationLabel.text = self.motivations[[[self.agent valueForKey:@"motivation"] intValue]];
    self.assesmentLabel.text = self.assesments[[self.agent.assesment intValue]];
}

- (void)setupArrays {
    self.destructionPowers = @[@"Patoso",@"Debil",@"Neutro", @"Macho", @"Terminator"];
    self.motivations = @[@"Vamos", @"Me aburro", @"Me como el mundo", @"Me la pela", @"GO GO GO"];
    self.assesments = @[@"Come on",@"GO", @"Amazing", @"Pepe", @"Hola"];
}

#pragma mark - Action Methods

- (IBAction)cancelButtonPressed:(UIBarButtonItem *)sender {
    if ([self.delegate respondsToSelector:@selector(modifiedDataInController:modified:)]) {
        [self.delegate modifiedDataInController:self modified:self.isModified];
    }
}

- (IBAction)saveButtonPressed:(id)sender {
    self.modified = YES;
    [self.nameTextField resignFirstResponder];
    self.agent.name = self.nameTextField.text;
}

- (IBAction)destructionPowerChanged:(UIStepper *)sender {
    NSUInteger value =(NSUInteger)sender.value;
    self.agent.destructionPower = [NSNumber numberWithInt:value];
}

- (IBAction)motivationValueChanged:(UIStepper *)sender {
    NSUInteger value =(NSUInteger)sender.value;
    self.motivationLabel.text = self.motivations[value];
    self.agent.motivation =[NSNumber numberWithInt:value];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    Agent *agent = (Agent *) object;
    if ([keyPath isEqualToString:@"destructionPower"]) {
        self.destructionPowerLabel.text = self.destructionPowers[[agent.destructionPower intValue]];
//        self.agent.assesment = self.agent.assesment;
    } else if ([keyPath isEqualToString:@"motivation"]) {
        self.motivationLabel.text = self.motivations[[agent.motivation intValue]];
//        self.agent.assesment = self.agent.assesment;
    } else if ([keyPath isEqualToString:@"assesment"]) {
        self.assesmentLabel.text = self.assesments[[agent.assesment intValue]];
    }
}

@end
