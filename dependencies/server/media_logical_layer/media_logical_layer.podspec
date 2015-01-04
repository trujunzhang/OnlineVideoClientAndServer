
Pod::Spec.new do |s|
  s.name     = 'media_logical_layer'
  s.version  = '0.1.0'
  s.license  = 'MIT'
  s.summary  = 'media_logical_layer aims to be a drop-in replacement for UITabBarController.' 
  s.description = 'media_logical_layer aims to be a drop-in replacement of UITabBarController with the intention of letting developers easily customise its appearance. JBTabBar uses .'
  s.homepage = 'http://www.github.com/wanghaogithub720'
  s.author   = { 'Jin Budelmann' => 'jin@bitcrank.com' }
  s.source   = { :git => 'https://github.com/wanghaogithub720/mxYoutube.git', :tag => '0.1.0' }
  s.platform = :osx

  #s.source_files = 'Pod/Classes/*.{h,m}'

  s.resources = "Pod/Assets/*/*.*"
  s.requires_arc = true

  s.subspec 'analisisfold' do |sub|
    sub.source_files = 'Pod/Classes/analisisfold/*.{h,m}'
  end

  s.subspec 'GeneratethumbnailTask' do |sub|
    sub.source_files = 'Pod/Classes/GeneratethumbnailTask/*.{h,m}'
  end

  s.subspec 'AppConsole' do |sub|
    sub.source_files = 'Pod/Classes/AppConsole/*.{h,m}'
  end

end


