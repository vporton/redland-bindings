# -*- Mode: Perl -*-
#
# RDF.pm - Redland Perl RDF Iterator module
#
# $Id$
#
# Copyright (C) 2000-2001 David Beckett - http://purl.org/net/dajobe/
# Institute for Learning and Research Technology - http://www.ilrt.org/
# University of Bristol - http://www.bristol.ac.uk/
# 
# This package is Free Software or Open Source available under the
# following licenses (these are alternatives):
#   1. GNU Lesser General Public License (LGPL) Version 2
#   2. GNU General Public License (GPL) Version 2
#   3. Mozilla Public License (MPL) Version 1.1
# and no other versions of those licenses.
# 
# See INSTALL.html or INSTALL.txt at the top of this package for the
# full license terms.
# 
#

package RDF::Iterator;

use strict;

=pod

=head1 NAME

RDF::Iterator - Redland RDF Iterator Class

=head1 SYNOPSIS

  use RDF;

  ...
  my $iterator=$model->targets_iterator($source_node, $arc_node);
  while($iterator && $iterator->have_elements) {
    my $node=$iterator->next;
    ...
  }

=head1 DESCRIPTION

This class is used to return lists of RDF::Node objects from a method
that returns an RDF::Iterator - commonly one of the
get_sources_iterator, get_targets_iterator or get_arcs_iterator
methods of the RDF::Model class.

This allows efficient retrieval of long lists of RDF::Node objects
but isn't really very Perl-friendly.  The get_sources, get_targets or
get_arcs methods of RDF::Model class return Perl lists and the
get_source, get_target and get_arc methods return single arbitrary
results.

=cut

######################################################################

=pod

=head1 CONSTRUCTORS

No public constructors - are created and returned from various methods
of classes including RDF::Model

=cut

# CONSTRUCTOR
# (main)
sub new ($$@) {
  my($proto,$object,@creators)=@_;
  return undef if !$object;

  warn "RDF::Iterator->new($object,@creators)\n" if $RDF::Debug;

  my $class = ref($proto) || $proto;
  my $self  = {};
  $self->{ITERATOR}=$object;
  # Keep around a reference to the objects that we use
  # so that perl does not destroy them while we are using them
  $self->{CREATORS}=[@creators];

  bless ($self, $class);
  return $self;
}

# DESTRUCTOR
sub DESTROY ($) {
  my $self=shift;
  warn "RDF::Iterator DESTROY\n" if $RDF::Debug;
  &Redland::librdf_free_iterator($self->{ITERATOR});
  $self->{CREATORS}=undef;
}


=head1 METHODS

=over

=item have_elements

Return non 0 if the iterator has more RDF::Node objects.

=cut

sub have_elements ($) {
  &Redland::librdf_iterator_have_elements(shift->{ITERATOR});
}

=item next

Returns the next RDF::Node object from iteration or undef if
the iteration is finished.

=cut

sub next ($) {
  # return a new (1) node (2)owned by the librdf iterator object
  # Reasons: (1) at the user API level the iterator only returns nodes
  #          (2) the node returned is shared with the iterator
  my $object=&Redland::librdf_iterator_get_next(shift->{ITERATOR});
  return undef if !$object;

  warn "RDF::Iterator::next object is $object\n" if $RDF::Debug;
  RDF::Node->_new_from_object($object,0);
}

=pod

=back

=head1 SEE ALSO

L<RDF::Model> and L<RDF::Node>

=head1 AUTHOR

Dave Beckett - http://purl.org/net/dajobe/

=cut

1;
