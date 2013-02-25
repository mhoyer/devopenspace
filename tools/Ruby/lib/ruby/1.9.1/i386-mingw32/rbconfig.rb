
# This file was created by mkconfig.rb when ruby was built.  Any
# changes made to this file will be lost the next time ruby is built.

module RbConfig
  RUBY_VERSION == "1.9.3" or
    raise "ruby lib version (1.9.3) doesn't match executable version (#{RUBY_VERSION})"

  TOPDIR = File.dirname(__FILE__).chomp!("/lib/ruby/1.9.1/i386-mingw32")
  DESTDIR = TOPDIR && TOPDIR[/\A[a-z]:/i] || '' unless defined? DESTDIR
  CONFIG = {}
  CONFIG["DESTDIR"] = DESTDIR
  CONFIG["MAJOR"] = "1"
  CONFIG["MINOR"] = "9"
  CONFIG["TEENY"] = "1"
  CONFIG["PATCHLEVEL"] = "362"
  CONFIG["INSTALL"] = '/usr/bin/install -c'
  CONFIG["prefix"] = (TOPDIR || DESTDIR + "")
  CONFIG["EXEEXT"] = ".exe"
  CONFIG["ruby_install_name"] = "ruby"
  CONFIG["RUBY_INSTALL_NAME"] = "ruby"
  CONFIG["RUBY_SO_NAME"] = "msvcrt-ruby191"
  CONFIG["SHELL"] = "/bin/sh"
  CONFIG["PATH_SEPARATOR"] = ":"
  CONFIG["PACKAGE_NAME"] = ""
  CONFIG["PACKAGE_TARNAME"] = ""
  CONFIG["PACKAGE_VERSION"] = ""
  CONFIG["PACKAGE_STRING"] = ""
  CONFIG["PACKAGE_BUGREPORT"] = ""
  CONFIG["exec_prefix"] = "$(prefix)"
  CONFIG["bindir"] = "$(exec_prefix)/bin"
  CONFIG["sbindir"] = "$(exec_prefix)/sbin"
  CONFIG["libexecdir"] = "$(exec_prefix)/libexec"
  CONFIG["datarootdir"] = "$(prefix)/share"
  CONFIG["datadir"] = "$(datarootdir)"
  CONFIG["sysconfdir"] = "$(prefix)/etc"
  CONFIG["sharedstatedir"] = "$(prefix)/com"
  CONFIG["localstatedir"] = "$(prefix)/var"
  CONFIG["includedir"] = "$(prefix)/include"
  CONFIG["oldincludedir"] = "/usr/include"
  CONFIG["docdir"] = "$(datarootdir)/doc/$(PACKAGE)"
  CONFIG["infodir"] = "$(datarootdir)/info"
  CONFIG["htmldir"] = "$(docdir)"
  CONFIG["dvidir"] = "$(docdir)"
  CONFIG["pdfdir"] = "$(docdir)"
  CONFIG["psdir"] = "$(docdir)"
  CONFIG["libdir"] = "$(exec_prefix)/lib"
  CONFIG["localedir"] = "$(datarootdir)/locale"
  CONFIG["mandir"] = "$(datarootdir)/man"
  CONFIG["DEFS"] = ""
  CONFIG["ECHO_C"] = ""
  CONFIG["ECHO_N"] = "-n"
  CONFIG["ECHO_T"] = ""
  CONFIG["LIBS"] = "-lshell32 -lws2_32 -limagehlp -lshlwapi "
  CONFIG["build_alias"] = ""
  CONFIG["host_alias"] = ""
  CONFIG["target_alias"] = ""
  CONFIG["BASERUBY"] = "ruby"
  CONFIG["RUBY_PROGRAM_VERSION"] = "1.9.3"
  CONFIG["RUBY_RELEASE_DATE"] = "2012-12-25"
  CONFIG["build"] = "i686-pc-mingw32"
  CONFIG["build_cpu"] = "i686"
  CONFIG["build_vendor"] = "pc"
  CONFIG["build_os"] = "mingw32"
  CONFIG["RUBY_BASE_NAME"] = "ruby"
  CONFIG["RUBYW_BASE_NAME"] = "rubyw"
  CONFIG["host"] = "i686-pc-mingw32"
  CONFIG["host_cpu"] = "i686"
  CONFIG["host_vendor"] = "pc"
  CONFIG["host_os"] = "mingw32"
  CONFIG["target"] = "i386-pc-mingw32"
  CONFIG["target_cpu"] = "i386"
  CONFIG["target_vendor"] = "pc"
  CONFIG["target_os"] = "mingw32"
  CONFIG["CC"] = "gcc"
  CONFIG["CFLAGS"] = "$(cflags)"
  CONFIG["LDFLAGS"] = "-L. "
  CONFIG["CPPFLAGS"] = "-DFD_SETSIZE=2048 $(DEFS) $(cppflags)"
  CONFIG["OBJEXT"] = "o"
  CONFIG["CXX"] = "g++"
  CONFIG["CXXFLAGS"] = "$(cxxflags)"
  CONFIG["CPP"] = "$(CC) -E"
  CONFIG["GREP"] = "/usr/bin/grep"
  CONFIG["EGREP"] = "/usr/bin/grep -E"
  CONFIG["GCC"] = "yes"
  CONFIG["GNU_LD"] = "yes"
  CONFIG["CPPOUTFILE"] = "-o conftest.i"
  CONFIG["OUTFLAG"] = "-o "
  CONFIG["COUTFLAG"] = "-o "
  CONFIG["try_header"] = ""
  CONFIG["RANLIB"] = "ranlib"
  CONFIG["AR"] = "ar"
  CONFIG["AS"] = "as"
  CONFIG["ASFLAGS"] = ""
  CONFIG["OBJDUMP"] = "objdump"
  CONFIG["OBJCOPY"] = ":"
  CONFIG["WINDRES"] = "windres"
  CONFIG["DLLWRAP"] = "dllwrap"
  CONFIG["NM"] = "nm"
  CONFIG["LN_S"] = "cp -p"
  CONFIG["SET_MAKE"] = ""
  CONFIG["INSTALL_PROGRAM"] = "$(INSTALL)"
  CONFIG["INSTALL_SCRIPT"] = "$(INSTALL)"
  CONFIG["INSTALL_DATA"] = "$(INSTALL) -m 644"
  CONFIG["MAKEDIRS"] = "/usr/bin/mkdir -p"
  CONFIG["DOT"] = ""
  CONFIG["DOXYGEN"] = ""
  CONFIG["PKG_CONFIG"] = ""
  CONFIG["RM"] = "rm -f"
  CONFIG["CP"] = "cp"
  CONFIG["RMDIR"] = "rmdir --ignore-fail-on-non-empty"
  CONFIG["RMDIRS"] = "rmdir --ignore-fail-on-non-empty -p"
  CONFIG["RMALL"] = "rm -fr"
  CONFIG["CHDIR"] = "cd"
  CONFIG["WERRORFLAG"] = "-Werror"
  CONFIG["ALLOCA"] = ""
  CONFIG["DLDFLAGS"] = " -Wl,--enable-auto-image-base,--enable-auto-import $(DEFFILE)"
  CONFIG["ARCH_FLAG"] = ""
  CONFIG["STATIC"] = ""
  CONFIG["CCDLFLAGS"] = ""
  CONFIG["LDSHARED"] = "$(CC) -shared $(if $(filter-out -g -g0,$(debugflags)),,-s)"
  CONFIG["LDSHAREDXX"] = "$(CXX) -shared $(if $(filter-out -g -g0,$(debugflags)),,-s)"
  CONFIG["DLEXT"] = "so"
  CONFIG["DLEXT2"] = ""
  CONFIG["LIBEXT"] = "a"
  CONFIG["LINK_SO"] = ""
  CONFIG["LIBPATHFLAG"] = " -L%s"
  CONFIG["RPATHFLAG"] = ""
  CONFIG["LIBPATHENV"] = ""
  CONFIG["TRY_LINK"] = ""
  CONFIG["STRIP"] = "strip"
  CONFIG["EXTSTATIC"] = ""
  CONFIG["setup"] = "Setup"
  CONFIG["TEST_RUNNABLE"] = "yes"
  CONFIG["PREP"] = "miniruby$(EXEEXT)"
  CONFIG["EXTOUT"] = ".ext"
  CONFIG["LIBRUBY_RELATIVE"] = "no"
  CONFIG["ARCHFILE"] = ""
  CONFIG["EXECUTABLE_EXTS"] = ".exe .com .cmd .bat"
  CONFIG["RDOCTARGET"] = "nodoc"
  CONFIG["CAPITARGET"] = "nodoc"
  CONFIG["INSTALLDOC"] = "nodoc"
  CONFIG["NULLCMD"] = ":"
  CONFIG["cppflags"] = "-DFD_SETSIZE=2048"
  CONFIG["cflags"] = " $(optflags) $(debugflags) $(warnflags)"
  CONFIG["cxxflags"] = " $(optflags) $(debugflags) $(warnflags)"
  CONFIG["optflags"] = "-O3 -fno-omit-frame-pointer"
  CONFIG["debugflags"] = "-g"
  CONFIG["warnflags"] = "-Wall -Wextra -Wno-unused-parameter -Wno-parentheses -Wno-long-long -Wno-missing-field-initializers -Werror=pointer-arith -Werror=write-strings -Werror=declaration-after-statement -Werror=implicit-function-declaration"
  CONFIG["LIBRUBY_LDSHARED"] = "$(CC) -shared $(if $(filter-out -g -g0,$(debugflags)),,-s)"
  CONFIG["LIBRUBY_DLDFLAGS"] = " -Wl,--enable-auto-image-base,--enable-auto-import -Wl,--out-implib=$(LIBRUBY) $(RUBYDEF)"
  CONFIG["rubyw_install_name"] = "$(RUBYW_INSTALL_NAME)"
  CONFIG["RUBYW_INSTALL_NAME"] = "$(RUBYW_BASE_NAME)"
  CONFIG["LIBRUBY_A"] = "lib$(RUBY_SO_NAME)-static.a"
  CONFIG["LIBRUBY_SO"] = "$(RUBY_SO_NAME).dll"
  CONFIG["LIBRUBY_ALIASES"] = ""
  CONFIG["LIBRUBY"] = "lib$(RUBY_SO_NAME).dll.a"
  CONFIG["LIBRUBYARG"] = "$(LIBRUBYARG_SHARED)"
  CONFIG["LIBRUBYARG_STATIC"] = "-l$(RUBY_SO_NAME)-static"
  CONFIG["LIBRUBYARG_SHARED"] = "-l$(RUBY_SO_NAME)"
  CONFIG["SOLIBS"] = "$(LIBS)"
  CONFIG["DLDLIBS"] = ""
  CONFIG["ENABLE_SHARED"] = "yes"
  CONFIG["MAINLIBS"] = ""
  CONFIG["COMMON_LIBS"] = "m"
  CONFIG["COMMON_MACROS"] = ""
  CONFIG["COMMON_HEADERS"] = "winsock2.h windows.h"
  CONFIG["EXPORT_PREFIX"] = " "
  CONFIG["SYMBOL_PREFIX"] = "_"
  CONFIG["THREAD_MODEL"] = "win32"
  CONFIG["PLATFORM_DIR"] = "win32"
  CONFIG["MAKEFILES"] = "Makefile GNUmakefile"
  CONFIG["rubylibprefix"] = "$(libdir)/$(RUBY_BASE_NAME)"
  CONFIG["ridir"] = "$(datarootdir)/$(RI_BASE_NAME)"
  CONFIG["RI_BASE_NAME"] = "ri"
  CONFIG["arch"] = "i386-mingw32"
  CONFIG["sitearch"] = "i386-msvcrt"
  CONFIG["ruby_version"] = "1.9.1"
  CONFIG["sitedir"] = "$(rubylibprefix)/site_ruby"
  CONFIG["vendordir"] = "$(rubylibprefix)/vendor_ruby"
  CONFIG["configure_args"] = " '--enable-shared' '--disable-install-doc' 'debugflags=-g' 'CPPFLAGS=-DFD_SETSIZE=2048' '--prefix=' 'LDFLAGS='"
  CONFIG["UNIVERSAL_ARCHNAMES"] = ""
  CONFIG["UNIVERSAL_INTS"] = ""
  CONFIG["rubyhdrdir"] = "$(includedir)/$(RUBY_BASE_NAME)-$(ruby_version)"
  CONFIG["sitehdrdir"] = "$(rubyhdrdir)/site_ruby"
  CONFIG["vendorhdrdir"] = "$(rubyhdrdir)/vendor_ruby"
  CONFIG["NROFF"] = "/bin/false"
  CONFIG["MANTYPE"] = "man"
  CONFIG["USE_RUBYGEMS"] = "YES"
  CONFIG["BUILTIN_TRANSSRCS"] = " newline.c"
  CONFIG["PACKAGE"] = "ruby"
  CONFIG["ruby_pc"] = "ruby-1.9.pc"
  CONFIG["exec"] = "exec"
  CONFIG["rubylibdir"] = "$(rubylibprefix)/$(ruby_version)"
  CONFIG["archdir"] = "$(rubylibdir)/$(arch)"
  CONFIG["sitelibdir"] = "$(sitedir)/$(ruby_version)"
  CONFIG["sitearchdir"] = "$(sitelibdir)/$(sitearch)"
  CONFIG["vendorlibdir"] = "$(vendordir)/$(ruby_version)"
  CONFIG["vendorarchdir"] = "$(vendorlibdir)/$(sitearch)"
  CONFIG["topdir"] = File.dirname(__FILE__)
  MAKEFILE_CONFIG = {}
  CONFIG.each{|k,v| MAKEFILE_CONFIG[k] = v.dup}
  def RbConfig::expand(val, config = CONFIG)
    newval = val.gsub(/\$\$|\$\(([^()]+)\)|\$\{([^{}]+)\}/) {
      var = $&
      if !(v = $1 || $2)
	'$'
      elsif key = config[v = v[/\A[^:]+(?=(?::(.*?)=(.*))?\z)/]]
	pat, sub = $1, $2
	config[v] = false
	config[v] = RbConfig::expand(key, config)
	key = key.gsub(/#{Regexp.quote(pat)}(?=\s|\z)/n) {sub} if pat
	key
      else
	var
      end
    }
    val.replace(newval) unless newval == val
    val
  end
  CONFIG.each_value do |val|
    RbConfig::expand(val)
  end

  # returns the absolute pathname of the ruby command.
  def RbConfig.ruby
    File.join(
      RbConfig::CONFIG["bindir"],
      RbConfig::CONFIG["ruby_install_name"] + RbConfig::CONFIG["EXEEXT"]
    )
  end
end
autoload :Config, "rbconfig/obsolete.rb" # compatibility for ruby-1.8.4 and older.
CROSS_COMPILING = nil unless defined? CROSS_COMPILING
