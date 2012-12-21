package MT::Blog::Alias::Tags;

use strict;
use MT::Blog::Alias;

sub hdlr_blog_alias {
    my ( $ctx, $args ) = @_;
    my $blog = $ctx->stash('blog')
        or return $ctx->error(plugin->translate('You used an \'[_1]\' tag outside of the context of a blog', 'mt:BlogAlias'));
    $blog->alias || '';
}

sub hdlr_blog_alias_to_id {
    my ( $ctx, $args ) = @_;
    my $alias = $args->{alias}
        or return $ctx->error(plugin->translate('mt:[_1] tag requires [_2] modifier.', $ctx->stash('tag') || '', 'alias'));    
    my $actual = $alias;
    $actual =~ s/^~//;

    return $ctx->error(plugin->translate('Wildcard(*) not allowed in mt:[_1] tag.', $ctx->stash('tag') || ''))
        if $actual =~ /\*/;

    my $blog = $ctx->stash('blog') || 0;
    my $site = ( $blog && $blog->is_blog ? $blog->website : $blog ) || 0;

    my $id = resolve_alias($site, $actual)
        or return $ctx->error(plugin->translate('Can\'t resolve alias to [_1].'), $alias);

    $id;
}

sub hdlr_blog_alias_path {
    my ( $ctx, $args ) = @_;
    my @aliases;

    # Current alias
    my $alias = hdlr_blog_alias(@_);
    print STDERR '"', $alias, "'", "\n";
    return unless defined $alias;
    return '' unless $alias;
    unshift @aliases, $alias;

    # Website alias if blog
    my $blog = $ctx->stash('blog');
    if ( $blog->is_blog ) {
        local $ctx->{__stash}{blog} = $blog->website;
        $alias = hdlr_blog_alias(@_);
        unshift @aliases, $alias if $alias;
    }

    # Reverse and join
    @aliases = reverse @aliases if $args->{reverse};
    my $glue = $args->{glue};
    $glue = '/' unless defined $glue;

    join $glue, @aliases;
}

1;