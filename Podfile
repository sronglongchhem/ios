workspace 'TogglTrackiOS.xcworkspace'
platform :ios, '11.0'

# ignore all warnings from all pods
# inhibit_all_warnings!

def rxswift
    pod 'RxSwift', '~> 5'
end

def rxcocoa
    pod 'RxCocoa', '~> 5'
end

def rxdatasources
    pod 'RxDataSources', '~> 4.0'
end

def rxtests
  pod 'RxBlocking', '~> 5'
  pod 'RxTest', '~> 5'
end

def analytics
  pod 'Firebase/Analytics'
  pod 'AppCenter'
end

project 'App/App.xcodeproj'
project 'Modules/TogglTrack/TogglTrack.xcodeproj'
project 'Modules/API/API.xcodeproj'
project 'Modules/Architecture/Architecture.xcodeproj'
project 'Modules/Networking/Networking.xcodeproj'
project 'Modules/Onboarding/Onboarding.xcodeproj'
project 'Modules/Timer/Timer.xcodeproj'
project 'Modules/Repository/Repository.xcodeproj'
project 'Modules/UIUtils/UIUtils.xcodeproj'
project 'Modules/Utils/Utils.xcodeproj'
project 'Modules/OtherServices/OtherServices.xcodeproj'
project 'Modules/Analytics/Analytics.xcodeproj'

target :App do
    project 'App/App.xcodeproj'

    target :AppTests do
        inherit! :search_paths
    end
end

target :TogglTrack do
    project 'Modules/TogglTrack/TogglTrack.xcodeproj'
    rxswift
    rxcocoa
    rxdatasources

    target :TogglTrackTests do
        inherit! :search_paths
    end
end

target :Onboarding do
    use_frameworks!
    project 'Modules/Onboarding/Onboarding.xcodeproj'
    rxswift
    rxcocoa
end

target :Timer do
    use_frameworks!
    project 'Modules/Timer/Timer.xcodeproj'
    rxswift
    rxcocoa
    rxdatasources

    target :TimerTests do
      rxtests
    end
end

target :Architecture do
    use_frameworks!
    project 'Modules/Architecture/Architecture.xcodeproj'
    rxswift
    rxcocoa
end

target :Networking do
    use_frameworks!
    project 'Modules/Networking/Networking.xcodeproj'
    rxswift
end

target :API do
    use_frameworks!
    project 'Modules/API/API.xcodeproj'
    rxswift
end

target :Repository do
    use_frameworks!
    project 'Modules/Repository/Repository.xcodeproj'
    rxswift
end

target :UIUtils do
  use_frameworks!
  project 'Modules/UIUtils/UIUtils.xcodeproj'
  rxswift
  rxcocoa
end

target :Utils do
    use_frameworks!
    project 'Modules/Utils/Utils.xcodeproj'
    rxswift
    rxcocoa
end

target :OtherServices do
    use_frameworks!
    project 'Modules/OtherServices/OtherServices.xcodeproj'
    rxswift
end

target :Analytics do
    use_frameworks!
    project 'Modules/Analytics/Analytics.xcodeproj'
    analytics
end

dynamic_frameworks = [analytics]
# Make all the other frameworks into static frameworks by overriding the static_framework? function to return true
pre_install do |installer|
  installer.pod_targets.each do |pod|
    if !dynamic_frameworks.include?(pod.name)
      puts "Overriding the static_framework? method for #{pod.name}"
      def pod.static_framework?;
        true
      end
    end
  end
end
