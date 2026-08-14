class DeepseekHarness < Formula
  desc "Open-source agent harness developed by DeepSeek AI"
  homepage "https://github.com/deepseek-ai/deepseek-harness"
  url "https://registry.npmjs.org/@deepseek-ai/dsh/-/dsh-0.1.0-rc.6.tgz"
  sha256 "1b8a9a0ad3c7feaece47926e0bd37ca151c7ccfa997953afa5fd01261784eadc"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args

    # Remove node-pty prebuilds for other platforms and architectures
    prebuilds =
      libexec/"lib/node_modules/@deepseek-ai/dsh/node_modules/node-pty/prebuilds"

    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    target = "#{os}-#{arch}"

    prebuilds.each_child do |dir|
      rm_r dir if dir.basename.to_s != target
    end

    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dsh --version")
    assert_match "profile", shell_output("#{bin}/dsh --help")
  end
end
