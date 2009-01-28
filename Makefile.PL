use strict;
use inc::Module::Install;

name("Twitter-Shell");
all_from('lib/Twitter/Shell.pm');
requires("Class::Accessor::Fast");
requires("Config::Any");
requires("Net::Twitter");
requires("Term::Shell");

install_script('script/twittershell');

&auto_install;
&WriteAll;