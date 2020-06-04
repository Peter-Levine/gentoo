# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit perl-module

MY_P="openbabel-$(ver_rs 1- -)"

DESCRIPTION="Perl bindings for OpenBabel"
HOMEPAGE="http://openbabel.sourceforge.net/"
SRC_URI="https://github.com/openbabel/openbabel/archive/${MY_P}.tar.gz"

OB_S="${WORKDIR}/openbabel-${MY_P}"
S="${OB_S}/scripts/perl"

SLOT="0/7"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RESTRICT="!test? ( test )"

RDEPEND="
	dev-lang/perl:=
	~sci-chemistry/openbabel-${PV}"
DEPEND="${RDEPEND}"
BDEPEND=">=dev-lang/swig-2"

src_prepare() {
	default

	swig -perl5 -c++ -small -O -templatereduce -naturalvar -I/usr/include/openbabel$(ver_cut 1) \
		-o "${S}"/openbabel-perl.cpp -outdir "${S}" "${OB_S}"/scripts/openbabel-perl.i || die

	if use test; then
		rm t/data.t || die # https://github.com/openbabel/openbabel/issues/2247
		export DIST_TEST="parallel verbose"
	fi
}

src_configure() {
		local myconf=( INC="-I/usr/include/openbabel$(ver_cut 1)" )
		perl-module_src_configure
}
