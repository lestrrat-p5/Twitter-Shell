# $Id$
#
# Copyright (c) 2007 Daisuke Maki <daisuke@endeworks.jp>
# All rights reserved.

package Twitter::Shell::Shell;
use strict;
use warnings;
use base qw(Term::Shell);

sub context { shift->_elem('context', @_) }
sub prompt_str { shift->_elem('prompt_str', @_) }
sub _elem
{
    my $self = shift;
    my $name = shift;
    my $value = $self->{$name};
    if (@_) {
        $self->{$name} = shift;
    }
    return $value;
}

sub _twitter_cmd
{
    my $self = shift;
    my $cmd  = shift;
    my $c    = $self->context;
    my $method = "api_$cmd";
    my $ret    = $c->$method(@_);

    if ($ret) {
        print "$cmd ok\n\n";
    } else {
        print "Command $cmd failed :(\n\n";
    }
    return $ret;
}

sub run_update
{
    my $self = shift;
    my $text = "@_";
    $text =~ s/^\s+//;
    $text =~ s/\s+$//;
    if ($text) {
        if ($text =~ /\W/) {
            $text .= " ";
        }
        $text .= "[from twittershell]";
    }
    $self->_twitter_cmd('update', $text);
}
sub smry_update { "post a message" }
sub help_update {}

# help
*run_say = \&run_update;
sub smry_say { "alias to 'update'" }
sub help_say {}

sub run_friends
{
    my $self = shift;
    my $ret  = $self->_twitter_cmd('friends');

    if ($ret) {
        foreach my $friend (@$ret) {
            printf( "[%s] %s\n", $friend->{screen_name}, $friend->{status}{text});
        }
    }
}
sub smry_friends { "display friends' status" }
sub help_friends {}

sub run_friends_timeline
{
    my $self = shift;
    my $ret  = $self->_twitter_cmd('friends_timeline');

    if ($ret) {
        foreach my $rec (@$ret) {
            printf( "[%s] %s\n", $rec->{user}{screen_name}, $rec->{text});
        }
    }
}
sub smry_friends_timeline { "display friends' status as a timeline" }
sub help_friends_timeline {}

*run_ft = \&run_friends_timeline;
sub smry_ft { "alias to friends_timeline" }
sub help_ft {}

sub run_public_timeline
{
    my $self = shift;
    my $ret  = $self->_twitter_cmd('public_timeline');

    if ($ret) {
        foreach my $rec (@$ret) {
            printf( "[%s] %s\n", $rec->{user}{screen_name}, $rec->{text});
        }
    }
}

sub smry_public_timeline { "display public status as a timeline" }
sub help_public_timeline {}

*run_pt = \&run_public_timeline;
sub smry_pt { "alias to public_timeline" }
sub help_pt {}

sub run_followers
{
    my $self = shift;
    my $ret  = $self->_twitter_cmd('followers');

    if ($ret) {
        foreach my $rec (@$ret) {
            printf( "[%s] %s\n", $rec->{screen_name}, $rec->{status}{text});
        }
    }
}
sub smry_followers { "display followers' status" }
sub help_followers {}

1;

__END__

=head1 NAME

Twitter::Shell::Shell - Provides shell for Twitter::Shell

=head1 METHODS

=head2 context

=head2 help_followers

=head2 help_friends

=head2 help_friends_timeline

=head2 help_ft

=head2 help_pt

=head2 help_public_timeline

=head2 help_say

=head2 help_update

=head2 new

=head2 prompt_str

=head2 run_followers

=head2 run_friends

=head2 run_friends_timeline

=head2 run_ft

=head2 run_pt

=head2 run_public_timeline

=head2 run_say

=head2 run_update

=head2 smry_followers

=head2 smry_friends

=head2 smry_friends_timeline

=head2 smry_ft

=head2 smry_pt

=head2 smry_public_timeline

=head2 smry_say

=head2 smry_update

=cut

