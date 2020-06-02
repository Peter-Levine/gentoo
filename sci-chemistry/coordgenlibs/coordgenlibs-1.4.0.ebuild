# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Schrodinger's 2D coordinate generation library"
HOMEPAGE="https://github.com/schrodinger/coordgenlibs"
SRC_URI="https://github.com/schrodinger/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RESTRICT="!test? ( test )"

RDEPEND=""
DEPEND="
	test? (
		sci-chemistry/maeparser
		dev-libs/boost
	)"

PATCHES=( "${FILESDIR}"/${PN}-1.4.0-libdir.patch )

src_configure() {
	local mycmakeargs=(
		-DCOORDGEN_BUILD_EXAMPLE=$(usex test)
		-DCOORDGEN_BUILD_TESTS=$(usex test)
	)
	cmake_src_configure
}
