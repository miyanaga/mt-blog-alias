package MT::Blog::Alias::CMS;

use strict;

sub plugin { MT->component('BlogAlias') }

sub template_param_cfg_prefs {
    my ( $cb, $app, $param, $tmpl ) = @_;

    my $blog = MT->model('blog')->load($param->{id}) || MT->model('website')->load($param->{id});
    $param->{alias} = $blog->alias;

    my $setting = $tmpl->createElement('app:setting', {
        label   => plugin->translate('Alias'),
        id      => 'alias',
        show_hint => 1,
        hint    => plugin->translate('Alias to this [_1] usable in blog_ids, site_ids, include_blogs and include_websites modifiers like "~news".',
            $blog->is_blog ? plugin->translate('Blog') : plugin->translate('Website')
        ),
    });
    $setting->innerHTML(q{
        ~ <input type="text" class="text" id="alias" style="width:20em" name="alias" value="<mt:var name='alias' escape='html'>">
    });

    my $target = $tmpl->getElementById('name');
    $tmpl->insertAfter($setting, $target);

    1;
}

sub save_filter_blog {
    my ( $cb, $app ) = @_;
    my $q = $app->param;

    my $screen = $q->param('cfg_screen');
    return 1 if $screen ne 'cfg_prefs';

    my $alias = $q->param('alias') || return 1;
    if ( $alias !~ /^[a-z0-9_\-]+$/ ) {
        return $app->error(
            plugin->translate('Alias must be consisted from characters, numbers, underscore or hyphen.')
        );
    }

    1;
}

sub pre_save_blog {
    my ( $cb, $app, $blog ) = @_;
    my $q = $app->param;

    my $screen = $q->param('cfg_screen');
    return 1 if $screen ne 'cfg_prefs';

    my $alias = $q->param('alias');
    $blog->alias($alias);

    1;
}

1;