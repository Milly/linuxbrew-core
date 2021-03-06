class Hivemind < Formula
  desc "The mind to rule processes of your development environment"
  homepage "https://github.com/DarthSim/hivemind"
  url "https://github.com/DarthSim/hivemind/archive/v1.0.6.tar.gz"
  sha256 "8ca7884db49268b7938d0503e7e95443cb3a56696478d5dcc2b9813705525a39"
  head "https://github.com/DarthSim/hivemind.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles"
    cellar :any_skip_relocation
    sha256 "8e6f70ca5e0c8eb1e42d47bee207ec5333b453660d808103a36d53c51a7fb59a" => :mojave
    sha256 "7a89018774693681975cea22dcdebe35df043507476d1318f195e6d194978693" => :high_sierra
    sha256 "4aa25b52b5c7fd3dc7ae29ab31cf19eeddde4e7685fd7e9838be0ea8cf09f3c1" => :sierra
    sha256 "e74b7949bb598fe11915c409c0028787bf0d97a7dc915df165dac884077a372b" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/DarthSim/hivemind/").install Dir["*"]
    system "go", "build", "-o", "#{bin}/hivemind", "-v", "github.com/DarthSim/hivemind/"
  end

  test do
    (testpath/"Procfile").write("test: echo 'test message'")
    assert_match "test message", shell_output("#{bin}/hivemind")
  end
end
