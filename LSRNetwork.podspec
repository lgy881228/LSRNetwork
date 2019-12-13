#


Pod::Spec.new do |s|

 
  s.name         = "LSRNetwork"
  s.version      = "1.0.0"
  s.summary      = "网络请求 LSRNetworking."

   s.description  = <<-DESC
	针对afn的一点封装 集成数据解析，快速模型化
                   DESC

  s.homepage     = "http://github.com/LSRNetwork"


 
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.requires_arc = true	

  s.author             = { "lgy881228" => "510687394@qq.com" }

  s.platform     = :ios, "11.0"
  s.ios.deployment_target = "8.0"

  s.source      = { :git => 'https://github.com/lgy881228/LSRNetwork.git',
:tag => s.version.to_s }


  s.source_files  = "LSRNetwork/*.{h,m}"
  s.public_header_files = "LSRNetwork/*.h"
  s.dependency 'AFNetworking'
  s.dependency 'JSONModel'
  s.frameworks  = "UIKit","AVFoundation","Foundation","AFNetworking","JSONModel"

  s.pod_target_xcconfig = {'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES'}


end
