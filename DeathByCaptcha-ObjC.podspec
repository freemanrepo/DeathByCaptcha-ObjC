Pod::Spec.new do |s|
  s.name                  = 'DeathByCaptcha-ObjC'
  s.version               = '1.0.0'
  s.summary               = 'An API wrapper for DeathByCaptcha written in obj-c.'

  s.description           = <<-DESC
This is an API wrapper built in Objective-C specifically for DeathByCaptcha. It requires a DeathByCaptcha account and enough balance to solve captchas. More info available on deathbycaptcha.com.
                       DESC

  s.homepage              = 'https://github.com/freemanrepo/DeathByCaptcha-ObjC'
  s.license               = { :type => 'MIT', :file => 'LICENSE' }
  s.author                = { 'Majd Alfhaily' => 'majd@alfhaily.me' }
  s.source                = { :git => 'https://github.com/freemanrepo/DeathByCaptcha-ObjC.git', :tag => s.version.to_s }
  s.social_media_url      = 'https://twitter.com/freemanrepo'

  s.source_files          = 'DeathByCaptcha-ObjC.{h,m}'
  s.requires_arc          = true

  s.ios.deployment_target = '7.0'
  s.osx.deployment_target = '10.7'
  s.frameworks       = 'Foundation'
  s.dependency 'STHTTPRequest'
end
