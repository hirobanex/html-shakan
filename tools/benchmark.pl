use strict;
use warnings;
use HTML::Shakan;
use HTML::FormFu;
use CGI;
use Benchmark ':all';

my $q = CGI->new;

{
    package B::D;
    use HTML::Shakan::Declare;
    form 'foo' => (
        TextField(name => 'foo')
    );
}

cmpthese(
    10000 => {
        shakan_declare => sub {
            my $form = B::D->get('foo' => (
                request => $q,
            ));
            '<form method="post">'.$form->render.'</form>';
        },
        shakan => sub {
            my $form = HTML::Shakan->new(
                request => $q,
                fields => [
                    TextField(name => 'foo')
                ],
            );
            '<form method="post">'.$form->render.'</form>';
        },
        formfu => sub {
            my $form = HTML::FormFu->new({
                elements => [
                    {type => 'Text', name => 'foo'}
                ],
            });
            $form->render;
        },
    },
);
