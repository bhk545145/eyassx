//
//  FileManager.h
//  FileManager
//
//  Created by YouXianMing on 15/12/5.
//  Copyright © 2015年 YouXianMing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "File.h"

@interface FileManager : NSObject

/// 把对象归档存到沙盒里
+(void)saveObject:(id)object byFileName:(NSString*)fileName;
/// 通过文件名从沙盒中找到归档的对象
+(id)getObjectByFileName:(NSString*)fileName;

/// 根据文件名删除沙盒中的 plist 文件
+(void)removeFileByFileName:(NSString*)fileName;

/**
 *  Get the file at the related file path.
 *
 *  @param relatedFilePath Related file path, "~" means sandbox root, "-" means bundle file root.
 *  @param maxTreeLevel    Scan level.
 *
 *  @return File.
 */
+ (File *)scanRelatedFilePath:(NSString *)relatedFilePath
                 maxTreeLevel:(NSInteger)maxTreeLevel;

/**
 *  Transform related file path to real file path.
 *
 *  @param relatedFilePath Related file path, "~" means sandbox root, "-" means bundle file root.
 *
 *  @return The real file path.
 */
+ (NSString *)theRealFilePath:(NSString *)relatedFilePath;

/**
 *  Get the bundle file path by the bundle file name.
 *
 *  @param name Bundle file name.
 *
 *  @return Bundle file path.
 */
+ (NSString *)bundleFileWithName:(NSString *)name;

/**
 *  To check the file at the given file path exist or not.
 *
 *  @param theRealFilePath The real file path.
 *
 *  @return Exist or not.
 */
+ (BOOL)fileExistWithRealFilePath:(NSString *)theRealFilePath;

@end

/**
 *  Transform related file path to real file path.
 *
 *  @param relatedFilePath Related file path, "~" means sandbox root, "-" means bundle file root.
 *
 *  @return The real file path.
 */
NS_INLINE NSString *filePath(NSString * relatedFilePath) {
    
    return [FileManager theRealFilePath:relatedFilePath];
}

/**
 *  To check the file at the given file path exist or not.
 *
 *  @param theRealFilePath The real file path.
 *
 *  @return Exist or not.
 */
NS_INLINE BOOL fileExistWithRealFilePath(NSString * theRealFilePath) {
    
    return [FileManager fileExistWithRealFilePath:theRealFilePath];
}

