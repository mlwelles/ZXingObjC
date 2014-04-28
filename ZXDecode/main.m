//
//  main.m
//  ZXDecode
//
//  Created by Mike Welles on 4/28/14.
//  Copyright (c) 2014 zxing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZXingObjC.h"

int err(NSString *message) {
    NSFileHandle *stderrHandle = [NSFileHandle fileHandleWithStandardError];
    if (message) {
        [stderrHandle writeData:[message dataUsingEncoding:NSUTF8StringEncoding]];
        [stderrHandle writeData:[@"\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [stderrHandle writeData:[@"Usage: ZXDecode [filename]\n" dataUsingEncoding:NSUTF8StringEncoding]];
    return 1;
}
int main(int argc, const char * argv[])
{
    @autoreleasepool {

        NSFileHandle *stdoutHandle = [NSFileHandle fileHandleWithStandardOutput];
        if (argc != 2) {
            return err(nil);
        }
        NSString *fileName = [[NSString alloc] initWithBytes:argv[1] length:strlen(argv[1]) encoding:NSASCIIStringEncoding];
        
        NSImage *image = [[NSImage alloc] initWithContentsOfFile:fileName];
        if (! image) {
            return err([NSString stringWithFormat:@"Failed to open image '%@'\n", fileName ]);
        }
        CGImageRef imageToDecode = [image CGImageForProposedRect:NULL context:[NSGraphicsContext currentContext] hints:nil];
        ZXLuminanceSource* source = [[ZXCGImageLuminanceSource alloc] initWithCGImage:imageToDecode];
        ZXBinaryBitmap* bitmap = [ZXBinaryBitmap binaryBitmapWithBinarizer:[ZXHybridBinarizer binarizerWithSource:source]];
        
        NSError* error = nil;
        
        // There are a number of hints we can give to the reader, including
        // possible formats, allowed lengths, and the string encoding.
        ZXDecodeHints* hints = [ZXDecodeHints hints];
        
        ZXMultiFormatReader* reader = [ZXMultiFormatReader reader];
        ZXResult* result = [reader decode:bitmap
                                    hints:hints
                                    error:&error];
        if (result) {
            // The coded result as a string. The raw data can be accessed with
            // result.rawBytes and result.length.
            NSString* contents = result.text;
            [stdoutHandle writeData:[contents dataUsingEncoding:NSUTF8StringEncoding]];
            // The barcode format, such as a QR code or UPC-A
            //ZXBarcodeFormat format = result.barcodeFormat;
        } else {
            return err([NSString stringWithFormat:@"Failed to open image '%@'\n", fileName ]);
            // Use error to determine why we didn't get a result, such as a barcode
            // not being found, an invalid checksum, or a format inconsistency.
        }
    }
    return 0;
}

