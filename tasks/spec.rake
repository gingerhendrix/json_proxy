
desc "Run all examples"
Spec::Rake::SpecTask.new('test:spec') do |t|
  t.spec_files = FileList['test/spec/**/*.rb']
end

desc "Run cucumber tests"
Cucumber::Rake::Task.new('test:acceptance') do |t|
  t.cucumber_opts = "test/features --format pretty"
end

