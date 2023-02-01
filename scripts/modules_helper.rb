require "cocoapods-core/specification"

def defmodule(name:, summary:, description: summary, static: false, version: "1.0", create_test_spec: false, author:, dependencies: [])
  Pod::Spec.new do |s|

    puts "Local module " + name + " " + version

    s.name = name
    s.version = version
    s.summary = summary

    s.platform = :ios, "14.0"
    s.swift_version = "5.0"
    s.static_framework = static
    if static
      s.pod_target_xcconfig = { 'OTHER_LDFLAGS' => '$(inherited) -ObjC -l"c++"' }
    else
      s.pod_target_xcconfig = { 'SWIFT_INSTALL_OBJC_HEADER' => 'NO' }
    end

    s.description = description
    s.license = {
      :type => "Custom",
      :text => <<-LICENSE,
        Copyright 2019
        Permission is granted to MD
      LICENSE
    }

    s.author = author
    s.homepage = "https://github.com/NGDev1/iosPods"
    s.source = {:git => "https://github.com/NGDev1/iosPods", :tag => "#{s.version}"}

    #s.resource_bundle = { 'Resources' => 'Resources/**/*' }
    s.resources = [
      "Resources/**/*"
    ]

    s.subspec 'Source' do |ss|
      ss.source_files = ["Source/**/*"]
    end

    s.test_spec "Tests" do |test_spec|
#      test_spec.dependency "Nimble"
#      test_spec.dependency "Quick"
#      test_spec.dependency "TestAdditions"
      test_spec.source_files = [
        "**/*Tests.swift",
      ]
    end if create_test_spec

    dependencies.each do |dep|
      s.dependency dep
    end
     
  end
end
