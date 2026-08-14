class DeepseekHarness < Formula
  desc "DeepSeek Harness: Everything is a Plugin."
  homepage "https://github.com/deepseek-ai/deepseek-harness"
  url "https://registry.npmjs.org/@deepseek-ai/dsh/-/dsh-0.1.0-rc.6.tgz"
  sha256 "1b8a9a0ad3c7feaece47926e0bd37ca151c7ccfa997953afa5fd01261784eadc"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dsh --version")
    assert_match "profile", shell_output("#{bin}/dsh --help")
  end
end
