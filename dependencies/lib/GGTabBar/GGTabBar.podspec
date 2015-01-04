Pod::Spec.new do |s|
  s.name         = "GGTabBar"
  s.version      = "0.0.2"
  s.summary      = "Simple UITabBar/UITabBarController replacement made by using AutoLayout"
  s.description  = "100% Made with Auto Layout customizable UITabBar or UITabBarController replacement. Forget CGRects and frames. Born out of the necessity of having a customizable UITabBar replacement that would be ready for any screen size and that adopted the more modern Auto Layout API."
  s.homepage     = "https://github.com/Goles/GGTabBar/"
  s.screenshots  = "https://raw.githubusercontent.com/Goles/GGTabBar/master/screenshot.png"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Nicolas Goles" => "goles.nicolas@gmail.com" }
  s.social_media_url   = "http://twitter.com/ngoles"
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/Goles/GGTabBar.git", :tag => "0.0.2" }

  s.resources = 'resources/*.*'

  s.subspec 'GGTabBar' do |sub|
    sub.source_files = 'GGTabBar/*.{h,m}'
  end

  s.subspec 'GGTabBarItem' do |sub|
    sub.source_files = 'GGTabBarItem/*.{h,m}'
  end

  s.requires_arc = true
end
