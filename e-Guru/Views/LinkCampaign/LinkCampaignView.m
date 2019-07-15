//
//  LinkCampaignView.m
//  e-Guru
//
//  Created by Juili on 01/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "LinkCampaignView.h"

@implementation LinkCampaignView

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
        [[NSBundle mainBundle] loadNibNamed:@"LinkCampaignView" owner:self options:nil];
        [self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        [self.view setFrame:frame];
        [self addSubview:self.view];
        self.pickerView.backgroundColor = [UIColor whiteColor];
         
    }
    return self;
}

 
- (IBAction)linkCampaign:(id)sender {
   self.selectedCampaign.toOpportunity = self.opportunity;
    [self.delegate linkCampaignOperationWithCampaign:self.selectedCampaign];
}

- (IBAction)cancelCampaignLinkage:(id)sender {
    [self.delegate cancelOperation];
}

# pragma mark - table view Delegates

// Catpure the picker view selection
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self resignFirstResponder];
    if([self.pickerArray count] >= row + 1){
    self.selectedCampaign = self.pickerArray[row];
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
    return self.pickerArray.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return [self.pickerArray valueForKeyPath:@"campaignName"][row];
}

@end
