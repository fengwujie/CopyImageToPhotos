//
//  ViewController.m
//  CopyImageToPhotos
//
//  Created by allen on 2016/10/14.
//  Copyright © 2016年 allen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
/**
 *  复制图片到相册
 */
- (IBAction)btnCopyImage:(id)sender;
/**
 *  清空图片
 */
- (IBAction)btnClearImage:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *labMsg;
/**
 *  图片路径数组
 */
@property (strong,nonatomic) NSMutableArray *arrayImagePath;
/**
 *  数组图片的总数量
 */
@property (assign, nonatomic) NSUInteger iArrayImageCount;
/**
 *  当前图片在数组中是第几个
 */
@property (assign, nonatomic) NSUInteger iArrayImageCurrent;
/**
 *  图片数组保存成功数量
 */
@property (assign, nonatomic) NSUInteger iArraySuccessCount;
/**
 *  图片数组保存失败数量
 */
@property (assign, nonatomic) NSUInteger iArrayErrorCount;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(NSMutableArray *)arrayImagePath
{
    if(_arrayImagePath == nil)
        _arrayImagePath = [NSMutableArray array];
    return _arrayImagePath;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnCopyImage:(id)sender {
    
    [self.arrayImagePath removeAllObjects];
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    NSString *imagePath = [bundlePath stringByAppendingPathComponent:@"CopyImages"];
    [self listFileAtPath:imagePath];
    if(self.arrayImagePath.count == 0)
    {
        self.labMsg.text = @"没有图片可复制！";
    }
    else
    {
        self.iArrayImageCount = self.arrayImagePath.count;
        self.iArrayErrorCount = 0;
        self.iArraySuccessCount = 0;
        self.iArrayImageCurrent = 0;
        //self.labMsg.text = @"正在复制图片！";
        [self saveNext];
    }
}
/**
 *  循环遍历获取所有的图片路径
 *
 *  @param pathName 文件夹路径
 */
- (void)listFileAtPath:(NSString *)pathName {
    NSArray *contentOfFolder = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:pathName error:NULL];
    for (NSString *aPath in contentOfFolder) {
        NSString * fullPath = [pathName stringByAppendingPathComponent:aPath];
        [self.arrayImagePath addObject:fullPath];
        BOOL isDir;
        if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&isDir] && isDir) {
            [self listFileAtPath:fullPath];
        }
    }
    
    /*
    NSArray *contentOfFolder = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:pathName error:NULL];
    for (NSString *aPath in contentOfFolder) {
        NSString * fullPath = [pathName stringByAppendingPathComponent:aPath];
        NSLog(@"%@", fullPath);
        BOOL isDir;
        if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&isDir] && isDir) {
            [self listFileAtPath:fullPath];
        }
        else
        {
            [self saveImageToPhotos:[UIImage imageWithContentsOfFile:fullPath]];
        }
    }
    */
}

- (IBAction)btnClearImage:(id)sender {
//    ALAssetsLibrary *lib = [[ALAssetsLibrary alloc]init];
//    [lib enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
//        [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
//            if (result.isEditable) {
//                //在这里imageData 和 metaData设为nil，就可以将相册中的照片删除
//                [result setImageData:nil metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
//                    NSLog(@"asset url(%@) should be delete . Error:%@ ", assetURL, error);
//                }];
//            }
//        }];
//    } failureBlock:^(NSError *error) {
//        
//    }];
    /*
    PHFetchResult *collectonResuts = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAny options:[PHFetchOptions new]] ;
    [collectonResuts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        PHAssetCollection *assetCollection = obj;
        if ([assetCollection.localizedTitle isEqualToString:@"Camera Roll"])  {
            PHFetchResult *assetResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:[PHFetchOptions new]];
            [assetResult enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                    //获取相册的最后一张照片
                    if (idx == [assetResult count] - 1) {
                        [PHAssetChangeRequest deleteAssets:@[obj]];
                    }
                } completionHandler:^(BOOL success, NSError *error) {
                    NSLog(@"Error: %@", error);
                }];
            }];
        }
    }];
     */
}

#pragma mark - 保存图片
-(void) saveNext{
    if (self.arrayImagePath.count > 0) {
        self.iArrayImageCurrent ++;
        UIImage *image =[UIImage imageWithContentsOfFile: [self.arrayImagePath objectAtIndex:0]];
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(savedPhotoImage:didFinishSavingWithError:contextInfo:), nil);
    }
    else
    {
        self.labMsg.text = [NSString stringWithFormat:@"图片复制完成，总共%ld/%ld张，成功%ld张，失败%ld张！",self.iArrayImageCurrent,self.iArrayImageCount,self.iArraySuccessCount,self.iArrayErrorCount];
    }
}
// 指定回调方法
- (void)savedPhotoImage: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    //NSString *msg = nil ;
    if(error != NULL){
        //msg = @"保存图片失败" ;
        //NSLog(@"error:%@",error);
        self.iArrayErrorCount ++;
    }else{
        //msg = @"保存图片成功" ;
        [self.arrayImagePath removeObjectAtIndex:0];
        self.iArraySuccessCount ++;
    }
    self.labMsg.text = [NSString stringWithFormat:@"正在复制图片，总共%ld张，执行%ld张，成功%ld张，失败%ld张！",self.iArrayImageCount,self.iArrayImageCurrent,self.iArraySuccessCount,self.iArrayErrorCount];
    [self saveNext];
}


@end
