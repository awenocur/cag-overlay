EAPI=7

LICENSE="MIT"
SLOT="0/${PV}"

KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~s390 ~sparc x86 ~amd64-linux ~x86-linux ~sparc-solaris ~x86-solaris"

RDEPEND="
	>=sci-libs/gsl-2
"

S=${WORKDIR}

src_unpack()
{
echo nothing to unpack
}

src_prepare()
{
eapply_user
}

src_configure()
{
echo nothing to configure
}

src_compile()
{
echo nothing to compile
}

src_install() {

	mkdir -p ${ED}/usr/$(get_libdir)
	cp "/usr/$(get_libdir)/libgsl.so" "${ED}/usr/$(get_libdir)/libgsl.so.0"
}
