class Umple < Formula
  desc "Umple: Model-Oriented Programming - embed models in code and vice versa and generate complete systems"
  homepage "http://www.umple.org"
  url "https://github.com/umple/umple/archive/v.1.27.1.tar.gz"
  sha256 "548ea671f9e5d2e9f7972c20d6527774fe3a466a2e65f5c8c4809c1fa6a0ad93"
  depends_on :java => "1.8+"
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
    system "dev-tools/tumple"
  end
end
