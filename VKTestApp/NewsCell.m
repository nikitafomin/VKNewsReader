//
//  NewsCell.m
//  VKTestApp
//
//  Created by Nikita Fomin on 14/02/14.
//  Copyright (c) 2014 Nikita Fomin. All rights reserved.
//

#import "NewsCell.h"

@implementation NewsCell

//+ (void)heightForItem:(NewsItem *)item
//{
//    fdgdfg
//}

- (void)configureWithItem:(NewsItem *)item
{
    [self.newsTextLabel setText:item.text];
    
    
    [self.textLabel setBackgroundColor:[UIColor redColor]];
    
    if (item.firstImageURL) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSURL *url = [NSURL URLWithString:item.firstImageURL];
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *img = [UIImage imageWithData:data];
            
            if (!img) {return;}
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                // change width
                CGFloat newWidth = (img.size.width / img.size.height)*self.firstImage.frame.size.height;
                [self.firstImage setFrame:CGRectMake(self.firstImage.frame.origin.x, self.firstImage.frame.origin.y, newWidth, self.firstImage.frame.size.height)];
                
                // set image
                self.firstImage.image = img;
                [self.firstImage setImage:img];
                self.firstImage.layer.cornerRadius = 20;
                self.firstImage.clipsToBounds = YES;
            });
        });
    }
    
    if (item.secondImageURL) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSURL *url = [NSURL URLWithString:item.secondImageURL];
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *img = [UIImage imageWithData:data];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.secondImage.image = img;
                [self.secondImage setImage:img];
                self.secondImage.layer.cornerRadius = 20;
                self.secondImage.clipsToBounds = YES;
            });
        });
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
