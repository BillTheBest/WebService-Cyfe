use inc::Module::Install;
name 'WebService-Cyfe';
all_from 'lib/WebService/Cyfe.pm';

requires 'Data::Printer';
requires 'JSON';
requires 'LWP';

build_requires 'Test::More';

use_test_base;
auto_include;
WriteAll;

