#include "catch.hpp"
#include "fixture.h"

TEST_CASE("Basis", "[basis]") {
  std::stringstream sstr;
  sstr << "2\n\nO 0 0 0\nO 0 0 1.5";
  auto atoms = libint2::read_dotxyz(sstr);
  auto test = [&atoms](const char* name) {
    libint2::BasisSet bs;
    REQUIRE_NOTHROW(bs = libint2::BasisSet(
        name, atoms));
    std::cout << "name=" << name << std::endl;
    REQUIRE(bs.nbf() > 0);
  };
  for(auto&& bs_name : {"3-21g",
                         "6-311g_d_p_",
                         "6-31g",
                         "6-31g_d_",
                         "6-31g_d_p_",
                         "ano-rcc",
                         "aug-cc-pv5z-cabs",
                         "aug-cc-pvdz-cabs",
                         "aug-cc-pvqz-cabs",
                         "aug-cc-pvtz-cabs",
                         "augmentation-cc-pv5z",
                         "augmentation-cc-pv5z-jkfit",
                         "augmentation-cc-pv5z-ri",
                         "augmentation-cc-pv6z",
                         "augmentation-cc-pv6z-ri",
                         "augmentation-cc-pvdz",
                         "augmentation-cc-pvdz-jkfit",
                         "augmentation-cc-pvdz-ri",
                         "augmentation-cc-pvqz",
                         "augmentation-cc-pvqz-jkfit",
                         "augmentation-cc-pvqz-ri",
                         "augmentation-cc-pvtz",
                         "augmentation-cc-pvtz-jkfit",
                         "augmentation-cc-pvtz-ri",
                         "cc-pv5z",
                         "cc-pv5z-jkfit",
                         "cc-pv5z-ri",
                         "cc-pv6z",
                         "cc-pv6z-ri",
                         "cc-pvdz",
                         "cc-pvdz-f12",
                         "cc-pvdz-f12-cabs",
                         "cc-pvdz-jkfit",
                         "cc-pvdz-ri",
                         "cc-pvqz",
                         "cc-pvqz-f12",
                         "cc-pvqz-f12-cabs",
                         "cc-pvqz-jkfit",
                         "cc-pvqz-ri",
                         "cc-pvtz",
                         "cc-pvtz-f12",
                         "cc-pvtz-f12-cabs",
                         "cc-pvtz-jkfit",
                         "cc-pvtz-mini",
                         "cc-pvtz-ri",
                         "def2-qzvp",
                         "def2-qzvp-c",
                         "def2-qzvp-j",
                         "def2-qzvp-jk",
                         "def2-qzvpd",
                         "def2-qzvpp",
                         "def2-qzvpp-c",
                         "def2-qzvpp-j",
                         "def2-qzvpp-jk",
                         "def2-qzvppd",
                         "def2-qzvppd-c",
                         "def2-sv",
                         "def2-sv(p)",
                         "def2-sv(p)-c",
                         "def2-sv(p)-j",
                         "def2-sv(p)-jk",
                         "def2-svp",
                         "def2-svp-c",
                         "def2-svp-j",
                         "def2-svp-jk",
                         "def2-svpd",
                         "def2-svpd-c",
                         "def2-tzvp",
                         "def2-tzvp-c",
                         "def2-tzvp-j",
                         "def2-tzvp-jk",
                         "def2-tzvpd",
                         "def2-tzvpd-c",
                         "def2-tzvpp",
                         "def2-tzvpp-c",
                         "def2-tzvpp-j",
                         "def2-tzvpp-jk",
                         "def2-tzvppd",
                         "def2-tzvppd-c",
                         "mini",
                         "sto-3g",
                         "sto-6g"})
    test(bs_name);
}
