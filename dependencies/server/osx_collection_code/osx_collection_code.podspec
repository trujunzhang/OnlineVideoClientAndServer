
Pod::Spec.new do |s|
  s.name     = 'osx_collection_code'
  s.version  = '0.1.0'
  s.license  = 'MIT'
  s.summary  = 'osx_collection_code aims to be a drop-in replacement for UITabBarController.' 
  s.description = 'osx_collection_code aims to be a drop-in replacement of UITabBarController with the intention of letting developers easily customise its appearance. JBTabBar uses .'
  s.homepage = 'http://www.github.com/wanghaogithub720'
  s.author   = { 'Jin Budelmann' => 'jin@bitcrank.com' }
  s.source   = { :git => 'https://github.com/wanghaogithub720/mxYoutube.git', :tag => '0.1.0' }
  s.platform = :osx

  #s.source_files = 'Pod/Classes/*.{h,m}'

  s.resources = "Pod/Assets/*/*.*"
  s.requires_arc = true

  s.subspec 'CustomTable' do |sub|
    sub.source_files = 'Pod/Classes/CustomTable/*.{h,m}'
  end

  s.subspec 'uikit-Category' do |sub|
    sub.source_files = 'Pod/Classes/uikit-Category/*.{h,m}'
  end



end


