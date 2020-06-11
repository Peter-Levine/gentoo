# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

MY_P="openbabel-$(ver_rs 1- -)"

DESCRIPTION="Python bindings for OpenBabel (including Pybel)"
HOMEPAGE="http://openbabel.sourceforge.net/"
SRC_URI="https://github.com/openbabel/openbabel/archive/${MY_P}.tar.gz"

OB_S="${WORKDIR}/openbabel-${MY_P}"
S="${OB_S}/scripts/python"

KEYWORDS="~amd64 ~x86"
SLOT="0/7"
LICENSE="GPL-2"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

BDEPEND=">=dev-lang/swig-2"
RDEPEND="${PYTHON_DEPS}
	~sci-chemistry/openbabel-${PV}"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}/openbabel-python-3.1.1-python-27-and-38.patch" )

src_prepare() {
	default

	ln -s ../../{openbabel-python,stereo}.i openbabel/ || die

	sed "s|\${BABEL_VERSION}|${PV}|" openbabel/__init__.py.in \
		> openbabel/__init__.py || die
}
