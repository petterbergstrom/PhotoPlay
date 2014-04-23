//
//  MccMemoryCollectionViewController.h
//  Memory
//
//  Created by Petter Bergström on 2014-03-22.
//  Copyright (c) 2014 McCoy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MccMemoryCollectionViewCell.h"
#import "MccMemoryCard.h"

@interface MccMemoryCollectionViewController : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong,nonatomic) NSMutableArray *cards;

@property (strong,nonatomic) NSMutableArray *imagesMajs;

@property NSIndexPath *flippedIndexPath;


@end
