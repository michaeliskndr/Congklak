# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

def rx_pod
  pod 'RxSwift'
  pod 'RxCocoa'
end

def di_pod
  pod 'Swinject'
end

def rx_test
  pod 'RxTest'
end

target 'Congklak' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Congklak
  rx_pod
  di_pod
  target 'CongklakTests' do
    inherit! :search_paths
    # Pods for testing
    rx_test
  end

  target 'CongklakUITests' do
    # Pods for testing
  end

end
