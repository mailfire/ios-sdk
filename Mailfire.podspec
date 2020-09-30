Pod::Spec.new do |s|
s.name              = 'Mailfire'
s.version           = '1.2.2'
s.summary           = 'Use the Mailfire SDK to track and report events occured in your application.'
s.homepage          = 'https://api.mailfire.io'

s.author            = { 'Oleksandr Liashko' => 'oleksandr.liashko@corp.mailfire.io' }
s.license           = { :type => 'Apache-2.0', :file => 'LICENSE' }

s.platform          = :ios
s.source            = { :git => 'https://github.com/mailfire/ios-sdk.git', :tag => s.version.to_s }

s.ios.deployment_target = '10.0'
s.ios.vendored_frameworks = 'Mailfire.framework'
end
