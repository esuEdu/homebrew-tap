class Wraith < Formula
  desc "Terminal proxy for macOS: inspect one source, route chosen hosts around the VPN"
  homepage "https://esuedu.github.io/wraith/"
  url "https://github.com/esuEdu/wraith/releases/download/v1.2.0/wraith-v1.2.0.tar.gz"
  sha256 "95e5df80fddedaa7be290ac797b5604856d8b3e05760df3b3399738fe88d63ba"
  license "MIT"
  head "https://github.com/esuEdu/wraith.git", branch: "main"

  depends_on "go" => :build
  depends_on :macos

  def install
    ldflags = %W[
      -s -w
      -X github.com/esuEdu/wraith/internal/version.Version=v#{version}
      -X github.com/esuEdu/wraith/internal/version.Commit=homebrew
      -X github.com/esuEdu/wraith/internal/version.Date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/wraith"
    generate_completions_from_executable(bin/"wraith", "completion")
  end

  def caveats
    <<~EOS
      wraith creates its own CA on first use (in ~/.wraith/ca). Before uninstalling,
      take it out of your simulators and, if you trusted it, your Mac:
        wraith ca remove
        wraith ca untrust --mac
    EOS
  end

  test do
    ENV["WRAITH_HOME"] = testpath/"wraith"
    assert_match "wraith v#{version}", shell_output("#{bin}/wraith version")
    system bin/"wraith", "bypass", "add", "api.example.com"
    assert_match "api.example.com", shell_output("#{bin}/wraith bypass list")
    system bin/"wraith", "ca", "export", testpath/"ca.pem"
    assert_match "BEGIN CERTIFICATE", (testpath/"ca.pem").read
    refute_match "PRIVATE KEY", (testpath/"ca.pem").read
    assert_match "unknown command", shell_output("#{bin}/wraith nope 2>&1", 2)
  end
end
