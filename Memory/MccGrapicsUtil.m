//
//  MccGrapicsUtil.m
//  Memory
//
//  Created by Petter Bergström on 2014-04-02.
//  Copyright (c) 2014 McCoy. All rights reserved.
//

#import "MccGrapicsUtil.h"

@implementation MccGrapicsUtil

+ (UIImage*) createCardImage:(UIImage*)image size:(CGSize) size{
    
    CGRect outerBounds = CGRectMake(0, 0, size.width, size.height);
    CGRect outerBoundsMinusFrame = CGRectMake(1, 1, outerBounds.size.width-2, outerBounds.size.height-2);
    CGFloat spaceX = size.height*0.05;
    CGFloat spaceY = size.width*0.05;
    
    CGRect imageBounds = CGRectMake(1+spaceX,
                                    1+spaceY,
                                    outerBounds.size.width-2-2*spaceX,
                                    outerBounds.size.height-2-2*spaceY);
    
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetRGBFillColor(context, 0, 0, 0, 1);
    CGContextFillRect(context, outerBounds);
    
    CGContextSetRGBFillColor(context, 1, 1, 1, 1);
    CGContextFillRect(context, outerBoundsMinusFrame);
    
    [image drawInRect:imageBounds];
    UIImage *createdImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return createdImage;
}



@end
