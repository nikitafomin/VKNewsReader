//
//  NewsCell.h
//  VKTestApp
//
//  Created by Nikita Fomin on 14/02/14.
//  Copyright (c) 2014 Nikita Fomin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsItem.h"

@interface NewsCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *newsTextLabel;
@property (strong, nonatomic) IBOutlet UIImageView *firstImage;
@property (strong, nonatomic) IBOutlet UIImageView *secondImage;
- (void)configureWithItem:(NewsItem *)item;

@end
