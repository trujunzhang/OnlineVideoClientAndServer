Pod::Spec.new do |s|
  s.name     = 'STCollapseTableView'
  s.version  = '0.1.1'
  s.license  = 'MIT'
  s.summary  = 'A UITableView subclass that automatically collapse and/or expand your sections.' 
  s.description = '                    A UITableView subclass that automatically collapse and/or expand your sections.\n                    You just have to fill your datasource like for a classic UITableView and the magic will happen.\n'
  s.homepage = 'https://github.com/iSofTom/STCollapseTableView'
  s.author   = { 'Jin Budelmann' => 'jin@bitcrank.com' }
  s.source   = { :git => 'https://github.com/jinthagerman/VideoWatchDetailViewControlleriPad.git', :tag => '0.1.0' }
  s.platform = :ios
  s.source_files = 'Pod/Classes/*.{h,m}'
  s.resources = 'Pod/Assets/*/*.*'
  s.requires_arc = true
end