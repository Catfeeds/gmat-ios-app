//
//  HTOpenCvImage.m
//  GMat
//
//  Created by hublot on 2017/3/28.
//  Copyright © 2017年 thinku. All rights reserved.
//
//#import <opencv2/opencv.hpp>
//#import <opencv2/imgproc/types_c.h>
//#import <opencv2/imgcodecs/ios.h>
#import "HTOpenCvImage.h"

@implementation HTOpenCvImage

//+ (UIImage *)openCvImageWithImage:(UIImage *)image {
//	cv::Mat resultImage;
//	UIImageToMat(image, resultImage);
//	//转为灰度图
//	cvtColor(resultImage, resultImage, cv::COLOR_BGR2GRAY);
//	//利用阈值二值化
//	cv::threshold(resultImage, resultImage, 100, 255, CV_THRESH_BINARY);
//	
//	
//	// 倾斜矫正
//	
//	
//	UIImage *numberImage = MatToUIImage(resultImage);
	
//	cv::Mat wrapSrc;
//	//默认转为4通道 所以下面Scalar也得是4通道，否则不能正确实现颜色
//	UIImageToMat(numberImage, wrapSrc);
//	NSLog(@"wrapSrc cols%d rows%d channels%d type%d depth%d elemSize%zu",wrapSrc.cols,wrapSrc.rows,wrapSrc.channels(),wrapSrc.type(),wrapSrc.depth(),wrapSrc.elemSize());
//	
//	//灰度
//	cv::Mat graymat;
//	cvtColor(wrapSrc ,graymat,cv::COLOR_BGR2GRAY);
//	blur(graymat, graymat, cv::Size2d(7,7));
//	//二值化，灰度大于14的为白色 需要多调整 直至出现白色大梯形
//	graymat=graymat>14;
//	
//	//Shi-Tomasi 角点算法参数
//	int maxCorners=4;
//	std::vector<cv::Point2f> corners;
//	double qualityLevel=0.01;
//	double minDistance=100;//角点之间最小距离
//	int blockSize=7;//轮廓越明显，取值越大
//	bool useHarrisDetector=false;
//	double k=0.04;
//	//Shi-Tomasi 角点检测
//	goodFeaturesToTrack(graymat,corners,maxCorners,qualityLevel,minDistance,cv::Mat(),blockSize,useHarrisDetector,k);
//	//cout<<"检测到角点数:"<<corners.size()<<endl;
//	NSLog(@"检测到角点数:%lu",corners.size());
//	int r=10;
//	cv::RNG rng;
//	//画出来看看 找到的是不是四个顶点 另外角点检测出来的点顺序每次不一定相同
//	/*
//	 if(corners.size()==4){
//	 circle(wrapSrc,corners[0],r,Scalar(255,0,0,255),2,8,0);//红
//	 circle(wrapSrc,corners[1],r,Scalar(0,255,0,255),2,8,0);//绿
//	 circle(wrapSrc,corners[2],r,Scalar(0,0,255,255),2,8,0);//蓝
//	 circle(wrapSrc,corners[3],r,Scalar(255,255,0,255),2,8,0);//黄
//	 }
//	 _imageView.image= MatToUIImage(wrapSrc) ;
//	 return;
//	 */
//	std::vector<std::vector<cv::Point>> contoursOutLine;
//	findContours(graymat,contoursOutLine,CV_RETR_LIST,CV_CHAIN_APPROX_SIMPLE);
//	// 对轮廓计算其凸包//
//	// 边界框
//	cv::Rect boudRect;
//	std::vector<cv::Point2i>  poly ;
//	for( int i = 0; i < contoursOutLine.size();  i++)
//		{
//			// 边界框
//			boudRect=  boundingRect(contoursOutLine[i] );
//			//面积过滤
//			int tmpArea=boudRect.area();
//			if(tmpArea>= 50000 )
//				{
//					rectangle(wrapSrc,cvPoint(boudRect.x,boudRect.y),cvPoint(boudRect.br().x ,boudRect.br().y ),cvScalar(128),2);
//				}
//		}
//	//src=wrapSrc(boudRect); 用这种方式截屏有时候会出错 不知咋回事
//	//用IOS的 quartz api来截图
//	image=[UIImage imageWithCGImage:CGImageCreateWithImageInRect([numberImage CGImage], CGRectMake(boudRect.x,boudRect.y,boudRect.width,boudRect.height))];
//	cv::Mat src,warp_dst;
//	UIImageToMat(image, src);
//	
//	
//	warp_dst = cv::Mat::zeros( src.rows, src.cols, src.type() );
//	
//	//从梯形srcTri[4] 变换成 外包矩形dstTri[4]
//	cv::Point2f srcTri[4];
//	cv::Point2f dstTri[4];
//	
//	cv::Point2f aRect1=boudRect.tl();
//	// 梯形四个顶点 顺序为 左上  右上  左下  右下
//	cv::Point2f srcTri0 = cv::Point2f(corners[0].x-aRect1.x  ,corners[0].y-aRect1.y );
//	cv::Point2f srcTri1 = cv::Point2f(corners[2].x-aRect1.x  ,corners[2].y-aRect1.y );
//	cv::Point2f srcTri2 = cv::Point2f(corners[1].x-aRect1.x  , corners[1].y-aRect1.y );
//	cv::Point2f srcTri3 = cv::Point2f(corners[3].x-aRect1.x  , corners[3].y-aRect1.y );
//	//查找左上点 取出外包矩形的中点，然后把梯形四个顶点与中点进行大小比较，如x，y都小于中点的是左上，x大于中点，y小于中点 则为右上
//	cv::Point2f boudRectCenter=cv::Point2f(src.cols/2,src.rows/2);
//	if(srcTri0.x>boudRectCenter.x){
//		if(srcTri0.y>boudRectCenter.y){//右下
//			srcTri[3]=srcTri0;
//		} else{//右上
//			srcTri[1]=srcTri0;
//		}
//	} else{
//		if(srcTri0.y>boudRectCenter.y){//左下
//			srcTri[2]=srcTri0;
//		} else{//左上
//			srcTri[0]=srcTri0;
//		}
//	}
//	if(srcTri1.x>boudRectCenter.x){
//		if(srcTri1.y>boudRectCenter.y){//右下
//			srcTri[3]=srcTri1;
//		} else{//右上
//			srcTri[1]=srcTri1;
//		}
//	} else{
//		if(srcTri1.y>boudRectCenter.y){//左下
//			srcTri[2]=srcTri1;
//		} else{//左上
//			srcTri[0]=srcTri1;
//		}
//	}
//	
//	if(srcTri2.x>boudRectCenter.x){
//		if(srcTri2.y>boudRectCenter.y){//右下
//			srcTri[3]=srcTri2;
//		} else{//右上
//			srcTri[1]=srcTri2;
//		}
//	} else{
//		if(srcTri2.y>boudRectCenter.y){//左下
//			srcTri[2]=srcTri2;
//		} else{//左上
//			srcTri[0]=srcTri2;
//		}
//	}
//	
//	if(srcTri3.x>boudRectCenter.x){
//		if(srcTri3.y>boudRectCenter.y){//右下
//			srcTri[3]=srcTri3;
//		} else{//右上
//			srcTri[1]=srcTri3;
//		}
//	} else{
//		if(srcTri3.y>boudRectCenter.y){//左下
//			srcTri[2]=srcTri3;
//		} else{//左上
//			srcTri[0]=srcTri3;
//		}
//	}
//	// 画出来 看看顺序对不对
//	circle(src,srcTri[0],r,cv::Scalar(255,0,0,255),-1,8,0);//红 左上
//	circle(src,srcTri[1],r,cv::Scalar(0,255,0,255),-1,8,0);//绿 右上
//	circle(src,srcTri[2],r,cv::Scalar(0,0,255,255),-1,8,0);//蓝 左下
//	circle(src,srcTri[3],r,cv::Scalar(255,255,0,255),-1,8,0);//黄 右下
//	
//	numberImage = MatToUIImage(src);
//	
//	//  return;
//	
//	// 外包矩形的四个顶点， 顺序为 左上  右上  左下  右下
//	dstTri[0] = cv::Point2f( 0,0 );
//	dstTri[1] = cv::Point2f( src.cols - 1, 0 );
//	dstTri[2] = cv::Point2f( 0, src.rows - 1 );
//	dstTri[3] = cv::Point2f( src.cols - 1, src.rows - 1 );
//	//自由变换 透视变换矩阵3*3
//	cv::Mat warp_matrix( 3, 3, CV_32FC1 );
//	warp_matrix=getPerspectiveTransform(srcTri  ,dstTri  );
//	warpPerspective( src, warp_dst, warp_matrix, warp_dst.size(),cv::WARP_FILL_OUTLIERS);
//	
//	numberImage = MatToUIImage(warp_dst) ;
	
	
//	return numberImage;
//}

@end
