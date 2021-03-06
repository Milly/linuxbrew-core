class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://www.imagemagick.org/"
  # Please always keep the Homebrew mirror as the primary URL as the
  # ImageMagick site removes tarballs regularly which means we get issues
  # unnecessarily and older versions of the formula are broken.
  url "https://dl.bintray.com/homebrew/mirror/imagemagick%406--6.9.10-42.tar.xz"
  mirror "https://www.imagemagick.org/download/ImageMagick-6.9.10-42.tar.xz"
  sha256 "f2fd506ea053f1a03658dd470b376d7f91e5c1b224568540671d0a661ae6822a"
  head "https://github.com/imagemagick/imagemagick6.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles"
    sha256 "59ee46306393636bca93346b36f0a79fd060c1448de9aba9de3f00b86569ecbd" => :mojave
    sha256 "8229b8dceaa37f5ea1b25ddcd1dad2bce7fbf00bfb1374e3419b63f616bc67e8" => :high_sierra
    sha256 "f077a394f4cdf894cc90774396fb5f0bd8c34022748841a1f78716692b1d559d" => :sierra
    sha256 "bd360755c75e48e9107a088f88910e02c350d75989e5d6ac6204c45146f62aff" => :x86_64_linux
  end

  keg_only :versioned_formula

  depends_on "pkg-config" => :build

  depends_on "freetype"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libtool"
  depends_on "little-cms2"
  depends_on "openjpeg"
  depends_on "webp"
  depends_on "xz"

  skip_clean :la

  def install
    args = %W[
      --disable-osx-universal-binary
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-silent-rules
      --disable-opencl
      --disable-openmp
      --enable-shared
      --enable-static
      --with-freetype=yes
      --with-modules
      --with-webp=yes
      --with-openjp2
      --without-gslib
      --with-gs-font-dir=#{HOMEBREW_PREFIX}/share/ghostscript/fonts
      --without-fftw
      --without-pango
      --without-x
      --without-wmf
    ]

    # versioned stuff in main tree is pointless for us
    inreplace "configure", "${PACKAGE_NAME}-${PACKAGE_VERSION}", "${PACKAGE_NAME}"
    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match "PNG", shell_output("#{bin}/identify #{test_fixtures("test.png")}")
    # Check support for recommended features and delegates.
    features = shell_output("#{bin}/convert -version")
    %w[Modules freetype jpeg png tiff].each do |feature|
      assert_match feature, features
    end
  end
end
