//
//  NewsItem.h
//  VKTestApp
//
//  Created by Nikita Fomin on 14/02/14.
//  Copyright (c) 2014 Nikita Fomin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsItem : NSObject

@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *senderName;
@property (nonatomic, copy) NSString *iconURL;
@property (nonatomic, copy) NSString *firstImageURL;
@property (nonatomic, copy) NSString *secondImageURL;

@end
