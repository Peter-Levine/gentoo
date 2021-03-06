# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=SHLOMIF
DIST_VERSION=0.17025
inherit perl-module

DESCRIPTION="Error/exception handling in an OO-ish way"

LICENSE+=" MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Scalar-List-Utils
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.280.801
	test? (
		virtual/perl-Test-Simple
	)
"

src_test() {
	perl_rm_files t/pod-coverage.t t/pod.t t/style-trailing-space.t
	perl-module_src_test
}
