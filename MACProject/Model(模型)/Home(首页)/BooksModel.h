//
//  BooksModel.h
//  MACProject
//
//  Created by 白洪坤 on 2018/5/5.
//  Copyright © 2018年 com.mackun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BooksModel : NSObject
/**
 *  书分类id
 */
@property(nonatomic,copy) NSString* _id;

/**
 *  书作者
 */
@property(nonatomic,copy) NSString* author;
/**
 *  书封面URL
 */
@property(nonatomic,copy) NSString* cover;
/**
 *  介绍
 */
@property(nonatomic,copy) NSString* shortIntro;
/**
 *  标题
 */
@property(nonatomic,copy) NSString* title;
/**
 *  古代言情
 */
@property(nonatomic,copy) NSString* majorCate;
/**
 *  古典架空
 */
@property(nonatomic,copy) NSString* minorCate;
/**
 *  人气
 */
@property(nonatomic,assign) NSInteger latelyFollower;

@end
