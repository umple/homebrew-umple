class Umple < Formula
  desc "Umple: Model-Oriented Programming - embed models in code and vice versa and generate complete systems"
  homepage "https://www.umple.org"
  url "https://github.com/umple/umple/archive/refs/tags/v1.30.2.tar.gz"
  sha256 "fc2a880c876fdebc00657e2d4461ad5237bd85bda85742778b2ec49c143c31d4"
  license "MIT"

  bottle :unneeded

  depends_on "ant" => "with-ivy"
  depends_on "ant-contrib"
  def install
    # Use IO.popen instead of system if user should see progress of install so it doesn't look like it is hanging
    system "export UMPLEROOT=$(pwd); dev-tools/fbumple"
    # IO.popen("export UMPLEROOT=$(pwd); dev-tools/fbumple") { |io| while (line = io.gets) do puts line end }
    system "cd dist; echo '#!/bin/csh -f\njava -jar #{prefix}/libexec/'$(ls umple-*.jar)' $*' > ../umple"
    bin.install "umple"
    libexec.install Dir["dist/umple-*.jar"]
  end
  test do
    cmd =
    "echo 'class X{ a; }' >test.ump;
    umple test.ump -c -;
    ls *java;"
    `#{cmd}`
    assert_equal(true, File.file?("X.java"), "Java file was not created at umple compilation")
    assert_equal(true, File.file?("X.class"), "Java file was not compiled at umple compilation")
  end
end

