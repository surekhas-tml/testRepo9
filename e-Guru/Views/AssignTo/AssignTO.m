//
//  AssignTO.m
//  e-guru
//
//  Created by Juili on 16/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "AssignTO.h"
#import "UpdateActivityViewController.h"

@implementation AssignTO
@synthesize pickerViewArray,selectedDse,currentAssignment,entryPoint;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //initialisation
        [[NSBundle mainBundle] loadNibNamed:@"AssignTO" owner:self options:nil];
        [self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        [self.view setFrame:frame];
        [self addSubview:self.view];
        self.pickerView.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}


# pragma mark - table view Delegates

// Catpure the picker view selection
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self resignFirstResponder];
    if([pickerViewArray count] >= row + 1){
        self.selectedDse = pickerViewArray[row];
    }
    // This method is triggered whenever the user makes a change to the picker selection.
    // The parameter named row and component represents what was selected.
}


// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.pickerViewArray.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
 
    return  [[[pickerViewArray valueForKeyPath:@"FirstName"][row] stringByAppendingString:@" "] stringByAppendingString:[pickerViewArray valueForKeyPath:@"LastName"][row]];
}


- (IBAction)assignToSelectedDSE:(id)sender {
    
    
    if([self.entryPoint  isEqual:ACTIVITY])
    {
        self.selectedDse.toOpportunity = self.opportunity;
        self.selectedDse.toActivity = self.activity;
        if([[[self.selectedDse.FirstName stringByAppendingString:@" "] stringByAppendingString: self.selectedDse.LastName] isEqualToString:[[self.selectedDse.toOpportunity.leadAssignedName stringByAppendingString:@" "] stringByAppendingString:self.selectedDse.toOpportunity.leadAssignedLastName]])
        {
             [UtilityMethods alert_ShowMessage:@"Already assigned to this DSE" withTitle:APP_NAME andOKAction:nil];
        }
        else
        {
        [self.delegate assignToDSEactivity:self.selectedDse];
        }
    }
    
    else{
        
        self.selectedDse.toOpportunity = self.opportunity;
        
        if([[[self.selectedDse.FirstName stringByAppendingString:@" "] stringByAppendingString: self.selectedDse.LastName] isEqualToString:self.selectedDse.toOpportunity.leadAssignedName])
        {
            [UtilityMethods alert_ShowMessage:@"Already assigned to this DSE" withTitle:APP_NAME andOKAction:nil];
            
        }
        else{
            
            [self.delegate assignToDSE:self.selectedDse];
        }
    }

}

- (IBAction)cancelAction:(id)sender {
     if([self.entryPoint  isEqual:ACTIVITY]){
    [self.delegate cancelAssignmentActivityOperation];
     }else{
    [self.delegate cancelAssignmentOperation];
     }

}
@end
