# $Id: core_ext.rb 132 2007-07-12 19:55:52Z phw $
#
# Author::    Nigel Graham (mailto:nigel_graham@rubyforge.org)
# Copyright:: Copyright (c) 2007, Nigel Graham, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

Dir[File.dirname(__FILE__) + "/core_ext/*.rb"].each { |file| require(file) }
