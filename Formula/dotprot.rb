class Dotprot < Formula
  desc "Lock up .env files (and anything in .prot) inside a 1Password vault."
  homepage "https://github.com/jstilwell/dotprot"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jstilwell/dotprot/releases/download/v0.3.0/dotprot-aarch64-apple-darwin.tar.xz"
      sha256 "139916416b3c66d2c2e1f5b05a9e859b1df9931bd586d0200f9229ecf3b9f868"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jstilwell/dotprot/releases/download/v0.3.0/dotprot-x86_64-apple-darwin.tar.xz"
      sha256 "485066c1f3f2d917bdba967d8de6ee4581758571f2a5af182a249a7ff827b4bb"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jstilwell/dotprot/releases/download/v0.3.0/dotprot-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "018c16a7064f16ac81a295fda9bfa1804e7a6d3b3d4ab01cfb293cb7d54eba09"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jstilwell/dotprot/releases/download/v0.3.0/dotprot-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "987b2814aae9166ee7b3d4001d5c06a15e464cf97d199aceb072ab623dab3912"
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
