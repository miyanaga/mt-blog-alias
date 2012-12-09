use strict;
use FindBin;
use lib $FindBin::Bin;

use MTPath;
use Test::More;

use MT::Plugins::Test::Object;
use MT::Plugins::Test::Template;

test_common_website(
    as_superuser => 1,
    test => sub {
        my ( $website1, $blog1, $user1, $password1 ) = @_;

        $website1->alias('website1');
        $website1->save;

        $blog1->alias('blog');
        $blog1->save;

        test_common_website(
            as_superuser => 1,
            test => sub {
                my ( $website2, $blog2, $user2, $password2 ) = @_;

                $website2->alias('website2');
                $website2->save;

                $blog2->alias('blog');
                $blog2->save;

                test_template(
                    stash => { blog => $website1 },
                    template => q{<mt:MultiBlog include_blogs="~*"><mt:BlogAlias></mt:MultiBlog>},
                    test => sub {
                        my %args = @_;
                        is $args{result}, join('', $blog1->alias), '~* in website1 context';
                    }
                );

                test_template(
                    stash => { blog => $website2 },
                    template => q{<mt:MultiBlog include_blogs="~*g"><mt:BlogAlias></mt:MultiBlog>},
                    test => sub {
                        my %args = @_;
                        is $args{result}, join('', $blog2->alias), '~*g in website2 context';
                    }
                );

                test_template(
                    stash => { blog => $website1 },
                    template => q{<mt:MultiBlog include_blogs="~/website*/blog"><mt:BlogAlias></mt:MultiBlog>},
                    test => sub {
                        my %args = @_;
                        is $args{result}, join('', $blog1->alias, $blog2->alias), '~/website*/blog in website1 context';
                    }
                );

                test_template(
                    stash => { blog => $website1 },
                    template => q{<mt:MultiBlog include_blogs="~/*/*"><mt:BlogAlias></mt:MultiBlog>},
                    test => sub {
                        my %args = @_;
                        is $args{result}, join('', $blog1->alias, $blog2->alias), '~/*/* in website1 context';
                    }
                );

                test_template(
                    stash => { blog => $website1 },
                    template => q{<mt:MultiBlog include_blogs="~/*"><mt:BlogAlias></mt:MultiBlog>},
                    test => sub {
                        my %args = @_;
                        is $args{result}, join('', $website1->alias, $website2->alias), '~/* in website1 context';
                    }
                );

                test_template(
                    stash => {  },
                    template => q{<mt:MultiBlog include_blogs="~*"><mt:BlogAlias></mt:MultiBlog>},
                    test => sub {
                        my %args = @_;
                        is $args{result}, join('', $website1->alias, $website2->alias), '~* in system context';
                    }
                );

                test_template(
                    stash => {  },
                    template => q{<mt:MultiBlog include_blogs="~*/blog"><mt:BlogAlias></mt:MultiBlog>},
                    test => sub {
                        my %args = @_;
                        is $args{result}, join('', $blog1->alias, $blog2->alias), '~*/blog in system context';
                    }
                );

                test_template(
                    stash => {  },
                    template => q{<mt:MultiBlog include_blogs="~*,~*/*"><mt:BlogAlias></mt:MultiBlog>},
                    test => sub {
                        my %args = @_;
                        is $args{result}, join('', $blog1->alias, $blog2->alias, $website1->alias, $website2->alias), '~*,~*/* in system context';
                    }
                );
            }
        );
    }
);

done_testing;