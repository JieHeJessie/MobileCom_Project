//
//  QRCodeTool.swift
//

import UIKit
import AVFoundation

typealias ScanResultBlock = ([String]) -> ()

class QRCodeTool: NSObject {
    
    // 根据给定的字符串, 转换成为二维码图片, 并将结果返回
    // 参数1: 需要转换的字符串
    // 参数2: 二维码中间的自定义图片
    // 返回值: 生成后的结果图片
    // 优化: 可以将自定义图片, 单独写成一个方法也可以, 也可以暴露更多的参数出去, 让方法变得更加灵活, 比如说是中间图片的大小
    class func generatorQRCode(inputStr: String, centerImage: UIImage?) -> UIImage {
        
        // 1. 创建二维码滤镜
        let filter = CIFilter(name: "CIQRCodeGenerator")
        
        // 1.1 恢复滤镜默认设置
        filter?.setDefaults()
        
        // 2. 设置滤镜输入数据
        // KVC
        let data = inputStr.dataUsingEncoding(NSUTF8StringEncoding)
        filter?.setValue(data, forKey: "inputMessage")
        
        // 2.2 设置二维码的纠错率
        filter?.setValue("M", forKey: "inputCorrectionLevel")
        
        
        // 3. 从二维码滤镜里面, 获取结果图片
        var image = filter?.outputImage
        
        
        // 借助这个方法, 处理成为一个高清图片
        let transform = CGAffineTransformMakeScale(20, 20)
        image = image?.imageByApplyingTransform(transform)
        
        // 3.1 图片处理
        // (23.0, 23.0)
        var resultImage = UIImage(CIImage: image!)
        //        print(resultImage.size)
        
        // 前景图片
        //        let center = UIImage(named: "erha.png")
        if centerImage != nil {
            resultImage = getNewImage(resultImage, center: centerImage!)
        }
        
        
        // 4. 显示图片
        return resultImage
        
        
        
    }
    
    
    
}

/// 私有方法
/// 这些方法, 都是工具类内部, 自己使用, 并不是直接暴漏给外界, 这样的话, 最好使用private关键字修饰我们的方法
extension QRCodeTool {
    
    // 根据一个图片的特征, 以及图片, 来绘制边框
    class private func drawFrame(image: UIImage, feature: CIQRCodeFeature) -> UIImage {
        
        let size = image.size
        //print(size)
        // 1. 开启图形上下文
        UIGraphicsBeginImageContext(size)
        
        
        // 2. 绘制大图片
        image.drawInRect(CGRectMake(0, 0, size.width, size.height))
        
        // 转换坐标系(上下颠倒)
        let context = UIGraphicsGetCurrentContext()
        CGContextScaleCTM(context, 1, -1)
        CGContextTranslateCTM(context, 0, -size.height)
        
        // 3. 绘制路径
        let bounds = feature.bounds
        let path = UIBezierPath(rect: bounds)
        UIColor.redColor().setStroke()
        path.lineWidth = 6
        path.stroke()
        
        // 4. 取出结果图片
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // 5. 关闭上下文
        UIGraphicsEndImageContext()
        
        
        // 6. 返回结果
        return resultImage
        
        
    }
    
    
    // 根据给定的两个图片, 生成合成后的图片, 返回给外界
    class private func getNewImage(sourceImage: UIImage, center: UIImage) -> UIImage {
        
        let size = sourceImage.size
        // 1. 开启图形上下文
        UIGraphicsBeginImageContext(size)
        
        // 2. 绘制大图片
        sourceImage.drawInRect(CGRectMake(0, 0, size.width, size.height))
        
        // 3. 绘制小图片
        let width: CGFloat = 100
        let height: CGFloat = 100
        let x: CGFloat = (size.width - width) * 0.5
        let y: CGFloat = (size.height - height) * 0.5
        center.drawInRect(CGRectMake(x, y, width, height))
        
        
        // 4. 取出结果图片
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // 5. 关闭上下文
        UIGraphicsEndImageContext()
        
        
        // 6. 返回结果
        return resultImage
        
        
        
    }
    
    
}





