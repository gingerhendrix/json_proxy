= discog

* http://discogs.rubyforge.org

== DESCRIPTION:

API Wrapper for discogs.org
http://www.discogs.com/help/api

== FEATURES/PROBLEMS:

* API wrapper for:
	- releases
	- artists
	- labels
	- search
* with class wrappers for:
	- contributors
	- genres
	- styles
	- images
	- tracks
	- formats

And a bin util

== SYNOPSIS:

d = Discog::Artist.new(ARGV[0])
puts "
Artist:     #{d.name}
Members:    #{d.members}
Images:     #{d.images}
URLs:       #{d.urls}
Releases:   #{d.releases.map{|r| r.title }}
"

release = Discog::Release.new('188365')
puts "
Title:        #{release.title}
Labels:       #{release.labels}
Format:       #{release.formats}
Status:       #{release.discog_status}
Genres:       #{release.genres}
Styles:       #{release.styles}
Country:      #{release.country}
ReleaseDate:  #{release.released}
Tracks        #{release.tracks}
Images:       #{release.images}
Extras:       #{release.contributors.join(', ')}
"

label = Discog::Label.new(ARGV[0])
puts "
Name:         #{label.name}
Images:       #{label.images}
Contact:      #{label.contact_info}
Profile:      #{label.profile}
URLs:         #{label.urls}
Parent:       #{label.parent}
SubLabels:    #{label.sublabels}
Releases:     #{label.releases}
"

== REQUIREMENTS:

rubygems
hpricot

== INSTALL:

sudo gem install discogs

== LICENSE:

(The MIT License)

Copyright (c) 2008 Josh Stephenson

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
