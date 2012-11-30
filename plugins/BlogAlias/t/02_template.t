use FindBin;
use lib $FindBin::Bin;

use MTPath;
use Test::More;

use MT::Plugins::Test::Object;
use MT::Plugins::Test::Template;

test_common_website(
    as_superuser => 1,
    test => sub {
        my ( $website, $blog, $user, $password ) = @_;

        $website->alias('website');
        $website->save;

        $blog->alias('blog');
        $blog->save;

        subtest '~blog in website context' => sub {
            test_template(
                stash => { blog => $website },
                template => q{<mt:MultiBlog include_blogs="~blog"><mt:BlogName></mt:MultiBlog>},
                test => sub {
                    my %args = @_;
                    is $args{result}, $blog->name;
                }
            );
        };

        subtest '~blog in blog context' => sub {
            test_template(
                stash => { blog => $blog },
                template => q{<mt:MultiBlog include_blogs="~blog"><mt:BlogName></mt:MultiBlog>},
                test => sub {
                    my %args = @_;
                    is $args{result}, $blog->name;
                }
            );
        };

        subtest '~blog without context' => sub {
            test_template(
                stash => {},
                template => q{<mt:MultiBlog include_blogs="~blog"><mt:BlogName></mt:MultiBlog>},
                test => sub {
                    my %args = @_;
                    ok !$args{result};
                    diag $args{error};
                    ok $args{error};
                }
            );
        };

        subtest '~website in website context' => sub {
            test_template(
                stash => { blog => $website },
                template => q{<mt:MultiBlog include_blogs="~website"><mt:BlogName></mt:MultiBlog>},
                test => sub {
                    my %args = @_;
                    is $args{result}, $website->name;
                }
            );
        };

        subtest '~website in blog context' => sub {
            test_template(
                stash => { blog => $blog },
                template => q{<mt:MultiBlog include_blogs="~website"><mt:BlogName></mt:MultiBlog>},
                test => sub {
                    my %args = @_;
                    is $args{result}, $website->name;
                }
            );
        };

        subtest '~website without context' => sub {
            test_template(
                stash => {},
                template => q{<mt:MultiBlog include_blogs="~website"><mt:BlogName></mt:MultiBlog>},
                test => sub {
                    my %args = @_;
                    is $args{result}, $website->name;
                }
            );
        };

        subtest '~not_found in website context' => sub {
            test_template(
                stash => { blog => $website },
                template => q{<mt:MultiBlog include_blogs="~not_found"><mt:BlogName></mt:MultiBlog>},
                test => sub {
                    my %args = @_;
                    ok !$args{result};
                    diag $args{error};
                    ok $args{error};
                }
            );
        };

        subtest '~not_found in blog context' => sub {
            test_template(
                stash => { blog => $blog },
                template => q{<mt:MultiBlog include_blogs="~not_found"><mt:BlogName></mt:MultiBlog>},
                test => sub {
                    my %args = @_;
                    ok !$args{result};
                    diag $args{error};
                    ok $args{error};
                }
            );
        };

        subtest '~not_found without context' => sub {
            test_template(
                stash => {},
                template => q{<mt:MultiBlog include_blogs="~not_found"><mt:BlogName></mt:MultiBlog>},
                test => sub {
                    my %args = @_;
                    ok !$args{result};
                    diag $args{error};
                    ok $args{error};
                }
            );
        };

        subtest '~website/blog in website context' => sub {
            test_template(
                stash => { blog => $website },
                template => q{<mt:MultiBlog include_blogs="~website/blog"><mt:BlogName></mt:MultiBlog>},
                test => sub {
                    my %args = @_;
                    is $args{result}, $blog->name;
                }
            );
        };

        subtest '~website/blog in blog context' => sub {
            test_template(
                stash => { blog => $blog },
                template => q{<mt:MultiBlog include_blogs="~website/blog"><mt:BlogName></mt:MultiBlog>},
                test => sub {
                    my %args = @_;
                    is $args{result}, $blog->name;
                }
            );
        };

        subtest '~website/blog without context' => sub {
            test_template(
                stash => {},
                template => q{<mt:MultiBlog include_blogs="~website/blog"><mt:BlogName></mt:MultiBlog>},
                test => sub {
                    my %args = @_;
                    is $args{result}, $blog->name;
                }
            );
        };

        subtest '~website/not_found in website context' => sub {
            test_template(
                stash => { blog => $website },
                template => q{<mt:MultiBlog include_blogs="~website/not_found"><mt:BlogName></mt:MultiBlog>},
                test => sub {
                    my %args = @_;
                    ok !$args{result};
                    diag $args{error};
                    ok $args{error};
                }
            );
        };

        subtest '~website/not_found in blog context' => sub {
            test_template(
                stash => { blog => $blog },
                template => q{<mt:MultiBlog include_blogs="~website/not_found"><mt:BlogName></mt:MultiBlog>},
                test => sub {
                    my %args = @_;
                    ok !$args{result};
                    diag $args{error};
                    ok $args{error};
                }
            );
        };

        subtest '~website/not_found without context' => sub {
            test_template(
                stash => {},
                template => q{<mt:MultiBlog include_blogs="~website/not_found"><mt:BlogName></mt:MultiBlog>},
                test => sub {
                    my %args = @_;
                    ok !$args{result};
                    diag $args{error};
                    ok $args{error};
                }
            );
        };

        subtest '~not_found/blog in website context' => sub {
            test_template(
                stash => { blog => $website },
                template => q{<mt:MultiBlog include_blogs="~not_found/blog"><mt:BlogName></mt:MultiBlog>},
                test => sub {
                    my %args = @_;
                    ok !$args{result};
                    diag $args{error};
                    ok $args{error};
                }
            );
        };

        subtest '~not_found/blog in blog context' => sub {
            test_template(
                stash => { blog => $blog },
                template => q{<mt:MultiBlog include_blogs="~not_found/blog"><mt:BlogName></mt:MultiBlog>},
                test => sub {
                    my %args = @_;
                    ok !$args{result};
                    diag $args{error};
                    ok $args{error};
                }
            );
        };

        subtest '~not_found/blog without context' => sub {
            test_template(
                stash => {},
                template => q{<mt:MultiBlog include_blogs="~not_found/blog"><mt:BlogName></mt:MultiBlog>},
                test => sub {
                    my %args = @_;
                    ok !$args{result};
                    diag $args{error};
                    ok $args{error};
                }
            );
        };
    }
);

done_testing;