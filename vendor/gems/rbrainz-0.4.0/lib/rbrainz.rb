# $Id: rbrainz.rb 145 2007-07-19 13:11:44Z phw $
#
# This is actually just a convenient shortcut that allows
# the user to use RBrainz by just using <tt>require 'rbrainz'</tt>.
# This will include the whole RBrainz web service library, which 
# should be ok most of the time.
# 
# If you want only the models use <tt>require 'rbrainz/model'</tt>.
# 
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2007, Nigel Graham, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

#require 'rbrainz/webservice'
#require 'rbrainz/core_ext'

require File.dirname(__FILE__) + '/rbrainz/webservice.rb'
Dir.glob(File.dirname(__FILE__) + '/rbrainz/webservice/*.rb') { |f| require f }

require File.dirname(__FILE__) + '/rbrainz/model/mbid.rb'

require File.dirname(__FILE__) + '/rbrainz/model.rb'

require File.dirname(__FILE__) + '/rbrainz/model/entity.rb'
require File.dirname(__FILE__) + '/rbrainz/model/individual.rb'

Dir.glob(File.dirname(__FILE__) + '/rbrainz/model/*.rb') { |f| require f }

require File.dirname(__FILE__) + '/rbrainz/version.rb'
require File.dirname(__FILE__) + '/rbrainz/utils.rb'
require File.dirname(__FILE__) + '/rbrainz/core_ext.rb'
