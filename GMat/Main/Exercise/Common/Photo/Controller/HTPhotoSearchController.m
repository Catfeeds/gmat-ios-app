//
//  HTPhotoSearchController.m
//  GMat
//
//  Created by hublot on 2017/3/17.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTPhotoSearchController.h"
#import "HTDevicePermissionManager.h"
#import "HTTakePhotoManager.h"
#import "HTImageCutView.h"
#import "HTSearchQuestionController.h"
#import "RTRootNavigationController.h"
#import <HTDevicePermissionManager.h>
#import "HTCroppedHelperView.h"

@interface HTPhotoSearchController ()

@property (nonatomic, strong) HTTakePhotoManager *takePhotoManager;

@property (nonatomic, strong) UIImageView *backgroundImageView;

@property (nonatomic, strong) UIButton *flashLightButton;

@property (nonatomic, strong) UIButton *takePhotoButton;

@property (nonatomic, strong) UIButton *chooseImageButton;

@property (nonatomic, strong) UILabel *titleNameLabel;

@property (nonatomic, strong) UIButton *exitButton;

@property (nonatomic, strong) HTImageCutView *cutCameraImageView;

@end

@implementation HTPhotoSearchController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initializeDataSource];
	[self initializeUserInterface];
}

- (void)viewDidAppear:(BOOL)animated {
	[UIApplication sharedApplication].statusBarHidden = true;
}

- (void)viewDidDisappear:(BOOL)animated {
	[self autoCloseFlashLightWhenOtherHandler];
	[UIApplication sharedApplication].statusBarHidden = false;
}

- (void)initializeDataSource {
	[HTDevicePermissionManager ht_sureDevicePermissionStyle:HTDevicePermissionStyleCamera authorized:^{
		[self.takePhotoManager reload];
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			NSArray *transformViewArray = @[self.flashLightButton, self.chooseImageButton, self.takePhotoButton, self.exitButton, self.titleNameLabel, self.cutCameraImageView.sureButton, self.cutCameraImageView.exitButton];
			[UIView animateWithDuration:0.25 animations:^{
				[transformViewArray enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL * _Nonnull stop) {
					view.transform = CGAffineTransformMakeRotation(- M_PI_2 * 0.35);
				}];
			} completion:^(BOOL finished) {
				[UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
					[transformViewArray enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL * _Nonnull stop) {
						view.transform = CGAffineTransformMakeRotation(M_PI_2);
					}];
				} completion:^(BOOL finished) {
					
				}];
			}];
		});
	} everDenied:^(void (^openUrlBlock)(void)) {
		[HTAlert title:@"没有相机访问权限" sureAction:^{
			if (openUrlBlock) {
				openUrlBlock();
			}
		}];
		[self.navigationController popViewControllerAnimated:true];
	} nowDenied:^(void (^openUrlBlock)(void)) {
		[HTAlert title:@"没有相机访问权限" sureAction:^{
			if (openUrlBlock) {
				openUrlBlock();
			}
		}];
		[self.navigationController popViewControllerAnimated:true];
	} restricted:^{
		[HTAlert title:@"没有相机访问权限" sureAction:^{
			
		}];
		[self.navigationController popViewControllerAnimated:true];
	}];
}

- (void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	self.takePhotoButton.layer.cornerRadius = self.takePhotoButton.bounds.size.width / 2;
	self.flashLightButton.layer.cornerRadius = self.exitButton.layer.cornerRadius = self.chooseImageButton.layer.cornerRadius = self.chooseImageButton.bounds.size.width / 2;
}

- (void)initializeUserInterface {
	self.navigationController.navigationBarHidden = true;
	[self.view.layer addSublayer:self.takePhotoManager.previewLayer];
	[self.view addSubview:self.backgroundImageView];
	[self.view addSubview:self.titleNameLabel];
	[self.view addSubview:self.takePhotoButton];
	[self.view addSubview:self.flashLightButton];
	[self.view addSubview:self.exitButton];
	[self.view addSubview:self.chooseImageButton];
	[self.view addSubview:self.cutCameraImageView];
	[self.takePhotoButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.mas_equalTo(self.view).offset(- 40);
		make.width.mas_equalTo(75);
		make.height.mas_equalTo(75);
		make.centerX.mas_equalTo(self.view);
	}];
	[self.titleNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
		make.center.mas_equalTo(self.view);
	}];
	
	[self.chooseImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.mas_equalTo(self.takePhotoButton);
		make.width.mas_equalTo(40);
		make.height.mas_equalTo(40);
		make.left.mas_equalTo(self.view).offset(20);
	}];
	[self.flashLightButton mas_updateConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(20);
		make.left.mas_equalTo(self.chooseImageButton);
		make.width.mas_equalTo(self.chooseImageButton);
		make.height.mas_equalTo(self.chooseImageButton);
	}];
	[self.exitButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.mas_equalTo(self.takePhotoButton);
		make.width.mas_equalTo(self.chooseImageButton);
		make.height.mas_equalTo(self.chooseImageButton);
		make.right.mas_equalTo(self.view).offset(- 20);
	}];
	[self.cutCameraImageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.mas_equalTo(self.view);
	}];
}

- (void)handleDealImageWithInputImage:(UIImage *)inputImage {
	if (!inputImage || inputImage.size.width < 1 || inputImage.size.height < 1) {
		[HTAlert title:@"获取图片失败"];
		return;
	}
	
	[self autoCloseFlashLightWhenOtherHandler];
	
	[HTCroppedHelperView showHelperView];

	__weak HTPhotoSearchController *weakSelf = self;
	self.cutCameraImageView.hidden = false;
	[self.cutCameraImageView setInputImage:inputImage outPutImageBlock:^(UIImage *outPutImage) {
		weakSelf.cutCameraImageView.hidden = true;
		if (outPutImage) {
			UIImage *searchImage = [outPutImage ht_customOrientationDisplay:UIImageOrientationLeft];
			HTSearchQuestionController *questionController = [[HTSearchQuestionController alloc] init];
			questionController.image = searchImage;
			[questionController setTryAgainCutImageBlock:^{
				[weakSelf.navigationController popViewControllerAnimated:true];
				[weakSelf handleDealImageWithInputImage:inputImage];
			}];
			[weakSelf.navigationController pushViewController:questionController animated:true];
		}
	}];
}

- (UIImageView *)backgroundImageView {
	if (!_backgroundImageView) {
		_backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
		_backgroundImageView.image = [UIImage imageNamed:@"ExerciseSearchNine"];
	}
	return _backgroundImageView;
}

- (UILabel *)titleNameLabel {
	if (!_titleNameLabel) {
		_titleNameLabel = [[UILabel alloc] init];
		NSMutableAttributedString *attributedString = [[[NSAttributedString alloc] initWithString:@"请按横屏拍照\n题目文字尽量与参考线平行" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont systemFontOfSize:14]}] mutableCopy];
		NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
		paragraphStyle.lineSpacing = 10;
		[attributedString addAttributes:@{NSParagraphStyleAttributeName:paragraphStyle} range:NSMakeRange(0, attributedString.length)];
		_titleNameLabel.attributedText = attributedString;
		_titleNameLabel.numberOfLines = 0;
		_titleNameLabel.textAlignment = NSTextAlignmentCenter;
	}
	return _titleNameLabel;
}

- (HTTakePhotoManager *)takePhotoManager {
	if (!_takePhotoManager) {
		_takePhotoManager = [[HTTakePhotoManager alloc] init];
	}
	return _takePhotoManager;
}

- (UIButton *)flashLightButton {
	if (!_flashLightButton) {
		_flashLightButton = [[UIButton alloc] init];
		[_flashLightButton setImage:[[UIImage imageNamed:@"ExerciseSearchLightSwitch"] ht_resetSizeZoomNumber:0.5] forState:UIControlStateNormal];
		[_flashLightButton setImage:[[[UIImage imageNamed:@"ExerciseSearchLightSwitch"] ht_resetSizeZoomNumber:0.5] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateSelected];
		[_flashLightButton setBackgroundImage:[UIImage ht_pureColor:self.chooseImageButton.backgroundColor] forState:UIControlStateNormal];
		[_flashLightButton setBackgroundImage:[UIImage ht_pureColor:[UIColor whiteColor]] forState:UIControlStateSelected];
		_flashLightButton.tintColor = self.chooseImageButton.backgroundColor;
		
		_flashLightButton.layer.masksToBounds = true;
		__weak HTPhotoSearchController *weakSelf = self;
		[_flashLightButton ht_whenTap:^(UIView *view) {
			weakSelf.takePhotoManager.openFlashLight = !weakSelf.takePhotoManager.openFlashLight;
			weakSelf.flashLightButton.selected = weakSelf.takePhotoManager.flashLightIsOpening;
		}];
	}
	return _flashLightButton;
}

- (UIButton *)takePhotoButton {
	if (!_takePhotoButton) {
		_takePhotoButton = [[UIButton alloc] init];
		[_takePhotoButton setImage:[[UIImage imageNamed:@"ExerciseSearchTakePhoto"] ht_resetSizeZoomNumber:0.5] forState:UIControlStateNormal];
		_takePhotoButton.backgroundColor = [UIColor ht_colorString:@"0099ff"];
		_takePhotoButton.layer.masksToBounds = true;
		
		__weak HTPhotoSearchController *weakSelf = self;
		[_takePhotoButton ht_whenTap:^(UIView *view) {
			weakSelf.takePhotoButton.enabled = false;
			[weakSelf.takePhotoManager cutCameraImageDataComplete:^(NSData *imageData) {
				weakSelf.takePhotoButton.enabled = true;
				UIImage *image = [UIImage imageWithData:imageData];
				image = [image ht_fixOrientation];
				[weakSelf handleDealImageWithInputImage:image];
			}];
		}];
	}
	return _takePhotoButton;
}

- (UIButton *)chooseImageButton {
	if (!_chooseImageButton) {
		_chooseImageButton = [[UIButton alloc] init];
		_chooseImageButton.titleLabel.font = [UIFont systemFontOfSize:14];
		[_chooseImageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[_chooseImageButton setTitle:@"相册" forState:UIControlStateNormal];
		_chooseImageButton.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.4];
		_chooseImageButton.layer.masksToBounds = true;
		__weak HTPhotoSearchController *weakSelf = self;
		[_chooseImageButton ht_whenTap:^(UIView *view) {
			UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
			imagePickerController.allowsEditing = false;
			imagePickerController.navigationBar.barTintColor = weakSelf.navigationController.navigationBar.barTintColor;
			imagePickerController.navigationBar.tintColor = weakSelf.navigationController.navigationBar.tintColor;
			imagePickerController.navigationBar.titleTextAttributes = weakSelf.navigationController.navigationBar.titleTextAttributes;
			imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
			[HTDevicePermissionManager ht_sureDevicePermissionStyle:HTDevicePermissionStylePhotos authorized:^{
				[weakSelf willPresentImagePickerController:imagePickerController];
			} everDenied:^(void (^openUrlBlock)(void)) {
				if (openUrlBlock) {
					[HTAlert title:@"没有相册访问权限哦😲" sureAction:^{
						openUrlBlock();
					}];
				}
			} nowDenied:^(void (^openUrlBlock)(void)) {
				if (openUrlBlock) {
					[HTAlert title:@"没有相册访问权限哦😲" sureAction:^{
						openUrlBlock();
					}];
				}
			} restricted:^{
				[HTAlert title:@"没有相册访问权限哦😲" sureAction:^{
					
				}];
			}];
		}];
	}
	return _chooseImageButton;
}

- (void)willPresentImagePickerController:(UIImagePickerController *)imagePickerController {
	UIStatusBarStyle statusBarStyle = [UIApplication sharedApplication].statusBarStyle;
	[imagePickerController setBk_didFinishPickingMediaBlock:^(UIImagePickerController *imagePickerController, NSDictionary *dictionary) {
		UIImage *image = dictionary[UIImagePickerControllerOriginalImage];
		[imagePickerController dismissViewControllerAnimated:true completion:^{
			[UIApplication sharedApplication].statusBarStyle = statusBarStyle;
		
			UIImage *inputImage = [image ht_fixOrientation];
			inputImage = [[UIImage alloc] initWithCGImage:inputImage.CGImage scale:inputImage.scale orientation:UIImageOrientationRight];
			[self handleDealImageWithInputImage:inputImage];
		}];
	}];
	[imagePickerController setBk_didCancelBlock:^(UIImagePickerController *imagePickerController) {
		[imagePickerController dismissViewControllerAnimated:true completion:^{
			[UIApplication sharedApplication].statusBarStyle = statusBarStyle;
		}];
	}];
	[self presentViewController:imagePickerController animated:true completion:nil];
}

- (void)autoCloseFlashLightWhenOtherHandler {
	if (self.takePhotoManager.flashLightIsOpening) {
		[self.flashLightButton ht_responderTap];
	}
}

- (UIButton *)exitButton {
	if (!_exitButton) {
		_exitButton = [[UIButton alloc] init];
		[_exitButton setImage:[[UIImage imageNamed:@"ExerciseClose128_128"] ht_resetSize:CGSizeMake(21, 21)] forState:UIControlStateNormal];
		_exitButton.backgroundColor = self.chooseImageButton.backgroundColor;
		_exitButton.layer.masksToBounds = true;
		__weak HTPhotoSearchController *weakSelf = self;
		[_exitButton ht_whenTap:^(UIView *view) {
			[weakSelf.navigationController popViewControllerAnimated:true];
		}];
	}
	return _exitButton;
}

- (HTImageCutView *)cutCameraImageView {
	if (!_cutCameraImageView) {
		_cutCameraImageView = [[HTImageCutView alloc] init];
		_cutCameraImageView.hidden = true;
	}
	return _cutCameraImageView;
}

- (UIBarButtonItem *)customBackItemWithTarget:(id)target action:(SEL)action {
	return nil;
}

@end
