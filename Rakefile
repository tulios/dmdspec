require "rake/clean"

OS = Rake.application.windows? ? :win : :posix 

EXTENSIONS_HASH = {
    :win => {
        :obj => ".obj",
        :exe => ".exe",
        :lib => ".lib"        
    },
    :posix => {
        :obj => ".o",
        :exe => "",
        :lib => ".a"
    }
}

def extension_for(type)
  return EXTENSIONS_HASH[OS][type]
end

project_name = "dmdspec"
spec_name = "#{project_name}_spec"

di_dir  = "import"
bin_dir = "bin"
obj_dir = "obj"
src_dir = "src"
test_src_dir = "test"
test_obj_dir = "#{obj_dir}/test"

lib_file = File.join(bin_dir, "#{project_name}#{extension_for :lib}")
spec_file = File.join(bin_dir, "#{spec_name}#{extension_for(:exe)}")

dflags = ["-I#{src_dir}"]
lflags = []

d_files = FileList[File.join("**", "*.d")]
src_files = FileList[File.join(src_dir, "**", "*.d")]
spec_src_files = FileList[File.join(test_src_dir, "**", "*.d")]

di_files = src_files.sub(/^#{src_dir}/, "#{di_dir}").sub(/\.d$/, ".di")

obj_files = src_files.sub(/^#{src_dir}/, "#{obj_dir}").sub(/\.d$/, extension_for(:obj))
spec_obj = spec_src_files.sub(/^#{test_src_dir}/, "#{test_obj_dir}").sub(/\.d$/, extension_for(:obj))

directory obj_dir
directory test_obj_dir
directory bin_dir
directory di_dir

task :default => [:spec]

desc "Create all D-Interface files for this project" 
task :interface => [di_dir] + di_files

desc "Create library for the project"
task :library => [:interface, bin_dir, lib_file]

desc "Build the binary containing the spec for the project"
task :build_tests => [:library, test_obj_dir, spec_file]

desc "Run spec for the project"
task :spec => [:build_tests] do 
  puts ""
  system spec_file     
end

file spec_file => [lib_file] + spec_obj do |t|
  sh "dmd #{lib_file} #{spec_obj} -of#{File.basename(t.name)}"
  FileUtils.mv(File.basename(t.name), bin_dir, :verbose => true) 
end

file lib_file => obj_files do |t|
  sh "dmd -lib #{obj_files} -of#{File.basename(t.name)}"
  FileUtils.mv(File.basename(t.name), bin_dir, :verbose => true)
end

rule extension_for(:obj) => lambda { |o| d_files.find { |s| File.basename(s, '.d') == File.basename(o, extension_for(:obj)) }} do |t|
  print t
  dir = File.dirname(t.name)
  FileUtils.mkdir_p(dir, :verbose => true) unless File.exist? dir
  sh "dmd -c #{dflags.join(" ")} -od#{File.dirname(t.name)} #{t.source}" 
end

rule ".di" => lambda { |o| src_files.find { |s| File.basename(s, '.d') == File.basename(o, ".di") } } do |t|
  dir = File.dirname(t.name)
  FileUtils.mkdir_p(dir, :verbose => true) unless File.exist? dir
  sh "dmd -c -o- -Isrc -Iimport -Hd#{dir} #{t.source}"
  print "test"
end

CLEAN.include File.join("**", "*.#{extension_for :obj}")
CLEAN.include File.join("**", "*.map")
CLEAN.include obj_dir
CLOBBER.include File.join(di_dir, "**", "*.di")
CLOBBER.include lib_file
CLOBBER.include spec_file
CLOBBER.include bin_dir
CLOBBER.include di_dir
