Pod::Spec.new do |s|
  s.name = 'ZXingObjC'
  s.version = '3.0.0-alpha.1'
  s.summary = 'An Objective-C Port of the ZXing barcode framework.'
  s.homepage = 'https://github.com/TheLevelUp/ZXingObjC'
  s.author = 'ZXingObjC team'
  s.license = { :type => 'Apache License 2.0', :file => 'COPYING' }
  s.source = { :git => 'https://github.com/TheLevelUp/ZXingObjC.git', :tag => "#{s.version}" }
  s.source_files = 'ZXingObjC/**/*.{h,m}'
  s.requires_arc = true

  s.ios.deployment_target = '6.0'
  s.osx.deployment_target = '10.8'

  s.ios.frameworks = 'AVFoundation', 'CoreGraphics', 'CoreMedia', 'CoreVideo', 'ImageIO', 'QuartzCore'
  s.osx.frameworks = 'AVFoundation', 'CoreMedia', 'QuartzCore'

  s.subspec 'Core' do |ss|
    ss.source_files = 'ZXingObjC/client/*.{h,m}', 'ZXingObjC/common/**/*.{h,m}', 'ZXingObjC/core/*.{h,m}', 'ZXingObjC/multi/*.{h,m}'
  end

  s.subspec 'QRCode' do |ss|
    ss.dependency 'ZXingObjC/Core'
    ss.source_files = 'ZXingObjC/qrcode/**/*.{h,m}'
  end
end
