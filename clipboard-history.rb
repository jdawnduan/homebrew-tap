class ClipboardHistory < Formula
  desc "Clipboard history manager with daemon and hotkey support"
  homepage "https://github.com/jdawnduan/clipboard_history"
  url "https://github.com/jdawnduan/clipboard_history/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "cbd2ac43d0e3b4ad9e50a805b64a54e52b6b03e5b8b3a5b6f3f123f282547a0f"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  service do
    run [opt_bin/"clipboard-history", "daemon"]
    keep_alive true
    log_path var/"log/clipboard-history.log"
    error_log_path var/"log/clipboard-history.log"
  end

  test do
    system "#{bin}/clipboard-history", "--help"
  end
end
