class Dotprot < Formula
  desc "Lock up .env files (and anything in .prot) inside a 1Password vault."
  homepage "https://github.com/jstilwell/dotprot"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jstilwell/dotprot/releases/download/v0.4.0/dotprot-aarch64-apple-darwin.tar.xz"
      sha256 "06d10045d4db01ae23e6481d6ac0c1ab6b70221578b3208faba12a1f4be4eb2c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jstilwell/dotprot/releases/download/v0.4.0/dotprot-x86_64-apple-darwin.tar.xz"
      sha256 "8dfc0dce4ead1712421d353bc47297fc07fd78b30782a5f0a576c8c4d9a64509"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jstilwell/dotprot/releases/download/v0.4.0/dotprot-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a6d9970e9ceb87b3bd202aa6842b3d7d7be6a38cd5d986ea51e71162994b9fa4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jstilwell/dotprot/releases/download/v0.4.0/dotprot-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d37e0ca2f4a51864f537ef8d4f69a242ecfa1be7c6c13f209d46be4fdbe35d2f"
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
