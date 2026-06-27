class Dotprot < Formula
  desc "Lock up .env files (and anything in .prot) inside a 1Password vault."
  homepage "https://github.com/jstilwell/dotprot"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jstilwell/dotprot/releases/download/v0.1.0/dotprot-aarch64-apple-darwin.tar.xz"
      sha256 "9866b5eb29d9c098fee14c63ac492c1696a1bd501aa75434bcd46aa471129267"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jstilwell/dotprot/releases/download/v0.1.0/dotprot-x86_64-apple-darwin.tar.xz"
      sha256 "ef9aeece2529ded30baea6f329611d2835ba934f4182f43fc59f0bb2939cac0d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jstilwell/dotprot/releases/download/v0.1.0/dotprot-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4547d6d5c2531562c642963bd84e9de269ee98b807517be6de0d9805b349798a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jstilwell/dotprot/releases/download/v0.1.0/dotprot-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ca0e89e539236da1d65c3ee8ffb9657e9c96ec4aa26558856acbda1a52a9238d"
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
