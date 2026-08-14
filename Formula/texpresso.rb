class Texpresso < Formula
  desc "Live rendering and error reporting for LaTeX"
  homepage "https://github.com/let-def/texpresso"
  license "MIT"
  head "https://github.com/let-def/texpresso.git", branch: "main"

  depends_on "pkgconf" => :build

  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "graphite2"
  depends_on "harfbuzz"
  depends_on "icu4c@78"
  depends_on "libpng"
  depends_on "mupdf-tools"
  depends_on "sdl2-compat"

  def install
    icu4c = Formula["icu4c@78"]

    # Upstream's macOS Makefiles call `brew --prefix` directly.
    # That is unsuitable inside a Homebrew formula build, so inject
    # the known Homebrew prefixes instead.
    ["Makefile", "src/engine/Makefile"].each do |makefile|
      inreplace makefile do |s|
        s.gsub! "BREW=$(shell brew --prefix)",
                "BREW=#{HOMEBREW_PREFIX}"
        s.gsub! "BREW_ICU4C=$(shell brew --prefix icu4c)",
                "BREW_ICU4C=#{icu4c.opt_prefix}"
      end
    end

    system "make", "all"

    bin.install "build/texpresso"
    bin.install "build/texpresso-xetex"
  end

  test do
    assert_predicate bin/"texpresso", :executable?
    assert_predicate bin/"texpresso-xetex", :executable?
  end
end
