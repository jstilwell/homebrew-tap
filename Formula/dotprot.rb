class Dotprot < Formula
  desc "Lock up .env files (and anything in .prot) inside a 1Password vault."
  homepage "https://github.com/jstilwell/dotprot"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jstilwell/dotprot/releases/download/v0.5.0/dotprot-aarch64-apple-darwin.tar.xz"
      sha256 "0874b60d8424e82c06e0c9d06e04c4cd9b472d77a67fddaf88e921cec37a7456"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jstilwell/dotprot/releases/download/v0.5.0/dotprot-x86_64-apple-darwin.tar.xz"
      sha256 "aa276588b616481fdc8d8ad9251597ab287dd791dcd1c0e09b1c5e6fe86eb35b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jstilwell/dotprot/releases/download/v0.5.0/dotprot-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c6990154f96e01b445be8fc13560e057e7a9fb2a0ed14b214690a2bdcd837769"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jstilwell/dotprot/releases/download/v0.5.0/dotprot-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "30217fadd048b841f5a15884cd68928c4ecba09a5864bfbfb4690481a91bab71"
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
