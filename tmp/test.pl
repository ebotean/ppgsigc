#!/usr/bin/env perl
# #!/opt/csw/bin/perl -w /usr/share/eprints3/perl_lib
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../perl_lib";
use EPrints;

use constant false => 0;
use constant true  => 1;

my $ep = EPrints->new();
my $repo = $ep->repository('ppgsigc');
my $eprint = $repo->eprint(5);

my $type = $eprint->value('type');
my $name = $eprint->value('event_name');
my $edit = $eprint->value('event_edition');
my $reach = $eprint->value('event_reach');
my $org = $eprint->value('event_organizer');
my $com = $eprint->value('event_committee');
my $anal = $eprint->value('event_anals');
my $fin = $eprint->value('event_financial');
my $level = $eprint->value('event_level');

# print "$name: $edit, $reach, $org, $com, $anal, $fin, $level\n";

if ($type eq 'event') {
	if ($eprint->is_set('event_edition') and 
		$eprint->is_set('event_reach') and 
		$eprint->is_set('event_organizer') and 
		$eprint->is_set('event_committee') and 
		$eprint->is_set('event_anals') and 
		$eprint->is_set('event_financial')){

		my $edit = $eprint->value('event_edition');
		my $reach = $eprint->value('event_reach');
		my $org = $eprint->value('event_organizer');
		my $com = $eprint->value('event_committee');
		my $anal = $eprint->value('event_anals');
		my $fin = $eprint->value('event_financial');
		my $found = false;
		my $lvls = 3;
		my $e4 = true;
		my $e3 = true;
		my $e2 = true;

		# Critérios exclusivos do Evento tipo E4
		if ($e4 and ($edit > 9) and ($reach eq 'national' or $reach eq 'international') 
			and $anal eq 'TRUE' and $org eq 'org3' and $com eq 'com3' and $fin eq 'type2') {
			print ("\nE4");
			$eprint->set_value('event_level', 'e4');
			$eprint->commit;
			$found = true;
		}
		else {
			$e4 = false;
			print("falha e4 \n");
		}

		# Critérios aplicáveis ao Evento tipo E3
		if (!$found and !$e4 and $e3 and ($edit >= 5) and 
			($reach eq 'national' or $reach eq 'international') 
			and $anal eq 'TRUE' and $org eq 'org3' and $com eq 'com3' and $fin eq 'type2') {
			print ("\nE3");
			$eprint->set_value('event_level', 'e3');
			$eprint->commit;
			$found = true;
		}
		else {
			$e3 = false;
			print("falha e3\n");
		}

		# Critérios aplicáveis ao Evento tipo E2
		if (!$found and !$e4 and !$e3 and $e2 and ($edit >= 3) and 
			($reach eq 'regional' or $reach eq 'state' or $reach eq 'national' or $reach eq 'international') and
			($org eq 'org2' or $org eq 'org3') and ($com eq 'com2' or $com eq 'com3') and ($fin eq 'fin1' or $fin eq 'fin2')) {
			print ("\nE2");
			$eprint->set_value('event_level', 'e2');
			$eprint->commit;
			$found = true;
		}
		else {
			$e2 = false;
			print("falha e2\n");	
		}

		# Todos os outros critérios são aplicáveis ao E1
		# equivalente a !$e4 and !$e3 and !$e2
		if (!($e4 or $e3 or $e2)) {
			print("E1\n");
			$eprint->set_value('event_level', 'e1');
			$eprint->commit;
			$found = true;
		}
	}
}

