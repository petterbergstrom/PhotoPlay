//
//  MccViewImageViewController.h
//  Memory
//
//  Created by Petter Bergström on 2014-03-23.
//  Copyright (c) 2014 McCoy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MccViewImageViewController : UIViewController

@property UIImage *image;
@property NSString *labelText;

@property (weak, nonatomic) IBOutlet UIImageView *detailImageView;
@property (weak, nonatomic) IBOutlet UILabel *label;


@end
