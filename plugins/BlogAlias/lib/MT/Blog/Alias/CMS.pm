package MT::Blog::Alias::CMS;

use strict;

sub plugin { MT->component('BlogAlias') }

sub config_template {
    my ( $app, $param, $scope ) = @_;
    my ( $blog_id, $blog, $is_blog, $system_config );
    if ( $scope =~ m!^blog:([0-9]+)$! ) {
        $blog_id = $1;
        $blog = MT->model('blog')->load($blog_id) || MT->model('website')->load($blog_id);

        # No config on blog
        $is_blog = $blog->is_blog || return '';

        my %config;
        plugin->load_config(\%config, 'system');
        $system_config = \%config;
    }

    $param->{show_reuiqres_website_alias} = $blog_id ? 0 : 1;
    $param->{requires_blog_alias_set_in_system}
        = $system_config && $system_config->{requires_blog_alias} ? 1 : 0;

    plugin->load_tmpl('config_template.tmpl');
}

sub template_param_cfg_prefs {
    my ( $cb, $app, $param, $tmpl ) = @_;

    my $blog = MT->model('blog')->load($param->{id}) || MT->model('website')->load($param->{id});
    $param->{alias} = defined $app->param('alias') ? $app->param('alias') : $blog->alias;

    # Alias field.
    my $setting = $tmpl->createElement('app:setting', {
        label   => plugin->translate('Alias'),
        id      => 'alias',
        show_hint => 1,
        hint    => plugin->translate('Alias to this [_1] usable in blog_id, site_id, blog_ids, site_ids, include_blogs and include_websites modifiers like "~news".',
            $blog->is_blog ? plugin->translate('Blog') : plugin->translate('Website')
        ),
    });
    $setting->innerHTML(q{
        <span class="prefix">~</span>
        <input type="text" class="text" id="alias" style="width:20em" name="alias" value="<mt:var name='alias' escape='html'>">
    });

    # Placeholder
    my $target = $tmpl->getElementById('name');
    $tmpl->insertAfter($setting, $target);

    1;
}

sub save_filter_blog {
    my ( $cb, $app ) = @_;
    my $blog = $app->blog;
    my $q = $app->param;

    # Apply only for cfg_screen context
    my $screen = $q->param('cfg_screen');
    return 1 if $screen ne 'cfg_prefs';

    # Check format
    my $alias = $q->param('alias') || return 1;
    if ( $alias !~ /^[a-z0-9_\-]+$/ ) {
        return $app->error(
            plugin->translate('Alias must be consisted from characters, numbers, underscore or hyphen.')
        );
    }

    # Check length
    if ( length($alias) >= 64 ) {
        return $app->error(
            plugin->translate('Alias must be within 64 characters.')
        ); 
    }

    # Check redundancy
    my $class = 'website';
    my $unique_scope;
    if ( $blog->is_blog ) {
        $class = 'blog';
        $unique_scope = $blog->website->id;
    }
    my $same_alias = MT->model($class)->load({
        alias => $alias,
        $unique_scope ? ( parent_id => $unique_scope ) : (),
    });
    if ( $same_alias && $same_alias->id != $blog->id ) {
        return $app->error(
            plugin->translate('Same alias "[_1]" is already used in [_2].', $alias, $same_alias->name)
        );
    }

    1;
}

sub pre_save_blog {
    my ( $cb, $app, $blog ) = @_;
    my $q = $app->param;

    # Apply only for cfg_screen context
    my $screen = $q->param('cfg_screen');
    return 1 if $screen ne 'cfg_prefs';

    # Set alias to object
    my $alias = $q->param('alias');
    $blog->alias($alias);

    1;
}

1;