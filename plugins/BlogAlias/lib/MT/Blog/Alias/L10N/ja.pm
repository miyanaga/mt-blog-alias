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
	'Alias' => 'エイリアス',
	'Alias to this [_1] usable in blog_ids, site_ids, include_blogs and include_websites modifiers like "~news".'
		=> 'blog_ids、site_ids、include_blogs、include_websitesモディファイアで"~news"のように使用できるこの[_1]に対するエイリアスを指定します。',
		
);

1;

