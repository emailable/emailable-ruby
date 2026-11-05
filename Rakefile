require 'bundler/gem_tasks'
require 'rake/testtask'

# Tags are bare versions like 4.2.3, not Bundler's default v4.2.3.
Bundler::GemHelper.instance.define_singleton_method(:version_tag) do
  version.to_s
end

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/*_test.rb']
end

task :default => :test

namespace :release do
  desc 'Check, bump, commit, and tag a release, e.g. rake release:prepare[1.2.3]'
  task :prepare, [:version] do |_, args|
    version = args[:version].to_s
    abort 'error: version must be x.y.z' unless version.match?(/\A\d+\.\d+\.\d+\z/)
    abort 'error: working tree not clean' unless `git status --porcelain`.empty?
    abort 'error: release from master' unless `git branch --show-current`.strip == 'master'

    sh 'git fetch -q --tags origin master'
    unless `git rev-parse HEAD` == `git rev-parse origin/master`
      abort 'error: master is not in sync with origin'
    end

    current = Bundler::GemHelper.instance.gemspec.version
    unless Gem::Version.new(version) > current
      abort "error: version must be greater than #{current}"
    end
    abort "error: tag #{version} already exists" unless `git tag -l #{version}`.empty?

    Rake::Task[:test].invoke
    sh 'bundle exec rubocop'

    path = 'lib/emailable/version.rb'
    File.write(path, File.read(path).sub(/VERSION = '.*'/, "VERSION = '#{version}'"))
    sh "git commit -q -am 'Release #{version}'"
    sh "git tag -a #{version} -m #{version}"
    puts "Tagged #{version}. Push the commit and tag to release: git push --follow-tags"
  end
end
