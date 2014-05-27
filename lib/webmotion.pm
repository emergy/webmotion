package webmotion;
use Dancer ':syntax';
use Dancer::Plugin::Database;
use Data::Dumper;
use File::Basename;
use LWP::UserAgent;
use IO::Socket;
use Dancer::Handler::PSGI;
use HTML::Entities;

our $VERSION = '0.1';
our $DEBUG = config->{DEBUG};

my $FILE_TYPE_JPEG = 1;
my $FILE_TYPE_OGG  = 8;
my $STREAM_CONTENT_TYPE = 'video/ogg';
my $motion_records_dir = config->{motion_records_dir};

my $public_dir = "public";
my $app_records_dir = "records";

hook 'before' => sub {
    if (session('user') && request->path_info =~ m{^/logout}) {
        Debug("Logout");
    } elsif (! session('user') && request->path_info !~ m{^/login}) {
        var requested_path => request->path_info;
        request->path_info('/login');
    } elsif (session('user') && session('user')->{'role'} eq 'service') {
        if (request->path_info !~ m{^/(on|off|status|service)}) {
            var requested_path => request->path_info;
            request->path_info('/service');
        }
    }
};

get '/' => sub {
    if (session('user')->{role} eq 'service') {
        redirect '/service';
    } else {
        redirect '/events';
    }
};

get '/service' => sub {
    to_log('service', 'open service page');
    return 'service';
};
        
get '/events' => sub {
    template 'records', { 
        nav => template 'nav', {}, { layout => undef },
    };
};

post '/events' => sub {
    Debug("events_params: ", params);
    my $camera = params->{camera} ||= 1;
    my $offset = params->{offset} ||= 0;
    my $limit =  params->{limit}  ||= 1;
    my $max_date = params->{max}  ||= 'NOW()';
    my $min_date = params->{min}  ||= '2013-03-29 16:53:56';

    my $query = "SELECT * FROM events " .
                "WHERE camera = ? AND file_type = ? AND event_timestamp <= ? AND event_timestamp >= ? " .
                "ORDER BY id DESC LIMIT ?, ?";
    my $sth = database->prepare($query);

    my $execute = $sth->execute($camera, $FILE_TYPE_OGG,
                                decodeURL($max_date),
                                decodeURL($min_date),
                                $offset,
                                $limit
    ) || die "Can't execute SQL query [$query]: $!\n";

    Debug("sql_query: ", $query);
    my @records;

    while (my $res = $sth->fetchrow_hashref) {
        #$res->{filename} =~ s/$motion_records_dir//;
        Debug("filename: " . $res->{filename});
        $res->{filename} = basename($res->{filename});
        $res->{width} = config->{embed_width} ||= 320;
        $res->{height} = config->{embed_height} ||= 240;

        push @records, $res;
    }

    my $json = params;
    to_log('get_events', to_json($json));

    content_type 'application/json';
    return to_json(\@records);
};

get '/record/:file' => sub {
    header 'X-Accel-Redirect' => '/protected/' . params->{file};
};

get '/logout' => sub {
   to_log("login", "logout: " . session('user')->{'name'});
   session->destroy;
   redirect '/';
};

get '/login' => sub {
    template 'login';
};

post '/login' => sub {
    my $user = database->quick_select('users', 
        { name => params->{login} }
    );

    if (!$user) {
        Debug("Login: Failed login for unrecognised user " . params->{login});
        return 0;
    } else {
        if ($user->{password} eq params->{password}) {
            to_log("login", "correct: " . params->{login});
            Debug("Login: Password correct");
            session user => $user;
            return 1;
        } else {
            to_log("login", "incorrect: " . params->{login});
            Debug("Login: failed - password incorrect for " . params->{login});
            return 0;
        }
    }
};

get '/live/:camera' => sub {
    header 'X-Accel-Redirect' => '/live-protected/' . params->{camera};
};

get '/camera' => sub { redirect '/camera/0' };

get '/camera/:camera' => sub {
    my $camera = params->{camera} ||= 0;

    to_log('camera', 'open camera ' . $camera);

    template 'camera', {
        embed_width => config->{embed_width},
        embed_height => config->{embed_height},
        live_url => "/live/$camera",
        nav => template 'nav', {}, { layout => undef },
    };
};

get '/on' => sub {
    to_log('service', 'Motion service start');
    return system("sudo service motion start");
};

get '/off' => sub {
    to_log('service', 'Motion service stop');
    return system("sudo service motion stop");
};

get '/status' => sub {
    my $status = 0;
    open STATUS, "ps -Af |" || die "Can't open ps proccess: $!\n";

    while (<STATUS>) {
        chomp;
        my ($user, $pid, $ppid, $c, $stime, $tty, $time, @CMD) = split(/\s+/, $_);
        my $cmd = join(' ', @CMD);
        $status = 1 if $cmd =~ m{^/usr/bin/motion};
    }

    close STATUS;
    return $status;
};

sub Debug {
    my ($title, $content) = @_;

    if ($DEBUG) {
        if ($content) {
            $Data::Dumper::Terse = 1;
            debug "\n\n\n$title: " . Dumper($content) . "\n\n\n";
        } else {
            debug "\n\n\n$title\n\n\n";
        }
    }
}

sub decodeURL {
    my $url = shift;

    $url =~ tr/+/ /;
    $url =~ s/%([\dA-Fa-f]{2})/pack("C", hex($1))/eg;

    $url = decode_entities($url);

    return $url;
}

sub to_log {
    my ($type, $text) = @_;

    database->quick_insert('log', {
        type => $type,
        text => $text,
    });
}

true;
