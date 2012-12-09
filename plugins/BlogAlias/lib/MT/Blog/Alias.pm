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
    my ( $parents, $alias, $load ) = @_;

    # Normalize parent ids    
    my $parent_ids = $parents;
    my $parent_id;
    if ( ref $parent_ids eq 'ARRAY' ) {
        $parents = join(',', @$parents);
    } else {
        $parent_ids = [ split(/\s*,\s*/, $parents) ];
    }
    $parent_id = $parent_ids->[0] if 1 == scalar @$parent_ids;

    $alias_cache{$parents} ||= {};

    if ( $load ) {

        my $model = $parents ? 'blog' : 'website';
        my %terms;

        # Class and parent
        if ( $parents ) {
            $terms{class} = 'blog';
            $terms{parent_id} = $parent_id || $parent_ids;
        } else {
            $terms{class} = 'website';
        }

        # Alias
        if ( index($alias, '*') >= 0 ) {
            my $like = $alias;
            $like =~ s/\*/%/g;
            $terms{alias} = { like => $like };
        } else {
            $terms{alias} = $alias;
        }

        # Make query
        my $class = MT->model($model);
        $class->errstr('');
        my @objs = $class->load(\%terms);
        die $class->errstr if $class->errstr;
        $alias_cache{$parents}->{$alias} = @objs ? \@objs : 0;
    }

    $alias_cache{$parents}->{$alias};
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
        : split(m!/+!, $alias);
    die plugin->translate('Invalid alias') unless @path;

    my $absolute;
    if ( $path[0] eq '' ) {
        $absolute = 1;
        shift @path;
    }

    my $blogs;
    if ( ( !$website || $absolute ) && scalar @path == 2 ) {

        # ~/website/blog
        my $wa = shift @path || '*';
        my $sites = alias_cache('', $wa);
        $sites = alias_cache('', $wa, 1) unless defined $sites;
        die plugin->translate('Website aliased:[_1] not found', $wa)
            if !$sites || !@$sites;

        my @ids = map { $_->id } @$sites;
        my $ba = shift @path || '*';
        $blogs = alias_cache(\@ids, $ba);
        $blogs = alias_cache(\@ids, $ba, 1) unless defined $blogs;
        die plugin->translate('Blog aliased:[_1] not found', $ba)
            if !$blogs || !@$blogs;

    } elsif ( scalar @path == 1 ) {
        my $a = shift @path || '*';

        if ( $website && !$absolute ) {

            # ~blog in blog or website context
            # Relative from current website
            $blogs = alias_cache([$website->id], $a);
            $blogs = alias_cache([$website->id], $a, 1) unless defined $blogs;
        } else {

            # ~website in system context or ~/website
            $blogs = alias_cache('', $a);
            $blogs = alias_cache('', $a, 1) unless defined $blogs;
        }

        die plugin->translate('Website or blog aliased:[_1] not found', $a)
            if !$blogs || !@$blogs;
    } else {
        die plugin->translate('Alias too deep') if scalar @path >= 2;
    }

    join( ',', map { $_->id } @$blogs ) . $suffix;
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
                    $value =~ s!\~([a-z0-9_\-/\*]+)(\s*,)?!resolve_alias($site, $1, $2)!ieg;
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