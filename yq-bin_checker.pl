#!/usr/bin/perl

use strict;
use warnings;

use Proc::Daemon;
use IO::Handle;
use LWP::Curl;
use JSON::XS;
use Data::Dumper;

# 定数宣言
use constant REFERER    => 'http://yq-bin.sakura.ne.jp';
use constant GET_URL    => REFERER.'/order_select.php';
use constant DELETE_URL => REFERER.'/order_delete.php';
use constant FILE       => '/tmp/yq-bin_order.json';

# ログ即時出力設定
STDOUT->autoflush;
STDERR->autoflush;

# SLEEP間隔
our $SLEEP_INTERVAL = 1;

# LWPオブジェクト作成
our $lwpcurl = LWP::Curl->new();

&init;
&run;

sub action {
    # メイン処理

    # SELECT API アクセス
    my $content = $lwpcurl->get(GET_URL, REFERER);

    # JSON変換
    my $json = decode_json $content;

    # データチェック
    my $count = @$json;
    if( $count < 1 ){
        print "data nothing...\n";
        return 1;
    }

    # debug log
    print Dumper $json;

    # データがある場合はファイルを出力
    open(my $fh, '>', FILE) or die "Can't open file: $!";
    # ファイル書き込みの処理
    print $fh $content;
    close($fh);

    # ファイル作成に成功した場合DELETE APIにアクセス
    foreach my $data ( @$json ){
        my $res = $lwpcurl->get(DELETE_URL.'?id='.$data->{ID}, REFERER);
        # debug log
        print Dumper $res;
    }

    return 1;
}

sub interrupt {
    my $sig = shift;

    # I *am* the leader
    setpgrp;
    $SIG{$sig} = 'IGNORE';
    # death to all-comers
    kill $sig, 0;
    die "killed by $sig";

    exit(0);
}

sub init {
    $SIG{INT}  = 'interrupt';         # Ctrl-C が押された場合
    $SIG{HUP}  = 'interrupt';         # HUP  シグナルが送られた場合
    $SIG{QUIT} = 'interrupt';         # QUIT シグナルが送られた場合
    $SIG{KILL} = 'interrupt';         # KILL シグナルが送られた場合
    $SIG{TERM} = 'interrupt';         # TERM シグナルが送られた場合

    Proc::Daemon::Init(
        {
            work_dir        => '/var/run',
            pid_file        => 'yq-bin_checker.pid',
            child_STDOUT    => '+>>/tmp/yq-bin_checker.out',
            child_STDERR    => '+>>/tmp/yq-bin_checker.err',
        }
    );
}

sub run {
    while(1) {
        # SLEEP_INTERVALごとにactionを呼び出す
        &action;

        sleep($SLEEP_INTERVAL);
    }
}

1;
