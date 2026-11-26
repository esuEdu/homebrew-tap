class Wraith < Formula
  desc "Terminal proxy for macOS that inspects HTTPS from one source you choose"
  homepage "https://esuedu.github.io/wraith/"
  url "https://github.com/esuEdu/wraith/releases/download/v2.0.0/wraith-v2.0.0.tar.gz"
  sha256 "bf6121fbe2e90f611851681e1ea0bbc6ad0de006b635d71e8560b63240c00a43"
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
    assert_match "removed in wraith v2.0.0", shell_output("#{bin}/wraith bypass 2>&1", 2)
    system bin/"wraith", "ca", "export", testpath/"ca.pem"
    assert_match "BEGIN CERTIFICATE", (testpath/"ca.pem").read
    refute_match "PRIVATE KEY", (testpath/"ca.pem").read
    assert_match "unknown command", shell_output("#{bin}/wraith nope 2>&1", 2)
  end
end
