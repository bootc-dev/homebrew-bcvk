class Bcvk < Formula
  desc "Bootc virtualization kit - launch ephemeral VMs and create disk images from bootc containers"
  homepage "https://github.com/bootc-dev/bcvk"
  url "https://github.com/bootc-dev/bcvk/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "67c632b26513f77edcf63b3da8b22941a4ef467c984bfce301544533a1f12979"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/bootc-dev/bcvk.git", branch: "main"

  depends_on "rust" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@3"

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"
    system "cargo", "install", *std_cargo_args(path: "crates/kit")
  end

  test do
    # Test that the binary exists and help works
    output = shell_output("#{bin}/bcvk --help")
    assert_match "bootc", output
    assert_match "Usage: bcvk <COMMAND>", output

    # Test that subcommands are available
    assert_match "ephemeral", output
    assert_match "to-disk", output
    assert_match "libvirt", output
  end
end
