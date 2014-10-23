require 'rubocop/rake_task'
desc 'Run RuboCop style checks'
RuboCop::RakeTask.new(:rubocop)

require 'foodcritic'
desc 'Run Foodcritic style checks'
FoodCritic::Rake::LintTask.new(:foodcritic) do |t|
  t.options = {
    fail_tags: ['any'],
    tags: ['~FC015']
  }
end

require 'rspec/core/rake_task'
desc 'Run RSpec examples'
RSpec::Core::RakeTask.new(:spec)

require 'kitchen/rake_tasks'
Kitchen::RakeTasks.new

namespace :kitchen do
  require 'kitchen'

  desc 'Destroy standalone cluster'
  task :destroy do
    sh 'kitchen destroy'
  end

  namespace :'standalone' do
    @instances = []
    @config = Kitchen::Config.new
    @names = %w( standalone-centos65 )
    @names.each { |name| @instances << @config.instances.get(name) }

    desc 'Login to chef server'
    task :login do
      @config.instances.get('standalone-centos65').login
    end

    desc 'Verify chef server'
    task :verify do
      @config.instances.get('standalone-centos65').verify
    end

    desc 'Setup chef server'
    task :setup do
      @config.instances.get('standalone-centos65').setup
    end

    desc 'Create standalone cluster'
    task :create do
      @instances.each(&:create)
    end

    desc 'Converge standalone cluster'
    task :converge do
      @instances.each(&:converge)
    end
  end
end
