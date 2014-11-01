#!/usr/bin/env rake
require 'rake'

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec) do |task|
    task.rspec_opts = '--color'
  end
rescue LoadError
  warn 'It looks like the Chef DK is not configured. Download the Chef DK'\
       " via\nhttps://downloads.getchef.com/chef-dk. On Linux and Mac OS X"\
       " add to $PATH with:\n"\
       '    eval "$(chef shell-init bash)"'
end

begin
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new do |task|
    task.fail_on_error = true
    task.options = %w(--display-cop-names)
  end
rescue LoadError
  warn '>>>>> Rubocop gem not loaded, omitting tasks'
end

begin
  require 'foodcritic/rake_task'
  require 'foodcritic'
  task default: [:foodcritic]
  FoodCritic::Rake::LintTask.new do |task|
    task.options = {
      fail_tags: ['any'],
      tags: ['~FC015']
    }
  end
rescue LoadError
  warn '>>>>> foodcritic gem not loaded, omitting tasks'
end

task default: 'test:quick'
namespace :test do
  desc 'Run all the quick tests.'
  task :quick do
    Rake::Task['rubocop'].invoke
    Rake::Task['foodcritic'].invoke
  end
end

unless ENV['CI']
  begin
    require 'kitchen/rake_tasks'
    Kitchen::RakeTasks.new

    desc 'Run _all_ the tests. Go get a coffee.'
    task :complete do
      Rake::Task['test:quick'].invoke
      Rake::Task['test:kitchen:all'].invoke
    end
  rescue LoadError
    puts '>>>>> Kitchen gem not loaded, omitting tasks'
  end
end

unless ENV['CI']
  namespace :standalone do
    require 'kitchen'

    @instances = []
    @config = Kitchen::Config.new
    @names = %w(node1-centos65 node2-centos65 standalone-centos65)
    @names.each { |name| @instances << @config.instances.get(name) }

    desc 'login to standalone server'
    task :login do
      @config.instances.get('standalone-centos65').login
    end

    desc 'create standalone cluster'
    task :create do
      @instances.each(&:create)
    end

    desc 'destroy standalone cluster'
    task :destroy do
      @instances.each(&:destroy)
    end

    desc 'converge standalone cluster'
    task :converge do
      @instances.each(&:converge)
    end
  end
end
