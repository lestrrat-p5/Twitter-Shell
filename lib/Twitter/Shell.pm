# $Id$
#
# Copyright (c) 2007 Daisuke Maki <daiuske@endeworks.jp>
# All rights reserved.

package Twitter::Shell;
use strict;
use warnings;
use base qw(Class::Accessor::Fast);
use Carp qw(croak);
use Config::Any;
use Net::Twitter;
use Twitter::Shell::Shell;

our $VERSION = '0.03';

__PACKAGE__->mk_accessors($_) for qw(shell config twitter);

sub new
{
    my $class = shift;
    my $config = $class->load_config(shift);
    my $self  = $class->SUPER::new();
    $self->config($config);
    $self->setup();
    $self;
}

sub load_config
{
    my $self = shift;
    my $config = shift;

    if ($config && ! ref $config) {
        my $filename = $config;
        # In the future, we may support multiple configs, but for now
        # just load a single file via Config::Any
        my $list = Config::Any->load_files( { files => [ $filename ] } );
        ($config) = $list->[0]->{$filename};
    }

    if (! $config) {
        croak("Could not load config");
    }

    if (ref $config ne 'HASH') {
        croak("Twitter::Shell expectes config that can be decoded to a HASH");
    }

    return $config;
}

sub setup
{
    my $self = shift;
    $self->shell(Twitter::Shell::Shell->new);
    $self->twitter(Net::Twitter->new(
        username => $self->config->{username},
        password => $self->config->{password},
    ));
}

sub run
{
    my $self = shift;

    my $shell = $self->shell;
    $shell->context($self);
    $shell->prompt_str('twitter> ');
    $shell->cmdloop();
}

sub api_update
{
    my $self = shift;
    $self->twitter->update(@_);
}

sub api_friends
{
    my $self = shift;
    $self->twitter->friends();
}

sub api_friends_timeline
{
    my $self = shift;
    $self->twitter->friends_timeline();
}

sub api_public_timeline
{
    my $self = shift;
    $self->twitter->public_timeline();
}

sub api_followers
{
    my $self = shift;
    $self->twitter->followers();
}

1;

__END__

=head1 NAME

Twitter::Shell - Twitter From Your Shell!

=head1 SYNOPSIS

   twittershell
   twitter> say Just type a message
   update ok

   twitter> friends
   [friend] A message, another message

   twitter> friends_timeline
   [friend] A message, another message

   twitter> ft
   [friend] A message, another message

   twitter> public_timeline
   [friend] A message, another message

   twitter> pt
   [friend] A message, another message

   twitter> followers
   [friend] A message, another message

=head1 DESCRIPTION

Twitter::Shell gives you access to Twitter from your shell!

Documentation coming soon...

=head1 METHODS

=head2 api_friends

=head2 api_friends_timeline

=head2 api_public_timeline

=head2 api_followers

=head2 api_update

=head2 load_config

=head2 new

=head2 run

=head2 setup

=head1 LICENSE

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

See http://www.perl.com/perl/misc/Artistic.html

=head1 LICENSE

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

See http://www.perl.com/perl/misc/Artistic.html

=cut