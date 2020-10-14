Pod::Spec.new do |s|
  s.name             = 'Rebar'
  s.version          = '2.0.0'
  s.license          = 'MIT'
  s.summary          = 'Rebar'
  s.homepage         = 'https://github.com/dbagwell/Rebar'
  s.author           = 'David Bagwell'
  s.source           = { :git => 'https://github.com/dbagwell/Rebar.git', :tag => '2.0.0' }

  s.ios.deployment_target = '11.0'
  s.swift_version = '5.0'

  s.source_files     = 'Source/**/*'

  # s.dependency 'Pod'

end
