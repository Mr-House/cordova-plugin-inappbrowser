//
//  CustomSchemeHandler.m
//  网上学院
//
//  Created by 刘涛 on 2022/1/5.
//

#import "CustomSchemeHandler.h"

@implementation CustomSchemeHandler

- (NSString *)getMIMETypeWithCAPIAtFilePath:(NSString *)path
{
    if (![[[NSFileManager alloc] init] fileExistsAtPath:path]) {
        return nil;
    }
//    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)[path pathExtension], NULL);
//    CFStringRef MIMEType = UTTypeCopyPreferredTagWithClass (UTI, kUTTagClassMIMEType);
//    CFRelease(UTI);
//    if (!MIMEType) {
        return @"application/octet-stream";
//    }
//    return (__bridge NSString *)(MIMEType);
}

- (void)webView:(nonnull WKWebView *)webView startURLSchemeTask:(nonnull id<WKURLSchemeTask>)urlSchemeTask  API_AVAILABLE(ios(11.0)){
    NSString *localFileName = [urlSchemeTask.request.URL lastPathComponent];
    NSLog(@"本地文件名称：%@", localFileName);
    NSString *fileExt = urlSchemeTask.request.URL.pathExtension;
    NSString *resourceName = [localFileName componentsSeparatedByString:@"."][0];
    NSArray *pathComponents = urlSchemeTask.request.URL.pathComponents;
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObjectsFromArray: pathComponents];
    [array removeObjectAtIndex: 0];
    [array removeLastObject];
    NSString *path = [array componentsJoinedByString:@"/"];
    NSString *resourcePath = [NSString stringWithFormat:@"%@/%@", @"www", path];
    NSString *localFilePath = [[NSBundle mainBundle] pathForResource:resourceName ofType:fileExt inDirectory:resourcePath];
    
    NSData *data=[NSData dataWithContentsOfFile:localFilePath];
    
    NSString *fileMIME = [self getMIMETypeWithCAPIAtFilePath:localFilePath];
    NSLog(@"文件MIME：%@", fileMIME);
    NSDictionary *responseHeader = @{
                                     @"Content-type":fileMIME,
                                     @"Content-length":[NSString stringWithFormat:@"%lu",(unsigned long)[data length]]
                                   };
    NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", @"injection://cordova.native.js/", localFileName]] statusCode:200 HTTPVersion:@"HTTP/1.1" headerFields:responseHeader];
    [urlSchemeTask didReceiveResponse:response];
    [urlSchemeTask didReceiveData:data];
    [urlSchemeTask didFinish];
}

- (void)webView:(nonnull WKWebView *)webView stopURLSchemeTask:(nonnull id<WKURLSchemeTask>)urlSchemeTask  API_AVAILABLE(ios(11.0)){
    
}

@end
