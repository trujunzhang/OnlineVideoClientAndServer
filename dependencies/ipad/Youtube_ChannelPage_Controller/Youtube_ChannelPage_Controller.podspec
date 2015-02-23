
Pod::Spec.new do |s|
  s.name     = 'Youtube_ChannelPage_Controller'
  s.version  = '0.1.0'
  s.license  = 'MIT'
  s.summary  = 'Youtube_ChannelPage_Controller aims to be a drop-in replacement for UITabBarController with the intention of letting developers easily customise its appearance.' 
  s.description = 'Youtube_ChannelPage_Controller aims to be a drop-in replacement of UITabBarController with the intention of letting developers easily customise its appearance. JBTabBar uses .'
  s.homepage = 'http://jinthagerman.github.com/Youtube_ChannelPage_Controller'
  s.author   = { 'Jin Budelmann' => 'jin@bitcrank.com' }
  s.source   = { :git => 'https://github.com/jinthagerman/Youtube_ChannelPage_Controller.git', :tag => '0.1.0' }
  s.platform = :ios


  s.resources = "Pod/Assets/*/*.*"
  s.requires_arc = true


  s.subspec 'ChannelPage' do |sub|
    sub.source_files = 'Pod/Classes/ChannelPage/*.{h,m}'
  end

  s.subspec 'FileInfoVideoCollectionViewController' do |sub|
    sub.source_files = 'Pod/Classes/FileInfoVideoCollectionViewController/*.{h,m}'
  end

  s.subspec 'TabbarPage' do |sub|
    sub.source_files = 'Pod/Classes/TabbarPage/*.{h,m}'
  end

end

