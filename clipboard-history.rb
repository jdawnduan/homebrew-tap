class ClipboardHistory < Formula
  desc "Clipboard history manager with daemon and hotkey support"
  homepage "https://github.com/jdawnduan/clipboard_history"
  url "https://github.com/jdawnduan/clipboard_history/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "b99f697525447da3cb6ec7466f8f893caba4109c303853084a2a9d5aaa7cae46"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    # --- .app bundle for persistent TCC permissions ---
    app_name = "Clipboard History.app"
    app_dir = prefix / app_name / "Contents"
    macos_dir = app_dir / "MacOS"
    macos_dir.mkpath

    # Copy the binary into the bundle
    cp bin/"clipboard-history", macos_dir/"clipboard-history"

    # Write Info.plist with stable bundle identifier
    (app_dir / "Info.plist").write <<~PLIST
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>CFBundleExecutable</key>
        <string>clipboard-history</string>
        <key>CFBundleIdentifier</key>
        <string>com.jdawnduan.clipboard-history</string>
        <key>CFBundleName</key>
        <string>Clipboard History</string>
        <key>CFBundleVersion</key>
        <string>#{version}</string>
        <key>CFBundleShortVersionString</key>
        <string>#{version}</string>
        <key>CFBundlePackageType</key>
        <string>APPL</string>
        <key>LSUIElement</key>
        <true/>
        <key>NSAccessibilityUsageDescription</key>
        <string>Clipboard History needs accessibility access to simulate Cmd+V for pasting clipboard entries into your active application.</string>
      </dict>
      </plist>
    PLIST
    # ---------------------------------------------------

    # Symlink the bundle's binary so `brew services` finds it
    bin.install_symlink macos_dir/"clipboard-history" => "clipboard-history"
  end

  def caveats
    <<~EOS
      Clipboard History is now installed as a .app bundle.
      If you have stale permissions from a pre-0.2.0 version,
      run this once to clean them up:
        tccutil reset Accessibility com.jdawnduan.clipboard-history
    EOS
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
