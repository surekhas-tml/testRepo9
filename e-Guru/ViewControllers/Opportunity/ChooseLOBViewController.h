//
//  ChooseLOBViewController.h
//  e-Guru
//
//  Created by MI iMac04 on 17/11/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseLOBViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *lobCollectionView;

@end
