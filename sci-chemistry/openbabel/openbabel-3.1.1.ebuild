# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
WX_GTK_VER="3.0"

inherit cmake desktop toolchain-funcs wxwidgets

MY_P="${PN}-$(ver_rs 1- -)"

DESCRIPTION="Interconverts file formats used in molecular modeling"
HOMEPAGE="http://openbabel.org/wiki/Main_Page"
SRC_URI="https://github.com/${PN}/${PN}/archive/${MY_P}.tar.gz"

S="${WORKDIR}/${PN}-${MY_P}"

# See src/CMakeLists.txt for LIBRARY_VERSION
SLOT="0/7.0.0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="cairo cpu_flags_arm_neon cpu_flags_x86_sse2 cpu_flags_x86_sse4_2 doc openmp test wxwidgets"

RESTRICT="!test? ( test )"

RDEPEND="
	dev-cpp/eigen:3
	dev-libs/libxml2:2
	>=dev-libs/rapidjson-1.1.0
	sci-chemistry/coordgenlibs
	sci-chemistry/maeparser
	sci-libs/inchi
	sys-libs/zlib
	cairo? ( x11-libs/cairo )
	wxwidgets? ( x11-libs/wxGTK:${WX_GTK_VER}[X] )
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=dev-util/cmake-2.4.8
	doc? ( app-doc/doxygen )
"

PATCHES=(
	"${FILESDIR}/${PN}-3.1.1-no-coordgen-template-file.patch"
	"${FILESDIR}/${P}-fix-patch-version.patch"
)

pkg_setup() {
	use openmp && tc-check-openmp
}

src_configure() {
	# -DOPTIMIZE_NATIVE=ON also forces -m CXXFLAGS
	# so define macros with append-cppflags instead
	use cpu_flags_x86_sse2 && append-cppflags -DRAPIDJSON_SSE2
	use cpu_flags_x86_sse4_2 && append-cppflags -DRAPIDJSON_SSE42
	use cpu_flags_arm_neon && append-cppflags -DRAPIDJSON_NEON

	use wxwidgets && setup-wxwidgets

	local mycmakeargs=(
		-DOPENBABEL_USE_SYSTEM_INCHI=ON
		-DENABLE_OPENMP=$(usex openmp)
		-DBUILD_GUI=$(usex wxwidgets)
		-DOPTIMIZE_NATIVE=OFF
		-DENABLE_TESTS=$(usex test)
		-DPYTHON_EXECUTABLE=false
		-DBUILD_DOCS=$(usex doc)
	)

	cmake_src_configure
}

src_test() {
	# wierd deadlock between test_builder tests
	cmake_src_test -j1
}

src_install() {
	use doc && cmake_src_install docs
	cmake_src_install

	dodoc doc/{dioxin.*,README.*}

	docinto html
	for x in doc/*.html; do
		[[ ${x} != doc/api*.html ]] && dodoc ${x}
	done

	if use doc ; then
		docinto html/API
		dodoc -r doc/API/html/*
	fi

	if use wxwidgets; then
		make_desktop_entry obgui "Open Babel" babel
		doicon src/GUI/babel.xpm
	fi
}

pkg_postinst() {
	optfeature "perl support" sci-chemistry/openbabel-perl
	optfeature "python support" sci-chemistry/openbabel-python
}
