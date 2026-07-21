# typed: strict
# frozen_string_literal: true

# CodexDreamSkinManager installs the local theme management service and WebUI.
class CodexDreamSkinManager < Formula
  desc "Local WebUI for managing Codex Dream Skin on macOS"
  homepage "https://github.com/StarRain/Codex-Dream-Skin-Manager"
  url "https://github.com/StarRain/Codex-Dream-Skin-Manager/releases/download/v1.0.0/codex-dream-skin-manager-macos.tar.gz"
  sha256 "a055d60782dd4d3554f0329d9f2675ebd1dffa300b4ed78556235c593e7cd037"
  license "MIT"

  depends_on :macos
  depends_on "node@22"

  def install
    libexec.install Dir["*"]
    (bin/"codex-dream-skin-manager").write_env_script(
      libexec/"bin/codex-dream-skin-manager",
      MANAGER_NODE_BIN: formula_opt_bin("node@22")/"node",
    )
  end

  post_install_steps do
    mkdir_p "codex-dream-skin-manager/runtime"
    mkdir_p "log/codex-dream-skin-manager"
  end

  service do
    run [opt_bin/"codex-dream-skin-manager", "serve"]
    environment_variables(
      MANAGER_NODE_BIN:    formula_opt_bin("node@22")/"node",
      MANAGER_RUNTIME_DIR: var/"codex-dream-skin-manager/runtime",
      MANAGER_LOG_DIR:     var/"log/codex-dream-skin-manager",
    )
    keep_alive true
    log_path var/"log/codex-dream-skin-manager/manager.log"
    error_log_path var/"log/codex-dream-skin-manager/manager-error.log"
    working_dir var/"codex-dream-skin-manager"
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/codex-dream-skin-manager version")
  end
end
