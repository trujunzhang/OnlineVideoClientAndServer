
Pod::Spec.new do |s|
  s.name     = 'media_sqlite_manager'
  s.version  = '0.1.0'
  s.license  = 'MIT'
  s.summary  = 'media_sqlite_manager aims to be a drop-in replacement for UITabBarController.' 
  s.description = 'media_sqlite_manager aims to be a drop-in replacement of UITabBarController with the intention of letting developers easily customise its appearance. JBTabBar uses .'
  s.homepage = 'http://www.github.com/wanghaogithub720'
  s.author   = { 'Jin Budelmann' => 'jin@bitcrank.com' }
  s.source   = { :git => 'https://github.com/wanghaogithub720/mxYoutube.git', :tag => '0.1.0' }
  #s.platform = :osx

  #s.source_files = 'Pod/Classes/*.{h,m}'

  s.resources = "Pod/Assets/*/*.*"
  s.requires_arc = true

  s.subspec 'datastore' do |sub|
    sub.source_files = 'Pod/Classes/datastore/*.{h,m}'
  end

  s.subspec 'models' do |sub|
    sub.source_files = 'Pod/Classes/models/*.{h,m}'
  end

  s.subspec 'clientmodels' do |sub|
    sub.source_files = 'Pod/Classes/clientmodels/*.{h,m}'
  end

  s.subspec 'ArraySort' do |sub|
    sub.source_files = 'Pod/Classes/ArraySort/*.{h,m}'
  end

end


