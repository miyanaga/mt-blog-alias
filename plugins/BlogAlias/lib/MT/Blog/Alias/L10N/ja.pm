# Movable Type (r) (C) 2006-2012 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

# Original Copyright (c) 2004-2006 David Raynes

package MT::Blog::Alias::L10N::ja;

use strict;
use utf8;
use base 'MT::Blog::Alias::L10N::en_us';
use vars qw( %Lexicon );

## The following is the translation table.

%Lexicon = (
    'Blog and Website Alias' => 'ブログ・ウェブサイトのエイリアス',
    'Adds keyword alias to blog and website.' => 'ブログとウェブサイトにキーワードエイリアスを追加します。',
	'Alias' => 'エイリアス',
	'Alias to this [_1] usable in blog_id, site_id, blog_ids, site_ids, include_blogs and include_websites modifiers like "~news".'
		=> 'blog_id, site_id, blog_ids、site_ids、include_blogs、include_websitesモディファイアで"~news"のように使用できるこの[_1]に対するエイリアスを指定します。',
    'You used an \'[_1]\' tag outside of the context of a blog'
        => '[_1]タグはブログのコンテキスト外で使用できません',
    'Alias must be consisted from characters, numbers, underscore or hyphen.'
        => 'エイリアスには半角英数字、アンダースコア(_)、ハイフンのみが使用できます。',
    'Alias must be within 64 characters.' => 'エイリアスは64文字以内で指定してください。',
    'mt:[_1] tag requires [_2] modifier.' => 'mt:[_1]テンプレートタグには[_2]モディファイアが必要です。',
    'Can\'t resolve alias to [_1].' => 'エイリアス[_1]を解決できません。',
    'Wildcard(*) not allowed in mt:[_1] tag.' => 'mt:[_1]テンプレートタグではエイリアスにワイルドカード(*)は使用できません。',
);

1;

