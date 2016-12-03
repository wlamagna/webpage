#!/usr/bin/perl


open A, "ausapasovehiculo-2015.csv" or die("no pude abrir archivo");

my %total_x_fecha;
my %fechas;
while (<A>) {
	next if /^PERIODO/;
	chomp;
	my $line = $_;
	my ($periodo, $fecha, $dia, $hora, $hora_fin,$estacion, $vehiculo, $forma_pago, $cantidad) = split(/;/, $line);
	my ($fdia, $fmes, $fanio) = split(/\//, $fecha);
	my $pseudo_date = "$fmes$fdia"; # Creado para ordenarlos
	if (!(defined($total_x_fecha{"$pseudo_date"}))) {
		$total_x_fecha{"$pseudo_date"} = $cantidad;
		$fechas{"$pseudo_date"} = $fecha;
	} else {
		$total_x_fecha{"$pseudo_date"} = $total_x_fecha{"$pseudo_date"} + $cantidad;
	}
}
close A;

foreach my $fecha (sort keys %total_x_fecha) {
	print $fechas{"$fecha"};
	print "\t";
	print $fecha;
	print "\t";
	print $total_x_fecha{"$fecha"};
	print "\n";
}
