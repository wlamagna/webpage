#!/usr/local/bin/perl

my $dato = substr $ENV{'QUERY_STRING'}, 10;

print "Content-type: text/xml\n\n";

my @datos = split("&", $dato);
my ($variable, $valor)  = split("=", $datos[0]);
$valor =~ s/[0-9]//g;

my @months = ("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec");
my $file = "/home/wallddbm/www/vast/email headers.csv";

open A, "$file" or die("no pude abrir email headers.csv");

print "<data wiki-url=\"http://simile.mit.edu/shelf/\" wiki-section=\"VAST 2014 - Grand Challenge\">\n";
while (<A>) {
        chomp;
        my $l = $_;
        next if ($l =~ /^From/);
        $l =~ s/\r//g;
        $l =~ s/\x92//g;
        my ($sender, $recipients, $date, $subject) = $l =~ /(.*?),(.*),([0-9].*?),(.*)$/g;
#       print "$sender\t$recipients\t$date\t$subject\n";
#next;
        $subject =~ s/"/ /g;
        # Print the sender and recipients
        $recipients =~ s/"//g;
        $recipients =~ s/ //g;
        # Para eliminar comunicaciones masivas
        my @aa = split(/,/,$recipients);
        next if (scalar(@aa) > 7);
        $sender =~ s/ //g;
	next if ((lc ($sender) !~ /$valor.*/) && (lc ($recipients) !~ /.*$valor/));
        my ($fecha, $time) = split(" ", $date);
        my ($month, $day, $year) = split("/", $fecha);
        $sender =~ s/\@.*//g;
        print "<event start=\"" . $months[($m)] . " $day $year $time:00\" title=\"$sender: $subject\"";
        print " icon=\"../timeline/timeline_js/images/icon_mail.gif\">\n";
        print "$date,$sender,$recipients\n";
        print "</event>\n";


}
close A;
print "</data>\n";
