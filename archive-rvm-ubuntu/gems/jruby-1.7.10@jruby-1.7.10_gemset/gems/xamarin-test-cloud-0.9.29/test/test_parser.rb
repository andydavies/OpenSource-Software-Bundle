require 'test/unit'
require 'thor'
require 'fileutils'
require 'xamarin-test-cloud/cli'

class TestParser < Test::Unit::TestCase
  def test_should_raise_if_no_app_or_api_key_is_given
    script = XamarinTestCloud::CLI.new([])
    assert_raise Thor::InvocationError do
      script.invoke(:submit)
    end

    script = XamarinTestCloud::CLI.new(["test/ipa/2012 Olympics_cal.ipa"])
    assert_raise Thor::InvocationError do
      script.invoke(:submit)
    end


  end

  def test_should_raise_if_app_is_not_file_ipa_or_apk
    script = XamarinTestCloud::CLI.new(["test/ipa/NONE_EXIST_2012 Olympics_cal.ipa","JIFZCTPZJJXJLEKMMYRY","."])
    assert_raise RuntimeError do
      script.invoke(:submit)
    end

    script = XamarinTestCloud::CLI.new(["test/ipa/features.zip","JIFZCTPZJJXJLEKMMYRY","."])

    assert_raise RuntimeError do
      script.invoke(:submit)
    end
  end

  def test_should_parse_all_configuration_options
    FileUtils.rm_f(File.join("test","vendor"))
    FileUtils.rm_f(File.join("test","Gemfile"))
    FileUtils.rm_f(File.join("test","Gemfile.lock"))

    config_options = {
        :host => "http://localhost:8080",
        :workspace => "test",
        :features => "test/ipa/features.zip",
        :config => "test/config/cucumber.yml",
        :profile => "a",
        "skip-check" => false,
        "reset-between-scenarios" => false,
        "dry-run" => true
    }
    script = XamarinTestCloud::CLI.new(["test/ipa/2012 Olympics_cal.ipa","JIFZCTPZJJXJLEKMMYRY"],config_options)


    script.invoke(:submit)

    FileUtils.rm_f(File.join("test","vendor","cache"))
    FileUtils.rm_f(File.join("test","Gemfile"))
    FileUtils.rm_f(File.join("test","Gemfile.lock"))



  end

end