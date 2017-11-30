//
//  HTRecognizeManager.m
//  GMat
//
//  Created by hublot on 2017/3/29.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTRecognizeManager.h"
//#import "HTOpenCvImage.h"
//#import <TesseractOCR/TesseractOCR.h>
#import "HTBaiduOcrManager.h"

@implementation HTRecognizeManager

//+ (UIImage *)handleDealImageByOpenCVWithImage:(UIImage *)image {
//	
//	image = [HTOpenCvImage openCvImageWithImage:image];
//	
//	return image;
//	
//}

+ (void)recognizeByBaiduApiWithImage:(UIImage *)image successHandler:(void(^)(NSString *result))successHandler
						 failHandler:(void (^)(NSError* err))failHandler {
	dispatch_async(dispatch_get_global_queue(0, 0), ^{
		[HTBaiduOcrManager requestWithImage:image complete:^(NSString *recognizeString) {
			dispatch_async(dispatch_get_main_queue(), ^{
				if (recognizeString.length) {
					!successHandler ? : successHandler(recognizeString);
				} else {
					!failHandler ? : failHandler(nil);
				}
			});
		}];
	});
}

//+ (void)recognizeByTesseractOCRWithImage:(UIImage *)image successHandler:(void(^)(NSString *result))successHandler {
//	dispatch_async(dispatch_get_global_queue(0, 0), ^{
//		G8Tesseract *tesseract = [[G8Tesseract alloc] init];
//		tesseract.language = @"eng";
//		tesseract.pageSegmentationMode = G8PageSegmentationModeAuto;
//		tesseract.maximumRecognitionTime = 60;
//		UIImage *openCvImage = [self handleDealImageByOpenCVWithImage:image];
//		tesseract.image = openCvImage;
//		[tesseract recognize];
//		NSString *recognizedText = tesseract.recognizedText;
//		recognizedText = recognizedText.length ? recognizedText : @"";
//		dispatch_async(dispatch_get_main_queue(), ^{
//			if (successHandler) {
//				successHandler(recognizedText);
//			}
//		});
//	});
//}

+ (void)recognizeImage:(UIImage *)image complte:(void(^)(NSString *result))complte {
	[self recognizeByBaiduApiWithImage:image successHandler:^(NSString *result) {
		if (complte) {
			complte(result);
		}
	} failHandler:^(NSError *err) {
		if (complte) {
			complte(@"");
		}
//		[self recognizeByTesseractOCRWithImage:image successHandler:^(NSString *result) {
//			if (complte) {
//                complte(result);
//			}
//		}];
	}];
}

@end
