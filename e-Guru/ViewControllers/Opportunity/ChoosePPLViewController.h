//
//  ChoosePPLViewController.h
//  e-Guru
//
//  Created by MI iMac04 on 18/11/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChoosePPLViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *pplCollectionView;

@end
