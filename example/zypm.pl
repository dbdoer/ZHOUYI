use ZHOUYI;
use utf8
binmode STDOUT, ":utf8";


my ( $num1, $mum2 )=@ARGV;

my $reply = ZhouyiEx( ZYindex( $mum2, $num1 ));
my $reply1=outGua($reply);
my $replyyao=sixyao($reply);
my $replytuan=outtuan($reply);
my $replyxiang=outxiang($reply);


print $reply1,"\n";
print "===六爻==\n\n";
print $replyyao,"\n";
print "===彖辞==\n\n";
print $replytuan,"\n";
print "===象传==\n\n";
print $replyxiang,"\n";

