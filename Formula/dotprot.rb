class Dotprot < Formula
  desc "Lock up .env files (and anything in .prot) inside a 1Password vault."
  homepage "https://github.com/jstilwell/dotprot"
  version "0.4.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jstilwell/dotprot/releases/download/v0.4.1/dotprot-aarch64-apple-darwin.tar.xz"
      sha256 "55bec01eb701c14dc4db67dc173e3510496a78eef9078d6eb932cb45bbbffc94"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jstilwell/dotprot/releases/download/v0.4.1/dotprot-x86_64-apple-darwin.tar.xz"
      sha256 "771becd602b7e8771df76c9187dafade73627a3e94a86ec6b7e117aa7118c4bf"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jstilwell/dotprot/releases/download/v0.4.1/dotprot-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a24709e653b9f17ea93208e45efcaeafed0792fdb3e81bfd63b31934c8f800f8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jstilwell/dotprot/releases/download/v0.4.1/dotprot-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "fc697f92caedc8b883e756a19ec0605328302a4466a9e170e091cd794bd79937"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "dotprot" if OS.mac? && Hardware::CPU.arm?
    bin.install "dotprot" if OS.mac? && Hardware::CPU.intel?
    bin.install "dotprot" if OS.linux? && Hardware::CPU.arm?
    bin.install "dotprot" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
