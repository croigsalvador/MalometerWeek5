//
//  IHDetailViewController.m
//  MalometerWeek5
//
//  Created by Carlos Roig Salvador on 30/06/14.
//  Copyright (c) 2014 IronHack. All rights reserved.
//

#import "IHAgentEditViewController.h"
#import "Agent+Model.h"
#import "FreakType+Model.h"
#import "Domain+Model.h"

@interface IHAgentEditViewController ()<UIImagePickerControllerDelegate, UIActionSheetDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *destructionPowerLabel;
@property (weak, nonatomic) IBOutlet UIStepper *destructionStepper;
@property (weak, nonatomic) IBOutlet UILabel *motivationLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIStepper *motivationStepper;
@property (weak, nonatomic) IBOutlet UILabel *assesmentLabel;
@property (weak, nonatomic) IBOutlet UITextField *categoryTextField;
@property (weak, nonatomic) IBOutlet UITextField *domainsTextField;

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
    self.categoryTextField.text = self.agent.category.name;
}

- (void)setupArrays {
    self.destructionPowers = @[@"Patoso",@"Debil",@"Neutro", @"Macho", @"Terminator"];
    self.motivations = @[@"Vamos", @"Me aburro", @"Me como el mundo", @"Me la pela", @"GO GO GO"];
    self.assesments = @[@"Come on",@"GO", @"Amazing", @"Pepe", @"Hola"];
}



- (FreakType *)freakTypeByName:(NSString *)name {
    NSManagedObjectContext *context = self.agent.managedObjectContext;
    FreakType *freakType = [FreakType giveFreakTypeWithName:name inManagedObjectContext:context];
    if (!freakType) {
        freakType = [FreakType initWithName:name inManagedObjectContext:context];
    }
    return freakType;
}

- (NSSet *)domainsFromText:(NSString *)domains {
    NSManagedObjectContext *context = self.agent.managedObjectContext;
    NSArray *domainsArray = [domains componentsSeparatedByString:@","];
    NSMutableSet *domainSet = [[NSMutableSet alloc] init];
    for (NSString *domainString in domainsArray) {
        Domain *domain = [Domain giveDomainTypeWithName:domainString inManagedObjectContext:context];
        if (!domain) {
            domain = [Domain initWithName:domainString inManagedObjectContext:context];
        }
        [domainSet addObject:domain];
    }
    return [domainSet copy];
}

#pragma mark - Action Methods

- (IBAction)cancelButtonPressed:(UIBarButtonItem *)sender {
    if ([self.delegate respondsToSelector:@selector(modifiedDataInController:modified:)]) {
        [self.delegate modifiedDataInController:self modified:self.isModified];
    }
}

- (IBAction)saveButtonPressed:(id)sender {
    self.agent.category = [self freakTypeByName:self.categoryTextField.text];
    self.agent.domains = [self domainsFromText:self.domainsTextField.text];
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

#pragma mark -
#pragma mark - Touches View
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark -
#pragma mark - Observer Method

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


#pragma mark -
#pragma mark - UITextField Delegate

- (void) textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.categoryTextField || textField == self.domainsTextField) {
        [self removeDecorationOfTextInTextField:textField];
    }
}

- (void) removeDecorationOfTextInTextField:(UITextField *)textField {
    textField.attributedText = [[NSAttributedString alloc] initWithString:textField.text
    attributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
}


- (void) textFieldDidEndEditing:(UITextField *)textField {
    BOOL exists = YES;
    if (textField == self.categoryTextField) {
        NSString *category = self.categoryTextField.text;
//        exists = [FreakType existsWithName:category];
            [self decorateTextField:textField withContents:@[category] values:@[@(exists)]];
    } else if (textField == self.domainsTextField) {
        NSString *domainsString = self.domainsTextField.text;
        NSArray *domains = [domainsString componentsSeparatedByString:@","];
        NSMutableArray *values = [[NSMutableArray alloc] initWithCapacity:[domains count]];
            for (NSString *domain in domains) {
//            exists = [Domain existsWithName:domain];
            [values addObject:@(exists)];
            if (domain !=nil) exists = !exists;
            }
                    [self decorateTextField:textField withContents:domains values:values];
        }
}


- (void) decorateTextField:(UITextField *)textField withContents:(NSArray *)contents values:(NSArray *)values{
    NSMutableAttributedString *coloredString = [[NSMutableAttributedString alloc] init];
    for (NSUInteger i = 0; i < [contents count]; i++) {
        BOOL exists = [[values objectAtIndex:i] boolValue];
        NSString *substring = [contents objectAtIndex:i];
        UIColor *decorationColor = (exists)?[UIColor greenColor]:[UIColor redColor];
        NSAttributedString *attributedSubstring = [[NSAttributedString alloc] initWithString:substring attributes:@{NSForegroundColorAttributeName: decorationColor}];
            [coloredString appendAttributedString:attributedSubstring];
            if (i < ([contents count] - 1)) {
                [coloredString appendAttributedString:[[NSAttributedString alloc] initWithString:@","]];
            }
        }
     textField.attributedText = coloredString;
}


- (void) initializeCategoryTextField {
    if (self.agent.category != nil) {
        // if it is read from the data, it exists.
        [self decorateTextField:self.categoryTextField withContents:@[self.agent.category] values:@[@(YES)]];
    }
}

- (void) initializeDomainsTextField {
    if ([self.agent.domains count] > 0) {
        NSArray *contents = [self.agent.domains valueForKey:@"name"];
        NSMutableArray *values = [[NSMutableArray alloc] initWithCapacity:[contents count]];
        for (NSUInteger i = 0; i < [contents count]; i++) {
            [values addObject:@(YES)];
        }
        [self decorateTextField:self.domainsTextField withContents:contents values:values];
    }
}


//#pragma mark - Action Sheet Delegate Methods
//
//- (void) actionSheet:(UIActionSheet *)actionSheet
//clickedButtonAtIndex:(NSInteger)buttonIndex {
//    if (buttonIndex == actionSheet.destructiveButtonIndex) {
//        [self deletePicture];
//    } else if (buttonIndex == actionSheet.firstOtherButtonIndex) {
//        [self obtainPictureFromCamera:YES];
//    } else if (buttonIndex == actionSheet.firstOtherButtonIndex + actionSheetLibrary) {
//        [self obtainPictureFromCamera:NO];
//    }
//}
//
//
//- (void) obtainPictureFromCamera:(BOOL)useCamera {
//    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
//    
//    if (useCamera &&
//        [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
//    } else {
//        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    }
//    imagePicker.allowsEditing = YES;
//    imagePicker.delegate = self;
//    
//    [self presentViewController:imagePicker animated:YES completion:nil];
//    
//}
//
//
//- (void) deletePicture {
//    imageStatus = ImageStatusDelete;
//    self.agentPicture = nil;
//    [self displayAgentPicture];
//}
//
//#pragma mark - Image picker view controller delegate
//
//- (void) imagePickerController:(UIImagePickerController *)imagePickerController
// didFinishPickingMediaWithInfo:(NSDictionary *)info {
//    self.agentPicture = [info[UIImagePickerControllerEditedImage] imageSquaredWithSide:pictureSide];
//    // AgentPicture is not observed, because it changes while this controller is hidden.
//    [self displayAgentPicture];
//    imageStatus = ImageStatusPreserveNew;
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
//
//
//- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
//    [self dismissViewControllerAnimated:YES completion:nil];
//}


@end
