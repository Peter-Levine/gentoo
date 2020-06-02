# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="A parser for Schrodinger Maestro files"
HOMEPAGE="https://github.com/schrodinger/maeparser"
SRC_URI="https://github.com/schrodinger/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="MIT-with-advertising"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/boost:=
	sys-libs/zlib:=
"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${PN}-1.2.3-libdir.patch )

src_configure() {
	local mycmakeargs=( -DMAEPARSER_BUILD_TESTS=$(usex test) )
	cmake_src_configure
}
