//
//  EGDSELeaveView.m
//  e-guru
//
//  Created by Apple on 25/02/19.
//  Copyright © 2019 TATA. All rights reserved.
//

#import "EGDSELeaveView.h"
#import "DropDownTextField.h"
#import "NSDate+eGuruDate.h"
#import "DropDownViewController.h"
#import "AppRepo.h"

@implementation EGDSELeaveView
@synthesize dseDropDownTextField;
@synthesize remarkTextView,protocolGDSELeaveView,viewEventList,viewDSELeave;


- (IBAction)cancelClicked:(id)sender {
//    if (sender == _backButton) {
//        [_eventList reloadData];
//        [self showDSEView];
//    }else{
    
        [self removeFromSuperview];
//
//}
}

- (void)showDSEView
{
    [self.viewEventList setHidden:TRUE];
    [self.viewDSELeave setHidden:FALSE];
    _checkedDatedArray = [self.exclusionViewModel.selectedDates mutableCopy];

    if ([self.exclusionViewModel getLeavesArrayForDate:self.eventDate]) {
        _deleteLeaveButton.enabled = true;
        [_deleteLeaveButton setBackgroundColor:[UIColor themePrimaryColor]];
    }else{        _deleteLeaveButton.enabled = false;
        _deleteLeaveButton.backgroundColor = [UIColor themeDisabledColor];
    }
    if ([_checkedDatedArray count]>0) {
        [self selectDatesClicked:_selectDateArrowButton];
    }
}

-(void)showEventList{
//    for (NSDate *date in self.exclusionViewModel.selectedDates) {
//        [_checkedDatedArray addObject:[NSDate getDate:date InFormat:dateFormatyyyyMMddhyp]];
//    }
    _checkedDatedArray = [self.exclusionViewModel getLeavesIDsForSelectedDates];
    CGFloat tblHt = [_checkedDatedArray count]*65;
    if (tblHt < 450) {
        _constraint_LeaveList_Ht.constant = tblHt + 15;
    }else{
        _constraint_LeaveList_Ht.constant = 450;
    }
    [self.viewEventList setHidden:FALSE];
    [self bringSubviewToFront:self.viewEventList];
    [self.viewDSELeave setHidden:TRUE];
    [self.rightView setHidden:TRUE];
}

- (IBAction)cancelLeaveClickd:(UIButton *)sender {

    if ([_checkedDatedArray count]  == 0){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Please select DSE" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK"  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}]];
        [ appDelegate.navigationController.topViewController presentViewController:alertController animated:YES completion:nil];
    }else{
//        [self.exclusionViewModel canc]
//        NSArray *selectedRowsArray = [_eventList indexPathsForSelectedRows];
//        NSMutableArray *leaveid = [[NSMutableArray alloc]init];
//        for (NSString *date in _checkedDatedArray) {
//            [leaveid addObject:[self.exclusionViewModel getLeaveIDForIndex:[_checkedDatedArray indexOfObject:date]]];
//        }
//        for (NSIndexPath *index in selectedRowsArray) {
//            [leaveid addObject:[self.exclusionViewModel getLeaveIDForIndex:index.row]];
//        }
        [self.exclusionViewModel  cancelLeaveForDSEArray:_checkedDatedArray ForDate:_selectedDate SuccessAction:^(bool status, NSString *msg) {
            if(status){
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:msg preferredStyle:UIAlertControllerStyleAlert];
                    [alertController addAction:[UIAlertAction actionWithTitle:@"OK"  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [protocolGDSELeaveView reloadDataForDate];
                        [self cancelClicked:nil];
                    }]];
                     [ appDelegate.navigationController.topViewController presentViewController:alertController animated:YES completion:nil];
                });
              
            }else{
                [self cancelClicked:nil];
            }
        }];
//        [self.exclusionViewModel  cancelLeaveWithForDSEID:[self.exclusionViewModel getLeaveIDForDate: _eventDate ForIndex:selectedIndexPath.row]  ForDate:_selectedDate SuccessAction:^(bool status, NSString *msg) {
//            if(status){
//                [protocolGDSELeaveView reloadDataForDate];
//            }
//
//            [self cancelClicked:nil];
//
//        }];
    }
    
}

- (IBAction)deleteLeaveUIClicked:(UIButton *)sender {
    [self showEventList];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation: @"GMT"];
    [displaydateFormatter setDateFormat:@"dd/mm/yyyy"];
    displaydateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation: @"GMT"];
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    _exclusionViewModel = [[EGExclusionViewModel alloc]init];
    self.dseDropDownTextField.field = [[Field alloc] init];
    _tblViewSelectedDates.tag = 1;
    _addedLeavesArray = [NSMutableArray new];
    _checkedDatedArray = [NSMutableArray new];
    self.remarkTextView.layer.borderColor = [UIColor textFieldGreyBorder].CGColor;
    self.remarkTextView.layer.borderWidth = 1;
    self.cancelButton.layer.borderColor = [UIColor textFieldGreyBorder].CGColor;
    self.cancelButton.layer.borderWidth = 1;
    self.doneButton.layer.borderColor = [UIColor textFieldGreyBorder].CGColor;
    self.doneButton.layer.borderWidth = 1;
    self.deleteLeaveButton.layer.borderColor = [UIColor textFieldGreyBorder].CGColor;
    self.deleteLeaveButton.layer.borderWidth = 1;
    [remarkTextView setPlaceholder:@"Please Enter Remark"]  ;
    self.backButton.layer.borderColor = [UIColor textFieldGreyBorder].CGColor;
    self.backButton.layer.borderWidth = 1;

    self.cancelLeaveActionButton.layer.borderColor = [UIColor textFieldGreyBorder].CGColor;
    self.cancelLeaveActionButton.layer.borderWidth = 1;
    [self.cancelLeaveActionButton setBackgroundColor:[UIColor themePrimaryColor]];
//    self.eventList.layer.borderColor = [UIColor textFieldGreyBorder].CGColor;
//    self.eventList.layer.borderWidth = 1;
    [self.backButton setBackgroundColor:[UIColor themePrimaryColor]];
    [self.cancelButton setBackgroundColor:[UIColor themePrimaryColor]];
    [self.doneButton setBackgroundColor:[UIColor themePrimaryColor]];
    self.rightViewCancelButton.layer.borderWidth = 1;
    [self.rightViewCancelButton setBackgroundColor:[UIColor themePrimaryColor]];
    self.rightViewDoneButton.layer.borderWidth = 1;
    self.rightViewCancelButton.layer.borderColor = [UIColor textFieldGreyBorder].CGColor;
    self.rightViewDoneButton.layer.borderColor = [UIColor textFieldGreyBorder].CGColor;
    self.selectDateArrowButton.layer.borderColor = [UIColor textFieldGreyBorder].CGColor;
    [self.rightViewDoneButton setBackgroundColor:[UIColor themePrimaryColor]];
    self.selectDateArrowButton.layer.borderWidth = 1;
    [self.selectDateArrowButton setBackgroundColor:[UIColor whiteColor]];
    self.viewDSELeave.layer.borderWidth = 1;
    self.viewDSELeave.layer.borderColor = [UIColor textFieldGreyBorder].CGColor;
    self.rightView.layer.borderWidth = 1;
    self.rightView.layer.borderColor = [UIColor textFieldGreyBorder].CGColor;
    
    [self.listDeleteDisabledButton setBackgroundColor:[UIColor themeDisabledColor]];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
    [tapGesture setNumberOfTapsRequired:1];
    [tapGesture setNumberOfTouchesRequired:1];
    tapGesture.delegate = self;
    [tapGesture addTarget:self action:@selector(fieldTapped:)];
    [self.dseDropDownView addGestureRecognizer:tapGesture];
    [self.eventList reloadData];
    self.tblViewSelectedDates.allowsMultipleSelection = YES;
    self.eventList.allowsMultipleSelection = YES;

}

- (IBAction)doneButtonActionClick:(id)sender {
    if (self.addedLeavesArray.count  == 0){
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"No data added" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK"  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}]];
   [ appDelegate.navigationController.topViewController presentViewController:alertController animated:YES completion:nil];
    }else{
//        [self.exclusionViewModel  applyLeaveWithForDSEID:selectedDSE.leadid andRemark:remarkTextView.text ForDate:_selectedDate SuccessAction:^(bool status, NSString *msg) {
//            if(status){
//                [protocolGDSELeaveView reloadDataForDate];
//            }
//
////            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:msg preferredStyle:UIAlertControllerStyleAlert];
////            [alertController addAction:[UIAlertAction actionWithTitle:@"OK"  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
////                [self cancelClicked:nil];
////            }]];
////            [ appDelegate.navigationController.topViewController presentViewController:alertController animated:YES completion:nil];
//            [self cancelClicked:nil];
//
//        }];
        [self.exclusionViewModel  applyLeaveWithForDSERequestDict:[self getRequestDictionary]  SuccessAction:^(bool status, NSString *msg) {
            if(status){
                         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:msg preferredStyle:UIAlertControllerStyleAlert];
                            [alertController addAction:[UIAlertAction actionWithTitle:@"OK"  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                [protocolGDSELeaveView reloadDataForDate];
                                [self cancelClicked:nil];
                            }]];
                 [ appDelegate.navigationController.topViewController presentViewController:alertController animated:YES completion:nil];
            }else{
                [self cancelClicked:nil];
            }
            
        }];
    }

}

-(NSDictionary*)getRequestDictionary{
    NSMutableArray *leaves = [[NSMutableArray alloc]init];
    for (NSDictionary *dict in self.addedLeavesArray) {
        EGDse *dse = [dict objectForKey:@"dse"];
        NSString *dseid = @"";NSString *firstName = @""; NSString *lastName = @""; NSString *empID = @"";
        if (dse.leadid != nil) {
            dseid = dse.leadid;
        }
        if (dse.FirstName != nil) {
            firstName = dse.FirstName;
        }
        if (dse.LastName != nil) {
            lastName = dse.LastName;
        }
        if (dse.leadLogin != nil) {
            empID = dse.leadLogin;
        }
        [leaves addObject:[ NSDictionary dictionaryWithObjectsAndKeys:[dict objectForKey:@"date"],@"date",empID,@"dse_id",dseid,@"dse_emp_id",firstName,@"first_name",lastName,@"last_name",[dict objectForKey:@"remark"],@"remark", nil]];
    }
    NSString *dsmid = @"";
    if ([[AppRepo sharedRepo] getLoggedInUser].employeeRowID != nil){
        dsmid = [[AppRepo sharedRepo] getLoggedInUser].employeeRowID ;
    }
    return [NSDictionary dictionaryWithObjectsAndKeys:leaves ,@"leave",dsmid,@"dsm_id", nil];
}

- (void)fieldTapped:(UITapGestureRecognizer *)gesture {
    [self showPopOver:dseDropDownTextField];
}

- (void)showPopOver:(DropDownTextField *)textField {
    [_exclusionViewModel getDSEListSuccessAction:^(NSMutableArray *responseArray, NSMutableArray *dseObjArray) {
        dseDropDownTextField.field.mValues = responseArray;
        dseDropDownTextField.field.mDataList = dseObjArray;
        dseDropDownTextField.field.mTitle = @"ExclusionDSEList";
        [self endEditing:true];
        DropDownViewController *dropDown = [[DropDownViewController alloc] init];
        [dropDown showDropDownInController:[[appDelegate.navigationController viewControllers] lastObject] withData:textField.field.mValues andModelData:textField.field.mDataList forView:textField withDelegate:self];

    } andFailuerAction:^(NSError *error) {
        
    }];
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}

#pragma mark - DropDownViewControllerDelegate Method
- (void)didSelectValueFromDropDown:(NSString *)selectedValue selectedObject:(id)selectedObject forField:(id)dropDownForView;
{
    self.dseDropDownTextField.text = selectedValue;
    selectedDSE = (EGDse *)selectedObject;
}
#pragma mark - uitableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == _tableViewLeaves && [_addedLeavesArray count] == 0) {
        return 0;
    }
        return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 1){
        return [self.exclusionViewModel.selectedDates count];
    }else if(tableView == _tableViewLeaves){
        return  [self.addedLeavesArray count];
    }else{
//       NSInteger rows = [self.exclusionViewModel getLeavesArrayForDate:self.eventDate];
        NSInteger rows =   [self.exclusionViewModel getLeavesArrayForMultipleDates];
        return rows;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell ;
    NSString *tableIdentifier  = @"Cell";
    cell = [self.eventList dequeueReusableCellWithIdentifier:tableIdentifier];
    
    if (cell == nil) {
        if(tableView == _tableViewLeaves || tableView == _eventList){
             cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:tableIdentifier];
        }else{ cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableIdentifier];}
        
        cell.backgroundColor = [UIColor tableLightRowColor];
//        cell.layer.borderColor = [UIColor textFieldGreyBorder].CGColor;
//        cell.layer.borderWidth = 1;
    }
    if([[tableView indexPathsForSelectedRows] containsObject:indexPath]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    if (tableView == _tblViewSelectedDates) {
//        NSDate *date = [self.exclusionViewModel.selectedDates objectAtIndex:indexPath.row];
        NSString *seleDate = [NSDate getDate:[_exclusionViewModel.selectedDates objectAtIndex:indexPath.row] InFormat:dateFormatddMMyyyy];
        cell.textLabel.text = seleDate;
        if ([_checkedDatedArray containsObject:[_exclusionViewModel.selectedDates objectAtIndex:indexPath.row]]) {
            cell.selected = true;
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.selected = false;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }else if(tableView == _tableViewLeaves){
        cell.accessoryType = UITableViewCellAccessoryNone;
        NSDictionary *dict = [self.addedLeavesArray objectAtIndex:indexPath.row];
        EGDse *dse = [dict objectForKey:@"dse"];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@ %@ ",dse.FirstName,dse.LastName,[dict objectForKey:@"remark"]];
        NSString *leaveDate = [dict objectForKey:@"date"];
         NSDate *lDate = [dateFormatter dateFromString:leaveDate];
        cell.detailTextLabel.text = [NSDate getDate:lDate InFormat:dateFormatddMMyyyy];
        cell.detailTextLabel.textColor = [UIColor blackColor];
    }else{
        if ([_checkedDatedArray containsObject:[self.exclusionViewModel getLeaveIDForIndex:indexPath.row]]) {
            cell.selected = true;
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.selected = false;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell.textLabel.text =  [self.exclusionViewModel getLeaveTitleForIndex:indexPath.row];
        NSString *leaveDate = [self.exclusionViewModel getLeaveDateForIndex:indexPath.row];
        NSDate *lDate = [dateFormatter dateFromString:leaveDate];
        cell.detailTextLabel.text = [NSDate getDate:lDate InFormat:dateFormatddMMyyyy];

    }
    return cell;
}
//
//-(void)selectAllRows{
//
//    for (int i = 0; i < self.tblViewSelectedDates.numberOfSections; i++)
//    {
//        for (int j = 0; j < [self.tblViewSelectedDates numberOfRowsInSection:i]; j++)
//        {
//
//            [self.tblViewSelectedDates selectRowAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i]
//                                        animated:YES
//                                  scrollPosition:UITableViewScrollPositionNone];
//            UITableViewCell* cell = [self.tblViewSelectedDates cellForRowAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i]];
//            cell.accessoryType = UITableViewCellAccessoryCheckmark;
//        }
//    }
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tblViewSelectedDates) {
        BOOL isSelected = ([tableView cellForRowAtIndexPath:indexPath].accessoryType ==  UITableViewCellAccessoryCheckmark);
        if(isSelected){
            if ([self.checkedDatedArray containsObject:[self.exclusionViewModel.selectedDates objectAtIndex:indexPath.row]]) {
                [self.checkedDatedArray removeObject:[self.exclusionViewModel.selectedDates objectAtIndex:indexPath.row]];
            }
            [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
            [tableView deselectRowAtIndexPath:indexPath animated:YES]; //this won't trigger the didDeselectRowAtIndexPath, but it's always a good idea to remove the selection
        }else{
            [self.checkedDatedArray addObject:[self.exclusionViewModel.selectedDates objectAtIndex:indexPath.row]];
            [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }else if(tableView == self.eventList){
        BOOL isSelected = ([tableView cellForRowAtIndexPath:indexPath].accessoryType ==  UITableViewCellAccessoryCheckmark);
        if(isSelected){
            if ([self.checkedDatedArray containsObject:[self.exclusionViewModel getLeaveIDForIndex:indexPath.row]]) {
                [self.checkedDatedArray removeObject:[self.exclusionViewModel getLeaveIDForIndex:indexPath.row]];
            }
            [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
            [tableView deselectRowAtIndexPath:indexPath animated:YES]; //this won't trigger the didDeselectRowAtIndexPath, but it's always a good idea to remove the selection
        }else{
            [self.checkedDatedArray addObject:[self.exclusionViewModel getLeaveIDForIndex:indexPath.row]];
            [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    if (tableView == self.tblViewSelectedDates){
        if ([self.checkedDatedArray containsObject:[self.exclusionViewModel.selectedDates objectAtIndex:indexPath.row]]) {
            [self.checkedDatedArray removeObject:[self.exclusionViewModel.selectedDates objectAtIndex:indexPath.row]];
        }
    }
    else if(tableView == self.eventList){
        if ([self.checkedDatedArray containsObject:[self.exclusionViewModel getLeaveIDForIndex:indexPath.row]]) {
            [self.checkedDatedArray removeObject:[self.exclusionViewModel getLeaveIDForIndex:indexPath.row]];
        }
    }
}

- (IBAction)selectDatesClicked:(UIButton*)sender {
    if (sender.tag == 0) {
        CGFloat tblHt = [self.exclusionViewModel.selectedDates count]*45;
        if (tblHt < 220) {
            self.constraint_tableViewSelectedDatesHeight.constant = tblHt + 14;
        }else{
            self.constraint_tableViewSelectedDatesHeight.constant = 220;
        }
        [_tblViewSelectedDates setHidden:false];
        sender.tag = 1;
    }else{
        [_tblViewSelectedDates setHidden:true];
        self.constraint_tableViewSelectedDatesHeight.constant = 0;
        sender.tag = 0;
    }
   
}
-(BOOL)leaveExistsForDate:(NSString*)date ForDSE:(NSString*)dseId {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"dseid == %@ and date == %@", dseId,date];
    NSArray *filteredArray = [self.addedLeavesArray filteredArrayUsingPredicate:predicate];
    if (filteredArray && [filteredArray count] > 0) {
        return true;
    }
    return false;
}

- (IBAction)addButtonClicked:(UIButton *)sender {
    NSString *leadIds = @"";
    NSMutableDictionary *leaveExists = [[NSMutableDictionary alloc]init];
    NSMutableArray *addNewArray = [[NSMutableArray alloc]init];
    for (NSDate *date in _checkedDatedArray) {
        NSString *seleDate = [NSDate getDate:date InFormat:dateFormatyyyyMMddhyp];
        NSString *dispseleDate = [NSDate getDate:date InFormat:dateFormatddMMyyyy];

        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:selectedDSE,@"dse",self.remarkTextView.text ,@"remark",seleDate,@"date",selectedDSE.leadLogin,@"dseid", nil];
        if (![self.exclusionViewModel leaveExistForLeaveID:selectedDSE.leadLogin ForDate:date] && ![self leaveExistsForDate:seleDate ForDSE:selectedDSE.leadLogin]) {
            [addNewArray addObject:dict];
        }else{
           NSString* leaveEx =  [leaveExists objectForKey:selectedDSE.leadLogin];
            if (leaveEx == nil) {
                [leaveExists setValue:[NSString stringWithFormat:@"%@ on %@",selectedDSE.leadLogin, dispseleDate] forKey:selectedDSE.leadLogin];
            }else{
                [leaveExists setValue:[NSString stringWithFormat:@"%@, %@",leaveEx,dispseleDate] forKey:selectedDSE.leadLogin];
            }
            if ([leadIds length]== 0) {
                leadIds = [NSString stringWithFormat:@"Leave exists for DSE %@ on %@",selectedDSE.leadLogin,dispseleDate];
            }else{
                leadIds = [NSString stringWithFormat:@"%@ %@ on %@",leadIds,selectedDSE.leadLogin,dispseleDate];
            }
        }
    }
    
    NSString *allExistingLeaves = @"";
    if ([[leaveExists allValues] count]>0) {
        allExistingLeaves = [NSString stringWithFormat:@"Leave exists for DSE %@",[ [leaveExists allValues] componentsJoinedByString:@", DSE "]];
    }
   
    NSString *message = @""; BOOL valid = true;
    if (self.dseDropDownTextField.text.length  == 0){
        message = @"Please select DSE";
        valid = false;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Please select DSE" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK"  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}]];
        [ appDelegate.navigationController.topViewController presentViewController:alertController animated:YES completion:nil];
    }
    else if ([remarkTextView.text length]  == 0){
        valid = false;
        message = @"Please add remark";
    }else if ([addNewArray count] == 0){
        message = @"Please select date";

        if ([allExistingLeaves length]) {
            message = allExistingLeaves;
        }
        valid = false;
        
    }
    if (!valid) {
//        [self.addedLeavesArray removeAllObjects];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:message preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK"  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}]];
        [ appDelegate.navigationController.topViewController presentViewController:alertController animated:YES completion:nil];
        return;
    }
    else if([addNewArray count]> 0){
        [self.addedLeavesArray addObjectsFromArray:addNewArray];
    }
    if([self.addedLeavesArray count]> 0) {
       
        CGFloat tblHt = [self.addedLeavesArray count]*40;
        if (tblHt < 450) {
            self.constraint_ht_tableLeaves.constant = tblHt + 15;
        }else{
            self.constraint_ht_tableLeaves.constant = 450;
        }
//        [self selectDatesClicked:_selectDateArrowButton];
        self.remarkTextView.text = nil;
        self.dseDropDownTextField.text = nil;
        _rightViewDoneButton.hidden = false;
        _rightViewCancelButton.hidden = false;
        [_tableViewLeaves setHidden:false];
        _rightViewTitle.hidden = false;
//        _rightView.hidden = false;
    }else{
        [_tableViewLeaves setHidden:true];
        self.constraint_ht_tableLeaves.constant = 0;
        _rightViewTitle.hidden = true;
        _rightViewDoneButton.hidden = true;
        _rightViewCancelButton.hidden = true;
//        _rightView.hidden = true;
    }
    if ([allExistingLeaves length]> 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:allExistingLeaves preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK"  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}]];
        [ appDelegate.navigationController.topViewController presentViewController:alertController animated:YES completion:nil];
    }
    [self.tableViewLeaves reloadData];
}
@end
