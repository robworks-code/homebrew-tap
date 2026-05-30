# Homebrew formula for Inferno AI
class Inferno < Formula
  desc "Enterprise AI/ML model runner with automatic updates and real-time monitoring"
  homepage "https://github.com/ringo380/inferno"
  license "MIT OR Apache-2.0"
  version "0.10.6"

  # Platform-specific downloads
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ringo380/inferno/releases/download/v#{version}/inferno-macos-aarch64.tar.gz"
      sha256 "d26107290b62824f040ac6c97efbdc018e6338e94439aadc4ccec656a9b5d5bf"
    else
      url "https://github.com/ringo380/inferno/releases/download/v#{version}/inferno-macos-x86_64.tar.gz"
      sha256 "16b5cd6d91ee6f0a4393f5b69caae3625bbc423f06d1e67feba474a223583286"
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ringo380/inferno/releases/download/v#{version}/inferno-linux-aarch64.tar.gz"
      sha256 "dc1b3a5b77fa0041c0a80d3099dd1d2330fafa4559fe29f84d50a25968046f4c"
    else
      url "https://github.com/ringo380/inferno/releases/download/v#{version}/inferno-linux-x86_64.tar.gz"
      sha256 "b9e291b7ca7bfa80fa44ca866ad78024d89ead5f064f410bab8b50043590987f"
    end
  end

  def install
    # Install the binary (extracted from tar.gz)
    bin.install "inferno"

    # Create directories for models and config
    (var/"inferno/models").mkpath
    (var/"inferno/cache").mkpath
    (etc/"inferno").mkpath

    # Note: Shell completions not yet supported by inferno CLI
    # TODO: Add completions when `inferno completions` command is implemented
  end

  def post_install
    # Create default config if it doesn't exist
    unless (etc/"inferno/config.toml").exist?
      (etc/"inferno/config.toml").write <<~EOS
        # Inferno Configuration
        models_dir = "#{var}/inferno/models"
        cache_dir = "#{var}/inferno/cache"
        log_level = "info"

        [server]
        bind_address = "127.0.0.1"
        port = 8080

        [backend_config]
        gpu_enabled = true
        context_size = 4096
      EOS
    end
  end

  def caveats
    <<~EOS
      Inferno AI has been installed!

      Configuration file: #{etc}/inferno/config.toml
      Models directory: #{var}/inferno/models
      Cache directory: #{var}/inferno/cache

      To get started:
        inferno --help
        inferno models list
        inferno serve

      To install models:
        Place your GGUF/ONNX models in #{var}/inferno/models
    EOS
  end

  service do
    run [opt_bin/"inferno", "serve"]
    keep_alive true
    log_path var/"log/inferno.log"
    error_log_path var/"log/inferno-error.log"
    environment_variables INFERNO_CONFIG_FILE: etc/"inferno/config.toml"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/inferno --version")
    assert_match "Usage:", shell_output("#{bin}/inferno --help")
  end
end
