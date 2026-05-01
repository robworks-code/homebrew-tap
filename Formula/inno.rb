class Inno < Formula
  desc "InnoDB file analysis toolkit for parsing, validating, and inspecting .ibd files"
  homepage "https://github.com/ringo380/idb-utils"
  license "MIT"
  version "5.1.0"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ringo380/idb-utils/releases/download/v#{version}/inno-v#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "41ead9a598f07cfeed71c8fa6a2d3dbfdb97cf44f6bd25b672fd796f827cc15f"
    else
      url "https://github.com/ringo380/idb-utils/releases/download/v#{version}/inno-v#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "06ec3e2656a942fd3dd6c2736d621892be4eb644c40e048b6fa1e56aa22930f2"
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ringo380/idb-utils/releases/download/v#{version}/inno-v#{version}-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d649c318d4cc529d5148c655756f5fb2d2b50f42e21473018484e8bd033ff284"
    else
      url "https://github.com/ringo380/idb-utils/releases/download/v#{version}/inno-v#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "8214ceb0bf434542c3581dbf6ae0db40597a8ab12968fe0dda5c130f75409232"
    end
  end

  def install
    bin.install "inno"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/inno --version")
    assert_match "Usage:", shell_output("#{bin}/inno --help")
  end
end
