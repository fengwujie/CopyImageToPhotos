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
 *
 *  @param sender <#sender description#>
 */
- (IBAction)btnClearImage:(id)sender;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnCopyImage:(id)sender {
    /*
    //NSString *textFileContentsContact = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"contact" ofType:@"txt"] encoding:NSUTF8StringEncoding error: &error];
    NSString *file =[[NSBundle mainBundle] pathForResource:@"1" ofType:@"png"];
    NSLog(file);
    UIImage *image =[UIImage imageWithContentsOfFile:file];
    //UIImage *image = [UIImage imageNamed:@"test"];
    */
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    NSString *imagePath = [bundlePath stringByAppendingPathComponent:@"CopyImages"];
    [self listFileAtPath:imagePath];
    //[self saveImageToPhotos:image];
}

- (void)listFileAtPath:(NSString *)pathName {
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
}

- (IBAction)btnClearImage:(id)sender {
}

#pragma mark - 保存图片
- (void)saveImageToPhotos:(UIImage*)savedImage
{
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

// 指定回调方法
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
        NSLog(@"error:%@",error);
    }else{
        msg = @"保存图片成功" ;
    }
    //[JoProgressHUD makeToast:msg];
    NSLog(msg);
}


@end
