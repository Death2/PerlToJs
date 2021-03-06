#!/usr/bin/perl -w

# Perl core modules
use Cwd;
use Getopt::Long;
use File::Slurp;

# PerlToJs modules
use lib Cwd::abs_path("$0/../../lib");
use PerlToJs;

# Get options
my ($includes, $output_file) = ([], '');
GetOptions(
	'include=s' => $includes,
	'output=s' => \$output_file,
);

# Get command & arguments
my $command = $ARGV[0] or die "No command given\n";
my @arguments = @ARGV[1 .. $#ARGV];

# Define commands
my %commands = (
	bundle => sub {
		PerlToJs::getBundleJs(
			includes => $includes,
			modules => \@arguments,
		);
	},
	interface => sub {
		PerlToJs::getInterfaceJs();
	},
	help => sub {
		"
Usage:
  perl-to-js.pl bundle <module>... [--include <directory>]... [--output <file>]
  perl-to-js.pl interface [--output <file>]
  perl-to-js.pl help [--output <file>]
  perl-to-js.pl version [--output <file>]

Options:
  --include <directory>		an \@INC directory (any number allowed)
  --output <file>		the file to write to [default: STDOUT]
";
	},
	version => sub {
		$PerlToJs::VERSION
	},
);

# Run command
die "Unknown command '$command'\n" unless (exists $commands{$command});
my $output = &{$commands{$command}}();

# Write output
if ($output_file){
	write_file($output_file, $output);
} else {
	print STDOUT $output;
}