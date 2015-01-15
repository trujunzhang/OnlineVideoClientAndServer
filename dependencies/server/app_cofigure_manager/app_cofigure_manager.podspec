Pod::Spec.new do |s|
  s.name     = 'app_cofigure_manager'
  s.version  = '0.1.0'
  s.license  = 'MIT'
  s.summary  = 'app_cofigure_manager aims to be a drop-in replacement for UITabBarController.' 
  s.description = 'app_cofigure_manager aims to be a drop-in replacement of UITabBarController with the intention of letting developers easily customise its appearance. JBTabBar uses .'
  s.homepage = 'http://www.github.com/wanghaogithub720'
  s.author   = { 'Jin Budelmann' => 'jin@bitcrank.com' }
  s.source   = { :git => 'https://github.com/wanghaogithub720/mxYoutube.git', :tag => '0.1.0' }
  s.platform = :ios
  s.source_files = 'Pod/Classes/*.{h,m}'
  s.resources = "Pod/Assets/*/*.*"
  s.requires_arc = true

  s.subspec 'model' do |sub|
    sub.source_files = 'Pod/Classes/model/*.{h,m}'
  end

  s.subspec 'parse-config' do |sub|
    sub.source_files = 'Pod/Classes/parse-config/*.{h,m}'
  end

  s.subspec 'ConfigureLocalStore' do |sub|
    sub.source_files = 'Pod/Classes/ConfigureLocalStore/*.{h,m}'
  end

  s.subspec 'VideoType' do |sub|
    sub.source_files = 'Pod/Classes/VideoType/*.{h,m}'
  end

end

