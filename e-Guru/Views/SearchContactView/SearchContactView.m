//
//  SearchContactView.m
//  e-Guru
//
//  Created by MI iMac01 on 18/11/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "SearchContactView.h"

@implementation SearchContactView

-(instancetype)initWithFrame:(CGRect)frame andData:(NSArray *)userArray{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"SearchContactView" owner:self options:nil];
        [self.view setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.view.layer.borderColor = [UIColor grayColor].CGColor;
        self.view.layer.borderWidth = 2.0f;
        [self addSubview:self.view];

        array = userArray;
        self.resultArray = userArray;
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
#pragma mark - Helper Methods
-(void)reloadTableView_ForString:(NSString *)string{
    if (![string isEqualToString:@""]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.firstName beginswith[c] %@",string];
        self.resultArray = [array filteredArrayUsingPredicate:predicate];
    }
    else{
        self.resultArray = array;
    }
    [self.contactSearchTableVIew reloadData];
}

# pragma mark - table view Delegates

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *simpleTableIdentifier = @"tableViewCell";
    
    SearchContactTableViewCell *cell = (SearchContactTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SearchContactTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.nameLabel.text = [(EGContact *)[self.resultArray objectAtIndex:indexPath.row] firstName];
    cell.mobileNumberLabel.text = [(EGContact *)[self.resultArray objectAtIndex:indexPath.row] contactNumber];
    
    return cell;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.resultArray count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegate searchContactSelectedValue:[self.resultArray objectAtIndex:indexPath.row] withIndex:indexPath.row];
}

#pragma mark - searchBar delegate methods

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar                      // return NO to not become first responder
{
    return YES;
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar                     // called when text starts editing
{
    
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar                       // called when text ends editing
{
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text NS_AVAILABLE_IOS(3_0) // called before text changes
{
    NSString *currentString = [searchBar.text stringByReplacingCharactersInRange:range withString:text];
    currentString = [currentString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    currentString = [currentString stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
//    NSUInteger length = [currentString length];
    
    [self reloadTableView_ForString:currentString];
    return YES;
}

@end
