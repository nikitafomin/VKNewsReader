//
//  NewsCell.m
//  VKTestApp
//
//  Created by Nikita Fomin on 14/02/14.
//  Copyright (c) 2014 Nikita Fomin. All rights reserved.
//

#import "NewsCell.h"

@implementation NewsCell

+ (CGFloat)heightForItem:(NewsItem *)item
{
    // MIN 8*2 (from top bottom offset)
    
    CGFloat summ = 8*2;
    
//    if (item.text) {
//        CGSize *textSize = [item.text sizeWithAttributes:<#(NSDictionary *)#>];
//    }
    
    return summ;
}

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
                CGFloat newWidth = (img.size.width / img.size.height)*self.firstImageView.frame.size.height;
                [self.firstImageView setFrame:CGRectMake(self.firstImageView.frame.origin.x, self.firstImageView.frame.origin.y, newWidth, self.firstImageView.frame.size.height)];
                
                // set image
                self.firstImageView.image = img;
                [self.firstImageView setImage:img];
                self.firstImageView.layer.cornerRadius = 20;
                self.firstImageView.clipsToBounds = YES;
            });
        });
    }
    
    if (item.secondImageURL) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSURL *url = [NSURL URLWithString:item.secondImageURL];
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *img = [UIImage imageWithData:data];
            
            if (!img) {return;}
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // change width
                CGFloat newWidth = (img.size.width / img.size.height)*self.secondImageView.frame.size.height;
                [self.secondImageView setFrame:CGRectMake(self.secondImageView.frame.origin.x, self.secondImageView.frame.origin.y, newWidth, self.secondImageView.frame.size.height)];
                
                // set image
                self.secondImageView.image = img;
                [self.secondImageView setImage:img];
                self.secondImageView.layer.cornerRadius = 20;
                self.secondImageView.clipsToBounds = YES;
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
