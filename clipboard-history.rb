class ClipboardHistory < Formula
  desc "Clipboard history manager with daemon and hotkey support"
  homepage "https://github.com/jdawnduan/clipboard_history"
  url "https://github.com/jdawnduan/clipboard_history/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "b309d86fb390ca7ff438e6699005ad0bf0d8541908aed6c783dadd56173c463a"
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
