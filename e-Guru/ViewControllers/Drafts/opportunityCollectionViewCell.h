//
//  opportunityCollectionViewCell.h
//  e-Guru
//
//  Created by Apple on 02/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface opportunityCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *opportunitymobilenodata;
@property (weak, nonatomic) IBOutlet UIButton *deleteOptyDraft;
@property (weak, nonatomic) IBOutlet UILabel *accountname;
@property (weak, nonatomic) IBOutlet UILabel *optyEmail;
@property (weak, nonatomic) IBOutlet UILabel *optyApplication;
@property (weak, nonatomic) IBOutlet UILabel *optyLOB;
@property (weak, nonatomic) IBOutlet UILabel *optyPPL;
@property (weak, nonatomic) IBOutlet UILabel *optyPL;
@property (weak, nonatomic) IBOutlet UILabel *optyStatus;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
