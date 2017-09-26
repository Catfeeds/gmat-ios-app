//
//  HTVoiceRecordController.m
//  GMat
//
//  Created by hublot on 17/4/12.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTVoiceRecordController.h"
#import <UITableView+HTSeparate.h>
#import "HTSearchListController.h"
#import "HTSearchController.h"
#import "HTRecordManager.h"
#import "HTRecordThenRecognitionManager.h"
#import "HTDevicePermissionManager+HTSpeechPermission.h"

@interface HTVoiceRecordController ()

@property (nonatomic, strong) UIButton *recordButton;

@property (nonatomic, strong) HTRecordThenRecognitionManager *recognitionManager;

@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) HTSearchController *searchController;

@end

@implementation HTVoiceRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDataSource];
    [self initializeUserInterface];
}

- (void)initializeDataSource {
	
}

- (void)initializeUserInterface {
	[self.view addSubview:self.recordButton];
	[self.view addSubview:self.textView];
    
    __weak HTVoiceRecordController *weakSelf = self;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"搜索" style:UIBarButtonItemStylePlain handler:^(id sender) {
        weakSelf.searchController.active = true;
        [weakSelf presentViewController:weakSelf.searchController animated:true completion:nil];
    }];
}

- (UIButton *)recordButton {
	if (!_recordButton) {
		_recordButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height / 2)];
        UIImage *recordImage = [[UIImage imageNamed:@"ExerciseRecord128_128"] ht_resetSize:CGSizeMake(50, 50)];
		[_recordButton setImage:recordImage forState:UIControlStateNormal];
        [_recordButton setImage:[recordImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateSelected];
        _recordButton.tintColor = [UIColor orangeColor];
		
		__weak HTVoiceRecordController *weakSelf = self;
		[_recordButton ht_whenTap:^(UIView *view) {
            [HTDevicePermissionManager ht_sureDevicePermissionStyle:HTDevicePermissionStyleMicrophone authorized:^{
                #ifdef __IPHONE_10_0
                    [HTDevicePermissionManager ht_sureSpeechRecognizerAuthorized:^{
                        weakSelf.recordButton.selected = !weakSelf.recordButton.selected;
                        weakSelf.recognitionManager.isRecordAndRecognition = weakSelf.recordButton.selected;
                    } openUrlBlock:nil everDenied:^(void (^openUrlBlock)(void)) {
                        [HTAlert title:@"应用需要访问你的语音解析才能继续哦" sureAction:^{
                            if (openUrlBlock) {
                                openUrlBlock();
                            }
                        }];
                    } nowDenied:^(void (^openUrlBlock)(void)) {
                        [HTAlert title:@"应用需要访问你的语音解析才能继续哦" sureAction:^{
                            if (openUrlBlock) {
                                openUrlBlock();
                            }
                        }];
                    } restricted:^{
                        [HTAlert title:@"应用需要访问你的语音解析才能继续哦" sureAction:^{
                            
                        }];
                    }];
                #else
                    weakSelf.recordButton.selected = !weakSelf.recordButton.selected;
                    weakSelf.recognitionManager.isRecordAndRecognition = weakSelf.recordButton.selected;
                #endif
            } everDenied:^(void (^openUrlBlock)(void)) {
                [HTAlert title:@"应用需要访问你的麦克风才能继续哦" sureAction:^{
                    if (openUrlBlock) {
                        openUrlBlock();
                    }
                }];
            } nowDenied:^(void (^openUrlBlock)(void)) {
                [HTAlert title:@"应用需要访问你的麦克风才能继续哦" sureAction:^{
                    if (openUrlBlock) {
                        openUrlBlock();
                    }
                }];
            } restricted:^{
                [HTAlert title:@"应用需要访问你的麦克风才能继续哦" sureAction:^{
                    
                }];
            }];
		}];
	}
	return _recordButton;
}

- (HTRecordThenRecognitionManager *)recognitionManager {
	if (!_recognitionManager) {
		_recognitionManager = [[HTRecordThenRecognitionManager alloc] init];
		
		__weak HTVoiceRecordController *weakSelf = self;
		[_recognitionManager setRecognitionReplyBlock:^(NSString *totalRecognitionString, BOOL isFinally) {
			if (isFinally) {
				weakSelf.recordButton.selected = false;
                weakSelf.searchController.searchBar.text = totalRecognitionString;
                weakSelf.searchController.active = true;
                [weakSelf presentViewController:weakSelf.searchController animated:true completion:nil];
            } else {
                weakSelf.textView.text = totalRecognitionString;
            }
		}];
	}
	return _recognitionManager;
}

- (UITextView *)textView {
	if (!_textView) {
		_textView = [[UITextView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.recordButton.frame), self.view.bounds.size.width, self.view.bounds.size.height - CGRectGetMaxY(self.recordButton.frame))];
		_textView.font = [UIFont systemFontOfSize:15];
		_textView.textColor = [UIColor orangeColor];
		_textView.editable = false;
		_textView.selectable = true;
		_textView.bounces = false;
	}
	return _textView;
}

- (HTSearchController *)searchController {
    if (!_searchController) {
        HTSearchListController *searchListController = [[HTSearchListController alloc] init];
        _searchController = [[HTSearchController alloc] initWithSearchResultsController:searchListController];
        _searchController.searchResultsUpdater = searchListController;
    }
    return _searchController;
}

@end
