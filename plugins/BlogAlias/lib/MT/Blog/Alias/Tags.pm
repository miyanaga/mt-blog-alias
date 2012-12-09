package MT::Blog::Alias::Tags;

use strict;

sub hdlr_blog_alias {
    my ( $ctx, $args ) = @_;
    my $blog = $ctx->stash('blog') 
        or return $ctx->error(plugin->translate('You used an \'[_1]\' tag outside of the context of a blog', 'mt:BlogAlias'));
    $blog->alias || '';
}

1;