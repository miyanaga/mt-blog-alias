# Movable Type Blog Alias Plugin

Adds string alias to blog and website.

Writing ids in templates is not readable, and not good to move or to merge to another system.

## License

Licensed under the MIT.

## Examples

These example assumed one website and one blog aliased:

* Website "Corporate Site" aliased corporate
* Blog "News Blog" aliased news

You can set the alias under the title in Settings > General screen.

### The alias in "News Blog"

<pre>
&lt;mt:BlogAlias&gt;
&lt;!--
Outout:
news
--&gt;
</pre>

### The alias path in "News Blog"

<pre>
&lt;mt:BlogAliasPath&gt;
&lt;mt:BlogAliasPath glue=" " reverse="1"&gt;
&lt;!--
Output:
corporate/news
news corporate
--&gt;
</pre>

### Convert alias to id

<pre>
&lt;mt:BlogAliasToId alias="~/corporate"&gt;
&lt;!--
Output example:
1
--&gt;
</pre>

### Include a template module in "Corporate Site" from "News Blog"

You can use ~/website_alias or ~/website_alias/blog_alias insteed of blog id.

<pre>
&lt;mt:Include module="header" blog_id="~/corporate"&gt;
</pre>

### Include a template module in "News Blog" from "Corporate Site"

Relative path is available from same website scope.

<pre>
&lt;mt:Include module="sidebar" blog_id="~news"&gt;
</pre>

This equals to:

<pre>
&lt;mt:Inlucde module="sidebar" blog_id="~/corporate/news"&gt;
</pre>

If you have an another blog, relative path is also available from "News Blog".

<pre>
&lt;mt:Inlcude module="sidebar" blog_id="~another_blog"&gt;
</pre>

### Using with MultiBlog

<pre>
&lt;mt:MultiBlog include_blogs="~news"&gt;
&lt;/mt:MultiBlog&gt;
</pre>

### Wildcard

If the modifier takes comma separated blog id set like include_blogs of mt:MultiBlog, you can wildcard(*).

<pre>
&lt;mt:MultiBlog include_blogs="~/*/news"&gt;
&lt;mt:Entries&gt;
<!-- Gether entries in blogs aliased news for all website -->
&lt;/mt:Entries&gt;
&lt;/mt:MultiBlog&gt;
</pre>

You can use wildcard at head and tail like "*news", "news*" or "*news*".

But wildcard can not be placed inside: "site*news" does not work. Becanse "*" will replaced to "%" as SQL.

## Aliasing in Modifier

Aliasing is available in the following modifiers of any template tag.

* blog_id
* site_id
* blog_ids
* site_ids
* include_blogs
* include_websites
* exclude_blogs
* exclude_websites

## Synonyms

Each of tags has synonyms.

* WebsiteAlias is as same as BlogAlias
* WebsiteAliasPath is as same as BlogAliasPath
* WebsiteAliasToId is as same as BlogAliasToId

## Aliasing by context

### In System Context

* To refer a website: ~corporate.
* To refer a blog: ~corporate/blog or ~/corporate/blog

### In Website Context

* To refer a blog in the website: ~blog or ~/website/blog
* To refer an another website: ~/website
* To refer a blog in an another website: ~/website-b/blog-b

## In Blog Context

* To refer the website: ~/website
* To refer an another blog in the same website: ~blog-b or ~/website/blog-b
* To refer an another website: ~/website-b
* To refer an another blog in an another website: ~/website-b/blog-b
