package ZHOUYI;

require Exporter;
use utf8;
use strict;
use warnings;

our @ISA    = qw(Exporter);
our @EXPORT = qw(ZhouyiEx ZYindex outGua sixyao outtuan outxiang maixyao maixiang);

=head1 NAME

ZHOUYI - The ZHOUYI is module interpreter and outer the Chinese ancient
philosophy of The Book of Change(易经);

=head1 VERSION

Version 0.07

=cut

our $VERSION = '0.08';

=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use ZHOUYI;

    my ( $num1, $mum2 )=@ARGV;
    my $foo = ZhouyiEx( ZYindex( $mum2, $num1 ), 'ZhouYi') ;
    print $foo;

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.


=head1 SUBROUTINES/METHODS

=cut

my ( $ZYdb, @ZYdb );
@ZYdb = <DATA>;
$ZYdb .= $_ for @ZYdb;

sub Bindex {
    my ( @yigua, %yi, %zy, @bagua, @bagua1,@bgindex,@num);

    @bagua  = qw(kun zhen kan dui gen li xun qian);
    @bagua1 = qw(di lei shui ze shan huo feng tian);
    @bgindex =
      qw(tian_tian tian_ze tian_huo tian_lei tian_feng tian_shui tian_shan tian_di ze_tian ze_ze ze_huo ze_lei ze_feng ze_shui ze_shan ze_di huo_tian huo_ze huo_huo huo_lei huo_feng huo_shui huo_shan huo_di lei_tian lei_ze lei_huo lei_lei lei_feng lei_shui lei_shan lei_di feng_tian feng_ze feng_huo feng_lei feng_feng feng_shui feng_shan feng_di shui_tian shui_ze shui_huo shui_lei shui_feng shui_shui shui_shan shui_di shan_tian shan_ze shan_huo shan_lei shan_feng shan_shui shan_shan shan_di di_tian di_ze di_huo di_lei di_feng di_shui di_shan di_di);
    @num =
      qw(1 10 13 25 44 6 33 12 43 58  49 17 28 47 31 45 14 38 30 21 50 64 56 35 34 54 55 51 32 40 62 16 9 61 37 42 57 59 53 20 5 60 63 3 48 29 39 8 26 41 21 27 18 4 52 23 11 19 36 24 46 7 15 2);

    @zy{@bgindex} = @num;
    for ( 0 .. 63 ) {

        my $zindexs = sprintf( "%lo", $_ );
        push @yigua, $zindexs;
    }

    for (@yigua) {

        if (/^\d$/) {

            #print $_,"\n";
            $yi{$_} = $bagua1[0] . "_" . $bagua1[$_];

        }
        else {
            my ( $q, $k ) = split //, $_;
            $yi{$_} = $bagua1[$q] . "_" . $bagua1[$k];
        }

    }

    return ( \%zy, \%yi );
}

sub ZYindex {
    my ( $wgua, $ngua ) = @_;
    $wgua %= 8;
    $ngua %= 8;
    my ( @index, @bgindex, @num, %qiankun );

    @index = qw(di tian ze huo lei feng shui shan);
    @bgindex =
      qw(tian_tian tian_ze tian_huo tian_lei tian_feng tian_shui tian_shan tian_di ze_tian ze_ze ze_huo ze_lei ze_feng ze_shui ze_shan ze_di huo_tian huo_ze huo_huo huo_lei huo_feng huo_shui huo_shan huo_di lei_tian lei_ze lei_huo lei_lei lei_feng lei_shui lei_shan lei_di feng_tian feng_ze feng_huo feng_lei feng_feng feng_shui feng_shan feng_di shui_tian shui_ze shui_huo shui_lei shui_feng shui_shui shui_shan shui_di shan_tian shan_ze shan_huo shan_lei shan_feng shan_shui shan_shan shan_di di_tian di_ze di_huo di_lei di_feng di_shui di_shan di_di);
    @num =
      qw(1 10 13 25 44 6 33 12 43 58  49 17 28 47 31 45 14 38 30 21 50 64 56 35 34 54 55 51 32 40 62 16 9 61 37 42 57 59 53 20 5 60 63 3 48 29 39 8 26 41 21 27 18 4 52 23 11 19 36 24 46 7 15 2);

    my $mindex = $index[$wgua] . "_" . $index[$ngua];
    @qiankun{@bgindex} = @num;
    return $qiankun{$mindex};
}

sub ZhouyiEx {
    my ( @line, $msg );
    my $n = shift;
    @line = split /^\s+$/sm, $ZYdb;
    my $i;
    for (@line) {
        $i++;
        $msg .= "$_\n" if $i == 2 * $n;
        $msg .= "$_\n" if $i == 2 * $n + 1;
    }

    return $msg;

}

sub outGua {
    my $msg = shift;
    my @guatext = split /\n/sm, $msg;
    my $omsg .= $guatext[1] . "\n\n" . $guatext[4] . "\n\n";
    return $omsg;
}

sub sixyao {
    my $msg = shift;
    my @guatext = split /\n/sm, $msg;
    my $omsg;
    $omsg .= outGua($msg);
    for (@guatext) {
        next if /^$/;
        next unless /^(初|六|九|上|用).：/;
        $omsg .= $_ . "\n";
    }
    return $omsg;
}

sub maixyao {
    my ( $msg, $yao ) = @_;
    my @guatext = split /\n/sm, $msg;
    my @yaoci;
    for (@guatext) {
        next if /^$/;
        next unless /^(初|六|九|上|用).：/;
        push @yaoci, $_;
    }
    return ( $yaoci[$yao], \@yaoci );
}

sub outtuan {

    my $msg = shift;
    my @guatext = split /\n/sm, $msg;
    my $omsg;
    $omsg .= outGua($msg);
    for (@guatext) {
        next if /^$/;
        next unless /《彖》/;
        $omsg .= $_ . "\n";
    }
    return $omsg;

}

sub outxiang {
    my $msg = shift;
    my @guatext = split /\n/sm, $msg;
    my $omsg;
    $omsg .= outGua($msg);
    for (@guatext) {
        next if /^$/;
        next unless /《象》/;
        $omsg .= $_ . "\n";
    }
    return $omsg;

}

sub maixiang {
    my ( $msg, $yao ) = @_;
    my @guatext = split /\n/sm, $msg;
    my @yaoci;
    for (@guatext) {
        next if /^$/;
        next unless /《象》/;
        push @yaoci, $_;
    }
    return ( $yaoci[$yao+1], \@yaoci );
}

=head1 AUTHOR

orange, C<< <bollwarm at ijz.me> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-zhouyi at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=ZHOUYI>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc ZHOUYI


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=ZHOUYI>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/ZHOUYI>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/ZHOUYI>

=item * Search CPAN

L<http://search.cpan.org/dist/ZHOUYI/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2016 orange.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). 

=cut

1;

# End of ZHOUYI

__DATA__
周易全文（上）
 
《易經》第一卦乾 乾為天 乾上乾下
 
乾，元亨，利貞。
初九：潛龍勿用。
九二：見龍再田，利見大人。
九三：君子終日乾乾，夕惕若，厲，無咎。
九四：或躍在淵，無咎。
九五：飛龍在天，利見大人。
上九：亢龍有悔。
用九：見群龍無首，吉。
《彖》曰：大哉乾元，萬物資始，乃統天。云行雨施，品物流形。大明始終，六位時成，時乘六龍以御天。乾道變化，各正性命，保合大和，乃利貞。首出庶物，萬國咸寧。
《象》曰：天行健，君子以自強不息。潛龍勿用，陽在下也。見龍在田，德施普也。終日乾乾，反復道也。或躍在淵，進無咎也。飛龍在天，大人造也。亢龍有悔，盈不可久也。用九，天德不可為首也。
《文言》曰：「元者，善之長也。亨者，嘉之會也。利者，義之和也。貞者，事之干也。君子體仁足以長人。嘉會足以合禮。利物足以和義。貞固足以干事。君子行此四者，故曰『乾，元亨利貞。』」
初九曰「潛龍勿用」，何謂也？
子曰：「龍德而隱者也。不易乎世，不成乎名，遯世而無悶，不見是而無悶。樂則行之，憂則違之，確乎其不可拔，乾龍也。」
九二曰「見龍在田，利見大人」，何謂也？
子曰：「龍德而正中者也。庸言之信，庸行之謹，閑邪存其誠，善世而不伐，德博而化。《易》曰『見龍在田，利見大人』，君德也。」
九三曰「君子終日乾乾，夕惕若，厲無咎」，何謂也？
子曰：「君子進德修業。忠信，所以進德也；修辭立其誠，所以居業也。知至至之，可與几也；知終終之，可與存義也。是故，居上位而不驕，在下位而不憂。故乾乾因其時而惕，雖危而無咎矣。」
九四曰「或躍在淵，無咎」，何謂也？
子曰：「上下無常，非為邪也。進退無恆，非離群也。君子進德修業，欲及時也，故無咎。」
九五曰「飛龍在天，利見大人」，何謂也？
子曰：「同聲相應，同氣相求。水流濕，火就燥，云從龍，風從虎，聖人作而萬物睹。本乎天者親上，本乎地者親下，則各從其類也。」
上九曰「亢龍有悔」，何謂也？
子曰：「貴而無位，高而無民，賢人在下而無輔，是以動而有悔也。」
「乾龍勿用」，下也。「見龍在田」，時舍也。「終日乾乾」，行事也。「或躍在淵」，自試也。「飛龍在天」，上治也。「亢龍有悔」，窮之災也。乾元用九，天下治也。
「乾龍勿用」，陽氣潛藏。「見龍在田」，天下文明。「終日乾乾」，與時偕行。「或躍在淵」，乾道乃革。「飛龍在天」，乃位乎天德。「亢龍有悔」，與時偕極。乾元用九，乃見天則。
乾元者，始而亨者也。利貞者，性情也。乾始能以美利利天下，不言所利，大矣哉！大哉乾乎！剛健中正，純粹精也。六爻發揮，旁通情也。時乘六龍，以御天也。云行雨施，天下平也。
君子以成德為行，日可見之行也。潛之為言也，隱而未見，行而未成，是以君子弗用也。
君子學以聚之，問以辯之，寬以居之，仁以行之。《易》曰「見龍在田，利見大人」，君德也。
九三重剛而不中，上不在天，下不在田，故乾乾因其時而惕，雖危無咎矣。
九四重剛而不中，上不在天，下不在田，中不在人，故或之。或之者，疑之也，故無咎。
夫大人者，與天地合其德，與日月合其明，與四時合其序，與鬼神合其吉凶。先天而天弗違，后天而奉天時。天且弗違，而況於人乎？況於鬼神乎？
亢之為言也，知進而不知退，知存而不知亡，知得而不知喪。其唯聖人乎！知進退存亡，而不失其正者，其唯聖人乎！
 
《易經》第二卦坤 坤為地 坤上坤下
 
坤，元亨，利牝馬之貞。君子有攸往，先迷后得主。利西南，得朋，東北，喪朋。安貞，吉。
《彖》曰：至哉坤元！萬物資生，乃順承天。坤厚載物，德合無疆。含弘光大，品物咸亨。牝馬地類，行地無疆，柔順利貞。君子攸行，先迷失道，后順得常。西南得朋，乃與類行。東北喪朋，乃終有慶。安貞之吉，應地無疆。
《象》曰：地勢坤，君子以厚德載物。
初六：履霜，堅冰至。
《象》曰：履霜堅冰，陰始凝也。馴致其道，至堅冰也。
六二：直，方，大，不習無不利。
《象》曰：六二之動，直以方也。不習無不利，地道光也。
六三：含章，可貞。或從王事，無成有終。
《象》曰：「含章，可貞」，以時發也。「或從王事」，知光大也。
六四：括囊，無咎，無譽。
《象》曰：「括囊，無咎」，慎不害也。
六五：黃裳，元吉。
《象》曰：「黃裳，元吉」，文在中也。
上六：龍戰於野，其血玄黃。
《象》曰：「龍戰於野」，其道窮也。
用六：利永貞。
《象》曰：用六永貞，以大終也。
《文言》曰：坤至柔而動也剛，至靜而德方，后得主而有常，含萬物而化光。坤道其順乎？承天而時行。
積善之家，必有餘慶。積不善之家，必有餘殃。臣弒其君，子弒其父，非一朝一夕之故，其所由來者漸矣，由辯之不早辯也。《易》曰「履霜堅冰至」，蓋言順也。
直其正也，方其義也。君子敬以直內，義以方外，敬義立而德不孤。「直，方，大，不習無不利」，則不疑其所行也。
陰雖有美，含之以從王事，弗敢成也，地道也，妻道也，臣道也。地道無成而代有終也。
天地變化，草木蕃。天地閉，賢人隱。《易》曰「括囊，無咎，無譽」，蓋言謹也。
君子黃中通理，正位居體，美在其中，而暢於四支，發於事業，美之至也。
陰疑於陽必戰，為其嫌於無陽也，故稱龍焉，猶未離其類也，故稱血焉。夫玄黃者，天地之雜也。天玄而地黃。
 
《易經》第三卦屯 水雷屯 坎上震下
 
屯，元亨，利貞，勿用有攸往，利建侯。
《彖》曰：屯，剛柔始交而難生，動乎險中，大亨貞。雷雨之動滿盈，天造草昧，宜建侯而不寧。
《象》曰：云雷，屯。君子以經綸。
初九：磐桓，利居貞，利建侯。
《象》曰：雖「磐桓」，志行正也。以貴下賤，大得民也。
六二：屯如邅如，乘馬班如，匪寇，婚媾。女子貞不字，十年乃字。
《象》曰：六二之難，乘剛也。十年乃字，反常也。
六三：即鹿無虞，惟入于林中，君子几不如舍，往吝。
《象》曰：「既鹿無虞」，以縱禽也。君子舍之，往吝窮也。
六四：乘馬班如，求婚媾，無不利。
《象》曰：求而往，明也。
九五：屯其膏，小貞吉，大貞凶。
《象》曰：屯其膏，施未光也。
上六：乘馬班如，泣血漣如。
《象》曰：「泣血漣如」，何可長也！
 
《易經》第四卦蒙山水蒙艮上坎下
 
蒙，亨。匪我求童蒙，童蒙求我。初噬告，再三瀆，瀆則不告。利貞。
《彖》曰：蒙，山下有險，險而止，蒙。蒙亨，以亨行，時中也。「匪我求童蒙，童蒙求我」，志應也。「初噬告」，以剛中也。「再三瀆，瀆則不告」，瀆蒙也。蒙以養正，聖功也。
《象》曰：山下出泉，蒙。君子以果行育德。
初六：發蒙，利用刑人，用說桎梏，以往吝。
《象》曰：「利用刑人」，以正法也。
九二：包蒙吉。納婦吉。子克家。
《象》曰：「子克家」，剛柔接也。
六三：勿用娶女，見金，夫不有躬，無攸利。
《象》曰：「勿用娶女」，行不順也。
六四：困蒙，吝。
《象》曰：困蒙之吝，獨遠實也。
六五：童蒙，吉。
《象》曰：童蒙之吉，順以巽也。
上九：擊蒙。不利為寇，利御寇。
《象》曰：利用御寇，上下順也。
 
《易經》第五卦需水天需坎上乾下
 
需，有孚，光亨，貞吉。利涉大川。
《彖》曰：需，須也。險在前也。剛健而不陷，其義不困窮矣。「需，有孚，光亨，貞吉」，位乎天位，以正中也。「利涉大川」，往有功也。
《象》曰：云上於天，需。君子以飲食宴樂。
初九：需于郊，利用恆，無咎。
《象》曰：「需于郊」，不犯難行也。「利用恆，無咎」，未失常也。
九二：需于沙，小有言，終吉。
《象》曰：「需于沙」，衍在中也。雖「小有言」，以終吉也。
九三：需于泥，致寇至。
《象》曰：「需于泥」，災在外也。自我致寇，敬慎不敗也。
六四：需于血，出自穴。
《象》曰：「需于血」，順以聽也。
九五：需于酒食，貞吉。
《象》曰：「酒食貞吉」，以中正也。
上六：入于穴，有不速之客三人來，敬之終吉。
《象》曰：不速之客來，「敬之終吉」，雖不當位，未大失也。
 
《易經》第六卦訟天水訟乾上坎下
 
訟，有孚，窒惕，中吉，終凶。利見大人，不利涉大川。
《彖》曰：訟，上剛下險，險而健，訟。「訟，有孚窒惕，中吉」，剛來而得中也。「終凶」，訟不可成也。「利見大人」，尚中正也。「不利涉大川」，入于淵也。
《象》曰：天與水違行，訟。君子以作事謀始。
初六：不永所事，小有言，終吉。
《象》曰：「不永所事」，訟不可長也。雖「有小言」，其辯明也。
九二：不克訟，歸而逋，其邑人三百戶，無眚。
《象》曰：「不克訟」，歸而逋也。自下訟上，患至掇也。
六三：食舊德，貞厲，終吉。或從王事，無成。
《象》曰：「食舊德」，從上吉也。
九四：不克訟，復自命渝，安貞，吉。
《象》曰：「復即命渝，安貞」，不失也。
九五：訟元吉。
《象》曰：「訟元吉」，以中正也。
上九：或錫之鞶帶，終朝三褫之。
《象》曰：以訟受服，亦不足敬也。
 
《易經》第七卦師地水師坤上坎下
 
師，貞丈人吉，無咎。
《彖》曰：師，眾也。貞，正也。能以眾正，可以王矣。剛中而應，行險而順，以此毒天下，而民從之，吉又何咎矣。
《象》曰：地中有水，師。君子以容民畜眾。
初六：師出以律，否臧凶。
《象》曰：「師出以律」，失律凶也。
九二：在師中，吉，無咎，王三錫命。
《象》曰：「在師中，吉」，承天寵也。「王三錫命」，懷萬邦也。
六三：師或輿尸，凶。
《象》曰：「師或輿尸」，大無功也。
六四：師左次，無咎。
《象》曰：「左次無咎」，未失常也。
六五：田有禽，利執言，無咎。長子帥師，弟子輿尸，貞凶。
《象》曰：「長子帥師」，以中行也。「弟子輿師」，使不當也。
上六：大君有命，開國承家，小人勿用。
《象》曰：「大君有命」，以正功也。「小人勿用」，必亂邦也。
 
《易經》第八卦比水地比坎上下坤
 
比，吉。原筮元永貞，無咎。不寧方來，后夫凶。
《彖》曰：比，吉也，比，輔也，下順從也。「原筮元永貞，無咎」，以剛中也。「不寧方來」，上下應也。「后夫凶」，其道窮也。
《象》曰：地上有水，比。先王以建萬國，親諸侯。
初六：有孚比之，無咎。有孚盈缶，終來有他，吉。
《象》曰：比之初六，「有他吉」也。
六二：比之自內，貞吉。
《象》曰：「比之自內」，不自失也。
六三：比之匪人。
《象》曰：「比之匪人」，不亦傷乎！
六四：外比之，貞吉。
《象》曰：外比於賢，以從上也。
九五：顯比，王用三驅，失前禽，邑人不誡，吉。
《象》曰：顯比之吉，位正中也。舍逆取順，「失前禽」也。「邑人不誡」，上使中也。
上六：比之無首，凶。
《象》曰：「比之無首」，無所終也。
 
《易經》第九卦小畜風天小畜巽上乾下
 
小畜，亨。密云不雨，自我西郊。
《彖》曰：小畜，柔得位而上下應之，曰小畜。健而巽，剛中而志行，乃亨。「密云不雨」，尚往也。「自我西郊」，施未行也。
《象》曰：風行天上，小畜。君子以懿文德。
初九：復自道，何其咎？吉。
《象》曰：「復自道」，其義吉也。
九二：牽復，吉。
《象》曰：「牽復」在中，亦不自失也。
九三：輿說輻，夫妻反目。
《象》曰：「夫妻反目」，不能正室也。
六四：有孚，血去惕出，無咎。
《象》曰：「有孚」「惕出」，上合志也。
九五：有孚攣如，富以其鄰。
《象》曰：「有孚攣如」，不獨富也。
上九：既雨既處，尚德載，婦貞厲。月几望，君子征凶。
《象》曰：「既雨既處」，德積載也。「君子征凶」，有所疑也。
 
《易經》第十卦履天澤履乾上兌下
 
履，履虎尾，不咥人，亨。
《彖》曰：履，柔履剛也。說而應乎乾，是以「履虎尾，不咥人，亨」。剛中正，履帝位而不疚，光明也。
《象》曰：上天下澤，履。君子以辨上下、定民志。
初九：素履往，無咎。
《象》曰：素履之往，獨行愿也。
九二：履道坦坦，幽人貞吉。
《象》曰：「幽人貞吉」，中不自亂也。
六三：眇能視，跛能履，履虎尾，咥人，凶。武人為于大君。
《象》曰：「眇能視」，不足以有明也。「跛能履」，不足以與行也。咥人之凶，位不當也。「武人為于大君」，志剛也。
九四：履虎尾，愬愬，終吉。
《象》曰：「愬愬，終吉」，志行也。
九五：夬履，貞厲。
《象》曰：「夬履，貞厲」，位正當也。
上九：視履考祥，其旋元吉。
《象》曰：元吉在上，大有慶也。
 
《易經》第十一卦泰天地泰坤上乾下
 
泰，小往大來，吉亨。
《彖》曰：「泰，小往大來，吉亨」，則是天地交而萬物通也，上下交而其志同也。內陽而外陰，內健而外順，內君子而外小人，君子道長，小人道消也。
《象》曰：天地交，泰，后以財（裁）成天地之道，輔相天地之宜，以左右民。
初九：拔茅茹，以其夤，征吉。
《象》曰：「拔茅」「征吉」，志在外也。
九二：包荒，用馮河，不遐遺，朋亡，得尚于中行。
《象》曰：「包荒」，「得尚于中行」，以光大也。
九三：無平不陂，無往不復，艱貞無咎。勿恤其孚，于食有福。
《象》曰：「無往不復」，天地際也。
六四：翩翩不富，以其鄰，不戒以孚。
《象》曰：「翩翩不富」，皆失實也。「不戒以孚」，中心愿也。
六五：帝乙歸妹，以祉元吉。
《象》曰：「以祉元吉」，中以行愿也。
上六：城復于隍，勿用師。自邑告命，貞吝。
《象》曰：「城復于隍」，其命亂也。
 
《易經》第十二卦否地天否乾上坤下
 
否，否之匪人，不利君子貞，大往小來。
《彖》曰：「否之匪人，不利君子貞，大往小來」，則是天地不交而萬物不通也，上下不交而天下無邦也。內陰而外陽，內柔而外剛，內小人而外君子，小人道長，君子道消也。
《象》曰：天地不交，否。君子以儉德辟難，不可榮以祿。
初六：拔茅茹，以其夤，貞吉亨。
《象》曰：「拔茅」貞吉，志在君也。
六二：包承，小人吉，大人否亨。
《象》曰：「大人否亨」，不亂群也。
六三：包羞。
《象》曰：「包羞」，位不當也。
九四：有命無咎，疇離祉。
《象》曰：「有命無咎」，志行也。
九五：休否，大人吉。其亡其亡，系于苞桑。
《象》曰：「大人之吉」，位正當也。
上九：傾否，先否后喜。
《象》曰：否終則傾，何可長也！
 
《易經》第十三卦同人天火同人乾上離下
 
同人，同人于野，亨，利涉大川，利君子貞。
《彖》曰：同人，柔得位得中而應乎乾曰同人。《同人》曰「同人于野，亨，利涉大川」，乾行也。文明以健，中正而應，君子正也。唯君子為能通天下之志。
《象》曰：天與火，同人。君子以類族辨物。
初九：同人于門，無咎。
《象》曰：出門同人，又誰咎也？
六二：同人于宗，吝。
《象》曰：「同人于宗」，吝道也。
九三：伏戎于莽，升其高陵，三歲不興。
《象》曰：「伏戎于莽」，敵剛也。「三歲不興」，安行也。
九四：乘其墉，弗克攻，吉。
《象》曰：「乘其墉」，義弗克也，其吉則困而反則也。
九五：同人，先號啕而后笑，大師克相遇。
《象》曰：同人之先，以中直也。大師相遇，言相克也。
上九：同人于郊，無悔。
《象》曰：「同人于郊」，志未得也。
 
《易經》第十四卦大有火天大有離上乾下
 
大有，元亨。
《彖》曰：大有，柔得尊位大中而上下應之曰大有。其德剛健而文明，應乎天而時行，是以元亨。
《象》曰：火在天上，大有。君子以竭惡揚善，順天休命。
初九：無交害，匪咎，艱則無咎。
《象》曰：《大有》初九，「無交害」也。
九二：大車以載，有攸往，無咎。
《象》曰：「大車以載」，積中不敗也。
九三：公用亨于天子，小人弗克。
《象》曰：「公用亨于天子」，小人害也。
九四：匪其彭，無咎。
《象》曰：「匪其彭，無咎」，明辨晰也。
六五：厥孚交如，威如，吉。
《象》曰：「厥孚交如」，信以發志也。威如之吉，易而無備也。
上九：自天佑之，吉無不利。
《象》曰：《大有》上吉，「自天佑」也。
 
《易經》第十五卦謙地山謙坤上艮下
 
謙，亨，君子有終。
《彖》曰：謙，亨，天道下濟而光明，地道卑而上行。天道虧盈而益謙，地道變盈而流謙，鬼神害盈而福謙，人道惡盈而好謙。謙尊而光，卑而不可踰，君子之終也。
《象》曰：地中有山，謙。君子以裒多益寡，稱物平施。
初六：謙謙君子，用涉大川，吉。
《象》曰：「謙謙君子」，卑以自牧也。
六二：鳴謙，貞吉。
《象》曰：「鳴謙貞吉」，中心得也。
九三：勞謙君子，有終吉。
《象》曰：「勞謙君子」，萬民服也。
六四：無不利，撝謙。
《象》曰：「無不利，撝謙」，不違則也。
六五：不富，以其鄰，利用侵伐，無不利。
《象》曰：「利用侵伐」，征不服也。
上六：鳴謙，利用行師，征邑國。
《象》曰：「鳴謙」，志未得也。「可用行師，征邑國」也。
 
《易經》第十六卦豫雷地豫震上坤下
 
豫，利建侯行師。
《彖》曰：豫，剛應而志行，順以動，豫。豫，順以動，故天地如之，而況建侯行師乎？天地以順動，故日月不過而四時不忒。聖人以順動，則刑罰清而民服。豫之時義大矣哉！
《象》曰：雷出地奮，豫。先王以作樂崇德，殷荐之上帝，以配祖考。
初六：鳴豫，凶。
《象》曰：初六「鳴豫」，志窮凶也。
六二：介于石，不終日，貞吉。
《象》曰：「不終日，貞吉」，以中正也。
六三：盱豫，悔。遲有悔。
《象》曰：「盱豫」「有悔」，位不當也。
九四：由豫，大有得。勿疑朋盍簪。
《象》曰：「由豫，大有得」，志大行也。
六五：貞疾，恆不死。
《象》曰：六五「貞疾」，乘剛也。「恆不死」，中未亡也。
上六：冥豫，成有渝，無咎。
《象》曰：「冥豫」在上，何可長也！
 
《易經》第十七卦隨澤雷隨兌上震下
 
隨，元亨，利貞，無咎。
《彖》曰：隨，剛來而下柔，動而說，隨。大亨貞，無咎，而天下隨時，隨之時義大矣哉！
《象》曰：澤中有雷，隨。君子以向晦入宴息。
初九：官有渝，貞吉。出門交有功。
《象》曰：「官有渝」，從正吉也。「出門交有功」，不失也。
六二：系小子，失丈夫。
《象》曰：「系小子」，弗兼與也。
六三：系丈夫，失小子。隨有求得，利居貞。
《象》曰：「系丈夫」，志舍下也。
九四：隨有獲，貞凶。有孚在道，以明，何咎？
《象》曰：「隨有獲」，其義凶也。「有孚在道」，明功也。
九五：孚于嘉，吉。
《象》曰：「孚于嘉，吉」，位正中也。
上六：拘系之，乃從維之。王用亨于西山。
《象》曰：「拘系之」，上窮也。
 
《易經》第十八卦蠱山風蠱艮上巽下
 
蠱，元亨，利涉大川。先甲三日，后甲三日。
《彖》曰：蠱，剛上而柔下，巽而止，蠱。「蠱，元亨」，而天下治也。「利涉大川」，往有事也。「先甲三日，后甲三日」，終則有始，天行也。
《象》曰：山下有風，蠱。君子以振民育德。
初六：干父之蠱，有子，考無咎，厲，終吉。
《象》曰：「干父之蠱」，意承考也。
九二：干母之蠱，不可貞。
《象》曰：「干母之蠱」，得中道也。
九三：干父之蠱，小有晦，無大咎。
《象》曰：「干父之蠱」，終無咎也。
六四：裕父之蠱，往見吝。
《象》曰：「裕父之蠱」，往未得也。
六五：干父之蠱，用譽。
《象》曰：「干父之蠱」，承以德也。
上九：不事王侯，高尚其事。
《象》曰：「不事王侯」，志可則也。
 
《易經》第十九卦臨地澤臨坤上兌下
 
臨，元亨，利貞。至于八月有凶。
《彖》曰：臨，剛浸而長。說而順，剛中而應，大亨以正，天之道也。「至于八月有凶」，消不久也。
《象》曰：澤上有地，臨。君子以教思無窮、容保民無疆。
初九：咸臨，貞吉。
《象》曰：「咸臨，貞吉」，志行正也。
九二：咸臨，吉無不利。
《象》曰：「咸臨，吉無不利」，未順命也。
六三：甘臨，無攸利。既憂之，無咎。
《象》曰：「甘臨」，位不當也。「既憂之」，咎不長也。
六四：至臨，無咎。
《象》曰：「至臨，無咎」，位當也。
六五：知臨，大君之宜，吉。
《象》曰：「大君之宜」，行中之謂也。
上六：敦臨，吉，無咎。
《象》曰：敦臨之吉，志在內也。
 
《易經》第二十卦觀風地觀巽上坤下
 
觀，盥而不荐，有孚顒若。
《彖》曰：大觀在上，順而巽，中正以觀天下。「觀，盥而不荐，有孚顒若」，下觀而化也。觀天之神道，而四時不忒，聖人以神道設教，而天下服矣。
《象》曰：風行地上，觀。先王以省方，觀民設教。
初六：童觀，小人無咎，君子吝。
《象》曰：初六「童觀」，小人道也。
六二：窺觀，利女貞。
《象》曰：「窺觀」「女貞」，亦可丑也。
六三：觀我生，進退。
《象》曰：「觀我生，進退」，未失道也。
六四：觀國之光，利用賓于王。
《象》曰：「觀國之光」，尚賓也。
九五：觀我生，君子無咎。
《象》曰：「觀我生」，觀民也。
上九：觀其生，君子無咎。
《象》曰：「觀其生」，志未平也。
 
《易經》第二十一卦噬嗑火雷噬嗑離上震下
 
噬嗑，亨。利用獄。
《彖》曰：頤中有物，曰噬嗑。噬嗑而亨，剛柔分，動而明，雷電合而章。柔得中而上行，雖不當位，利用獄也。
《象》曰：雷電噬嗑。先王以明罰敕法。
初九：履校滅趾，無咎。
《象》曰：「履校滅趾」，不行也。
六二：噬膚滅鼻，無咎。
《象》曰：「噬膚滅鼻」，乘剛也。
六三：噬臘肉，遇毒。小吝，無咎。
《象》曰：「遇毒」，位不當也。
九四：噬乾胏，得金矢，利艱貞，吉。
《象》曰：「利艱貞，吉」，未光也。
六五：噬乾肉，得黃金，貞厲，無咎。
《象》曰：「貞厲，無咎」，得當也。
上九：何校滅耳，凶。
《象》曰：「何校滅耳」，聰不明也。
 
《易經》第二十二卦賁山火賁艮上離下
 
賁，亨。小利有所往。
《彖》曰：賁，亨。柔來而文剛，故亨。分剛上而文柔，故小利有攸往。天文也。文明以止，人文也。觀乎天文，以察時變。觀乎人文，以化成天下。
《象》曰：山下有火，賁。君子以明庶政，無敢折獄。
初九：賁其趾，舍車而徒。
《象》曰：「舍車而徒」，義弗乘也。
六二：賁其須。
《象》曰：「賁其須」，與上興也。
九三：賁如濡如，永貞吉。
《象》曰：永貞之吉，終莫之陵也。
六四：賁如皤如，白馬翰如，匪寇婚媾。
《象》曰：六四當位，疑也。「匪寇婚媾」，終無尤也。
六五：賁于丘園，束帛戔戔，吝，終吉。
《象》曰：六五之吉，有喜也。
上九：白賁，無咎。
《象》曰：「白賁，無咎」，上得志也。
 
《易經》第二十三卦剝山地剝艮上坤下
 
剝，不利有攸往。
《彖》曰：剝，剝也，柔變剛也。「不利有攸往」，小人長也。順而止之，觀象也。君子尚消息盈虛，天行也。
《象》曰：山附地上，剝。上以厚下安宅。
初六：剝床以足，蔑貞凶。
《象》曰：「剝床以足」，以滅下也。
六二：剝床以辨，蔑貞凶。
《象》曰：「剝床以辨」，未有與也。
六三：剝之，無咎。
《象》曰：「剝之，無咎」，失上下也。
六四：剝床以膚，凶。
《象》曰：「剝床以膚」，切近災也。
六五：貫魚，以宮人寵，無不利。
《象》曰：「以宮人寵」，終無尤也。
上九：碩果不食，君子得輿，小人剝廬。
《象》曰：「君子得輿」，民所載也。「小人剝廬」，終不可用也。
 
《易經》第二十四卦復地雷復坤上震下
 
復，亨。出入無疾，朋來無咎。反復其道，七日來復，利有攸往。
《彖》曰：復，亨。剛反動而以順行，是以「出入無疾，朋來無咎」。「反復其道，七日來復」，天行也。「利有攸往」，剛長也。復其見天地之心乎？
《象》曰：雷在地中，復。先王以至日閉關，商旅不行，后不省方。
初九：不復遠，無只悔，元吉。
《象》曰：不遠之復，以修身也。
六二：休復，吉。
《象》曰：休復之吉，以下仁也。
六三：頻復，厲，無咎。
《象》曰：頻復之厲，義無咎也。
六四：中行獨復。
《象》曰：「中行獨復」，以從道也。
六五：敦復，無悔。
《象》曰：「敦復，無悔」，中以自考也。
上六：迷復，凶，有災眚。用行師，終有大敗，以其國君凶。至于十年不克征。
《象》曰：迷復之凶，反君道也。
 
《易經》第二十五卦無妄天雷無妄乾上震下
 
無妄，元亨，利貞。其匪正有眚，不利有攸往。
《彖》曰：無妄，剛自外來而為主於內。動而健，剛中而應，大亨以正，天之命也。「其匪正有眚，不利有攸往」，無妄之往，何之矣？天命不佑行矣哉？
《象》曰：天下雷行，物與無妄。先王以茂對時，育萬物。
初九：無妄往，吉。
《象》曰：無妄之往，得志也。
六二：不耕獲，不菑畬，則利有攸往。
《象》曰：「不耕獲」，未富也。
六三：無妄之災，或系之牛，行人之得，邑人之災。
《象》曰：行人得牛，邑人災也。
九四：可貞，無咎。
《象》曰：「可貞，無咎」，固有之也。
九五：無妄之疾，勿藥有喜。
《象》曰：無妄之藥，不可試也。
上九：無妄行，有眚，無攸利。
《象》曰：無妄之行，窮之災也。
 
《易經》第二十六卦大畜山天大畜艮上乾下
 
大畜，利貞。不家食吉，利涉大川。
《彖》曰：大畜，剛健篤實輝光，日新其德。剛上而尚賢，能止健，大正也。「不家食吉」，養賢也。「利涉大川」，應乎天也。
《象》曰：天在山中，大畜。君子以多識前言往行，以畜其德。
初九：有厲，利已。
《象》曰：「有厲，利已」，不犯災也。
九二：輿說輻。
《象》曰：「輿說輻」，中無尤也。
九三：良馬逐，利艱貞。曰閑輿衛，利有攸往。
《象》曰：「利有攸往」，上合志也。
六四：童豕之牿，元吉。
《象》曰：六四「元吉」，有喜也。
六五：豶豕之牙，吉。
《象》曰：六五之吉，有慶也。
上九：何天之衢，亨。
《象》曰：「何天之衢」，道大行也。
 
《易經》第二十七卦頤山雷頤艮上震下
 
頤，貞吉。觀頤，自求口實。
《彖》曰：「頤，貞吉」，養正則吉也。「觀頤」，觀其所養也。「自求口實」，觀其自養也。天地養萬物，聖人養賢以及萬民。頤之時義大矣哉！
《象》曰：山下有雷，頤。君子以慎言語，節飲食。
初九：舍爾靈龜，觀我朵頤，凶。
《象》曰：「觀我朵頤」，亦不足貴也。
六二：顛頤，拂經，于丘頤，征凶。
《象》曰：六二「征凶」，行失類也。
六三：拂頤，貞凶，十年勿用，無攸利。
《象》曰：「十年勿用」，道大悖也。
六四：顛頤吉，虎視眈眈，其欲逐逐，無咎。
《象》曰：顛頤之吉，上施光也。
六五：拂經，居貞吉，不可涉大川。
《象》曰：居貞之吉，順以從上也。
上九：由頤，厲，吉，利涉大川。
《象》曰：「由頤，厲，吉」，大有慶也。
 
《易經》第二十八卦大過澤風大過兌上巽下
 
大過，棟橈，利有攸往，亨。
《彖》曰：大過，大者過也。「棟橈」，本末弱也。剛過而中，巽而說行，「利有攸往」，乃亨。大過之時義大矣哉！
《象》曰：澤滅木，大過。君子以獨立不懼，遯世無悶。
初六：藉用白茅，無咎。
《象》曰：「藉用白茅」，柔在下也。
九二：枯楊生稊，老夫得其女妻，無不利。
《象》曰：老夫女妻，過以相與也。
九三：棟橈，凶。
《象》曰：棟橈之凶，不可以有輔也。
九四：棟隆，吉。有它吝。
《象》曰：棟隆之吉，不橈乎下也。
九五：枯楊生華，老婦得其士夫，無咎無譽。
《象》曰：「枯楊生華」，何可久也。老婦士夫，亦可丑也。
上六：過涉滅頂，凶，無咎。
《象》曰：過涉之凶，不可咎也。
 
《易經》第二十九卦坎坎為水坎上坎下
 
坎，習坎，有孚，維心亨，行有尚。
《彖》曰：「習坎」，重險也。水流而不盈，行險而不失其信。「維心亨」，乃以剛中也。「行有尚」，往有功也。天險不可升也，地險山川丘陵也。王公設險以守其國。坎之時用大矣哉！
《象》曰：水洊至，習坎。君子以常德行，習教事。
初六：習坎，入于坎窞，凶。
《象》曰：習坎入坎，失道凶也。
九二：坎有險，求小得。
《象》曰：「求小得」，未出中也。
六三：來之坎坎，險且枕，入于坎窞，勿用。
《象》曰：「來之坎坎」，終無功也。
六四：樽酒簋貳，用缶，納約自牖，終無咎。
《象》曰：「樽酒簋貳」，剛柔際也。
九五：坎不盈，祇既平，無咎。
《象》曰：「坎不盈」，中未大也。
上六：係用徽纆，置于叢棘，三歲不得，凶。
《象》曰：上六失道，凶三歲也。
 
《易經》第三十卦離離為火離上離下
 
離，利貞，亨。畜牝牛吉。
《彖》曰：離，麗也。日月麗乎天，百谷草木麗乎土，重明以麗乎正，乃化成天下。柔麗乎中正，故亨。是以「畜牝牛吉」也。
《象》曰：明兩作，離。大人以繼明照于四方。
初九：履錯然，敬之無咎。
《象》曰：履錯之敬，以辟咎也。
六二：黃離，元吉。
《象》曰：「黃離，元吉」，得中道也。
九三：日昃之離，不鼓缶而歌，則大耋之嗟，凶。
《象》曰：「日昃之離」，何可久也。
九四：突如其來如，焚如，死如，棄如。
《象》曰：「突如其來如」，無所容也。
六五：出涕沱若，戚嗟若，吉。
《象》曰：六五之吉，離王公也。
上九：王用出征，有嘉折首，獲其匪丑，無咎。
《象》曰：「王用出征」，以正邦也。
 
《易經》第三十一卦咸澤山咸兌上艮下
 
咸，亨，利貞。取女吉。
《彖》曰：咸，感也。柔上而剛下，二氣感應以相與，止而說，男下女，是以「亨，利貞，取女吉」也。天地感而萬物化生，聖人感人心而天下和平。觀其所感，而天地萬物之情可見矣！
《象》曰：山上有澤，咸。君子以虛受人。
初六：咸其拇。
《象》曰：「咸其拇」，志在外也。
六二：咸其腓，凶，居吉。
《象》曰：雖凶，居吉，順不害也。
九三：咸其股，執其隨，往吝。
《象》曰：「咸其股」，亦不處也。志在隨人，所執下也。
九四：貞吉悔亡，憧憧往來，朋從爾思。
《象》曰：「貞吉悔亡」，未感害也。「憧憧往來」，未光大也。
九五：咸其脢，無悔。
《象》曰：「咸其脢」，志末也。
上六：咸其輔、頰、舌。
《象》曰：「咸其輔、頰、舌」，滕口說也。
 
《易經》第三十二卦恆雷風恆震上巽下
 
恆，亨，無咎，利貞，利有攸往。
《彖》曰：恆，久也。剛上而柔下，雷風相與，巽而動，剛柔皆應，恆。「恆，亨，無咎，利貞」，久於其道也，天地之道，恆久而不已也。「利有攸往」，終則有始也。日月得天而能久照，四時變化而能久成，聖人久於其道而天下化成。觀其所恆，而天地萬物之情可見矣！
《象》曰：雷風，恆。君子以立不易方。
初六：浚恆，貞凶，無攸利。
《象》曰：浚恆之凶，始求深也。
九二：悔亡。
《象》曰：九二「悔亡」，能久中也。
九三：不恆其德，或承之羞，貞吝。
《象》曰：「不恆其德」，無所容也。
九四：田無禽。
《象》曰：久非其位，安得禽也？
六五：恆其德，貞婦人吉，夫子凶。
《象》曰：婦人貞吉，從一而終也。夫子制義，從婦凶也。
上六：振恆，凶。
《象》曰：「振恆」在上，大無功也。
 
《易經》第三十三卦遯天山遯乾上艮下
 
遯，亨，小利貞。
《彖》曰：「遯，亨」，遯而亨也。剛當位而應，與時行也。「小利貞」，浸而長也。
遯之時義大矣哉！
《象》曰：天下有山，遯。君子以遠小人，不惡而嚴。
初六：遯尾，厲，勿用有攸往。
《象》曰：遯尾之厲，不往何災也？
六二：執之用黃牛之革，莫之勝說。
《象》曰：執用黃牛，固志也。
九三：系遯，有疾厲，畜臣妾吉。
《象》曰：系遯之厲，有疾憊也。「畜臣妾吉」，不可大事也。
九四：好遯，君子吉，小人否。
《象》曰：君子好遯，小人否也。
九五：嘉遯，貞吉。
《象》曰：「嘉遯，貞吉」，以正志也。
上九：肥遯，無不利。
《象》曰：「肥遯，無不利」，無所疑也。
 
《易經》第三十四卦大壯雷天大壯震上乾下
 
大壯，利貞。
《彖》曰：大壯，大者壯也。剛以動，故壯。「大壯，利貞」，大者正也。正大而天地之情可見矣！
《象》曰：雷在天上，大壯。君子以非禮勿履。
初九：壯于趾，征凶，有孚。
《象》曰：「壯于趾」，其孚窮也。
九二：貞吉。
《象》曰：九二「貞吉」，以中也。
九三：小人用壯，君子用罔，貞厲。羝羊觸藩，羸其角。
《象》曰：「小人用壯」，君子罔也。
九四：貞吉悔亡，藩決不羸，壯于大輿之輹。
《象》曰：「藩決不羸」，尚往也。
六五：喪羊于易，無悔。
《象》曰：「喪羊于易」，位不當也。
上六：羝羊觸藩，不能退，不能遂，無攸利，艱則吉。
《象》曰：「不能退，不能遂」，不祥也。「艱則吉」，咎不長也。
 
《易經》第三十五卦晉火地晉離上坤下
 
晉，康侯用錫馬蕃庶，晝日三接。
《彖》曰：晉，進也。明出地上，順而麗乎大明，柔進而上行，是以「康侯用錫馬蕃庶，晝日三接」也。
《象》曰：明出地上，晉。君子以自昭明德。
初六：晉如，摧如，貞吉。罔孚，裕，無咎。
《象》曰：「晉如，摧如」，獨行正也。「裕，無咎」，未受命也。
六二：晉如，愁如，貞吉。受茲介福于其王母。
《象》曰：「受茲介福」，以中正也。
六三：眾允，悔亡。
《象》曰：眾允之，志上行也。
九四：晉如碩鼠，貞厲。
《象》曰：「碩鼠，貞厲」，位不當也。
六五：悔亡，失得勿恤，往吉，無不利。
《象》曰：「失得勿恤」，往有慶也。
上九：晉其角，維用伐邑，厲，吉，無咎，貞吝。
《象》曰：「維用伐邑」，道未光也。
 
《易經》第三十六卦明夷地火明夷坤上離下
 
明夷，利艱貞。
《彖》曰：明入地中，明夷。內文明而外柔順，以蒙大難，文王以之。「利艱貞」，晦其明也。內難而能正其志，箕子以之。
《象》曰：明入地中，明夷。君子以蒞眾，用晦而明。
初九：明夷于飛，垂其翼。君子于行，三日不食。有攸往，主人有言。
《象》曰：「君子于行」，義不食也。
六二：明夷，夷于左股，用拯馬壯，吉。
《象》曰：六二之吉，順以則也。
九三：明夷于南狩，得其大首，不可疾貞。
《象》曰：南狩之，志乃大得也。
六四：入于左腹，獲明夷之心，于出門庭。
《象》曰：「入于左腹」，獲心意也。
六五：箕子之明夷，利貞。
《象》曰：箕子之貞，明不可息也。
上六：不明晦，初登于天，后入于地。
《象》曰：「初登于天」，照四國也。「后入于地」，失則也。
 
《易經》第三十七卦家人風火家人巽上離下
 
家人，利女貞。
《彖》曰：家人，女正位乎內，男正位乎外，男女正，天地之大義也。家人有嚴君焉，父母之謂也。父父，子子，兄兄，弟弟，夫夫，婦婦，而家道正。正家而天下定矣。
《象》曰：風自火出，家人。君子以言有物，而行有恆。
初九：閑有家，悔亡。
《象》曰：「閑有家」，志未變也。
六二：無攸遂，在中饋，貞吉。
《象》曰：六二之吉，順以巽也。
九三：家人嗃嗃，悔厲吉。婦子嘻嘻，終吝。
《象》曰：「家人嗃嗃」，未失也。「婦子嘻嘻」，失家節也。
六四：富家，大吉。
《象》曰：「富家，大吉」，順在位也。
九五：王假有家，勿恤吉。
《象》曰：「王假有家」，交相愛也。
上九：有孚威如，終吉。
《象》曰：威如之吉，反身之謂也。
 
《易經》第三十八卦睽火澤睽離上兌下
 
睽，小事吉。
《彖》曰：睽，火動而上，澤動而下。二女同居，其志不同行。說而麗乎明，柔進而上行，得中而應乎剛，是以「小事吉」。天地睽而其事同也，男女睽而其志通也，萬物睽而其事類也。睽之時用大矣哉！
《象》曰：上火下澤，睽。君子以同而異。
初九：悔亡，喪馬勿逐，自復。見惡人無咎。
《象》曰：「見惡人」，以辟咎也。
九二：遇主于巷，無咎。
《象》曰：「遇主于巷」，未失道也。
六三：見輿曳，其牛掣，其人天且劓，無初有終。
《象》曰：「見輿曳」，位不當也。「無初有終」，遇剛也。
九四：睽孤，遇元夫，交孚，厲，無咎。
《象》曰：「交孚」「無咎」，志行也。
六五：悔亡，厥宗噬膚，往何咎。
《象》曰：「厥宗噬膚」，往有慶也。
上九：睽孤，見豕負涂，載鬼一車，先張之弧，后說之弧，匪寇婚媾，往遇雨則吉。
《象》曰：遇雨之吉，群疑亡也。
 
《易經》第三十九卦蹇水山蹇坎上艮下
 
蹇，利西南，不利東北。利見大人。貞吉。
《彖》曰：蹇，難也，險在前也。見險而能止，知矣哉！「蹇，利西南」，往得中也。「不利東北」，其道窮也。「利見大人」，往有功也。當位「貞吉」，以正邦也。蹇之時用大矣哉！
《象》曰：山上有水，蹇。君子以反身修德。
初六：往蹇，來譽。
《象》曰：「往蹇，來譽」，宜待也。
六二：王臣蹇蹇，匪躬之故。
《象》曰：「王臣蹇蹇」，終無尤也。
九三：往蹇來反。
《象》曰：「往蹇來反」，內喜之也。
六四：往蹇來連。
《象》曰：「往蹇來連」，當位實也。
九五：大蹇朋來。
《象》曰：「大蹇朋來」，以中節也。
上六：往蹇來碩，吉。利見大人。
《象》曰：「往蹇來碩」，志在內也。「利見大人」，以從貴也。
 
 
《易經》第四十卦解雷水解震上坎下
 
解，利西南。無所往，其來復吉。有攸往，夙吉。
《彖》曰：解，險以動，動而免乎險，解。「解，利西南」，往得眾也。「其來復吉」，乃得中也。「有攸往，夙吉」，往有功也。天地解而雷雨作，雷雨作而百果草木皆甲坼，解之時義大矣哉！
《象》曰：雷雨作，解。君子以赦過宥罪。
初六：無咎。
《象》曰：剛柔之際，義無咎也。
九二：田獲三狐，得黃矢，貞吉。
《象》曰：九二「貞吉」，得中道也。
六三：負且乘，致寇至，貞吝。
《象》曰：「負且乘」，亦可丑也。自我致戎，又誰咎也。
九四：解而拇，朋至斯孚。
《象》曰：「解而拇」，未當位也。
六五：君子維有解，吉。有孚于小人。
《象》曰：君子有解，小人退也。
上六：公用射隼于高墉之上，獲之，無不利。
《象》曰：「公用射隼」，以解悖也。
 
《易經》第四十一卦損山澤損艮上兌下
 
損，有孚，元吉，無咎，可貞，利有攸往。曷之用二簋，可用享。
《彖》曰：損，損下益上，其道上行。損而「有孚，元吉，無咎，可貞，利有攸往。曷之用？二簋，可用享」。二簋應有時。損剛益柔有時，損益盈虛，與時偕行。
《象》曰：山下有澤，損。君子以懲忿窒欲。
初九：已事遄往，無咎，酌損之。
《象》曰：「已事遄往」，尚合志也。
九二：利貞，征凶，弗損益之。
《象》曰：九二「利貞」，中以為志也。
六三：三人行，則損一人。一人行，則得其友。
《象》曰：「一人行」，三則疑也。
六四：損其疾，使遄有喜，無咎。
《象》曰：「損其疾」，亦可喜也。
六五：或益之，十朋之龜弗克違，元吉。
《象》曰：六五「元吉」，自上佑也。
上九：弗損，益之，無咎，貞吉，利有攸往。得臣無家。
《象》曰：「弗損，益之」，大得志也。
 
《易經》第四十二卦益風雷益巽上震下
 
益，利有攸往，利涉大川。
《彖》曰：益，損上益下，民說無疆，自上下下，其道大光。「利有攸往」，中正有慶。「利涉大川」，木道乃行。益動而巽，日進無疆。天施地生，其益無方。凡益之道，與時偕行。
《象》曰：風雷，益。君子以見善則遷，有過則改。
初九：利用為大作，元吉，無咎。
《象》曰：「元吉，無咎」，下不厚事也。
六二：或益之，十朋之龜弗克違，永貞吉。王用享于帝，吉。
《象》曰：「或益之」，自外來也。
六三：益之用凶事，無咎。有孚中行，告公用圭。
《象》曰：益用凶事，固有之也。
六四：中行，告公從，利用為依遷國。
《象》曰：「告公從」，以益志也。
九五：有孚惠心，勿問元吉。有孚惠我德。
《象》曰：「有孚惠心」，勿問之矣。「惠我德」，大得志也。
上九：莫益之，或擊之，立心勿恆，凶。
《象》曰：「莫益之」，偏辭也。「或擊之」，自外來也。
 
《易經》第四十三卦夬澤天夬兌上乾下
 
夬，揚于王庭，孚號，有厲，告自邑，不利即戎，利有攸往。
《彖》曰：夬，決也，剛決柔也。健而說，決而和，揚于王庭，柔乘五剛也。「孚號有厲」，其危乃光也。「告自邑，不利即戎」，所尚乃窮也。「利有攸往」，剛長乃終也。
《象》曰：澤上于天，夬。君子以施祿及下，居德則忌。
初九：壯于前趾，往不勝為吝。
《象》曰：不勝而往，咎也。
九二：惕號，莫夜有戎，勿恤。
《象》曰：「莫夜有戎」，得中道也。
九三：壯于頄，有凶。君子夬夬獨行，遇雨若濡，有慍，無咎。
《象》曰：「君子夬夬」，終無咎也。
九四：臀無膚，其行次且。牽羊悔亡，聞言不信。
《象》曰：「其行次且」，位不當也。「聞言不信」，聰不明也。
九五：莧陸夬夬中行，無咎。
《象》曰：「中行，無咎」，中未光也。
上六：無號，終有凶。
《象》曰：無號之凶，終不可長也。
 
《易經》第四十四卦姤天風姤乾上巽下
 
姤，女壯，勿用取女。
《彖》曰：姤，遇也，柔遇剛也。「勿用取女」，不可與長也。天地相遇，品物咸章也。剛遇中正，天下大行也。姤之時義大矣哉！
《象》曰：天下有風，姤。后以施命誥四方。
初六：系于金柅，貞吉，有攸往，見凶，羸豕踟躅。
《象》曰：「系于金柅」，柔道牽也。
九二：包有魚，無咎，不利賓。
《象》曰：「包有魚」，義不及賓也。
九三：臀無膚，其行次且，厲，無大咎。
《象》曰：「其行次且」，行未牽也。
九四：包無魚，起凶。
《象》曰：無魚之凶，遠民也。
九五：以杞包瓜，含章，有隕自天。
《象》曰：九五「含章」，中正也。「有隕自天」，志不舍命也。
上九：姤其角，吝，無咎。
《象》曰：「姤其角」，上窮吝也。
 
《易經》第四十五卦萃澤地萃兌上坤下
 
萃，亨。王假有廟，利見大人，亨，利貞。用大牲吉，利有攸往。
《彖》曰：萃，聚也。順以說，剛中而應，故聚也。「王假有廟」，致孝享也。「利見大人，亨」，聚以正也。「用大牲吉，利有攸往」，順天命也。觀其所聚，而天地萬物之情可見矣。
《象》曰：澤上於地，萃。君子以除戎器，戒不虞。
初六：有孚不終，乃亂乃萃，若號，一握為笑，勿恤，往無咎。
《象》曰：「乃亂乃萃」，其志亂也。
六二：引吉，無咎，孚乃利用禴。
《象》曰：「引吉，無咎」，中未變也。
六三：萃如，嗟如，無攸利，往無咎，小吝。
《象》曰：「往無咎」，上巽也。
九四：大吉，無咎。
《象》曰：「大吉，無咎」，位不當也。
九五：萃有位，無咎。匪孚，元永貞，悔亡。
《象》曰：「萃有位」，志未光也。
上六：齎咨涕洟，無咎。
《象》曰：「齎咨涕洟」，未安上也。
 
《易經》第四十六卦升地風升坤上巽下
 
升，元亨，用見大人，勿恤。南征吉。
《彖》曰：柔以時升，巽而順，剛中而應，是以大亨。「用見大人，勿恤」，有慶也。「南征吉」，志行也。
《象》曰：地中生木，升。君子以順德，積小以高大。
初六：允升，大吉。
《象》曰：「允升，大吉」，上合志也。
九二：孚乃利用禴，無咎。
《象》曰：九二之孚，有喜也。
九三：升虛邑。
《象》曰：「升虛邑」，無所疑也。
六四：王用亨于岐山，吉無咎。
《象》曰：「王用亨于岐山」，順事也。
六五：貞吉，升階。
《象》曰：「貞吉，升階」，大得志也。
上六：冥升，利于不息之貞。
《象》曰：「冥升」在上，消不富也。
 
《易經》第四十七卦困澤水困兌上坎下
 
困，亨，貞大人吉，無咎。有言不信。
《彖》曰：困，剛掩也。險以說，困而不失其所，亨，其唯君子乎？「貞大人吉」，以剛中也。「有言不信」，尚口乃窮也。
《象》曰：澤無水，困。君子以致命遂志。
初六：臀困于株木，入于幽谷，三歲不見。
《象》曰：「入于幽谷」，幽不明也。
九二：困于酒食，朱紱方來，利用亨祀，征凶，無咎。
《象》曰：「困于酒食」，中有慶也。
六三：困于石，據于蒺藜，入于其宮，不見其妻，凶。
《象》曰：「據于蒺藜」，乘剛也。「入于其宮，不見其妻」，不祥也。
九四：來徐徐，困于金車，吝，有終。
《象》曰：「來徐徐」，志在下也。雖不當位，有與也。
九五：劓刖，困于赤紱，乃徐有說，利用祭祀。
《象》曰：「劓刖」，志未得也。「乃徐有說」，以中直也。「利用祭祀」，受福也。
上六：困于葛藟，于臲卼，曰動悔，有悔，征吉。
《象》曰：「困于葛藟」，未當也。「動悔，有悔」，吉行也。
 
《易經》第四十八卦井水風井坎上巽下
 
井，改邑不改井，無喪無得。往來井井，汔至亦未繘井，羸其瓶，凶。
《彖》曰：巽乎水而上水，井。井養而不窮也。「改邑不改井」，乃以剛中也。「汔至亦未繘井」，未有功也。「羸其瓶」，是以凶也。
《象》曰：木上有水，井。君子以勞民勸相。
初六：井泥不食，舊井無禽。
《象》曰：「井泥不食」，下也。「舊井無禽」，時舍也。
九二：井谷射鮒，瓮敝漏。
《象》曰：「井谷射鮒」，無與也。
九三：井渫不食，為我民惻，可用汲，王明，并受其福。
《象》曰：「井渫不食」，行惻也。求王明，受福也。
六四：井甃，無咎。
《象》曰：「井甃，無咎」，修井也。
九五：井冽，寒泉食。
《象》曰：寒泉之食，中正也。
上六：井收勿幕，有孚元吉。
《象》曰：「元吉」在上，大成也。
 
《易經》第四十九卦革澤火革兌上離下
 
革，己日乃孚，元亨利貞，悔亡。
《彖》曰：革，水火相息，二女同居，其志不相得，曰革。「己日乃孚」，革而信也。文明以說，大亨以正，革而當，其悔乃亡。天地革而四時成，湯武革命，順乎天而應乎人，革之時義大矣哉！
《象》曰：澤中有火，革。君子以治歷明時。
初九：鞏用黃牛之革。
《象》曰：「鞏用黃牛」，不可以有為也。
六二：己日乃革之，征吉，無咎。
《象》曰：「己日革之」，行有嘉也。
九三：征凶，貞厲，革言三就，有孚。
《象》曰：「革言三就」，又何之矣。
九四：悔亡，有孚改命，吉。
《象》曰：改命之吉，信志也。
九五：大人虎變，未占有孚。
《象》曰：「大人虎變」，其文炳也。
上六：君子豹變，小人革面，征凶，居貞吉。
《象》曰：「君子豹變」，其文蔚也。「小人革面」，順以從君也。
 
《易經》第五十卦鼎火風鼎離上巽下
 
鼎，元吉，亨。
《彖》曰：鼎，象也。以木巽火，亨飪也。聖人亨以享上帝，而大亨以養聖賢。巽而耳目聰明，柔進而上行，得中而應乎剛，是以元亨。
《象》曰：木上有火，鼎。君子以正位凝命。
初六：鼎顛趾，利出否，得妾以其子，無咎。
《象》曰：「鼎顛趾」，未悖也。「利出否」，以從貴也。
九二：鼎有實，我仇有疾，不我能即，吉。
《象》曰：「鼎有實」，慎所之也。「我仇有疾」，終無尤也。
九三：鼎耳革，其行塞，雉膏不食，方雨虧悔，終吉。
《象》曰：「鼎耳革」，失其義也。
九四：鼎折足，覆公餗，其形渥，凶。
《象》曰：「覆公餗」，信如何也。
六五：鼎黃耳金鉉，利貞。
《象》曰：「鼎黃耳」，中以為實也。
上九：鼎玉鉉，大吉，無不利。
《象》曰：玉鉉在上，剛柔節也。
 
《易經》第五十一卦震震為雷震上震下
 
震，亨。震來虩虩，笑言啞啞。震驚百里，不喪匕鬯。
《彖》曰：「震，亨。震來虩虩」，恐致福也。「笑言啞啞」，后有則也。「震驚百里」，驚遠而懼邇也，出可以守宗廟社稷，以為祭主也。
《象》曰：洊雷，震。君子以恐懼修身。
初九：震來虩虩，后笑言啞啞，吉。
《象》曰：「震來虩虩」，恐致福也。笑言啞啞，后有則也。
六二：震來厲，億喪貝，躋于九陵，勿逐，七日得。
《象》曰：「震來厲」，乘剛也。
六三：震蘇蘇，震行無眚。
《象》曰：「震蘇蘇」，位不當也。
九四：震遂泥。
《象》曰：「震遂泥」，未光也。
六五：震往來厲，億無喪，有事。
《象》曰：「震往來厲」，危行也。其事在中，大無喪也。
上六：震索索，視矍矍，征凶。震不于其躬，于其鄰，無咎。婚媾有言。
《象》曰：「震索索」，未得中也。雖凶無咎，畏鄰戒也。
 
《易經》第五十二卦艮艮為山艮上艮下
 
艮，艮其背，不獲其身，行其庭，不見其人，無咎。
《彖》曰：艮，止也。時止則止，時行則行，動靜不失其時，其道光明。艮其止，止其所也。上下敵應，不相與也。是以「不獲其身，行其庭不見其人，無咎」也。
《象》曰：兼山，艮。君子以思不出其位。
初六：艮其趾，無咎，利永貞。
《象》曰：艮其趾，未失正也。
六二：艮其腓，不拯其隨，其心不快。
《象》曰：「不拯其隨」，未退聽也。
九三：艮其限，列其夤，厲薰心。
《象》曰：「艮其限」，危薰心也。
六四：艮其身，無咎。
《象》曰：「艮其身」，止諸躬也。
六五：艮其輔，言有序，悔亡。
《象》曰：「艮其輔」，以中正也。
上九：敦艮，吉。
《象》曰：敦艮之吉，以厚終也。
 
《易經》第五十三卦漸風山漸巽上艮下
 
漸，女歸吉，利貞。
《彖》曰：漸之進也，女歸吉也。進得位，往有功也。進以正，可以正邦也。其位剛，得中也。止而巽，動不窮也。
《象》曰：山上有木，漸。君子以居賢德善俗。
初六：鴻漸于干，小子厲。有言，無咎。
《象》曰：小子之厲，義無咎也。
六二：鴻漸于磐，飲食衎衎，吉。
《象》曰：「飲食衎衎」，不素飽也。
九三：鴻漸于陸，夫征不復，婦孕不育，凶。利御寇。
《象》曰：「夫征不復」，離群丑也。「婦孕不育」，失其道也。「利用御寇」，順相保也。
六四：鴻漸于木，或得其桷，無咎。
《象》曰：「或得其桷」，順以巽也。
九五：鴻漸于陵，婦三歲不孕，終莫之勝，吉。
《象》曰：「終莫之勝，吉」，得所愿也。
上九：鴻漸于逵，其羽可用為儀，吉。
《象》曰：「其羽可用為儀，吉」，不可亂也。
 
《易經》第五十四卦歸妹雷澤歸妹震上兌下
 
歸妹，征凶，無攸利。
《彖》曰：歸妹，天地之大義也。天地不交而萬物不興。歸妹，人之終始也。說以動，所歸妹也。「征凶」，位不當也。「無攸利」，柔乘剛也。
《象》曰：澤上有雷，歸妹。君子以永終知敝。
初九：歸妹以娣，跛能履，征吉。
《象》曰：「歸妹以娣」，以恆也。「跛能履」，吉相承也。
九二：眇能視，利幽人之貞。
《象》曰：「利幽人之貞」，未變常也。
六三：歸妹以須，反歸以娣。
《象》曰：「歸妹以須」，未當也。
九四：歸妹愆期，遲歸有時。
《象》曰：愆期之志，有待而行也。
六五：帝乙歸妹，其君之袂，不如其娣之袂良，月几望，吉。
《象》曰：「帝乙歸妹」，「不如其娣之袂良」也。其位在中，以貴行也。
上六：女承筐無實，士刲羊無血，無攸利。
《象》曰：上六無實，承虛筐也。
 
《易經》第五十五卦丰雷火丰震上離下
 
丰，亨，王假之，勿憂，宜日中。
《彖》曰：丰，大也。明以動，故丰。「王假之」，尚大也。「勿憂，宜日中」，宜照天下也。日中則昃，月盈則食，天地盈虛，與時消息，而況人於人乎？況於鬼神乎？
《象》曰：雷電皆至，丰。君子以折獄致刑。
初九：遇其配主，雖旬無咎，往有尚。
《象》曰：「雖旬無咎」，過旬災也。
六二：丰其蔀，日中見斗，往得疑疾，有孚發若，吉。
《象》曰：「有孚發若」，信以發志也。
九三：丰其沛，日中見昧，折其右肱，無咎。
《象》曰：「丰其沛」，不可大事也。「折其右肱」，終不可用也。
九四：丰其蔀，日中見斗，遇其夷主，吉。
《象》曰：「丰其蔀」，位不當也。「日中見斗」，幽不明也。「遇其夷主」，吉行也。
六五：來章，有慶譽，吉。
《象》曰：六五之吉，有慶也。
上六：丰其屋，蔀其家，窺其戶，闃其無人，三歲不見，凶。
《象》曰：「丰其屋」，天際翔也。「窺其戶，闃其無人」，自藏也。
 
《易經》第五十六卦旅火山旅離上艮下
 
旅，小亨，旅貞吉。
《彖》曰：「旅，小亨」，柔得中乎外，而順乎剛，止而麗乎明，是以「小亨，旅貞吉」也。旅之時義大矣哉！
《象》曰：山上有火，旅。君子以明慎用刑而不留獄。
初六：旅瑣瑣，斯其所取災。
《象》曰：「旅瑣瑣」，志窮災也。
六二：旅即次，懷其資，得童仆貞。
《象》曰：「得童仆貞」，終無尤也。
九三：旅焚其次，喪其童仆，貞厲。
《象》曰：「旅焚其次」，亦以傷矣。以旅與下，其義喪也。
九四：旅于處，得其資斧，我心不快。
《象》曰：「旅于處」，未得位也。「得其資斧」，心未快也。
六五：射雉一矢亡，終以譽命。
《象》曰：「終以譽命」，上逮也。
上九：鳥焚其巢，旅人先笑后號啕。喪牛于易，凶。
《象》曰：以旅在上，其義焚也。「喪牛于易」，終莫之聞也。
 
《易經》第五十七卦巽巽為風巽上巽下
 
巽，小亨，利有攸往，利見大人。
《彖》曰：重巽以申命，剛巽乎中正而志行，柔皆順乎剛，是以「小亨，利有攸往，利見大人」。
《象》曰：隨風，巽。君子以申命行事。
初六：進退，利武人之貞。
《象》曰：「進退」，志疑也。「利武人之貞」，志治也。
九二：巽在床下，用史巫紛若，吉無咎。
《象》曰：紛若之吉，得中也。
九三：頻巽，吝。
《象》曰：頻巽之吝，志窮也。
六四：悔亡，田獲三品。
《象》曰：「田獲三品」，有功也。
九五：貞吉悔亡，無不利。無初有終，先庚三日，后庚三日，吉。
《象》曰：九五之吉，位正中也。
上九：巽在床下，喪其資斧，貞凶。
《象》曰：「巽在床下」，上窮也。「喪其資斧」，正乎凶也。
 
《易經》第五十八卦兌兌為澤兌上兌下
 
兌，亨，利貞。
《彖》曰：兌，說也。剛中而柔外，說以利貞，是以順乎天而應乎人。說以先民，民忘其勞。說以犯難，民忘其死。說之大，民勸矣哉！
《象》曰：麗澤，兌。君子以朋友講習。
初九：和兌，吉。
《象》曰：和兌之吉，行未疑也。
九二：孚兌，吉，悔亡。
《象》曰：孚兌之吉，信志也。
六三：來兌，凶。
《象》曰：來兌之凶，位不當也。
九四：商兌，未寧，介疾有喜。
《象》曰：九四之喜，有慶也。
九五：孚于剝，有厲。
《象》曰：「孚于剝」，位正當也。
上六：引兌。
《象》曰：上六「引兌」，未光也。
 
《易經》第五十九卦渙風水渙巽上坎下
 
渙，亨。王假有廟，利涉大川，利貞。
《彖》曰：「渙，亨」，剛來而不窮，柔得位乎外而上同。「王假有廟」，王乃在中也。「利涉大川」，乘木有功也。
《象》曰：風行水上，渙。先王以享于帝立廟。
初六：用拯馬壯，吉。
《象》曰：初六之吉，順也。
九二：渙奔其機，悔亡。
《象》曰：「渙奔其機」，得愿也。
六三：渙其躬，無悔。
《象》曰：「渙其躬」，志在外也。
六四：渙其群，元吉。渙有丘，匪夷所思。
《象》曰：「渙其群，元吉」，光大也。
九五：渙汗其大號，渙王居，無咎。
《象》曰：「王居，無咎」，正位也。
上九：渙其血，去逖出，無咎。
《象》曰：「渙其血」，遠害也。
 
《易經》第六十卦節水澤節坎上兌下
 
節，亨。苦節，不可貞。
《彖》曰：「節，亨」，剛柔分而剛得中。「苦節，不可貞」，其道窮也。說以行險，當位以節，中正以通。天地節而四時成，節以制度，不傷財，不害民。
《象》曰：澤上有水，節。君子以制數度、議德行。
初九：不出戶庭，無咎。
《象》曰：「不出戶庭」，知通塞也。
九二：不出門庭，凶。
《象》曰：「不出門庭」，失時極也。
六三：不節若，則嗟若，無咎。
《象》曰：不節之嗟，又誰咎也？
六四：安節，亨。
《象》曰：安節之亨，承上道也。
九五：甘節，吉。往有尚。
《象》曰：甘節之吉，居位中也。
上六：苦節，貞凶，悔亡。
《象》曰：「苦節，貞凶」，其道窮也。
 
《易經》第六十一卦中孚風澤中孚巽上兌下
 
中孚，豚魚吉，利涉大川，利貞。
《彖》曰：中孚，柔在內而剛得中。說而巽，孚乃化邦也。「豚魚吉」，信及豚魚也。「利涉大川」，乘木舟虛也。中孚以利貞，乃應乎天也。
《象》曰：澤上有風，中孚。君子以議獄緩死。
初九：虞吉，有他不燕。
《象》曰：初九「虞吉」，志未變也。
九二：鳴鶴在陰，其子和之，我有好爵，吾與爾靡之。
《象》曰：「其子和之」，中心愿也。
六三：得敵，或鼓或罷，或泣或歌。
《象》曰：「或鼓或罷」，位不當也。
六四：月几望，馬匹亡，無咎。
《象》曰：馬匹亡，絕類上也。
九五：有孚攣如，無咎。
《象》曰：「有孚攣如」，位正當也。
上九：翰音登于天，貞凶。
《象》曰：「翰音登于天」，何可長也！
 
《易經》第六十二卦小過雷山小過震上艮下
 
小過，亨，利貞，可小事，不可大事。飛鳥遺之音，不宜上宜下，大吉。
《彖》曰：小過，小者過而亨也。過以利貞，與時行也。柔得中，是以小事吉也。剛失位而不中，是以不可大事也。有飛鳥之象焉。「飛鳥遺之音，不宜上宜下，大吉」，上逆而下順也。
《象》曰：山上有雷，小過。君子以行過乎恭，喪過乎哀，用過乎儉。
初六：飛鳥以凶。
《象》曰：「飛鳥以凶」，不可如何也。
六二：過其祖，遇其妣，不及其君，遇其臣，無咎。
《象》曰：「不及其君」，臣不可過也。
九三：弗過防之，從或戕之，凶。
《象》曰：「從或戕之」，凶如何也。
九四：無咎，弗過遇之。往厲必戒，勿用永貞。
《象》曰：「弗過遇之」，位不當也。「往厲必戒」，終不可長也。
六五：密云不雨，自我西郊，公弋，取彼在穴。
《象》曰：「密云不雨」，已上也。
上六：弗遇過之，飛鳥離之，凶，是謂災眚。
《象》曰：「弗遇過之」，已亢也。
 
《易經》第六十三卦既濟水火既濟坎上離下
 
既濟，亨，小利貞，初吉終亂。
《彖》曰：「既濟，亨」，小者亨也。「利貞」，剛柔正而位當也。「初吉」，柔得中也。終止則亂，其道窮也。
《象》曰：水在火上，既濟。君子以思患而預防之。
初九：曳其輪，濡其尾，無咎。
《象》曰：「曳其輪」，義無咎也。
六二：婦喪其茀，勿逐，七日得。
《象》曰：「七日得」，以中道也。
九三：高宗伐鬼方，三年克之，小人勿用。
《象》曰：「三年克之」，憊也。
六四：儒有衣袽，終日戒。
《象》曰：「終日戒」，有所疑也。
九五：東鄰殺牛，不如西鄰之禴祭，實受其福。
《象》曰：「東鄰殺牛」，不如西鄰之時也。「實受其福」，吉大來也。
上六：濡其首，厲。
《象》曰：「濡其首，厲」，何可久也！
 
《易經》第六十四卦未濟火水未濟離上坎下
 
未濟，亨，小狐汔濟，濡其尾，無攸利。
《彖》曰：「未濟，亨」，柔得中也。「小狐汔濟」，未出中也。「濡其尾，無攸利」，不續終也。雖不當位，剛柔應也。
《象》曰：火在水上，未濟。君子以慎辨物居方。
初六：濡其尾，吝。
《象》曰：「濡其尾」，亦不知極也。
九二：曳其輪，貞吉。
《象》曰：九二「貞吉」，中以行正也。
六三：未濟，征凶，利涉大川。
《象》曰：「未濟，征凶」，位不當也。
九四：貞吉，悔亡，震用伐鬼方，三年有賞于大國。
《象》曰：「貞吉，悔亡」，志行也。
六五：貞吉，無悔，君子之光，有孚，吉。
《象》曰：「君子之光」，其暉吉也。
上九：有孚于飲酒，無咎，濡其首，有孚失是。
《象》曰：飲酒濡首，亦不知節也。
 
系辭上傳
 
天尊地卑，乾坤定矣。卑高以陳，貴賤位矣。動靜有常，剛柔斷矣。方以類聚，物以群分，吉凶生矣。在天成象，在地成形，變化見矣。是故剛柔相摩，八卦相蕩。鼓之以雷霆，潤之以風雨。日月運行，一寒一暑。乾道成男，坤道成女。
乾知大始，坤作成物。乾以易知，坤以簡能。易則易知，簡則易從。易知則有親，易從則有功。有親則可久，有功則可大。可久則賢人之德，可大則賢人之業。易簡而天下矣之理得矣。天下之理得，而成位乎其中矣。
聖人設卦觀象，系辭焉而明吉凶，剛柔相推而生變化。是故，吉凶者，失得之象也。悔吝者，憂虞之象也。變化者，進退之象也。剛柔者，晝夜之象也。六爻之動，三極之道也。是故，君子所居而安者，易之序也。所樂而玩者，爻之辭也。是故，君子居則觀其象而玩其辭，動則觀其變而玩其占。是故自天佑之，吉無不利。
彖者，言乎象者也。爻者，言乎變者也。吉凶者，言乎其失得也。悔吝者，言乎其小疵也。無咎者，善補過也。是故，列貴賤者存乎位，齊小大者存乎卦，辯吉凶者存乎辭，憂悔吝者存乎介，震無咎者存乎悔。是故，卦有小大，辭有險易。辭也者，也各指其所之。
《易》與天地准，故能彌綸天地之道。
仰以觀於天文，俯以察於地理，是故知幽明之故。原始反終，故知死生之說。精氣為物，游魂為變，是故知鬼神之情狀。
與天地相似，故不違。知周乎萬物而道濟天下，故不過。旁行而不流，樂天知命，故不憂。安土敦乎仁，故能愛。
范圍天地之化而不過，曲成萬物而不遺，通乎晝夜之道而知，故神無方而《易》無體。
一陰一陽之謂道，繼之者善也，成之者性也。仁者見之謂之仁，知者見之謂之知。百姓日用不知，故君子之道鮮矣！
顯諸仁，藏諸用，鼓萬物而不與聖人同憂，盛德大業至矣哉！富有之謂大業，日新之謂盛德。生生之謂易，成象之謂乾，效法之謂坤，極數知來之謂占，通變之謂事，陰陽不測之謂神。
夫《易》廣矣大矣！以言乎遠則不御，以言乎邇則靜而正，以言乎天地之間則備矣！
夫乾，其靜也專，其動也直，是以大生焉。夫坤，其靜也翕，其動也辟，是以廣生焉。廣大配天地，變通配四時，陰陽之義配日月，易簡之善配至德。
子曰：「《易》其至矣乎！」夫《易》，聖人所以崇德而廣業也。知崇禮卑，崇效天，卑法地，天地設位，而《易》行乎其中矣。成性存存，道義之門。
聖人有以見天下之賾，而擬諸其形容，象其物宜，是故謂之象。聖人有以見天下之動，而觀其會通，以行其禮，系辭焉，以斷其吉凶，是故謂之爻。
言天下之至賾，而不可惡也。言天下之至動，而不可亂也。擬之而后言，議之而后動，擬議以成其變化。
「鳴鶴在陰，其子和之，我有好爵，吾與爾靡之。」子曰：「君子居其室，出其言善，則千里之外應之，況其邇者乎?居其室，出其言不善，則千里之外違之，況其邇者乎?言出乎身，加乎民。行發乎邇, 見乎遠。言行，君子之樞機。樞機之發，榮辱之主也。言行，君子之所以動天地也，可不慎乎?」
「同人，先號咷而后笑。」子曰：「君子之道，或出或處，或默或語，二人同心，其利斷金。同心之言，其臭如蘭。」
「初六，藉用白茅，無咎。」子曰：「苟錯諸地而可矣。藉之用茅，何咎之有？慎之至也。夫茅之為物薄，而用可重也。慎斯朮也以往，其無所失矣。」
「勞謙，君子有終吉。」子曰：「勞而不伐，有功而不德，厚之至也，語以其功下人者也。德言盛，禮言恭，謙也者，致恭以存其位者也。」
「亢龍有悔。」子曰：「貴而無位，高而無民，賢人在下位而無輔，是以動而有悔也。」
「不出戶庭，無咎。」子曰：「亂之所生也，則言語以為階。君不密則失臣，臣不密則失身，几事不密，則害成，是以君子慎密而不出也。」
子曰：「作《易》者其知盜乎？《易》曰：『負且乘，致寇至。』負也者，小人之事也。小人而乘君子之器，盜思奪矣！上慢下暴，盜思伐之矣！慢藏誨盜，冶容誨淫，《易》曰：『負且乘，致寇至。』盜之招也。」
天一地二，天三地四，天五地六，天七地八，天九地十。天數五，地數五，五位相得而各有合。天數二十有五，地數三十，凡天地之數五十有五，此所以成變化而行鬼神也。
大衍之數五十，其用四十有九。分而為二以象兩，挂一以象三，揲之以四以象四時，歸奇於扐以象閏，故再扐而后挂。
乾之策二百一十有六，坤之策百四十有四，凡三百有六十，當期之日。二篇之策，萬有一千五百二十，當萬物之數也。
是故，四營而成《易》，十有八變而成卦，八卦而小成。引而伸之，觸類而長之，天下之能事畢矣。
顯道神德行，是故可與酬酢，可與佑神矣。子曰：「知變化之道者，其知神之所為乎！」
《易》有聖人之道四焉：以言者尚其辭，以動者尚其變，以制器者尚其象，以卜筮者尚其占。是以君子將有為也，將有行也，問焉而以言，其受命也如響，無有遠近幽深，遂知來物。非天下之至精，其孰能與於此？
參伍以變，錯綜其數，通其變，遂成天地之文。極其數，遂定天下之象。非天下之致變，其孰能與於此？
《易》無思也，無為也，寂然不動，感而遂通天下之故。非天下之致神，其孰能與於此？
夫《易》，聖人之所以極深而研幾也。惟深也，故能通天下之志。惟幾也，故能成天下之務。惟神也，故不疾而速，不行而至。子曰「《易》有聖人之道四焉」者，此之謂也。
子曰：「夫《易》何為者也？夫《易》開物成務，冒天下之道，如斯而已者也。是故聖人以通天下之志，以定天下之業，以斷天下之疑。」
是故蓍之德圓而神，卦之德方以知，六爻之義易以貢。聖人以此洗心，退藏於密，吉凶與民同患。神以知來，知以藏往，其孰能與於此哉！古之聰明睿知神武而不殺者夫？是以明於天之道，而察於民之故，是與神物，以前民用。聖人以此齋戒，以神明其德夫！
是故闔戶謂之坤，辟戶謂之乾，一闔一辟謂之變，往來不窮謂之通。見乃謂之象，形乃謂之器，制而用之謂之法，利用出入，民咸用之，謂之神。
是故《易》有太極，是生兩儀，兩儀生四象，四象生八卦，八卦定吉凶，吉凶生大業。
是故法象莫大乎天地，變通莫大乎四時，懸象著明莫在乎日月，崇高莫大乎富貴，備物致用，立成器以為天下利，莫大乎聖人，探賾索隱，鉤深致遠，以定天下之吉凶，成天下之亹亹者，莫大乎蓍龜。
是故天生神物，聖人則之。天地變化，聖人效之。天垂象，見吉凶，聖人象之。河出圖，洛出書，聖人則之。《易》有四象，所以示也。系辭焉，所以告也。定之以吉凶，所以斷也。
《易》曰：「自天佑之，吉無不利。」子曰：「佑者助也。天之所助者，順也。人之所助者，信也。履信思乎順，又以尚賢也。是以自天佑之，吉無不利也。」
子曰：「書不盡言，言不盡意。然則聖人之意，其不可見乎？」子曰：「聖人立象以盡意，設卦以盡情偽，系辭焉以盡其言，變而通之以盡利，鼓之舞之以盡神。」
乾坤其《易》之縕邪？乾坤成列，而《易》立乎其中矣。乾坤毀，則無以見《易》。《易》不可見，則乾坤或几乎息矣。
是故形而上者謂之道，形而下者謂之器，化而裁之謂之變，推而行之謂之通，舉而錯之天下之民謂之事業。
是故，夫象，聖人有以見天下之賾，而擬諸形容，象其物宜，是故謂之象。聖人有以見天下之動，而觀其會通，以行其典禮，系辭焉，以斷其吉凶，是故謂之爻。極天下之賾者存乎卦，鼓天下之動者存乎辭，化而裁之存乎變，推而行之存乎通，神而明之存乎其人，默而成之，不言而信，存乎德行。
 
系辭下傳
 
八卦成列，象在其中矣。因而重之，爻在其中矣。剛柔相推，變在其中矣。系辭焉而命之，動在其中矣。
吉凶悔吝者，生乎動者也。剛柔者，立本者也。變通者，趣時者也。吉凶者，貞勝者也。天地之道，貞觀者也。日月之道，貞明者也。天下之動，貞夫一者也。
夫乾，確然示人易矣。夫坤，聵然示人簡矣。爻也者，效此者也。象也者，像此者也。
爻象動乎內，吉凶見乎外，功業見乎變，聖人之情見乎辭。
天地之大德曰生，聖人之大寶曰位，何以守位曰仁，何以聚人曰財，理財正辭，禁民為非曰義。
古者包羲氏之王天下也，仰則觀象於天，俯則觀法於地，觀鳥獸之文，與地之宜，近取諸身，遠取諸物，於是始作八卦，以通神明之德，以類萬物之情。
作結繩而為網罟，以佃以漁，蓋取諸離。
包羲氏沒，神農氏作，斲木為耜，揉木為耒，耒耨之利，以教天下，蓋取諸益。
日中為市，致天下之貨，交易而退，各得其所，蓋取諸噬嗑。
神農氏沒，黃帝、堯、舜氏作，通其變，使民不倦，神而化之，使民宜之。易窮則變，變則通，通則久，是以「自天佑之，吉無不利」。黃帝、堯、舜垂衣裳而天下治，蓋取諸乾坤。
刳木為舟，剡木為楫，舟楫之利，以濟不通，致遠以利天下，蓋取諸渙。
服牛乘馬，引重致遠，以利天下，蓋取諸隨。
重門擊柝，以待暴客，蓋取諸豫。
斷木為杵，掘地為臼，臼杵之利，萬民以濟，蓋取諸小過。
弦木為弧，剡木為矢，弧矢之利，以威天下，蓋取諸睽。
上古穴居而野處，后世聖人易之以宮室，上棟下宇，以待風雨，蓋取諸大壯。
古之葬者厚衣之以薪，葬之中野，不封不樹，喪期無數，后世聖人易之以棺槨，蓋取諸大過。
上古結繩而治，后世聖人易之以書契，百官以治，萬民以察，蓋取諸夬。
是故，《易》者象也。象也者，像也。彖者材也。爻也者，效天下之動也。是故吉凶生而悔吝著也。
陽卦多陰，陰卦多陽，其故何也？陽卦奇，陰卦耦。其德行何也？陽一君而二民，君子之道也。陰二君而一民，小人之道也。
《易》曰：「憧憧往來，朋從爾思。」子曰：「天下何思何慮？天下同歸而殊途，一致而百慮，天下何思何慮？日往則月來，月往則日來，日月相推而明生焉。寒往則暑來，暑往則寒來，寒暑相推而歲成焉。往者屈也，來者信也，屈信相感而利生焉。尺蠖之屈，以求信也。龍蛇之蟄，以存身也。精義入神，以致用也。利用安身，以崇德也。過此以往，未之或知也。窮神知化，德之盛也。」
《易》曰：「困于石，據于蒺藜，入于其宮，不見其妻，凶。」子曰：「非所困而困焉，名必辱。非所據而據焉，身必危。既辱且危，死期將至，妻其可得見邪？」
《易》曰：「公用射隼于高墉之上，獲之，無不利。」子曰：「隼者，禽也。弓矢者，器也。射之者，人也。君子藏器於身，待時而動，何不利之有？動而不括，是以出而不獲。語成器而動者也。」
子曰：「小人不恥不仁，不畏不義，不見利而不勸，不威不懲。小懲而大誡，此小人之福也。《易》曰『履校滅趾，無咎』，此之謂也。善不積不足以成名，惡不積不足以滅身。小人以小善為無益而弗為也，以小惡為無傷而弗去也，故惡積而不可掩，罪大而不可解。《易》曰：『履校滅耳，凶。』」
子曰：「危者，安其位者也；亡者，保其存者也；亂者，有其治者也。是故君子安而不忘危，存而不忘亡，治而不忘亂，是以身安而國家可保也。《易》曰：『其亡其亡，系于苞桑。』」子曰：「德薄而位尊，知小而謀大，力少而任重，鮮不及矣。《易》曰：『鼎折足，覆公餗，其形渥，凶。』言不勝其任也。」
子曰：「知幾其神乎！君子上交不諂，下交不瀆，其知幾乎？幾者，動之微，吉之先見者也。君子見幾而作，不俟終日。《易》曰：『介於石，不終日，貞吉。』介如石焉，寧用終日？斷可識矣。君子知微知彰，知柔知剛，萬夫之望。」
子曰：「顏氏之子，其殆庶幾乎？有不善未嘗不知，知之未嘗復行也。《易》曰：『不遠復，無祗悔，元吉。』」
天地絪溫，萬物化醇。男女構精，萬物化生。《易》曰：「三人行則損一人，一人行則得其友。」言致一也。
子曰：「君子安其身而後動，易其心而後語，定其交而後求。君子修此三者，故全也。危以動，則民不與也；懼以語，則民不應也；無交而求，則民不與也。莫之與，則傷之者至矣。《易》曰：『莫益之，或擊之，立心勿恒，凶。』」
子曰：「乾坤，其《易》之門耶？」乾，陽物也；坤，陰物也。陰陽合德，而剛柔有體，以體天地之撰，以通神明之德。其稱名也，雜而不越。於稽其類，其衰世之意邪？夫《易》，彰往而察來，而微顯闡幽，開而當名辨物正言斷辭則備矣。其稱名也小，其取類也大。其旨遠，其辭文，其言曲而中，其事肆而隱。因貳以濟民行，以明失得之報。
《易》之興也，其於中古乎？作《易》者，其有憂患乎？是故，《履》，德之基也；《謙》，德之柄也；《復》，德之本也；《恒》，德之固也；《損》，德之修也；《益》，德之裕也；《困》，德之辨也；《井》，德之地也；《巽》，德之制也。《履》和而至；《謙》尊而光；《復》小而辨於物；《恒》雜而不厭；《損》先難而後易；《益》長裕而不設；《困》窮而通；《井》居其所而遷；《巽》稱而隱。《履》以和行；《謙》以制禮；《復》以自知；《恒》以一德；《損》以遠害；《益》以興利；《困》以寡怨；《井》以辨義；《巽》以行權。
《易》之為書也不可遠，為道也屢遷，變動不居，周流六虛，上下無常，剛柔相易，不可為典要，唯變所適。其出入以度，外內使知懼，又明於憂患與故，無有師保，如臨父母。初率其辭而揆其方，既有典常。苟非其人，道不虛行。
《易》之為書也，原始要終以為質也。六爻相雜，唯其時物也。其初難知，其上易知，本末也。初辭擬之，卒成之終。若夫雜物撰德，辯是與非，則非其中爻不備。噫！亦要存亡吉凶，則居可知矣。知者觀其彖辭，則思過半矣。二與四同功而異位，其善不同，二多譽，四多懼，近也。柔之為道，不利遠者，其要無咎，其用柔中也。三與五同功而異位，三多凶，五多功，貴賤之等也。其柔危，其剛勝耶？
《易》之為書也，廣大悉備，有天道焉，有人道焉，有地道焉。兼三才而兩之，故六。六者非它也，三材之道也。道有變動，故曰爻；爻有等，故曰物；物相雜，故曰文；文不當，故吉凶生焉。
《易》之興也，其當殷之末世，周之盛德耶？當文王與紂之事耶？是故其辭危。危者使平，易者使傾。其道甚大，百物不廢。懼以終始，其要無咎，此之謂《易》之道也。
夫乾，天下之至健也，德行恒易以知險。夫坤，天下之至順也，德行恒簡以知阻。能說諸心，能研諸侯之慮，定天下之吉凶，成天下之亹亹者。是故變化雲為，吉事有祥。象事知器，占事知來。天地設位，聖人成能。人謀鬼謀，百姓與能。八卦以象告，爻彖以情言，剛柔雜居，而吉凶可見矣。變動以利言，吉凶以情遷。是故愛惡相攻而吉凶生，遠近相取而悔吝生，情偽相感而利害生。凡《易》之情，近而不相得則凶，或害之，悔且吝。將叛者其辭慚，中心疑者其辭枝，吉人之辭寡，躁人之辭多，誣善之人其辭遊，失其守者其辭屈。 
 
說卦 
 
昔者聖人之作《易》也，幽贊於神明而生蓍，參天兩地而倚數，觀變於陰陽而立卦，發揮於剛柔而生爻，和順于道德而理於義，窮理盡性以至於命。
昔者聖人之作《易》也，將以順性命之理，是以立天之道曰陰與陽，立地之道曰柔與剛，立人之道曰仁與義。兼三才而兩之，故《易》六畫而成卦。分陰分陽，迭用柔剛，故《易》六位而成章。
天地定位，山澤通氣，雷風相薄，水火不相射，八卦相錯。數往者順，知來者逆，是故《易》逆數也。
雷以動之，風以散之，雨以潤之，日以烜之，艮以止之，兌以說之，乾以君之，坤以藏之。
帝出乎震，齊乎巽，相見乎離，致役乎坤，說言乎兌，戰乎乾，勞乎坎，成言乎艮。萬物出乎震，震東方也。齊乎巽，巽東南也。齊也者，言萬物之絜齊也。離也者，明也，萬物皆相見，南方之卦也。聖人南面而聽天下，向明而治，蓋取諸此也。坤也者，地也，萬物皆致養焉，故曰「致役乎坤」。兌，正秋也，萬物之所說也，故曰「說言乎兌」。「戰乎乾」，乾，西北之卦也，言陰陽相薄也。坎者水也，正北方之卦也，勞卦也，萬物之所歸也，故曰「勞乎坎」。艮，東北之卦也。萬物之所成終而成始也，故曰「成言乎艮」。
神也者，妙萬物而為言者也。動萬物者莫疾乎雷，撓萬物者莫疾乎風，躁萬物者莫乎火，說萬物者莫說乎澤，潤萬物者莫潤乎水，終萬物始萬物者莫盛乎艮。故水火相逮，雷風不相悖，山澤通氣，然後能變化，既成萬物也。
乾，健也。坤，順也。震，動也。巽，入也。坎，陷也。離，麗也。艮，止也。兌，說也。
乾為馬，坤為牛，震為龍，巽為雞，坎為豕，離為雉，艮為狗，兌為羊。
乾為首，坤為腹，震為足，巽為股，坎為耳，離為目，艮為手，兌為口。
乾，天也，故稱乎父。坤，地也，故稱乎母。震一索而得男，故謂之長男。巽一索而得女，故謂之長女。坎再索而得男。故謂之中男。離再索而得女，故謂之中女。艮三索而得男，故謂之少男。兌三索而得女，故謂之少女。
乾為天，為圓，為君，為父，為玉，為金，為寒，為冰，為大赤，為良馬，為老馬，為瘠馬，為駁馬，為木果。
坤為地，為母，為布，為釜，為吝嗇，為均，為子母牛，為大輿，為文，為眾，為柄。其於地也為黑。
震為雷，為龍，為玄黃，為旉，為大途，為長子，為決躁，為蒼筤竹，為萑葦。其于馬也，為善鳴，為足，為作足，為的顙。其於稼也，為反生。其究為健，為蕃鮮。
巽為木，為風，為長女，為繩直，為工，為白，為長，為高，為進退，為不果，為臭。其於人也，為寡發，為廣顙，為多白眼，為近利市三倍，其究為躁卦。
坎為水，為溝瀆，為隱伏，為矯輮，為弓輪。其於人也，為加憂，為心病，為耳痛，為血卦，為赤。其于馬也，為美脊，為亟心，為下首，為薄蹄，為曳。其於輿也，為多眚，為通，為月，為盜。其於木也，為堅多心。
離為火，為日，為電，為中女，為甲胄，為戈兵。其於人也，為大腹。為乾卦，為鱉，為蟹，為蠃，為蚌，為龜。其於木也，為科上槁。
艮為山，為徑路，為小石，為門闕，為果蓏，為閽寺，為指，為狗，為鼠，為黔喙之屬。其於木也，為堅多節。
兌為澤，為少女，為巫，為口舌，為毀折，為附決。其於地也，為剛鹵。為妾，為羊。  
 
序卦 
 
有天地，然後萬物生焉。盈天地之間者唯萬物，故受之以《屯》。屯者，盈也。屯者，物之始生也。物生必蒙，故受之以《蒙》。蒙者，蒙也，物之稚也。物稚不可不養也，故受之以《需》。需者，飲食之道也。飲食必有訟，故受之以《訟》。訟必有眾起，故受之以《師》。師者，眾也。眾必有所比，故受之以《比》。比者，比也。比必有所畜，故受之以《小畜》。物畜然後有禮，故受之以《履》。履者，禮也。履而泰然後安，故受之以《泰》。泰者，通也。物不可以終通，故受之以《否》。物不可以終否，故受之以《同人》。與人同者，物必歸焉，故受之以《大有》。有大者，不可以盈，故受之以《謙》。有大而能謙必豫，故受之以《豫》。豫必有隨，故受之以《隨》。以喜隨人者必有事，故受之以《蠱》。蠱者，事也。有事而後可大，故受之以《臨》。臨者，大也。物大然後可觀，故受之以《觀》。可觀而後有所合，故受之以《噬嗑》。嗑者，合也。物不可以苟合而已，故受之以《賁》。賁者，飾也。致飾然後亨則盡矣，故受之以《剝》。剝者，剝也。物不可以終盡剝，窮上反下，故受之以《復》。復則不妄矣，故受之以《無妄》。有無妄，物然後可畜，故受之以《大畜》。物畜然後可養，故受之以《頤》。頤者，養也。不養則不可動，故受之以《大過》。物不可以終過，故受之以《坎》。坎者，陷也。陷必有所麗，故受之以《離》。離者，麗也。
有天地然後有萬物，有萬物然後有男女，有男女然後有夫婦，有夫婦然後有父子，有父子然後有君臣，有君臣然後有上下，有上下然後禮義有所錯。夫婦之道不可以不久也，故受之以《恒》。恒者，久也。物不可以久居其所，故受之以《遯》。遯者，退也。物不可以終遯，故受之以《大壯》。物不可以終壯，故受之以《晉》。晉者，進也。進必有所傷，故受之以《明夷》。夷者，傷也。傷于外者必反於家，故受之以《家人》。家道窮必乖，故受之以《睽》。睽者，乖也。乖必有難，故受之以《蹇》。蹇者，難也。物不可以終難，故受之以《解》。解者，緩也。緩必有所失，故受之以《損》。損而不已必益，故受之以《益》。益而不已必決，故受之以《夬》。夬者，決也。決必有遇，故受之以《姤》。姤者，遇也。物相遇而後聚，故受之以《萃》。萃者，聚也。聚而上者謂之升，故受之以《升》。升而不已必困，故受之以《困》。困乎上者必反下，故受之以《井》。井道不可不革，故受之以《革》。革物者莫若鼎，故受之以《鼎》。主器者莫若長子，故受之以《震》。震者，動也。物不可以終動，止之，故受之以《艮》。艮者，止也。物不可以終止，故受之以《漸》。漸者，進也。進必有所歸，故受之以《歸妹》。得其所歸者必大，故受之以《豐》。豐者，大也。窮大者必失其居，故受之以《旅》。旅而無所容，故受之以《巽》。巽者，入也。入而後說之，故受之以《兌》。兌者，說也。說而後散之，故受之以《渙》。渙者，離也。物不可以終離，故受之以《節》。節而信之，故受之以《中孚》。有其信者必行之，故受之以《小過》。有過物者必濟，故受之以《既濟》。物不可窮也，故受之以《未濟》，終焉。
 
雜卦 
 
《乾》剛《坤》柔，《比》樂《師》憂；《臨》《觀》之義，或與或求。《屯》見而不失其居。《蒙》雜而著。《震》，起也。《艮》，止也。《損》、《益》，盛衰之始也。《大畜》，時也。《無妄》，災也。《萃》聚而《升》不來也。《謙》輕而《豫》怠也。《噬嗑》，食也。《賁》，無色也。《兌》見而《巽》伏也。《隨》，無故也。《蠱》則飭也。《剝》，爛也。《復》，反也。《晉》，晝也。《明夷》，誅也。《井》通而《困》相遇也。《咸》，速也。《恒》，久也。《渙》，離也。《節》，止也。《解》，緩也。《蹇》，難也。《睽》，外也。《家人》，內也。《否》、《泰》，反其類也。《大壯》則止，《遯》則退也。《大有》，眾也。《同人》，親也。《革》，去故也。《鼎》，取新也。《小過》，過也。《中孚》，信也。《豐》，多故也。親寡，《旅》也。《離》上而《坎》下也。《小畜》，寡也。《履》，不處也。《需》，不進也。《訟》，不親也。《大過》，顛也。《姤》，遇也，柔遇剛也。《漸》，女歸待男行也。《頤》，養正也。《既濟》，定也。《歸妹》，女之終也。《未濟》，男之窮也。《夬》，決也，剛決柔也。


