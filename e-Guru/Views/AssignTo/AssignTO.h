//
//  AssignTO.h
//  e-guru
//
//  Created by Juili on 16/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import "EGDse.h"
#import "EGOpportunity.h"
@protocol AssignTODelegate
-(void)cancelAssignmentOperation;
-(void)cancelAssignmentActivityOperation;
-(void)assignToDSE:(EGDse *)dse;
-(void)assignToDSEactivity:(EGDse *)dse;
@end
@interface AssignTO : UIView<UIPickerViewDelegate,UIPickerViewDataSource>{
}
@property (strong, nonatomic) EGDse *selectedDse;
@property (strong, nonatomic) EGOpportunity *opportunity;
@property (strong, nonatomic) EGOpportunity *opty;

@property (strong, nonatomic) EGActivity *activity;
@property (strong,nonatomic) NSArray *pickerViewArray;
@property (weak,nonatomic)id<AssignTODelegate> delegate;
@property (strong, nonatomic) NSString *entryPoint;
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UILabel *currentAssignment;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
- (IBAction)assignToSelectedDSE:(id)sender;
- (IBAction)cancelAction:(id)sender;


@end
