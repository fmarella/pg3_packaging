Name:		promogest
Version:	3.0
Release:	0%{?dist}
Summary:	Erp and managerial program for small and medium enterprises

License:	GPLv2
URL:		http://www.promogest.me/promoGest
Source:		%{name}-%{version}.tar.xz

BuildRoot:	%{_tmppath}/%{name}-%{version}-%{release}-root
BuildArch:	noarch
Requires:	python-setuptools
Requires:	pygobject3-base
Requires:	subversion
Requires:	pysvn
Requires:	python-sqlalchemy
Requires:	python-reportlab
Requires:	python-pillow
Requires:	python-jinja2
Requires:	webkitgtk3
Requires:	poppler-glib
Requires:	python-xhtml2pdf
Requires:	python-alembic
Requires:	python-psycopg2
Requires:	zenity

%description
PromoGest è un programma di gestione per la vostra attività commerciale.

%prep
%setup

%build

%install
%{__rm} -rf %{buildroot}
#mkdir -p $RPM_BUILD_ROOT/%{_datadir}/promogest2
mkdir -p $RPM_BUILD_ROOT/%{_datadir}/pixmaps
mkdir -p $RPM_BUILD_ROOT/%{_datadir}/applications
mkdir -p ${RPM_BUILD_ROOT}/usr/bin
#install -m 644 COPYING $RPM_BUILD_ROOT/%{_datadir}/promogest2/.
install -m 755 pg-launcher $RPM_BUILD_ROOT/%{_bindir}/pg-launcher
install -m 644 promogest.png $RPM_BUILD_ROOT/%{_datadir}/pixmaps/.
install -m 644 promogest.desktop $RPM_BUILD_ROOT/%{_datadir}/applications/.
#%{__rm} $RPM_BUILD_ROOT/%{_datadir}/promogest2/COPYING

%post
/usr/bin/easy_install -U html5lib
/usr/bin/easy_install -U pisa
/usr/bin/easy_install -U xhtml2pdf

%clean
%{__rm} -rf $RPM_BUILD_ROOT

%files
%defattr(-, root, root, -)
%attr(755,root,root) %{_bindir}/pg-launcher
%doc README COPYING
%{_datadir}/applications/*
%{_datadir}/pixmaps/*

%changelog
* Mon Nov 21 2011 Francesco Marella <fmarl@besixdouze> - 2.9-2
- Add easy_install xhtml2pdf

* Mon Nov 14 2011 Francesco Marella <fmarl@besixdouze> - 2.9-1
- Update to 2.9

* Tue May 10 2011 Francesco Marella <fmarl@tabu> - 2.7.2-1
- Initial version
