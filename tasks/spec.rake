
desc "Run all examples"
Spec::Rake::SpecTask.new('test:spec') do |t|
  t.spec_files = FileList['test/spec/**/*.rb']
end

desc "Run functional tests"
Spec::Rake::SpecTask.new('test:functional') do |t|
  t.spec_files = FileList['test/functional/*_spec.rb']
end
