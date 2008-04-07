# $Id: utils.rb 143 2007-07-18 11:40:55Z phw $
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2007, Nigel Graham, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

require 'rbrainz/version'
Dir[File.dirname(__FILE__) + "/utils/*.rb"].each { |file| require(file) }
