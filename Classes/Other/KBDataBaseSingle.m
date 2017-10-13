//
//  KBDataBaseSingle.m
//  LuoXun
//
//  Created by dkb on 17/2/9.
//  Copyright © 2017年 dkb. All rights reserved.
//

#import "KBDataBaseSingle.h"

@implementation KBDataBaseSingle

+ (instancetype)sharDataBase
{
    static KBDataBaseSingle *dataBase = nil;
    
    if (dataBase == nil)
    {
        dataBase = [[KBDataBaseSingle alloc] init];
    }
    return dataBase;
}

- (void)openDB
{
    //导入sqlite框架，导入FMDB文件夹
    
    //1.获得数据库文件的路径
    NSString *doc=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName=[doc stringByAppendingPathComponent:@"DataBase.sqlite"];
    NSLog(@"fileName = %@",fileName);
    
    //2.获得数据库
    self.db = [FMDatabase databaseWithPath:fileName];
    
    //3.打开数据库
    if ([self.db open]) {
        NSlog(@"数据库打开成功");
        
        
        //        //4.创表
        //        BOOL result = [self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS Featured (id INTEGER PRIMARY KEY AUTOINCREMENT, photo TEXT NOT NULL, text TEXT NOT NULL, photo_width TEXT NOT NULL, photo_height TEXT NOT NULL);"];
        //
        //        if (result)
        //        {
        //            NSLog(@"创建Featured精选故事表成功");
        //        }else
        //        {
        //            NSLog(@"创建Featured精选故事表失败");
        //        }
        
        //4.创表
        BOOL result = [self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS Featured (id INTEGER PRIMARY KEY AUTOINCREMENT, tVersion TEXT NOT NULL, tPlayTime TEXT NOT NULL, tDownloadUrl TEXT NOT NULL, tIsLink TEXT NOT NULL, tLink TEXT NOT NULL, localImageUrl TEXT NOT NULL, number TEXT NOT NULL, fileName TEXT NOT NULL, tEnterUrl TEXT NOT NULL, tImgPath TEXT NOT NULL, tIntroduction TEXT NOT NULL, tLinkType TEXT NOT NULL, tName TEXT NOT NULL, tNewOrGameId TEXT NOT NULL);"];
        
        if (result)
        {
            NSlog(@"创建轮播图表成功");
        }else
        {
            NSlog(@"创建轮播图表失败");
        }
        
        //url表
        BOOL resultArr = [self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS titleArr (id INTEGER PRIMARY KEY AUTOINCREMENT, tStr TEXT NOT NULL);"];
        if (resultArr)
        {
            NSLog(@"创建url表成功");
        }else
        {
            NSLog(@"创建url表失败");
        }

    }
}
//插入url数据
- (void)insertNewArrModel:(NSString *)str
{
    //如果用stringWithFormat时,sql语句中可以用'%@'
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO titleArr (tStr) VALUES ('%@')", str];
    
    BOOL result = [self.db executeUpdate:sql];
    if (result) {
        
        NSLog(@"插入arr数据成功");
        
    }else
    {
        NSLog(@"插入arr数据失败");
    }
}
#pragma mark 查询所有数据
- (NSMutableArray *)selecturlAllData
{
    // 初始化数组
    NSMutableArray *array = [NSMutableArray array];
    //1.执行查询语句
    FMResultSet *resultSet = [self.db executeQuery:@"select * from titleArr"];
    
    //2.遍历结果集合
    while ([resultSet next]) {
        
        int idNum = [resultSet intForColumn:@"id"];
        NSString *tStr = [resultSet objectForColumnName:@"tStr"];
        
        NSLog(@"105 ---id=%i, starTime=%@", idNum, tStr);
        
        [array addObject:tStr];
        //        NSLog(@"1111%@", model);
    }
    return array;
}

#pragma mark 插入新倒计时数据
- (void)insertNewTimeModel:(StartModel *)timeModel
{
    //如果用stringWithFormat时,sql语句中可以用'%@'
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO Featured (tVersion, tPlayTime, tDownloadUrl, tIsLink, tLink, localImageUrl, number, fileName, tEnterUrl, tImgPath, tIntroduction, tLinkType, tName, tNewOrGameId) VALUES ('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@')", timeModel.tVersion, timeModel.tPlayTime, timeModel.tDownloadUrl, timeModel.tIsLink, timeModel.tLink, timeModel.localImageUrl, timeModel.number, timeModel.fileName, timeModel.tEnterUrl, timeModel.tImgPath, timeModel.tIntroduction, timeModel.tLinkType, timeModel.tName, timeModel.tNewOrGameId];
    
    BOOL result = [self.db executeUpdate:sql];
    if (result) {
        
        NSlog(@"插入轮播图数据成功");
        
    }else
    {
        NSlog(@"插入轮播图数据失败");
    }
}

#pragma mark 查询Featured数据
-(NSMutableArray *)selectFeaturedAllData
{
    // 初始化数组
    NSMutableArray *array = [NSMutableArray array];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    //1.执行查询语句
    FMResultSet *resultSet = [self.db executeQuery:@"select * from Featured"];
    
    //2.遍历结果集合
    while ([resultSet next]) {
        
        int idNum = [resultSet intForColumn:@"id"];
        NSString *tVersion = [resultSet objectForColumnName:@"tVersion"];
        NSString *tPlayTime = [resultSet objectForColumnName:@"tPlayTime"];
        NSString *tDownloadUrl = [resultSet objectForColumnName:@"tDownloadUrl"];
        NSString *tIsLink = [resultSet objectForColumnName:@"tIsLink"];
        NSString *tLink = [resultSet objectForColumnName:@"tLink"];
        NSString *localImageUrl = [resultSet objectForColumnName:@"localImageUrl"];
        NSString *number = [resultSet objectForColumnName:@"number"];
        NSString *fileName = [resultSet objectForColumnName:@"fileName"];
        NSString *tEnterUrl = [resultSet objectForColumnName:@"tEnterUrl"];
        NSString *tImgPath = [resultSet objectForColumnName:@"tImgPath"];
        NSString *tIntroduction = [resultSet objectForColumnName:@"tIntroduction"];
        NSString *tLinkType = [resultSet objectForColumnName:@"tLinkType"];
        NSString *tName = [resultSet objectForColumnName:@"tName"];
        NSString *tNewOrGameId = [resultSet objectForColumnName:@"tNewOrGameId"];
        
//        NSLog(@"id=%i, tVersion=%@, tPlayTime=%@, tDownloadUrl=%@, tIsLink=%@, tLink=%@, localImageUrl=%@, number=%@, fileName=%@, tEnterUrl=%@, tImgPath=%@, tIntroduction=%@, tLinkType=%@, tName=%@, tNewOrGameId=%@", idNum, tVersion, tPlayTime, tDownloadUrl, tIsLink, tLink, localImageUrl, number, fileName, tEnterUrl, tImgPath, tIntroduction, tLinkType, tName, tNewOrGameId);
        
        StartModel *model = [[StartModel alloc] init];
        model.tVersion = tVersion;
        model.tPlayTime = tPlayTime;
        model.tDownloadUrl = tDownloadUrl;
        model.tIsLink = tIsLink;
        model.tLink = tLink;
        model.localImageUrl = localImageUrl;
        model.number = number;
        model.fileName = fileName;
        model.tEnterUrl = tEnterUrl;
        model.tImgPath = tImgPath;
        model.tIntroduction = tIntroduction;
        model.tLinkType = tLinkType;
        model.tName = tName;
        model.tNewOrGameId = tNewOrGameId;
        
        NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:localImageUrl];
        NSlog(@"数据库中路径为%@", fullPath);
        
        [array addObject:model];
        [arr addObject:number];
        
//        for (int i = 0; i < array.count; i++) {
//            StartModel *model = [[StartModel alloc] init];
//            [arr addObject:model.number];
//        }
        NSlog(@"array = %@", array);
        
        for (int i = 0; i < array.count; i++) {
            for (int j = i+1; j < array.count; j++) {
                if ([arr[i]integerValue] > [arr[j]integerValue]) {
                    [array exchangeObjectAtIndex:i withObjectAtIndex:j];
                    [arr exchangeObjectAtIndex:i withObjectAtIndex:j];
                    NSlog(@"arr = %@", arr);
                    NSlog(@"array = %@", array);
                }
            }
        }
        
        NSLog(@"1111%@", model);
    }
    return array;
}

#pragma mark 销毁表格
-(void)dropTable
{
    [self.db executeUpdate:@"DROP TABLE IF EXISTS Featured"];
    //4.创表
    BOOL result = [self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS Featured (id INTEGER PRIMARY KEY AUTOINCREMENT, tVersion TEXT NOT NULL, tPlayTime TEXT NOT NULL, tDownloadUrl TEXT NOT NULL, tIsLink TEXT NOT NULL, tLink TEXT NOT NULL, localImageUrl TEXT NOT NULL, number TEXT NOT NULL, fileName TEXT NOT NULL, tEnterUrl TEXT NOT NULL, tImgPath TEXT NOT NULL, tIntroduction TEXT NOT NULL, tLinkType TEXT NOT NULL, tName TEXT NOT NULL, tNewOrGameId TEXT NOT NULL);"];
    
    if (result)
    {
        NSlog(@"创建计时表成功");
    }else
    {
        NSlog(@"创建计时表失败");
    }
}


#pragma mark 删除某条计时数据
-(void)deleteImageNameData:(NSString *)ImageName
{
    
    NSString *deleteSql = [NSString stringWithFormat:
                           @"DELETE FROM Featured WHERE localImageUrl = '%@'", ImageName];
    BOOL result = [self.db executeUpdate:deleteSql];
    
    if (result)
    {
        NSlog(@"删除成功");
    }
    else
    {
        NSlog(@"删除数据失败");
    }
    
}




@end
