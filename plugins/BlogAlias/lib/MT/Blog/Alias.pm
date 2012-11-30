package MT::Blog::Alias;

use strict;

my %alias_cache;
my @target_args = qw(blog_id site_id blog_ids site_ids include_blogs include_websites exclude_blogs exclude_websites);

sub plugin { MT->component('BlogAlias') }

sub init_app { 1 }

sub on_blog_saved {
    my ( $cb, $eh, $blog ) = @_;
    reset_alias_cache();
}

sub on_blog_removed {
    my ( $cb, $eh, $blog ) = @_;
    reset_alias_cache();
}

sub alias_cache {
    my ( $parent, $alias, $load ) = @_;
    $alias_cache{$parent} ||= {};

    if ( $load ) {

        my $model = $parent ? 'blog' : 'website';
        my %terms = ( alias => $alias, class => $model );
        $terms{parent_id} = $parent if $parent;

        my $class = MT->model($model);
        $class->errstr('');
        my $o = $class->load(\%terms) || 0;
        die $class->errstr if $class->errstr;
        $alias_cache{$parent}->{$alias} = $o;
    }

    $alias_cache{$parent}->{$alias};
}

sub reset_alias_cache {
    my ( $parent, $alias ) = @_;

    %alias_cache = ();
}

sub resolve_alias {
    my ( $website, $alias, $suffix ) = @_;
    $suffix ||= '';

    my @path = ref $alias eq 'ARRAY'
        ? @$alias
        : grep { $_ } split('/', $alias);
    die plugin->translate('Invalid alias') unless @path;
    die plugin->translate('Alias too deep') if scalar @path > 2;

    my $blog;
    if ( scalar @path == 2 ) {

        # website/blog
        my $wa = shift @path;
        my $site = alias_cache(0, $wa);
        $site = alias_cache(0, $wa, 1) unless defined $site;
        die plugin->translate('Website alias:[_1] not found', $wa)
            unless $site;

        my $ba = shift @path;
        $blog = alias_cache($site->id, $ba);
        $blog = alias_cache($site->id, $ba, 1) unless defined $blog;
        die plugin->translate('Blog alias:[_1] not found', $ba)
            unless $blog;

    } else {
        my $a = shift @path;

        if ( $website ) {

            # Relative from current website
            $blog = alias_cache($website->id, $a);
            $blog = alias_cache($website->id, $a, 1) unless defined $blog;
        }

        unless ( $blog ) {

            # Retry as website
            $blog = alias_cache(0, $a);
            $blog = alias_cache(0, $a, 1) unless defined $blog;
        }

        die plugin->translate('Website or blog alias:[_1] not found', $a)
            unless $blog;
    }

    $blog->id . $suffix;
}

{
    no warnings qw(redefine);

    my $invoke = \&MT::Template::Handler::invoke;
    *MT::Template::Handler::invoke = sub {
        my ( $self, $ctx, $args ) = @_;
        my ( $blog, $site );

        for my $arg ( @target_args ) {
            defined(my $value = $args->{$arg}) or next;
            if ( index($value, '~') >= 0 ) {
                $blog = $ctx->stash('blog') || 0 unless defined $blog;
                $site = ( $blog && $blog->is_blog ? $blog->website : $blog ) || 0 unless defined $site;

                local $@;
                eval {
                    $value =~ s!\~([a-z0-9_\-/]+)(\s*,)?!resolve_alias($site, $1, $2)!ieg;
                };
                if ( $@ ) {
                    my $err = $@;
                    my $tag = $ctx->stash('tag') || '';
                    return $ctx->error(plugin->translate('Cannot resolve alias in [_2] of mt:[_1]: [_3]', $tag, $arg, $err));
                }

                $args->{$arg} = $value;
            }
        }

        $invoke->(@_);
    };
}

1;
__END__